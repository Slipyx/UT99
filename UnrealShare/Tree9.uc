//=============================================================================
// Tree9.
//=============================================================================
class Tree9 extends Tree;


#exec MESH IMPORT MESH=Tree9M ANIVFILE=MODELS\Tree15_a.3D DATAFILE=MODELS\Tree15_d.3D LODSTYLE=2
//#exec MESH LODPARAMS MESH=Tree9M STRENGTH=0.5 
#exec MESH ORIGIN MESH=Tree9M X=0 Y=320 Z=0 YAW=64 ROLL=-64
#exec MESH SEQUENCE MESH=Tree9M SEQ=All    STARTFRAME=0   NUMFRAMES=1
#exec MESH SEQUENCE MESH=Tree9M SEQ=Still  STARTFRAME=0   NUMFRAMES=1
#exec TEXTURE IMPORT NAME=JTree91 FILE=MODELS\Tree15.PCX GROUP=Skins FLAGS=2
#exec MESHMAP SCALE MESHMAP=Tree9M X=0.12 Y=0.12 Z=0.24
#exec MESHMAP SETTEXTURE MESHMAP=Tree9M NUM=1 TEXTURE=JTree91

defaultproperties
{
      Mesh=None
      CollisionRadius=15.000000
      CollisionHeight=39.000000
}
