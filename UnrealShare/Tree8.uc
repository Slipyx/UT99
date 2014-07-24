//=============================================================================
// Tree8.
//=============================================================================
class Tree8 extends Tree;


#exec MESH IMPORT MESH=Tree8M ANIVFILE=MODELS\Tree14_a.3D DATAFILE=MODELS\Tree14_d.3D LODSTYLE=2
//#exec MESH LODPARAMS MESH=Tree8M STRENGTH=0.5 
#exec MESH ORIGIN MESH=Tree8M X=0 Y=320 Z=0 YAW=64 ROLL=-64
#exec MESH SEQUENCE MESH=Tree8M SEQ=All    STARTFRAME=0   NUMFRAMES=1
#exec MESH SEQUENCE MESH=Tree8M SEQ=Still  STARTFRAME=0   NUMFRAMES=1
#exec TEXTURE IMPORT NAME=JTree81 FILE=MODELS\Tree14.PCX GROUP=Skins FLAGS=2
#exec MESHMAP SCALE MESHMAP=Tree8M X=0.1 Y=0.1 Z=0.2
#exec MESHMAP SETTEXTURE MESHMAP=Tree8M NUM=1 TEXTURE=JTree81

defaultproperties
{
     Mesh=LodMesh'UnrealShare.Tree8M'
     CollisionRadius=15.000000
     CollisionHeight=32.000000
}
