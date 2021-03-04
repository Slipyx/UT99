//=============================================================================
// Pammo.
//=============================================================================
class PAmmo extends TournamentAmmo;

#exec MESH IMPORT MESH=Pammo ANIVFILE=MODELS\Pammo_a.3d DATAFILE=MODELS\Pammo_d.3d X=0 Y=0 Z=0
#exec MESH ORIGIN MESH=Pammo X=0 Y=0 Z=0
#exec MESH SEQUENCE MESH=Pammo SEQ=All                      STARTFRAME=0 NUMFRAMES=1
#exec MESH SEQUENCE MESH=Pammo SEQ=all                      STARTFRAME=0 NUMFRAMES=1
#exec MESHMAP NEW   MESHMAP=Pammo MESH=Pammo
#exec MESHMAP SCALE MESHMAP=Pammo X=0.03 Y=0.03 Z=0.06
#exec TEXTURE IMPORT NAME=JPammo_01 FILE=MODELS\PAmmo.PCX GROUP=Skins LODSET=2
#exec MESHMAP SETTEXTURE MESHMAP=Pammo NUM=1 TEXTURE=JPammo_01

defaultproperties
{
      AmmoAmount=25
      MaxAmmo=199
      UsedInWeaponSlot(3)=1
      PickupMessage="You picked up a Pulse Cell."
      ItemName="Pulse Cell"
      PickupViewMesh=LodMesh'Botpack.PAmmo'
      Mesh=LodMesh'Botpack.PAmmo'
      CollisionRadius=20.000000
      CollisionHeight=12.000000
}
