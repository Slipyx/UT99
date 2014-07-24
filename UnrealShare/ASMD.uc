//=============================================================================
// ASMD.
//=============================================================================
class ASMD extends Weapon;

#exec MESH IMPORT MESH=ASMDM ANIVFILE=MODELS\ASMD_a.3D DATAFILE=MODELS\ASMD_d.3D X=0 Y=0 Z=0
#exec MESH ORIGIN MESH=ASMDM X=0 Y=0 Z=0 YAW=-64 PITCH=0
#exec MESH SEQUENCE MESH=ASMDM SEQ=All       STARTFRAME=0  NUMFRAMES=80
#exec MESH SEQUENCE MESH=ASMDM SEQ=Select    STARTFRAME=0  NUMFRAMES=14 RATE=27 GROUP=Select
#exec MESH SEQUENCE MESH=ASMDM SEQ=Still     STARTFRAME=14 NUMFRAMES=2
#exec MESH SEQUENCE MESH=ASMDM SEQ=Down      STARTFRAME=16 NUMFRAMES=10
#exec MESH SEQUENCE MESH=ASMDM SEQ=Still2    STARTFRAME=26 NUMFRAMES=2
#exec MESH SEQUENCE MESH=ASMDM SEQ=Fire1     STARTFRAME=28 NUMFRAMES=9  RATE=24
#exec MESH SEQUENCE MESH=ASMDM SEQ=Fire2     STARTFRAME=37 NUMFRAMES=10
#exec MESH SEQUENCE MESH=ASMDM SEQ=Steam     STARTFRAME=47 NUMFRAMES=10
#exec MESH SEQUENCE MESH=ASMDM SEQ=Cocking   STARTFRAME=57 NUMFRAMES=19
#exec MESH SEQUENCE MESH=ASMDM SEQ=Sway      STARTFRAME=76 NUMFRAMES=4
#exec TEXTURE IMPORT NAME=ASMD1 FILE=MODELS\ASMD.PCX GROUP="Skins"
#exec OBJ LOAD FILE=Textures\SmokeEffect3.utx PACKAGE=UnrealShare.SEffect3
#exec MESHMAP SCALE MESHMAP=ASMDM X=0.007 Y=0.005 Z=0.01
#exec MESHMAP SETTEXTURE MESHMAP=ASMDM NUM=1 TEXTURE=ASMD1
#exec MESHMAP SETTEXTURE MESHMAP=ASMDM NUM=0 TEXTURE=UnrealShare.SEffect3.SmokeEffect3

#exec MESH IMPORT MESH=ASMDPick ANIVFILE=MODELS\Tazlo_a.3D DATAFILE=MODELS\Tazlo_d.3D X=0 Y=0 Z=0
#exec MESH ORIGIN MESH=ASMDPick X=0 Y=-10 Z=-13 YAW=-64 PITCH=0
#exec MESH SEQUENCE MESH=ASMDPick SEQ=All   STARTFRAME=0  NUMFRAMES=6
#exec TEXTURE IMPORT NAME=ASMD1 FILE=MODELS\ASMD.PCX GROUP="Skins"
#exec MESHMAP SCALE MESHMAP=ASMDPick X=0.1 Y=0.1 Z=0.2
#exec MESHMAP SETTEXTURE MESHMAP=ASMDPick NUM=1 TEXTURE=ASMD1

#exec MESH IMPORT MESH=ASMD3 ANIVFILE=MODELS\Tazlo_a.3D DATAFILE=MODELS\Tazlo_d.3D X=0 Y=0 Z=0
#exec MESH ORIGIN MESH=ASMD3 X=0 Y=-190 Z=-40 YAW=-64 ROLL=9
#exec MESH SEQUENCE MESH=ASMD3 SEQ=All   STARTFRAME=0  NUMFRAMES=1
#exec MESH SEQUENCE MESH=ASMD3 SEQ=Still STARTFRAME=0  NUMFRAMES=1
#exec MESH SEQUENCE MESH=ASMD3 SEQ=Fire1 STARTFRAME=0  NUMFRAMES=1
#exec TEXTURE IMPORT NAME=ASMD1 FILE=MODELS\ASMD.PCX GROUP="Skins"
#exec MESHMAP SCALE MESHMAP=ASMD3 X=0.065 Y=0.065 Z=0.13
#exec MESHMAP SETTEXTURE MESHMAP=ASMD3 NUM=1 TEXTURE=ASMD1

