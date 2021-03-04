//=============================================================================
// FlakArena.
// replaces all weapons and ammo with FlakCannons and ammo
//=============================================================================

class FlakArena expands Arena;

defaultproperties
{
      WeaponName="UT_FlakCannon"
      AmmoName="FlakAmmo"
      WeaponString="Botpack.UT_FlakCannon"
      AmmoString="Botpack.flakammo"
      DefaultWeapon=Class'Botpack.UT_FlakCannon'
}
