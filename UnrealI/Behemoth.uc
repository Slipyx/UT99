//=============================================================================
// Behemoth.
//=============================================================================
class Behemoth extends Brute;

#exec TEXTURE IMPORT NAME=Brute2 FILE=Models\Brute2H.PCX GROUP="Skins"

function GoBerserk()
{
	bLongBerserk = false;
	bBerserk = false;
}

defaultproperties
{
      WhipDamage=35
      RefireRate=0.500000
      bLeadTarget=True
      SightRadius=2000.000000
      Health=500
      Skin=Texture'UnrealI.Skins.Brute2'
      DrawScale=1.300000
      TransientSoundVolume=6.000000
      CollisionRadius=68.000000
      CollisionHeight=68.000000
      Mass=500.000000
}
