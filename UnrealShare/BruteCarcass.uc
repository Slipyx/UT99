//=============================================================================
// BruteCarcass.
//=============================================================================
class BruteCarcass extends CreatureCarcass;

#exec MESH IMPORT MESH=BigChunk1 ANIVFILE=MODELS\g_cow2_a.3D DATAFILE=MODELS\g_cow2_d.3D X=0 Y=0 Z=0
#exec MESH ORIGIN MESH=bigchunk1 X=0 Y=-30 Z=0 YAW=64
#exec MESH SEQUENCE MESH=bigchunk1 SEQ=All    STARTFRAME=0   NUMFRAMES=1
#exec MESH SEQUENCE MESH=bigchunk1 SEQ=Still  STARTFRAME=0   NUMFRAMES=1
#exec TEXTURE IMPORT NAME=JGCow1  FILE=MODELS\Nc_1.PCX GROUP=Skins 
#exec MESHMAP SCALE MESHMAP=bigchunk1 X=0.12 Y=0.12 Z=0.24
#exec MESHMAP SETTEXTURE MESHMAP=bigchunk1 NUM=1 TEXTURE=JGCow1

#exec MESH IMPORT MESH=bigchunk2 ANIVFILE=MODELS\g_cowb_a.3D DATAFILE=MODELS\g_cowb_d.3D X=0 Y=0 Z=0
#exec MESH ORIGIN MESH=bigchunk2 X=0 Y=-30 Z=0 YAW=64
#exec MESH SEQUENCE MESH=bigchunk2 SEQ=All    STARTFRAME=0   NUMFRAMES=1
#exec MESH SEQUENCE MESH=bigchunk2 SEQ=Still  STARTFRAME=0   NUMFRAMES=1
#exec TEXTURE IMPORT NAME=JGCow1  FILE=MODELS\Nc_1.PCX GROUP=Skins 
#exec MESHMAP SCALE MESHMAP=bigchunk2 X=0.1 Y=0.1 Z=0.2
#exec MESHMAP SETTEXTURE MESHMAP=bigchunk2 NUM=1 TEXTURE=JGCow1

#exec MESH IMPORT MESH=BruteHead ANIVFILE=MODELS\g_brth_a.3D DATAFILE=MODELS\g_brth_d.3D X=0 Y=0 Z=0
#exec MESH ORIGIN MESH=BruteHead X=0 Y=0 Z=0 YAW=64
#exec MESH SEQUENCE MESH=BruteHead SEQ=All    STARTFRAME=0   NUMFRAMES=1
#exec MESH SEQUENCE MESH=BruteHead SEQ=Still  STARTFRAME=0   NUMFRAMES=1
#exec TEXTURE IMPORT NAME=Jgbrt  FILE=MODELS\g_brute.PCX GROUP=Skins 
#exec MESHMAP SCALE MESHMAP=BruteHead X=0.09 Y=0.09 Z=0.18
#exec MESHMAP SETTEXTURE MESHMAP=BruteHead NUM=1 TEXTURE=Jgbrt

#exec MESH IMPORT MESH=BruteHand ANIVFILE=MODELS\g_brtz_a.3D DATAFILE=MODELS\g_brtz_d.3D X=0 Y=0 Z=0
#exec MESH ORIGIN MESH=BruteHand X=0 Y=0 Z=0 YAW=64
#exec MESH SEQUENCE MESH=BruteHand SEQ=All    STARTFRAME=0   NUMFRAMES=1
#exec MESH SEQUENCE MESH=BruteHand SEQ=Still  STARTFRAME=0   NUMFRAMES=1
#exec TEXTURE IMPORT NAME=Jgbrt  FILE=MODELS\g_brute.PCX GROUP=Skins 
#exec MESHMAP SCALE MESHMAP=BruteHand X=0.09 Y=0.09 Z=0.18
#exec MESHMAP SETTEXTURE MESHMAP=BruteHand NUM=1 TEXTURE=Jgbrt

#exec MESH IMPORT MESH=BrutePiece ANIVFILE=MODELS\g_brtp_a.3D DATAFILE=MODELS\g_brtp_d.3D X=0 Y=0 Z=0
#exec MESH ORIGIN MESH=BrutePiece X=0 Y=0 Z=0 YAW=64
#exec MESH SEQUENCE MESH=BrutePiece SEQ=All    STARTFRAME=0   NUMFRAMES=1
#exec MESH SEQUENCE MESH=BrutePiece SEQ=Still  STARTFRAME=0   NUMFRAMES=1
#exec TEXTURE IMPORT NAME=Jgbrt  FILE=MODELS\g_brute.PCX GROUP=Skins 
#exec MESHMAP SCALE MESHMAP=BrutePiece X=0.09 Y=0.09 Z=0.18
#exec MESHMAP SETTEXTURE MESHMAP=BrutePiece NUM=1 TEXTURE=Jgbrt

#exec MESH IMPORT MESH=BruteFoot ANIVFILE=MODELS\g_brtf_a.3D DATAFILE=MODELS\g_brtf_d.3D X=0 Y=0 Z=0
#exec MESH ORIGIN MESH=BruteFoot X=0 Y=0 Z=0 YAW=64
#exec MESH SEQUENCE MESH=BruteFoot SEQ=All    STARTFRAME=0   NUMFRAMES=1
#exec MESH SEQUENCE MESH=BruteFoot SEQ=Still  STARTFRAME=0   NUMFRAMES=1
#exec TEXTURE IMPORT NAME=Jgbrt  FILE=MODELS\g_brute.PCX GROUP=Skins 
#exec MESHMAP SCALE MESHMAP=BruteFoot X=0.09 Y=0.09 Z=0.18
#exec MESHMAP SETTEXTURE MESHMAP=BruteFoot NUM=1 TEXTURE=Jgbrt



function ForceMeshToExist()
{
	//never called
	Spawn(class 'Brute');
}

defaultproperties
{
     bodyparts(0)=LodMesh'UnrealShare.BruteHead'
     bodyparts(1)=LodMesh'UnrealShare.BruteFoot'
     bodyparts(2)=LodMesh'UnrealShare.BruteHand'
     bodyparts(3)=LodMesh'UnrealShare.BigChunk1'
     bodyparts(4)=LodMesh'UnrealShare.BrutePiece'
     bodyparts(5)=LodMesh'UnrealShare.BrutePiece'
     bodyparts(6)=LodMesh'UnrealShare.BruteHand'
     bodyparts(7)=LodMesh'UnrealShare.bigchunk2'
     ZOffset(0)=0.600000
     ZOffset(1)=0.500000
     ZOffset(3)=0.200000
     ZOffset(4)=-0.200000
     ZOffset(5)=-0.500000
     AnimSequence=Dead1
     Mesh=LodMesh'UnrealShare.Brute1'
     CollisionRadius=52.000000
     CollisionHeight=52.000000
     Mass=400.000000
     Buoyancy=390.000000
}
