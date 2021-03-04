//=============================================================================
// FemaleTwoBot.
//=============================================================================
class FemaleTwoBot extends FemaleBot;

function ForceMeshToExist()
{
	Spawn(class'FemaleTwo');
}

defaultproperties
{
      CarcassType=Class'UnrealI.FemaleTwoCarcass'
      Skin=Texture'UnrealShare.Skins.Sonya'
      Mesh=LodMesh'UnrealI.Female2'
}