#exec AUDIO IMPORT FILE="Sounds\Tazer\TSHOTA6.WAV" NAME="TazerFire" GROUP="ASMD"
#exec AUDIO IMPORT FILE="Sounds\Tazer\TSHOTB1.WAV" NAME="TazerAltFire" GROUP="ASMD"
#exec AUDIO IMPORT FILE="Sounds\Tazer\TPICKUP3.WAV" NAME="TazerSelect" GROUP="ASMD"
#exec AUDIO IMPORT FILE="Sounds\Tazer\Vapour1.WAV" NAME="Vapour" GROUP="ASMD"

var() int HitDamage;
var Pickup Amp;
var Projectile Tracked;
var bool bBotSpecialMove;

function inventory SpawnCopy( pawn Other )
{
	local inventory Copy;
	local Inventory I;

	Copy = Super.SpawnCopy(Other);
	I = Other.FindInventoryType(class'Amplifier');
	if ( Amplifier(I) != None )
		ASMD(Copy).Amp = Amplifier(I);

	return Copy;
}

function AltFire( float Value )
{
	local actor HitActor;
	local vector HitLocation, HitNormal, Start; 

	if ( Owner.IsA('Bots') || Owner.IsA('Bot')  ) //make sure won't blow self up
	{
		Start = Owner.Location + CalcDrawOffset() + FireOffset.Z * vect(0,0,1); 
		HitActor = Trace(HitLocation, HitNormal, Start + 250 * Normal(Pawn(Owner).Enemy.Location - Start), Start, false, vect(12,12,12));
		if ( HitActor != None )
		{
			Global.Fire(Value);
			return;
		}
		if ( Owner.IsInState('TacticalMove') && (Owner.Target == Pawn(Owner).Enemy)
			 && (Owner.Physics == PHYS_Walking)
			 && (Pawn(Owner).Skill > 1) && (FRand() < 0.35) )
			Pawn(Owner).SpecialFire();
	}	
	if (AmmoType.UseAmmo(1))
	{
		GotoState('AltFiring');
		if ( PlayerPawn(Owner) != None )
		{
			PlayerPawn(Owner).ClientInstantFlash( -0.4, vect(0, 0, 800));
			PlayerPawn(Owner).ShakeView(ShakeTime, ShakeMag, ShakeVert);
		}
		bPointing=True;
		ProjectileFire(AltProjectileClass, AltProjectileSpeed, bAltWarnTarget);
		PlayAltFiring();
		if ( Owner.bHidden )
			CheckVisibility();
	}
}

function TraceFire( float Accuracy )
{
	local vector HitLocation, HitNormal, StartTrace, EndTrace, X,Y,Z;
	local actor Other;

	Owner.MakeNoise(Pawn(Owner).SoundDampening);
	GetAxes(Pawn(owner).ViewRotation,X,Y,Z);
	StartTrace = Owner.Location + CalcDrawOffset() + FireOffset.X * X + FireOffset.Y * Y + FireOffset.Z * Z; 
	EndTrace = StartTrace + Accuracy * (FRand() - 0.5 )* Y * 1000
		+ Accuracy * (FRand() - 0.5 ) * Z * 1000 ;

	if ( bBotSpecialMove && (Tracked != None)
		&& (((Owner.Acceleration == vect(0,0,0)) && (VSize(Owner.Velocity) < 40)) ||
			(Normal(Owner.Velocity) Dot Normal(Tracked.Velocity) > 0.95)) )
		EndTrace += 10000 * Normal(Tracked.Location - StartTrace);
	else
	{
		bSplashDamage = false;
		AdjustedAim = pawn(owner).AdjustAim(1000000, StartTrace, 2.75*AimError, False, False);	
		bSplashDamage = true;
		EndTrace += (10000 * vector(AdjustedAim)); 
	}

	Tracked = None;
	bBotSpecialMove = false;

	Other = Pawn(Owner).TraceShot(HitLocation,HitNormal,EndTrace,StartTrace);
	ProcessTraceHit(Other, HitLocation, HitNormal, vector(AdjustedAim),Y,Z);
}

function float RateSelf( out int bUseAltMode )
{
	local float rating;

	if ( Amp != None )
		rating = 2 * AIRating;
	else 
		rating = AIRating;

	if ( AmmoType.AmmoAmount <=0 )
		return -2;

	if ( Pawn(Owner).Enemy == None )
		bUseAltMode = 0;
	else if ( Pawn(Owner).IsInState('Hunting') || Pawn(Owner).IsInState('StakeOut')
		|| Pawn(Owner).IsInState('RangedAttack')
		|| !Pawn(Owner).LineOfSightTo(Pawn(Owner).Enemy) )
	{
		bUseAltMode = 1;
		return (Rating + 0.3);
	}
	else if ( (Pawn(Owner).Skill > 1) && (Owner.Acceleration == vect(0,0,0)) )
		bUseAltMode = 1;
	else
		bUseAltMode = int( FRand() < 0.4 );

	return rating;
}

