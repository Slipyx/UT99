//=============================================================================
// BruteProjectile.
//=============================================================================
class BruteProjectile extends Projectile;

#exec MESH IMPORT MESH=srocket ANIVFILE=MODELS\srocket_a.3D DATAFILE=MODELS\srocket_d.3D X=0 Y=0 Z=0
#exec MESH ORIGIN MESH=srocket X=0 Y=0 Z=-40 YAW=0 ROLL=0 PITCH=-64
#exec MESH SEQUENCE MESH=srocket SEQ=All       STARTFRAME=0   NUMFRAMES=16
#exec MESH SEQUENCE MESH=srocket SEQ=Ignite    STARTFRAME=0   NUMFRAMES=3
#exec MESH SEQUENCE MESH=srocket SEQ=Flying    STARTFRAME=3   NUMFRAMES=13
#exec TEXTURE IMPORT NAME=JTeace1 FILE=MODELS\srocket.PCX
#exec OBJ LOAD FILE=textures\FireEffect18.utx PACKAGE=UnrealShare.Effect18
#exec MESHMAP SCALE MESHMAP=srocket  X=1.0 Y=1.0 Z=2.0
#exec MESHMAP SETTEXTURE MESHMAP=srocket NUM=1 TEXTURE=JTeace1
#exec MESHMAP SETTEXTURE MESHMAP=srocket NUM=0 TEXTURE=UnrealShare.Effect18.FireEffect18

#exec AUDIO IMPORT FILE="Sounds\General\8blfly2.WAV" NAME="BRocket" GROUP="General"
#exec AUDIO IMPORT FILE="Sounds\EightBal\Ignite.WAV" NAME="Ignite" GROUP="Eightball"
#exec AUDIO IMPORT FILE="Sounds\flak\Explode1.WAV" NAME="Explode1" GROUP="flak"

var float TimerDelay;

auto state Flying
{
	simulated function Timer()
	{
		local SpriteSmokePuff bs;
			
		if (Level.NetMode!=NM_DedicatedServer) 
		{
			bs = Spawn(class'SpriteSmokePuff');
			bs.RemoteRole = ROLE_None;		
		}
		SetTimer(TimerDelay,True);			
		TimerDelay += 0.01;
	}

	simulated function ProcessTouch (Actor Other, Vector HitLocation)
	{
		if (Other != instigator)
			Explode(HitLocation,Vect(0,0,0));
	}
	
	function BlowUp(vector HitLocation)
	{
		HurtRadius(damage, 50 + instigator.skill * 45, 'exploded', MomentumTransfer, HitLocation);
		MakeNoise(1.0);
		PlaySound(ImpactSound);
	}

	simulated function Explode(vector HitLocation, vector HitNormal)
	{
		local SpriteBallExplosion s;

		BlowUp(HitLocation);
		s = spawn(class 'SpriteBallExplosion',,'',HitLocation+HitNormal*10 );
		s.RemoteRole = ROLE_None;
		Destroy();
	}

	simulated function AnimEnd()
	{
		LoopAnim('Flying');
		Disable('AnimEnd');
	}

	function SetUp()
	{
		PlaySound(SpawnSound);
		Velocity = Vector(Rotation) * speed;
		if ( ScriptedPawn(Instigator) != None )
		{
			Speed = ScriptedPawn(Instigator).ProjectileSpeed;
			if ( Instigator.IsA('LesserBrute') )
				Damage *= 0.7;
		}
	}

	simulated function BeginState()
	{
		if ( Level.NetMode != NM_DedicatedServer )
		{
			PlayAnim('Ignite',0.5);
			if (Level.bHighDetailMode) TimerDelay = 0.03;
			else TimerDelay = 5.0;;
			Timer();
		}
		SetUp();
	}

Begin:
	Sleep(7.0); //self destruct after 7.0 seconds
	Explode(Location,vect(0,0,0));
}

defaultproperties
{
     speed=700.000000
     MaxSpeed=900.000000
     Damage=30.000000
     MomentumTransfer=50000
     SpawnSound=Sound'UnrealShare.Eightball.Ignite'
     ImpactSound=Sound'UnrealShare.flak.Explode1'
     RemoteRole=ROLE_SimulatedProxy
     LifeSpan=8.000000
     AmbientSound=Sound'UnrealShare.General.BRocket'
     Texture=None
     Mesh=LodMesh'UnrealShare.srocket'
     DrawScale=0.120000
     AmbientGlow=9
     bUnlit=True
     SoundRadius=15
     SoundVolume=255
     SoundPitch=73
     LightType=LT_Steady
     LightBrightness=154
     LightHue=24
     LightSaturation=207
     LightRadius=2
}
