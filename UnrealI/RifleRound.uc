//=============================================================================
// RifleRound.
//=============================================================================
class RifleRound extends RifleAmmo;

#exec MESH IMPORT MESH=RifleRoundM ANIVFILE=MODELS\rifles_a.3D DATAFILE=MODELS\rifles_d.3D LODSTYLE=10
#exec MESH ORIGIN MESH=RifleRoundM X=0 Y=-200 Z=0 YAW=0
#exec MESH SEQUENCE MESH=RifleRoundM SEQ=All    STARTFRAME=0  NUMFRAMES=1
#exec TEXTURE IMPORT NAME=RifleR1 FILE=MODELS\rifles.PCX GROUP="Skins"
#exec MESHMAP SCALE MESHMAP=RifleRoundM X=0.02 Y=0.02 Z=0.04
#exec MESHMAP SETTEXTURE MESHMAP=RifleRoundM NUM=1 TEXTURE=RifleR1

defaultproperties
{
      AmmoAmount=1
      ParentAmmo=Class'UnrealI.RifleAmmo'
      PickupMessage="You got a Rifle Round."
      PickupViewMesh=LodMesh'UnrealI.RifleRoundM'
      Mesh=LodMesh'UnrealI.RifleRoundM'
      CollisionRadius=5.000000
      CollisionHeight=15.000000
}
