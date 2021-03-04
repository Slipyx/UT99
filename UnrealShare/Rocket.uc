//=============================================================================
// rocket.
//=============================================================================
class rocket extends Projectile;

#exec MESH IMPORT MESH=RocketM ANIVFILE=MODELS\rocket_a.3D DATAFILE=MODELS\rocket_d.3D LODSTYLE=2 LODFRAME=3
#exec MESH LODPARAMS MESH=RocketM STRENGTH=0.2

#exec MESH ORIGIN MESH=RocketM X=0 Y=-240 Z=0 YAW=-64

#exec MESH SEQUENCE MESH=RocketM SEQ=All       STARTFRAME=0   NUMFRAMES=6
#exec MESH SEQUENCE MESH=RocketM SEQ=Still     STARTFRAME=0   NUMFRAMES=1
#exec MESH SEQUENCE MESH=RocketM SEQ=WingIn    STARTFRAME=1   NUMFRAMES=1
#exec MESH SEQUENCE MESH=RocketM SEQ=Armed     STARTFRAME=1   NUMFRAMES=3
#exec MESH SEQUENCE MESH=RocketM SEQ=SpinCCW   STARTFRAME=4   NUMFRAMES=1
#exec MESH SEQUENCE MESH=RocketM SEQ=SpinCW    STARTFRAME=5   NUMFRAMES=1

#exec TEXTURE IMPORT NAME=JRocket1 FILE=MODELS\rocket.PCX
#exec OBJ LOAD FILE=Textures\fireeffect16.utx PACKAGE=UnrealShare.Effect16
#exec MESHMAP SCALE MESHMAP=rocketM X=0.5 Y=0.5 Z=1.0 YAW=128
#exec MESHMAP SETTEXTURE MESHMAP=rocketM NUM=1 TEXTURE=Jrocket1 TLOD=50

#exec AUDIO IMPORT FILE="Sounds\EightBal\Ignite.WAV" NAME="Ignite" GROUP="Eightball"
#exec AUDIO IMPORT FILE="Sounds\EightBal\grenflor.wav" NAME="GrenadeFloor" GROUP="Eightball"
#exec AUDIO IMPORT FILE="Sounds\General\brufly1.WAV" NAME="Brufly1" GROUP="General"

var Actor Seeking;
var float MagnitudeVel,Count,SmokeRate;
var vector InitialDir;
var bool bRing,bHitWater,bWaterStart;
var int NumExtraRockets;

simulated function PostBeginPlay()
{
	Count = -0.1;
	if (Level.bHighDetailMode) SmokeRate = 0.035;
	else SmokeRate = 0.15;
}

simulated function Tick(float DeltaTime)
{
	local SpriteSmokePuff b;

	if (bHitWater || Level.Netmode==NM_DedicatedServer && RemoteRole != ROLE_DumbProxy)
	{
		Disable('Tick');
		Return;
	}
	Count += DeltaTime;
	if ( (Count>(SmokeRate+FRand()*(SmokeRate+NumExtraRockets*0.035))) ) 
	{
		b = Spawn(class'SpriteSmokePuff');
		if (RemoteRole != ROLE_DumbProxy)
		    b.RemoteRole = ROLE_None;		
		
		if( Level.bDropDetail )
			Count= -0.5; // Reduce detail.
		else Count = 0;

	}
}

auto state Flying
{

	simulated function ZoneChange( Zoneinfo NewZone )
	{
		local waterring w;
		
		if (!NewZone.bWaterZone || bHitWater) Return;

		bHitWater = True;
		Disable('Tick');
		if ( Level.NetMode != NM_DedicatedServer )
		{
			w = Spawn(class'WaterRing',,,,rot(16384,0,0));
			w.DrawScale = 0.2;
			w.RemoteRole = ROLE_None;
			PlayAnim( 'Still', 3.0 );
		}		
		Velocity=0.6*Velocity;
	}

	simulated function ProcessTouch (Actor Other, Vector HitLocation)
	{
		if ((Other != instigator) && (Rocket(Other) == none)) 
			Explode(HitLocation,Normal(HitLocation-Other.Location));
	}

	function BlowUp(vector HitLocation, RingExplosion r)
	{
		if ( Level.Game.IsA('DeathMatchGame') ) //bigger damage radius
			HurtRadius(0.9 * Damage,240.0, 'exploded', MomentumTransfer, HitLocation );
		else
			HurtRadius(Damage,200.0, 'exploded', MomentumTransfer, HitLocation );
		MakeNoise(1.0);

		if ( r != None )
			r.PlaySound(r.ExploSound,,6);
	}

	simulated function Explode(vector HitLocation, vector HitNormal)
	{
		local SpriteBallExplosion s;
		local RingExplosion3 r;

		s = spawn(class'SpriteBallExplosion',,,HitLocation + HitNormal*16);
		if ( RemoteRole!=ROLE_DumbProxy ) // 227: Make sure it's replicated on seeking rocket!
 		    s.RemoteRole = ROLE_None;

		if (bRing) 
		{
			r = Spawn(class'RingExplosion3',,,HitLocation + HitNormal*16,rotator(HitNormal));
			r.RemoteRole = ROLE_None;
		}
		BlowUp(HitLocation, r);

 		Destroy();
	}

	function BeginState()
	{
		initialDir = vector(Rotation);
		if ( Role == ROLE_Authority )	
			Velocity = speed*initialDir;
		Acceleration = initialDir*50;
		PlaySound(SpawnSound, SLOT_None, 2.3);
		PlayAnim( 'Armed', 0.2 );
		if (Region.Zone.bWaterZone)
		{
			bHitWater = True;
			Velocity=0.6*Velocity;
		}
	}
}

defaultproperties
{
      Seeking=None
      MagnitudeVel=0.000000
      Count=0.000000
      SmokeRate=0.000000
      InitialDir=(X=0.000000,Y=0.000000,Z=0.000000)
      bRing=False
      bHitWater=False
      bWaterStart=False
      NumExtraRockets=0
      speed=900.000000
      MaxSpeed=1600.000000
      Damage=85.000000
      MomentumTransfer=80000
      SpawnSound=Sound'UnrealShare.Eightball.Ignite'
      ImpactSound=Sound'UnrealShare.Eightball.GrenadeFloor'
      RemoteRole=ROLE_SimulatedProxy
      LifeSpan=6.000000
      AnimSequence="Armed"
      AmbientSound=Sound'UnrealShare.General.Brufly1'
      Skin=FireTexture'UnrealShare.Effect16.fireeffect16'
      Mesh=LodMesh'UnrealShare.RocketM'
      DrawScale=0.050000
      AmbientGlow=96
      bUnlit=True
      SoundRadius=9
      SoundVolume=255
      LightType=LT_Steady
      LightEffect=LE_NonIncidence
      LightBrightness=126
      LightHue=28
      LightSaturation=64
      LightRadius=6
      bCorona=True
      bBounce=True
}
