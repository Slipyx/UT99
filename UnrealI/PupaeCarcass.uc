//=============================================================================
// PupaeCarcass.
//=============================================================================
class PupaeCarcass extends CreatureCarcass;

#exec MESH IMPORT MESH=PupaeBody ANIVFILE=MODELS\g_pupb_a.3D DATAFILE=MODELS\g_pupb_d.3D X=0 Y=0 Z=0
#exec MESH ORIGIN MESH=PupaeBody X=0 Y=0 Z=0 YAW=64
#exec MESH SEQUENCE MESH=PupaeBody SEQ=All    STARTFRAME=0   NUMFRAMES=1
#exec MESH SEQUENCE MESH=PupaeBody SEQ=Still  STARTFRAME=0   NUMFRAMES=1
#exec TEXTURE IMPORT NAME=Jgpupae1  FILE=MODELS\g_pupae.PCX GROUP=Skins 
#exec MESHMAP SCALE MESHMAP=PupaeBody X=0.09 Y=0.09 Z=0.18
#exec MESHMAP SETTEXTURE MESHMAP=PupaeBody NUM=1 TEXTURE=Jgpupae1

#exec MESH IMPORT MESH=PupaeHead ANIVFILE=MODELS\g_puph_a.3D DATAFILE=MODELS\g_puph_d.3D X=0 Y=0 Z=0
#exec MESH ORIGIN MESH=PupaeHead X=0 Y=0 Z=0 YAW=64
#exec MESH SEQUENCE MESH=PupaeHead SEQ=All    STARTFRAME=0   NUMFRAMES=1
#exec MESH SEQUENCE MESH=PupaeHead SEQ=Still  STARTFRAME=0   NUMFRAMES=1
#exec TEXTURE IMPORT NAME=Jgpupae1  FILE=MODELS\g_pupae.PCX GROUP=Skins 
#exec MESHMAP SCALE MESHMAP=PupaeHead X=0.09 Y=0.09 Z=0.18
#exec MESHMAP SETTEXTURE MESHMAP=PupaeHead NUM=1 TEXTURE=Jgpupae1

#exec MESH IMPORT MESH=PupaeLeg1 ANIVFILE=MODELS\g_pupl_a.3D DATAFILE=MODELS\g_pupl_d.3D X=0 Y=0 Z=0
#exec MESH ORIGIN MESH=PupaeLeg1 X=0 Y=0 Z=0 YAW=64
#exec MESH SEQUENCE MESH=PupaeLeg1 SEQ=All    STARTFRAME=0   NUMFRAMES=1
#exec MESH SEQUENCE MESH=PupaeLeg1 SEQ=Still  STARTFRAME=0   NUMFRAMES=1
#exec TEXTURE IMPORT NAME=Jgpupae1  FILE=MODELS\g_pupae.PCX GROUP=Skins 
#exec MESHMAP SCALE MESHMAP=PupaeLeg1 X=0.09 Y=0.09 Z=0.18
#exec MESHMAP SETTEXTURE MESHMAP=PupaeLeg1 NUM=1 TEXTURE=Jgpupae1

#exec MESH IMPORT MESH=PupaeLeg2 ANIVFILE=MODELS\g_pup2_a.3D DATAFILE=MODELS\g_pup2_d.3D X=0 Y=0 Z=0
#exec MESH ORIGIN MESH=PupaeLeg2 X=0 Y=0 Z=0 YAW=64
#exec MESH SEQUENCE MESH=PupaeLeg2 SEQ=All    STARTFRAME=0   NUMFRAMES=1
#exec MESH SEQUENCE MESH=PupaeLeg2 SEQ=Still  STARTFRAME=0   NUMFRAMES=1
#exec TEXTURE IMPORT NAME=Jgpupae1  FILE=MODELS\g_pupae.PCX GROUP=Skins 
#exec MESHMAP SCALE MESHMAP=PupaeLeg2 X=0.09 Y=0.09 Z=0.18
#exec MESHMAP SETTEXTURE MESHMAP=PupaeLeg2 NUM=1 TEXTURE=Jgpupae1

#exec MESH IMPORT MESH=PupaeLeg3 ANIVFILE=MODELS\g_pup3_a.3D DATAFILE=MODELS\g_pup3_d.3D X=0 Y=0 Z=0
#exec MESH ORIGIN MESH=PupaeLeg3 X=0 Y=0 Z=0 YAW=64
#exec MESH SEQUENCE MESH=PupaeLeg3 SEQ=All    STARTFRAME=0   NUMFRAMES=1
#exec MESH SEQUENCE MESH=PupaeLeg3 SEQ=Still  STARTFRAME=0   NUMFRAMES=1
#exec TEXTURE IMPORT NAME=Jgpupae1  FILE=MODELS\g_pupae.PCX GROUP=Skins 
#exec MESHMAP SCALE MESHMAP=PupaeLeg3 X=0.09 Y=0.09 Z=0.18
#exec MESHMAP SETTEXTURE MESHMAP=PupaeLeg3 NUM=1 TEXTURE=Jgpupae1

#exec AUDIO IMPORT FILE="Sounds\Pupae\thump1.WAV" NAME="thumppp" GROUP="Pupae"

static simulated function bool AllowChunk(int N, name A)
{
	if ( (A == 'Dead2') && (N == 4) )
		return false;
	if ( (A == 'Dead3') && (N == 3) )
		return false;

	return true;
}

defaultproperties
{
      bodyparts(0)=LodMesh'UnrealI.PupaeBody'
      bodyparts(1)=LodMesh'UnrealI.PupaeLeg3'
      bodyparts(2)=LodMesh'UnrealI.PupaeLeg1'
      bodyparts(3)=LodMesh'UnrealI.PupaeLeg2'
      bodyparts(4)=LodMesh'UnrealI.PupaeHead'
      bodyparts(5)=None
      ZOffset(0)=0.000000
      ZOffset(1)=0.000000
      LandedSound=Sound'UnrealI.Pupae.thumppp'
      Mesh=LodMesh'UnrealI.Pupae1'
      CollisionRadius=28.000000
      CollisionHeight=9.000000
      Mass=80.000000
}
