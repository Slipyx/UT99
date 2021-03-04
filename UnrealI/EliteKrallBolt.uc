//=============================================================================
// EliteKrallBolt.
//=============================================================================
class EliteKrallBolt extends KraalBolt;

#exec MESH IMPORT MESH=eplasma ANIVFILE=..\UnrealShare\MODELS\cros_t_a.3D DATAFILE=..\UnrealShare\MODELS\cros_t_d.3D X=0 Y=0 Z=0 
#exec MESH ORIGIN MESH=eplasma X=0 Y=0 Z=0 YAW=-64
#exec MESH SEQUENCE MESH=eplasma SEQ=All STARTFRAME=0  NUMFRAMES=1
#exec MESH SEQUENCE MESH=eplasma SEQ=Still  STARTFRAME=0 NUMFRAMES=1
#exec MESHMAP SCALE MESHMAP=eplasma X=0.04 Y=0.04 Z=0.08
#exec OBJ LOAD FILE=..\UnrealShare\Textures\fireeffect1.utx PACKAGE=UNREALSHARE.Effect1
#exec MESHMAP SETTEXTURE MESHMAP=eplasma NUM=0 TEXTURE=UnrealShare.Effect1.FireEffect1e
#exec MESHMAP SETTEXTURE MESHMAP=eplasma NUM=1 TEXTURE=UnrealShare.Effect1.FireEffect1d

defaultproperties
{
      speed=880.000000
      Damage=19.000000
      Mesh=LodMesh'UnrealI.eplasma'
}
