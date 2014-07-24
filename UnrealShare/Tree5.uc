//=============================================================================
// Tree5.
//=============================================================================
class Tree5 extends Tree;

#exec MESH IMPORT MESH=Tree5M ANIVFILE=MODELS\Tree11_a.3D DATAFILE=MODELS\Tree11_d.3D LODSTYLE=2
//#exec MESH LODPARAMS MESH=Tree5M STRENGTH=0.5 
#exec MESH ORIGIN MESH=Tree5M X=0 Y=320 Z=0 YAW=64 ROLL=-64
#exec MESH SEQUENCE MESH=Tree5M SEQ=All    STARTFRAME=0   NUMFRAMES=1
#exec MESH SEQUENCE MESH=Tree5M SEQ=Still  STARTFRAME=0   NUMFRAMES=1
#exec TEXTURE IMPORT NAME=JTree51 FILE=MODELS\Tree11.PCX GROUP=Skins FLAGS=2
#exec MESHMAP SCALE MESHMAP=Tree5M X=0.25 Y=0.25 Z=0.5
#exec MESHMAP SETTEXTURE MESHMAP=Tree5M NUM=1 TEXTURE=JTree51

defaultproperties
{
     Mesh=LodMesh'UnrealShare.Tree5M'
     CollisionRadius=12.000000
     CollisionHeight=80.000000
}
