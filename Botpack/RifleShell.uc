//=============================================================================
// RifleShell.
//=============================================================================
class RifleShell extends BulletBox;

defaultproperties
{
      AmmoAmount=1
      ParentAmmo=Class'Botpack.BulletBox'
      PickupMessage="You got a rifle round."
      ItemName="Rifle Round"
      PickupViewMesh=LodMesh'UnrealI.RifleRoundM'
      Mesh=LodMesh'UnrealI.RifleRoundM'
      CollisionHeight=15.000000
}
