//=============================================================================
// RocketPack.
//=============================================================================
class RocketPack extends TournamentAmmo;

#exec MESH IMPORT MESH=RocketPackMesh ANIVFILE=MODELS\eightballammo_a.3D DATAFILE=MODELS\eightballammo_d.3D X=0 Y=0 Z=0
#exec MESH ORIGIN MESH=RocketPackMesh X=0 Y=0 Z=0 ROLL=-64
#exec MESH SEQUENCE MESH=RocketPackMesh SEQ=All    STARTFRAME=0  NUMFRAMES=1
#exec TEXTURE IMPORT NAME=JRocketPack1 FILE=MODELS\eightballammo.PCX GROUP="Skins"
#exec MESHMAP SCALE MESHMAP=RocketPackMesh X=0.036 Y=0.036 Z=0.072
#exec MESHMAP SETTEXTURE MESHMAP=RocketPackMesh NUM=1 TEXTURE=JRocketPack1

defaultproperties
{
      AmmoAmount=12
      MaxAmmo=48
      UsedInWeaponSlot(5)=1
      PickupMessage="You picked up a rocket pack."
      PickupViewMesh=LodMesh'Botpack.RocketPackMesh'
      MaxDesireability=0.300000
      Physics=PHYS_Falling
      Mesh=LodMesh'Botpack.RocketPackMesh'
      CollisionRadius=27.000000
      CollisionHeight=12.000000
      bCollideActors=True
}
