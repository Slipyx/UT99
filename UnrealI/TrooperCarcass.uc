//=============================================================================
// TrooperCarcass.
//=============================================================================
class TrooperCarcass extends CreatureCarcass;

#exec MESH IMPORT MESH=SkaarjBody ANIVFILE=MODELS\g_Skrb_a.3D DATAFILE=MODELS\g_skrb_d.3D X=0 Y=0 Z=0
#exec MESH ORIGIN MESH=SkaarjBody X=0 Y=0 Z=0 YAW=64
#exec MESH SEQUENCE MESH=SkaarjBody SEQ=All    STARTFRAME=0   NUMFRAMES=1
#exec MESH SEQUENCE MESH=SkaarjBody SEQ=Still  STARTFRAME=0   NUMFRAMES=1
#exec TEXTURE IMPORT NAME=JGSkaarj1  FILE=..\UnrealShare\MODELS\skr1.PCX FAMILY=Skins 
#exec MESHMAP SCALE MESHMAP=SkaarjBody X=0.09 Y=0.09 Z=0.18
#exec MESHMAP SETTEXTURE MESHMAP=SkaarjBody NUM=1 TEXTURE=JGSkaarj1

#exec MESH IMPORT MESH=SkaarjHead ANIVFILE=MODELS\g_Skrz_a.3D DATAFILE=MODELS\g_skrz_d.3D X=0 Y=0 Z=0
#exec MESH ORIGIN MESH=SkaarjHead X=0 Y=0 Z=0 YAW=64
#exec MESH SEQUENCE MESH=SkaarjHead SEQ=All    STARTFRAME=0   NUMFRAMES=1
#exec MESH SEQUENCE MESH=SkaarjHead SEQ=Still  STARTFRAME=0   NUMFRAMES=1
#exec TEXTURE IMPORT NAME=JGSkaarj1  FILE=..\UnrealShare\MODELS\skr1.PCX FAMILY=Skins 
#exec MESHMAP SCALE MESHMAP=SkaarjHead X=0.09 Y=0.09 Z=0.18
#exec MESHMAP SETTEXTURE MESHMAP=SkaarjHead NUM=1 TEXTURE=JGSkaarj1

#exec MESH IMPORT MESH=SkaarjLeg ANIVFILE=MODELS\g_Skrl_a.3D DATAFILE=MODELS\g_skrl_d.3D X=0 Y=0 Z=0
#exec MESH ORIGIN MESH=SkaarjLeg X=0 Y=0 Z=0 YAW=64
#exec MESH SEQUENCE MESH=SkaarjLeg SEQ=All    STARTFRAME=0   NUMFRAMES=1
#exec MESH SEQUENCE MESH=SkaarjLeg SEQ=Still  STARTFRAME=0   NUMFRAMES=1
#exec TEXTURE IMPORT NAME=JGSkaarj2  FILE=..\UnrealShare\MODELS\skr2.PCX FAMILY=Skins 
#exec MESHMAP SCALE MESHMAP=SkaarjLeg X=0.09 Y=0.09 Z=0.18
#exec MESHMAP SETTEXTURE MESHMAP=SkaarjLeg NUM=1 TEXTURE=JGSkaarj2

function ForceMeshToExist()
{
	//never called
	Spawn(class 'SkaarjTrooper');
}

function CreateReplacement()
{
	local CreatureChunks carc;
	
	if (bHidden)
		return;
	carc = Spawn(class'TrooperMasterChunk'); 
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
      bodyparts(0)=LodMesh'UnrealShare.SkaarjBody'
      bodyparts(1)=LodMesh'UnrealShare.SkaarjHead'
      bodyparts(2)=LodMesh'UnrealShare.SkaarjBody'
      bodyparts(3)=LodMesh'UnrealShare.SkaarjLeg'
      bodyparts(4)=LodMesh'UnrealShare.SkaarjLeg'
      bodyparts(5)=LodMesh'UnrealShare.CowBody1'
      bodyparts(6)=LodMesh'UnrealShare.CowBody2'
      AnimSequence="Death"
      Mesh=LodMesh'UnrealI.sktrooper'
      CollisionRadius=32.000000
      CollisionHeight=42.000000
      Mass=130.000000
}
