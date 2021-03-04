//=============================================================================
// VacuumZone.
//=============================================================================
class VacuumZone extends ZoneInfo;

var() float  KillTime;					// How long to kill the player?
var() float  StartFlashScale;			// Fog values for client death sequence
var() Vector StartFlashFog;
var() float  EndFlashScale;
var() Vector EndFlashFog;
var() float  DieFOV;					// Field of view when dead (interpolates)
var() float  DieDrawScale;				// Drawscale when dead
var   float  FatnessAccumulator;

function BeginPlay()
{
	Super.BeginPlay();
	Disable('Tick');
	DieFOV = FClamp( DieFOV, 1, 170 );
}

event ActorEntered( Actor Other )
{
	local Pawn P;

	Super.ActorEntered(Other);

	if ( Other.bIsPawn )
	{
		P = Pawn(Other);

		// Maybe scream?
		if( P.bIsPlayer )
		{
			// Scream now (from the terrible pain)
			P.PlaySound( P.Die, SLOT_Talk );
		}

		Enable('Tick');
	}
}

function Tick( float DeltaTime )
{
	local float  		ratio, curScale;
	local vector 		curFog;
	local PlayerPawn	pPawn;
	local Pawn P;
	local bool bActive;
	local int OldFatness;
	local int AddFatness;

	// Should be done per pawn.
	FatnessAccumulator += 128.f * DeltaTime/KillTime;
	AddFatness = int(FatnessAccumulator - (FatnessAccumulator % 1));
	FatnessAccumulator -= float(AddFatness);
	
	for ( P=Level.PawnList; P!=None; P=P.NextPawn )
	{
		// Ensure player hasn't been dispatched through other means already (suicide?)
		if( (P.Region.Zone == self) && (P.Health > 0) )
		{
			bActive = true;
			P.Fatness = Clamp( int(P.Fatness) + AddFatness, 0, 255);
			ratio = FMax( 0.01, (float(P.Fatness)-float(P.default.Fatness)) / FMax(1,255-P.Default.Fatness) );

			// old pre-v469 code.
//			ratio = FMax(0.01,float(Max(P.Fatness,128) - P.Default.Fatness)/FMax(1,(255 - P.Default.Fatness)));
//			ratio += DeltaTime/KillTime;
			// Fatness
//			OldFatness = P.Fatness;
//			P.Fatness = Max(P.Fatness,128) + Max(1, ratio * (255 - P.Default.Fatness) - (P.Fatness - P.Default.Fatness));
//			if ( P.Fatness < Max(OldFatness,P.Default.Fatness) )
//				P.Fatness = 255;

			// Fog & Field of view
			pPawn = PlayerPawn(P);
			if( pPawn != None )
			{
				curScale = (EndFlashScale-StartFlashScale)*ratio + StartFlashScale;
				curFog   = (EndFlashFog  -StartFlashFog  )*ratio + StartFlashFog;
				pPawn.ClientFlash( curScale, 1000 * curFog );
				pPawn.SetFOVAngle( (DieFOV-pPawn.default.FOVAngle)*ratio + pPawn.default.FOVAngle);
			}
			if ( P.Fatness > 250 )
			{	
				Level.Game.SpecialDamageString = DamageString;		
				P.TakeDamage
				(
					10000,
					P,
					P.Location,
					Vect(0,0,0),
					DamageType				
				);
				MakeNormal(P);
			}
		}
	}	
	
	if( !bActive )
		Disable('Tick');
}

function MakeNormal(Pawn P)
{
	local PlayerPawn PPawn;
	// set the fatness back to normal
	P.Fatness = P.Default.Fatness;
	P.DrawScale = P.Default.DrawScale;
	PPawn = PlayerPawn(P);
	if( PPawn != None )
		PPawn.SetFOVAngle( PPawn.Default.FOVAngle );
}

// When an actor leaves this zone.
event ActorLeaving( actor Other )
{
	if( Other.bIsPawn )
		MakeNormal(Pawn(Other));
	Super.ActorLeaving(Other);
}

defaultproperties
{
      KillTime=2.500000
      StartFlashScale=1.000000
      StartFlashFog=(X=0.000000,Y=0.000000,Z=0.000000)
      EndFlashScale=1.000000
      EndFlashFog=(X=0.000000,Y=0.000000,Z=0.000000)
      DieFOV=90.000000
      DieDrawScale=1.000000
      FatnessAccumulator=0.000000
      DamageType="SpecialDamage"
      DamageString="%o was depressurized"
      bStatic=False
}
