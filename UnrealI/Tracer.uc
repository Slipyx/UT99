//=============================================================================
// Tracer.
//=============================================================================
class Tracer extends Projectile;

#exec MESH IMPORT MESH=TracerM ANIVFILE=MODELS\tracer_a.3D DATAFILE=MODELS\tracer_d.3D X=0 Y=0 Z=0
#exec MESH ORIGIN MESH=TracerM X=0 Y=0 Z=-0 YAW=64
#exec MESH SEQUENCE MESH=TracerM SEQ=All    STARTFRAME=0   NUMFRAMES=1
#exec MESH SEQUENCE MESH=TracerM SEQ=Still  STARTFRAME=0   NUMFRAMES=1
#exec TEXTURE IMPORT NAME=Jmisc2 FILE=..\unrealshare\MODELS\misc2.PCX
#exec MESHMAP SCALE MESHMAP=TracerM X=0.07 Y=0.2 Z=0.14
#exec MESHMAP SETTEXTURE MESHMAP=TracerM NUM=0 TEXTURE=Jmisc2

	function PostBeginPlay()
	{
		Super.PostBeginPlay();
		Velocity = Vector(Rotation) * speed;
	}

	simulated function ProcessTouch (Actor Other, Vector HitLocation)
	{
		if (Other != instigator)
			Destroy();
	}

defaultproperties
{
      speed=10000.000000
      MaxSpeed=10000.000000
      RemoteRole=ROLE_SimulatedProxy
      LifeSpan=3.000000
      Mesh=LodMesh'UnrealI.TracerM'
      AmbientGlow=130
      bUnlit=True
}
