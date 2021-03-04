//=============================================================================
// Tree6.
//=============================================================================
class Tree6 extends Tree;

#exec MESH IMPORT MESH=Tree6M ANIVFILE=MODELS\Tree12_a.3D DATAFILE=MODELS\Tree12_d.3D LODSTYLE=2
//#exec MESH LODPARAMS MESH=Tree6M STRENGTH=0.5 
#exec MESH ORIGIN MESH=Tree6M X=-50 Y=320 Z=0 YAW=64 ROLL=-64
#exec MESH SEQUENCE MESH=Tree6M SEQ=All    STARTFRAME=0   NUMFRAMES=1
#exec MESH SEQUENCE MESH=Tree6M SEQ=Still  STARTFRAME=0   NUMFRAMES=1
#exec TEXTURE IMPORT NAME=JTree61 FILE=MODELS\Tree12.PCX GROUP=Skins FLAGS=2
#exec MESHMAP SCALE MESHMAP=Tree6M X=0.3 Y=0.3 Z=0.6
#exec MESHMAP SETTEXTURE MESHMAP=Tree6M NUM=1 TEXTURE=JTree61

defaultproperties
{
      Mesh=LodMesh'UnrealShare.Tree6M'
      CollisionRadius=17.000000
      CollisionHeight=93.000000
}
