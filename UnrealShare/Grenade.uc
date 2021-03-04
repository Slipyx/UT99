//=============================================================================
// Grenade.
//=============================================================================
class Grenade extends Projectile;

#exec MESH IMPORT MESH=GrenadeM ANIVFILE=MODELS\rocket_a.3D DATAFILE=MODELS\rocket_d.3D X=0 Y=0 Z=0
#exec MESH ORIGIN MESH=GrenadeM X=0 Y=0 Z=0 YAW=-64

#exec MESH SEQUENCE MESH=GrenadeM SEQ=All       STARTFRAME=0   NUMFRAMES=6
#exec MESH SEQUENCE MESH=GrenadeM SEQ=Still     STARTFRAME=0   NUMFRAMES=1
#exec MESH SEQUENCE MESH=GrenadeM SEQ=WingIn    STARTFRAME=1   NUMFRAMES=1
#exec MESH SEQUENCE MESH=GrenadeM SEQ=Armed     STARTFRAME=1   NUMFRAMES=3
#exec MESH SEQUENCE MESH=GrenadeM SEQ=SpinCCW   STARTFRAME=4   NUMFRAMES=1
#exec MESH SEQUENCE MESH=GrenadeM SEQ=SpinCW    STARTFRAME=5   NUMFRAMES=1

#exec TEXTURE IMPORT NAME=JRocket1 FILE=MODELS\Rocket.PCX
#exec MESHMAP SCALE MESHMAP=GrenadeM X=0.025 Y=0.025 Z=0.05 YAW=128
#exec MESHMAP SETTEXTURE MESHMAP=GrenadeM NUM=1 TEXTURE=JRocket1 TLOD=50

#exec AUDIO IMPORT FILE="Sounds\EightBal\grenflor.wav" NAME="GrenadeFloor" GROUP="Eightball"

var bool bCanHitOwner, bHitWater;
var float Count, SmokeRate;
var ScriptedPawn WarnTarget;	// warn this pawn away
var int NumExtraGrenades;

simulated function PostBeginPlay()
{
	local vector X,Y,Z;
	local rotator RandRot;

	Super.PostBeginPlay();
	if ( Level.NetMode != NM_DedicatedServer )
		PlayAnim('WingIn');
	SetTimer(2.5+FRand()*0.5,false);                  //Grenade begins unarmed

	if ( Role == ROLE_Authority )
	{
		if (Instigator!=None)
		{
			GetAxes(Instigator.ViewRotation,X,Y,Z);
			Velocity = X * (Instigator.Velocity Dot X)*0.4 + Vector(Rotation) * (Speed +
					   FRand() * 100);
		}
		else
			Velocity = Vector(Rotation) * (Speed + FRand() * 100);
		Velocity.z += 210;
		RandRot.Pitch = FRand() * 1400 - 700;
		RandRot.Yaw = FRand() * 1400 - 700;
		RandRot.Roll = FRand() * 1400 - 700;
		MaxSpeed = 1000;
		Velocity = Velocity >> RandRot;
		RandSpin(50000);	
		bCanHitOwner = False;
		if (Instigator.HeadRegion.Zone.bWaterZone)
		{
			bHitWater = True;
			Disable('Tick');
			Velocity=0.6*Velocity;			
		}
	}	
}

simulated function BeginPlay()
{
	if (Level.bHighDetailMode) SmokeRate = 0.03;
	else SmokeRate = 0.15;
}

simulated function ZoneChange( Zoneinfo NewZone )
{
	local waterring w;
	
	if (!NewZone.bWaterZone || bHitWater) Return;

	bHitWater = True;
	w = Spawn(class'WaterRing',,,,rot(16384,0,0));
	w.DrawScale = 0.2;
	w.RemoteRole = ROLE_None;
	Velocity=0.6*Velocity;
}

simulated function Timer()
{
	Explosion(Location+Vect(0,0,1)*16);
}

simulated function Tick(float DeltaTime)
{
	local BlackSmoke b;

	if( bHitWater || Level.NetMode==NM_DedicatedServer )
	{
		Disable('Tick');
		Return;
	}
	Count += DeltaTime;
	if ( (Count>Frand()*SmokeRate+SmokeRate+NumExtraGrenades*0.03) )
	{
		b = Spawn(class'BlackSmoke');
		b.RemoteRole = ROLE_None;
		if( Level.bDropDetail )
			Count= -0.5; // Reduce detail.
		else Count = 0;
	}
}

simulated function Landed( vector HitNormal )
{
	HitWall( HitNormal, None );
}

simulated function ProcessTouch( actor Other, vector HitLocation )
{
	if ( (Other!=instigator) || bCanHitOwner )
		Explosion(HitLocation);
}

simulated function HitWall( vector HitNormal, actor Wall )
{
	bCanHitOwner = True;
	Velocity = 0.8*(( Velocity dot HitNormal ) * HitNormal * (-2.0) + Velocity);   // Reflect off Wall w/damping
	RandSpin(100000);
	speed = VSize(Velocity);
	if ( Level.NetMode != NM_DedicatedServer )
		PlaySound(ImpactSound, SLOT_Misc, FMax(0.5, speed/800) );
	if ( Velocity.Z > 400 )
		Velocity.Z = 0.5 * (400 + Velocity.Z);	
	else if ( speed < 20 ) 
	{
		bBounce = False;
		SetPhysics(PHYS_None);
	}
}

///////////////////////////////////////////////////////
function BlowUp(vector HitLocation)
{
	HurtRadius(damage, 200, 'exploded', MomentumTransfer, HitLocation);
	MakeNoise(1.0);
}

simulated function Explosion(vector HitLocation)
{
	local SpriteBallExplosion s;

	BlowUp(HitLocation);
  	s = spawn(class'SpriteBallExplosion',,,HitLocation);
	s.RemoteRole = ROLE_None;
 	Destroy();
}

defaultproperties
{
      bCanHitOwner=False
      bHitWater=False
      Count=0.000000
      SmokeRate=0.000000
      WarnTarget=None
      NumExtraGrenades=0
      speed=600.000000
      MaxSpeed=1000.000000
      Damage=100.000000
      MomentumTransfer=50000
      ImpactSound=Sound'UnrealShare.Eightball.GrenadeFloor'
      Physics=PHYS_Falling
      RemoteRole=ROLE_SimulatedProxy
      AnimSequence="WingIn"
      Mesh=LodMesh'UnrealShare.GrenadeM'
      AmbientGlow=64
      bUnlit=True
      bBounce=True
      bFixedRotationDir=True
      DesiredRotation=(Pitch=12000,Yaw=5666,Roll=2334)
}
