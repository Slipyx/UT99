//=============================================================================
// Plant3.
//=============================================================================
class Plant3 extends Decoration;

#exec MESH IMPORT MESH=Plant3M ANIVFILE=MODELS\plant3_a.3D DATAFILE=MODELS\plant3_d.3D LODSTYLE=2
//#exec MESH LODPARAMS MESH=Plant3M STRENGTH=0.5 
#exec MESH ORIGIN MESH=Plant3M X=0 Y=100 Z=210 YAW=64

#exec MESH SEQUENCE MESH=plant3M SEQ=All    STARTFRAME=0   NUMFRAMES=1
#exec MESH SEQUENCE MESH=plant3M SEQ=Still  STARTFRAME=0   NUMFRAMES=1

#exec TEXTURE IMPORT NAME=JPlant31 FILE=MODELS\plant3.PCX GROUP=Skins FLAGS=2
#exec MESHMAP SCALE MESHMAP=plant3M X=0.05 Y=0.05 Z=0.1
#exec MESHMAP SETTEXTURE MESHMAP=plant3M NUM=1 TEXTURE=Jplant31

defaultproperties
{
      DrawType=DT_Mesh
      Mesh=LodMesh'UnrealShare.Plant3M'
      CollisionRadius=12.000000
      CollisionHeight=21.000000
      bCollideActors=True
      bCollideWorld=True
}
