//=============================================================================
// Plant1.
//=============================================================================
class Plant1 extends Decoration;

#exec MESH IMPORT MESH=Plant1M ANIVFILE=MODELS\plant1_a.3D DATAFILE=MODELS\plant1_d.3D LODSTYLE=2
//#exec MESH LODPARAMS MESH=Plant1M STRENGTH=0.5 
#exec MESH ORIGIN MESH=Plant1M X=0 Y=100 Z=-10 YAW=64

#exec MESH SEQUENCE MESH=plant1M SEQ=All    STARTFRAME=0   NUMFRAMES=1
#exec MESH SEQUENCE MESH=plant1M SEQ=Still  STARTFRAME=0   NUMFRAMES=1

#exec TEXTURE IMPORT NAME=JPlant11 FILE=MODELS\plant1.PCX GROUP=Skins FLAGS=2
#exec MESHMAP SCALE MESHMAP=plant1M X=0.05 Y=0.05 Z=0.1
#exec MESHMAP SETTEXTURE MESHMAP=plant1M NUM=1 TEXTURE=Jplant11

defaultproperties
{
     DrawType=DT_Mesh
     Mesh=LodMesh'UnrealShare.Plant1M'
     CollisionRadius=6.000000
     CollisionHeight=13.000000
     bCollideWorld=True
}
