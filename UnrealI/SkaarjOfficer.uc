//=============================================================================
// SkaarjOfficer.
//=============================================================================
class SkaarjOfficer extends SkaarjTrooper;

#exec TEXTURE IMPORT NAME=sktrooper3 FILE=MODELS\zaarj3.PCX GROUP=Skins

defaultproperties
{
      WeaponType=Class'UnrealI.Razorjack'
      Health=200
      Skin=Texture'UnrealI.Skins.sktrooper3'
      DrawScale=1.100000
      Fatness=140
      CollisionRadius=35.000000
      CollisionHeight=46.000000
      Mass=150.000000
      Buoyancy=150.000000
}
