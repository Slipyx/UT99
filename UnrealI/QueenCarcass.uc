//=============================================================================
// QueenCarcass.
//=============================================================================
class QueenCarcass extends CreatureCarcass;

#exec MESH IMPORT MESH=BigChunk1 ANIVFILE=MODELS\g_cow2_a.3D DATAFILE=MODELS\g_cow2_d.3D X=0 Y=0 Z=0
#exec MESH ORIGIN MESH=bigchunk1 X=0 Y=-30 Z=0 YAW=64
#exec MESH SEQUENCE MESH=bigchunk1 SEQ=All    STARTFRAME=0   NUMFRAMES=1
#exec MESH SEQUENCE MESH=bigchunk1 SEQ=Still  STARTFRAME=0   NUMFRAMES=1
#exec TEXTURE IMPORT NAME=JGCow1  FILE=..\UnrealShare\MODELS\Nc_1.PCX GROUP=Skins 
#exec MESHMAP SCALE MESHMAP=bigchunk1 X=0.12 Y=0.12 Z=0.24
#exec MESHMAP SETTEXTURE MESHMAP=bigchunk1 NUM=1 TEXTURE=JGCow1

#exec MESH IMPORT MESH=bigchunk2 ANIVFILE=MODELS\g_cowb_a.3D DATAFILE=MODELS\g_cowb_d.3D X=0 Y=0 Z=0
#exec MESH ORIGIN MESH=bigchunk2 X=0 Y=-30 Z=0 YAW=64
#exec MESH SEQUENCE MESH=bigchunk2 SEQ=All    STARTFRAME=0   NUMFRAMES=1
#exec MESH SEQUENCE MESH=bigchunk2 SEQ=Still  STARTFRAME=0   NUMFRAMES=1
#exec TEXTURE IMPORT NAME=JGCow1  FILE=..\UnrealShare\MODELS\Nc_1.PCX GROUP=Skins 
#exec MESHMAP SCALE MESHMAP=bigchunk2 X=0.1 Y=0.1 Z=0.2
#exec MESHMAP SETTEXTURE MESHMAP=bigchunk2 NUM=1 TEXTURE=JGCow1

function ForceMeshToExist()
{
	//never called
	Spawn(class 'Queen');
}

defaultproperties
{
      bodyparts(0)=LodMesh'UnrealShare.BigChunk1'
      bodyparts(1)=LodMesh'UnrealShare.BigChunk1'
      bodyparts(2)=LodMesh'UnrealShare.bigchunk2'
      bodyparts(3)=LodMesh'UnrealShare.bigchunk2'
      bodyparts(4)=LodMesh'UnrealShare.BigChunk1'
      bodyparts(5)=LodMesh'UnrealShare.bigchunk2'
      bodyparts(6)=LodMesh'UnrealShare.BigChunk1'
      bodyparts(7)=LodMesh'UnrealShare.bigchunk2'
      ZOffset(0)=0.600000
      ZOffset(1)=0.500000
      ZOffset(3)=0.200000
      ZOffset(4)=-0.200000
      ZOffset(5)=-0.500000
      bPermanent=True
      AnimSequence="OutCold"
      Mesh=LodMesh'UnrealI.SkQueen'
      CollisionRadius=82.000000
      CollisionHeight=97.000000
      Mass=1000.000000
}
