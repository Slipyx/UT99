//=============================================================================
// SmallSpark.
//=============================================================================
class SmallSpark extends Effects;

#exec MESH IMPORT MESH=SmallSparkM ANIVFILE=MODELS\Spark_a.3D DATAFILE=MODELS\Spark_d.3D X=0 Y=0 Z=0
#exec MESH ORIGIN MESH=SmallSparkM X=0 Y=0 Z=0 PITCH=-64
#exec MESH SEQUENCE MESH=SmallSparkM SEQ=All       STARTFRAME=0   NUMFRAMES=2
#exec MESH SEQUENCE MESH=SmallSparkM SEQ=Explosion STARTFRAME=0   NUMFRAMES=2
#exec TEXTURE IMPORT NAME=JSmlSpark1 FILE=MODELS\Spark.PCX GROUP=Skins
#exec MESHMAP SCALE MESHMAP=SmallSparkM X=0.06 Y=0.06 Z=0.12
#exec MESHMAP SETTEXTURE MESHMAP=SmallSparkM NUM=1 TEXTURE=JSmlSpark1


simulated function PostBeginPlay()
{
	Super.PostBeginPlay();

	if ( Level.NetMode != NM_DedicatedServer )
	{
		PlayAnim  ( 'Explosion', 0.2 );
		PlaySound (EffectSound1);
	}
}

simulated function AnimEnd()
{	
  	Destroy();
}

defaultproperties
{
     RemoteRole=ROLE_SimulatedProxy
     LifeSpan=4.000000
     DrawType=DT_Mesh
     Mesh=LodMesh'UnrealShare.SmallSparkM'
     AmbientGlow=223
     bUnlit=True
}