function BecomePickup()
{
	Amp = None;
	Super.BecomePickup();
}

function Timer()
{
	local actor targ;
	local float bestAim, bestDist;
	local vector FireDir;

	bestAim = 0.95;
	if ( Pawn(Owner) == None )
	{
		GotoState('');
		return;
	}
	FireDir = vector(Pawn(Owner).ViewRotation);
	targ = Pawn(Owner).PickTarget(bestAim, bestDist, FireDir, Owner.Location);
	if ( Pawn(targ) != None )
	{
		bPointing = true;
		Pawn(targ).WarnTarget(Pawn(Owner), 300, FireDir);
		SetTimer(1 + 4 * FRand(), false);
	}
	else 
	{
		SetTimer(0.5 + 2 * FRand(), false);
		bPointing = false;
	}
}	

function Finish()
{
	if ( (Pawn(Owner).bFire!=0) && (FRand() < 0.6) )
		Timer();
	if ( !bChangeWeapon && (Tracked != None) && !Tracked.bDeleteMe && (Owner != None) 
		&& (Owner.IsA('Bots') || Owner.IsA('Bot')) && (Pawn(Owner).Enemy != None)
		&& (AmmoType.AmmoAmount > 0) && (Pawn(Owner).Skill > 1) ) 
	{
		if ( (Owner.Acceleration == vect(0,0,0)) ||
			(Abs(Normal(Owner.Velocity) dot Normal(Tracked.Velocity)) > 0.95) )
		{
			bBotSpecialMove = true;
			GotoState('ComboMove');
			return;
		}
	}

	bBotSpecialMove = false;
	Tracked = None;
	Super.Finish();
}

///////////////////////////////////////////////////////
function PlayFiring()
{
	Owner.PlaySound(FireSound, SLOT_None, Pawn(Owner).SoundDampening*4.0);
	PlayAnim('Fire1', 0.5,0.05);
}

function Projectile ProjectileFire(class<projectile> ProjClass, float ProjSpeed, bool bWarn)
{
	local Vector Start, X,Y,Z;
	local float Mult;

	if (Amp!=None) Mult = Amp.UseCharge(80);
	else Mult=1.0;

	Owner.MakeNoise(Pawn(Owner).SoundDampening);
	GetAxes(Pawn(owner).ViewRotation,X,Y,Z);
	Start = Owner.Location + CalcDrawOffset() + FireOffset.X * X + FireOffset.Y * Y + FireOffset.Z * Z; 
	bSplashDamage = false;
	AdjustedAim = pawn(owner).AdjustAim(ProjSpeed, Start, AimError, True, bWarn);	
	bSplashDamage = true;
	Tracked = Spawn(ProjClass,,, Start,AdjustedAim);
	Tracked.Damage = Tracked.Damage*Mult;
}

function ProcessTraceHit(Actor Other, Vector HitLocation, Vector HitNormal, Vector X, Vector Y, Vector Z)
{
	local vector SmokeLocation,DVector;
	local rotator SmokeRotation;
	local float NumPoints,Mult;
	local int i;
	local class<RingExplosion> rc;
	local RingExplosion r;

	if (Other==None)
	{
		HitNormal = -X;
		HitLocation = Owner.Location + X*10000.0;
	}

	if (Amp!=None) Mult = Amp.UseCharge(100);
	else Mult=1.0;
	SmokeLocation = Owner.Location + CalcDrawOffset() + FireOffset.X * X + FireOffset.Y * 3.3 * Y + FireOffset.Z * Z * 3.0;
	DVector = HitLocation - SmokeLocation;
	NumPoints = VSize(DVector)/70.0;
	SmokeLocation += DVector/NumPoints;
	SmokeRotation = rotator(HitLocation-Owner.Location);
	if (NumPoints>15) NumPoints=15;
	if ( NumPoints>1.0 ) SpawnEffect(DVector, NumPoints, SmokeRotation, SmokeLocation);

	if ( TazerProj(Other)!=None )
	{ 
		AmmoType.UseAmmo(2);
		TazerProj(Other).SuperExplosion();
	}
	else
	{
		if (Mult>1.5)
			rc = class'RingExplosion3';
		else
			rc = class'RingExplosion';
			 
		r = Spawn(rc,,, HitLocation+HitNormal*8,rotator(HitNormal));
		if ( r != None )
			r.PlaySound(r.ExploSound,,6);
	}

	if ( (Other != self) && (Other != Owner) && (Other != None) ) 
		Other.TakeDamage(HitDamage*Mult, Pawn(Owner), HitLocation, 50000.0*X, 'jolted');
}


