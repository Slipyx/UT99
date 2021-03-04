//=============================================================================
// DAmmo5.
//=============================================================================
class DAmmo5 extends DispersionAmmo;

#exec MESH IMPORT MESH=DispM4 ANIVFILE=MODELS\cros_t_a.3D DATAFILE=MODELS\cros_t_d.3D X=0 Y=0 Z=0 
#exec MESH ORIGIN MESH=DispM4 X=0 Y=-500 Z=0 YAW=-64
#exec MESH SEQUENCE MESH=DispM4 SEQ=All STARTFRAME=0  NUMFRAMES=1
#exec MESH SEQUENCE MESH=DispM4 SEQ=Still  STARTFRAME=0 NUMFRAMES=1
#exec MESHMAP SCALE MESHMAP=DispM4 X=0.09 Y=0.15 Z=0.08
#exec  OBJ LOAD FILE=Textures\fireeffect1.utx PACKAGE=UnrealShare.Effect1
#exec MESHMAP SETTEXTURE MESHMAP=DispM4 NUM=0 TEXTURE=UnrealShare.Effect1.FireEffect1p
#exec MESHMAP SETTEXTURE MESHMAP=DispM4 NUM=1 TEXTURE=UnrealShare.Effect1.FireEffect1ob

#exec TEXTURE IMPORT NAME=PalRed FILE=textures\expred.pcx GROUP=Effects

defaultproperties
{
      ParticleType=Class'UnrealShare.Spark35'
      SparkModifier=3.000000
      ExpType=Texture'UnrealShare.DispExpl.DseO_A00'
      ExpSkin=Texture'UnrealShare.Effects.PalRed'
      Damage=75.000000
      Mesh=LodMesh'UnrealShare.DispM4'
      LightBrightness=190
      LightHue=5
      LightSaturation=63
}
