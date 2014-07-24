//=============================================================================
// Tree7.
//=============================================================================
class Tree7 extends Tree;


#exec MESH IMPORT MESH=Tree7M ANIVFILE=MODELS\Tree13_a.3D DATAFILE=MODELS\Tree13_d.3D LODSTYLE=2
//#exec MESH LODPARAMS MESH=Tree7M STRENGTH=0.5 
#exec MESH ORIGIN MESH=Tree7M X=0 Y=320 Z=0 YAW=64 ROLL=-64
#exec MESH SEQUENCE MESH=Tree7M SEQ=All    STARTFRAME=0   NUMFRAMES=1
#exec MESH SEQUENCE MESH=Tree7M SEQ=Still  STARTFRAME=0   NUMFRAMES=1
#exec TEXTURE IMPORT NAME=JTree71 FILE=MODELS\Tree13.PCX GROUP=Skins FLAGS=2
#exec MESHMAP SCALE MESHMAP=Tree7M X=0.2 Y=0.2 Z=0.4
#exec MESHMAP SETTEXTURE MESHMAP=Tree7M NUM=1 TEXTURE=JTree71

defaultproperties
{
     Mesh=LodMesh'UnrealShare.Tree7M'
     CollisionRadius=12.000000
     CollisionHeight=65.000000
}
