//=============================================================================
// GassiusCarcass.
//=============================================================================
class GassiusCarcass extends CreatureCarcass;

#exec MESH IMPORT MESH=GasArm1 ANIVFILE=MODELS\g_gasa_a.3D DATAFILE=MODELS\g_gasa_d.3D X=0 Y=0 Z=0
#exec MESH ORIGIN MESH=GasArm1 X=450 Y=150 Z=0 YAW=64
#exec MESH SEQUENCE MESH=GasArm1 SEQ=All    STARTFRAME=0   NUMFRAMES=1
#exec MESH SEQUENCE MESH=GasArm1 SEQ=Still  STARTFRAME=0   NUMFRAMES=1
#exec TEXTURE IMPORT NAME=JGas1  FILE=MODELS\g_gas1.PCX GROUP=Skins 
#exec MESHMAP SCALE MESHMAP=GasArm1 X=0.09 Y=0.09 Z=0.18
#exec MESHMAP SETTEXTURE MESHMAP=GasArm1 NUM=1 TEXTURE=JGas1

#exec MESH IMPORT MESH=GasArm2 ANIVFILE=MODELS\g_gas2_a.3D DATAFILE=MODELS\g_gas2_d.3D X=0 Y=0 Z=0
#exec MESH ORIGIN MESH=GasArm2 X=450 Y=150 Z=0 YAW=64
#exec MESH SEQUENCE MESH=GasArm2 SEQ=All    STARTFRAME=0   NUMFRAMES=1
#exec MESH SEQUENCE MESH=GasArm2 SEQ=Still  STARTFRAME=0   NUMFRAMES=1
#exec TEXTURE IMPORT NAME=JGas2  FILE=MODELS\g_gas2.PCX GROUP=Skins 
#exec MESHMAP SCALE MESHMAP=GasArm2 X=0.09 Y=0.09 Z=0.18
#exec MESHMAP SETTEXTURE MESHMAP=GasArm2 NUM=1 TEXTURE=JGas2

#exec MESH IMPORT MESH=GasHand ANIVFILE=MODELS\g_gash_a.3D DATAFILE=MODELS\g_gash_d.3D X=0 Y=0 Z=0
#exec MESH ORIGIN MESH=GasHand X=450 Y=150 Z=0 YAW=64
#exec MESH SEQUENCE MESH=GasHand SEQ=All    STARTFRAME=0   NUMFRAMES=1
#exec MESH SEQUENCE MESH=GasHand SEQ=Still  STARTFRAME=0   NUMFRAMES=1
#exec TEXTURE IMPORT NAME=JGas1  FILE=MODELS\g_gas1.PCX GROUP=Skins 
#exec MESHMAP SCALE MESHMAP=GasHand X=0.09 Y=0.09 Z=0.18
#exec MESHMAP SETTEXTURE MESHMAP=GasHand NUM=1 TEXTURE=JGas1

#exec MESH IMPORT MESH=GasHead ANIVFILE=MODELS\g_gasz_a.3D DATAFILE=MODELS\g_gasz_d.3D X=0 Y=0 Z=0
#exec MESH ORIGIN MESH=GasHead X=450 Y=150 Z=0 YAW=64
#exec MESH SEQUENCE MESH=GasHead SEQ=All    STARTFRAME=0   NUMFRAMES=1
#exec MESH SEQUENCE MESH=GasHead SEQ=Still  STARTFRAME=0   NUMFRAMES=1
#exec TEXTURE IMPORT NAME=JGas2  FILE=MODELS\g_gas2.PCX GROUP=Skins 
#exec MESHMAP SCALE MESHMAP=GasHead X=0.09 Y=0.09 Z=0.18
#exec MESHMAP SETTEXTURE MESHMAP=GasHead NUM=1 TEXTURE=JGas2

#exec MESH IMPORT MESH=GasPart ANIVFILE=MODELS\g_gasp_a.3D DATAFILE=MODELS\g_gasp_d.3D X=0 Y=0 Z=0
#exec MESH ORIGIN MESH=GasPart X=450 Y=150 Z=30 YAW=64
#exec MESH SEQUENCE MESH=GasPart SEQ=All    STARTFRAME=0   NUMFRAMES=1
#exec MESH SEQUENCE MESH=GasPart SEQ=Still  STARTFRAME=0   NUMFRAMES=1
#exec TEXTURE IMPORT NAME=JGas1  FILE=MODELS\g_gas1.PCX GROUP=Skins 
#exec MESHMAP SCALE MESHMAP=GasPart X=0.09 Y=0.09 Z=0.18
#exec MESHMAP SETTEXTURE MESHMAP=GasPart NUM=1 TEXTURE=JGas1


function ForceMeshToExist()
{
	//never called
	Spawn(class 'Gasbag');
}

defaultproperties
{
      bodyparts(0)=LodMesh'UnrealI.GasHead'
      bodyparts(1)=LodMesh'UnrealI.GasArm1'
      bodyparts(2)=LodMesh'UnrealI.GasArm2'
      bodyparts(3)=LodMesh'UnrealI.GasHand'
      bodyparts(4)=LodMesh'UnrealI.GasPart'
      bodyparts(5)=LodMesh'UnrealI.GasPart'
      ZOffset(0)=0.700000
      ZOffset(1)=0.000000
      ZOffset(2)=0.350000
      ZOffset(3)=-0.300000
      ZOffset(4)=-0.500000
      ZOffset(5)=-0.700000
      AnimSequence="Deflate"
      Mesh=LodMesh'UnrealI.GasBagM'
      Mass=120.000000
}