function SpawnEffect(Vector DVector, int NumPoints, rotator SmokeRotation, vector SmokeLocation)
{
	local RingExplosion4 Smoke;
	
	Smoke = Spawn(class'RingExplosion4',,,SmokeLocation,SmokeRotation);
	Smoke.MoveAmount = DVector/NumPoints;
	Smoke.NumPuffs = NumPoints;
}

function PlayAltFiring()
{
	Owner.PlaySound(AltFireSound, SLOT_None,Pawn(Owner).SoundDampening*4.0);
	PlayAnim('Fire1',0.8,0.05);
}

function PlayIdleAnim()
{
	if ( AnimSequence == 'Fire1' && FRand()<0.2)
	{
		Owner.PlaySound(Misc1Sound, SLOT_None, Pawn(Owner).SoundDampening*0.5);	
		PlayAnim('Steam',0.1,0.4);
	}
	else if ( VSize(Owner.Velocity) > 20 )
	{
		if ( AnimSequence=='Still' )
			LoopAnim('Sway',0.1,0.3);
	}
	else if ( AnimSequence!='Still' ) 
	{
		if (FRand()<0.5) 
		{
			PlayAnim('Steam',0.1,0.4);
			Owner.PlaySound(Misc1Sound, SLOT_None, Pawn(Owner).SoundDampening*0.5);			
		}
		else LoopAnim('Still',0.04,0.3);
	}
	Enable('AnimEnd');
}

state Idle
{

	function BeginState()
	{
		bPointing = false;
		SetTimer(0.5 + 2 * FRand(), false);
		Super.BeginState();
		if (Pawn(Owner).bFire!=0) Fire(0.0);
		if (Pawn(Owner).bAltFire!=0) AltFire(0.0);		
	}

	function EndState()
	{
		SetTimer(0.0, false);
		Super.EndState();
	}
}

state ComboMove
{
	function Fire(float F); 
	function AltFire(float F); 

	function Tick(float DeltaTime)
	{
		if ( (Owner == None) || (Pawn(Owner).Enemy == None) )
		{
			Tracked = None;
			bBotSpecialMove = false;
			Finish();
			return;
		}
		if ( (Tracked == None) || Tracked.bDeleteMe 
			|| (((Tracked.Location - Owner.Location) 
				dot (Tracked.Location - Pawn(Owner).Enemy.Location)) >= 0)
			|| (VSize(Tracked.Location - Pawn(Owner).Enemy.Location) < 100) )
			Global.Fire(0);
	}

Begin:
	Sleep(7.0);
	Tracked = None;
	bBotSpecialMove = false;
	Global.Fire(0);
}

defaultproperties
{
     hitdamage=35
     AmmoName=Class'UnrealShare.ASMDAmmo'
     PickupAmmoCount=20
     bInstantHit=True
     bAltWarnTarget=True
     bSplashDamage=True
     FireOffset=(X=12.000000,Y=-6.000000,Z=-7.000000)
     AltProjectileClass=Class'UnrealShare.TazerProj'
     AIRating=0.600000
     AltRefireRate=0.700000
     FireSound=Sound'UnrealShare.ASMD.TazerFire'
     AltFireSound=Sound'UnrealShare.ASMD.TazerAltFire'
     SelectSound=Sound'UnrealShare.ASMD.TazerSelect'
     Misc1Sound=Sound'UnrealShare.ASMD.Vapour'
     DeathMessage="%k inflicted mortal damage upon %o with the %w."
     AutoSwitchPriority=4
     InventoryGroup=4
     PickupMessage="You got the ASMD"
     ItemName="ASMD"
     PlayerViewOffset=(X=3.500000,Y=-1.800000,Z=-2.000000)
     PlayerViewMesh=LodMesh'UnrealShare.ASMDM'
     PickupViewMesh=LodMesh'UnrealShare.ASMDPick'
     ThirdPersonMesh=LodMesh'UnrealShare.ASMD3'
     PickupSound=Sound'UnrealShare.Pickups.WeaponPickup'
     Mesh=LodMesh'UnrealShare.ASMDPick'
     bNoSmooth=False
     CollisionRadius=28.000000
     CollisionHeight=8.000000
     Mass=50.000000
}
