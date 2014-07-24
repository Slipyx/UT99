//=============================================================================
// SkaarjCarcass.
//=============================================================================
class SkaarjCarcass extends CreatureCarcass;

#exec MESH IMPORT MESH=SkaarjBody ANIVFILE=MODELS\g_Skrb_a.3D DATAFILE=MODELS\g_skrb_d.3D X=0 Y=0 Z=0
#exec MESH ORIGIN MESH=SkaarjBody X=0 Y=0 Z=0 YAW=64
#exec MESH SEQUENCE MESH=SkaarjBody SEQ=All    STARTFRAME=0   NUMFRAMES=1
#exec MESH SEQUENCE MESH=SkaarjBody SEQ=Still  STARTFRAME=0   NUMFRAMES=1
#exec TEXTURE IMPORT NAME=JGSkaarj1  FILE=MODELS\skr1.PCX FAMILY=Skins 
#exec MESHMAP SCALE MESHMAP=SkaarjBody X=0.09 Y=0.09 Z=0.18
#exec MESHMAP SETTEXTURE MESHMAP=SkaarjBody NUM=1 TEXTURE=JGSkaarj1

#exec MESH IMPORT MESH=SkaarjHand ANIVFILE=MODELS\g_Skrh_a.3D DATAFILE=MODELS\g_skrh_d.3D X=0 Y=0 Z=0
#exec MESH ORIGIN MESH=SkaarjHand X=0 Y=0 Z=0 YAW=64
#exec MESH SEQUENCE MESH=SkaarjHand SEQ=All    STARTFRAME=0   NUMFRAMES=1
#exec MESH SEQUENCE MESH=SkaarjHand SEQ=Still  STARTFRAME=0   NUMFRAMES=1
#exec TEXTURE IMPORT NAME=JGSkaarj2  FILE=MODELS\skr2.PCX FAMILY=Skins 
#exec MESHMAP SCALE MESHMAP=SkaarjHand X=0.09 Y=0.09 Z=0.18
#exec MESHMAP SETTEXTURE MESHMAP=SkaarjHand NUM=1 TEXTURE=JGSkaarj2

#exec MESH IMPORT MESH=SkaarjHead ANIVFILE=MODELS\g_Skrz_a.3D DATAFILE=MODELS\g_skrz_d.3D X=0 Y=0 Z=0
#exec MESH ORIGIN MESH=SkaarjHead X=0 Y=0 Z=0 YAW=64
#exec MESH SEQUENCE MESH=SkaarjHead SEQ=All    STARTFRAME=0   NUMFRAMES=1
#exec MESH SEQUENCE MESH=SkaarjHead SEQ=Still  STARTFRAME=0   NUMFRAMES=1
#exec TEXTURE IMPORT NAME=JGSkaarj1  FILE=MODELS\skr1.PCX FAMILY=Skins 
#exec MESHMAP SCALE MESHMAP=SkaarjHead X=0.09 Y=0.09 Z=0.18
#exec MESHMAP SETTEXTURE MESHMAP=SkaarjHead NUM=1 TEXTURE=JGSkaarj1

#exec MESH IMPORT MESH=SkaarjLeg ANIVFILE=MODELS\g_Skrl_a.3D DATAFILE=MODELS\g_skrl_d.3D X=0 Y=0 Z=0
#exec MESH ORIGIN MESH=SkaarjLeg X=0 Y=0 Z=0 YAW=64
#exec MESH SEQUENCE MESH=SkaarjLeg SEQ=All    STARTFRAME=0   NUMFRAMES=1
#exec MESH SEQUENCE MESH=SkaarjLeg SEQ=Still  STARTFRAME=0   NUMFRAMES=1
#exec TEXTURE IMPORT NAME=JGSkaarj2  FILE=MODELS\skr2.PCX FAMILY=Skins 
#exec MESHMAP SCALE MESHMAP=SkaarjLeg X=0.09 Y=0.09 Z=0.18
#exec MESHMAP SETTEXTURE MESHMAP=SkaarjLeg NUM=1 TEXTURE=JGSkaarj2

#exec MESH IMPORT MESH=SkaarjTail ANIVFILE=MODELS\g_Skrt_a.3D DATAFILE=MODELS\g_skrt_d.3D X=0 Y=0 Z=0
#exec MESH ORIGIN MESH=SkaarjTail X=0 Y=0 Z=0 YAW=64
#exec MESH SEQUENCE MESH=SkaarjTail SEQ=All    STARTFRAME=0   NUMFRAMES=1
#exec MESH SEQUENCE MESH=SkaarjTail SEQ=Still  STARTFRAME=0   NUMFRAMES=1
#exec TEXTURE IMPORT NAME=JGSkaarj2  FILE=MODELS\skr2.PCX FAMILY=Skins 
#exec MESHMAP SCALE MESHMAP=SkaarjTail X=0.1 Y=0.1 Z=0.2
#exec MESHMAP SETTEXTURE MESHMAP=SkaarjTail NUM=1 TEXTURE=JGSkaarj2

function ForceMeshToExist()
{
	//never called
	Spawn(class 'Skaarjwarrior');
}

static simulated function bool AllowChunk(int N, name A)
{
	if ( (A == 'Death5') && (N == 7) )
		return false;

	return true;
}

function CreateReplacement()
{
	local CreatureChunks carc;
	
	if (bHidden)
		return;
	carc = Spawn(class'SkaarjMasterChunk'); 
	if (carc != None)
	{
		carc.bMasterChunk = true;
		carc.Initfor(self);
		carc.Bugs = Bugs;
		if ( Bugs != None )
			Bugs.SetBase(carc);
		Bugs = None;
	}
	else if ( Bugs != None )
		Bugs.Destroy();
}

defaultproperties
{
     bodyparts(0)=LodMesh'UnrealShare.SkaarjTail'
     bodyparts(1)=LodMesh'UnrealShare.SkaarjBody'
     bodyparts(2)=LodMesh'UnrealShare.SkaarjHand'
     bodyparts(3)=LodMesh'UnrealShare.SkaarjBody'
     bodyparts(4)=LodMesh'UnrealShare.SkaarjLeg'
     bodyparts(5)=LodMesh'UnrealShare.SkaarjLeg'
     bodyparts(6)=LodMesh'UnrealShare.CowBody1'
     bodyparts(7)=LodMesh'UnrealShare.SkaarjHead'
     ZOffset(1)=0.000000
     ZOffset(3)=0.300000
     ZOffset(4)=-0.500000
     ZOffset(5)=-0.500000
     AnimSequence=Death
     Mesh=LodMesh'UnrealShare.Skaarjw'
     CollisionRadius=35.000000
     CollisionHeight=46.000000
     Mass=150.000000
     Buoyancy=140.000000
}
