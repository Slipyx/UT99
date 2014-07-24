//=============================================================================
// BloodPool.
//=============================================================================
class BloodPool extends Effects;

#exec MESH IMPORT MESH=BSpot ANIVFILE=MODELS\bpool_a.3D DATAFILE=MODELS\bpool_d.3D X=0 Y=0 Z=0
#exec MESH ORIGIN MESH=BSpot X=0 Y=0 Z=0 PITCH=0
#exec MESH SEQUENCE MESH=BSpot SEQ=All       STARTFRAME=0   NUMFRAMES=2
#exec MESH SEQUENCE MESH=BSpot SEQ=Explo     STARTFRAME=0   NUMFRAMES=2
#exec MESHMAP SCALE MESHMAP=BSpot X=0.2 Y=0.2 Z=0.2
#exec TEXTURE IMPORT NAME=T_BPool FILE=MODELS\BPool.PCX GROUP=Skins
#exec MESHMAP SETTEXTURE MESHMAP=BSpot NUM=1 TEXTURE=T_BPool

function PostBeginPlay()
{
	Super.PostBeginPlay();
	PlayAnim ( 'Explo', 0.005 );
}

simulated function EndAnim()
{
	Destroy();
}

defaultproperties
{
     bHighDetail=True
     LifeSpan=5.000000
     AnimSequence=Explo
     DrawType=DT_Mesh
     Mesh=LodMesh'UnrealShare.BSpot'
     AmbientGlow=100
}
