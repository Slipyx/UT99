//=============================================================================
// Shock Core
//=============================================================================
class ShockCore extends TournamentAmmo;

#exec MESH IMPORT MESH=ShockCoreM ANIVFILE=MODELS\asmdammo_a.3D DATAFILE=MODELS\asmdammo_d.3D X=0 Y=0 Z=0
#exec MESH ORIGIN MESH=ShockCoreM X=0 Y=0 Z=0 YAW=0
#exec MESH SEQUENCE MESH=ShockCoreM SEQ=All    STARTFRAME=0  NUMFRAMES=1
#exec TEXTURE IMPORT NAME=JShockCore FILE=MODELS\asmdammo.PCX GROUP="Skins" LODSET=2
#exec MESHMAP SCALE MESHMAP=ShockCoreM X=0.055 Y=0.055 Z=0.11
#exec MESHMAP SETTEXTURE MESHMAP=ShockCoreM NUM=1 TEXTURE=JShockCore

defaultproperties
{
      AmmoAmount=10
      MaxAmmo=50
      UsedInWeaponSlot(4)=1
      PickupMessage="You picked up a Shock Core."
      ItemName="Shock Core"
      PickupViewMesh=LodMesh'Botpack.ShockCoreM'
      Physics=PHYS_Falling
      Mesh=LodMesh'Botpack.ShockCoreM'
      SoundRadius=26
      SoundVolume=37
      SoundPitch=73
      CollisionRadius=14.000000
      CollisionHeight=20.000000
      bCollideActors=True
}
