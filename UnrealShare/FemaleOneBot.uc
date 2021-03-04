//=============================================================================
// FemaleOneBot.
//=============================================================================
class FemaleOneBot extends FemaleBot;

function ForceMeshToExist()
{
	Spawn(class'FemaleOne');
}

defaultproperties
{
      CarcassType=Class'UnrealShare.FemaleOneCarcass'
      Skin=Texture'UnrealShare.Skins.gina'
      Mesh=LodMesh'UnrealShare.Female1'
}
