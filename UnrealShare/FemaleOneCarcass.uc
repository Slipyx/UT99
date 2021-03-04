//=============================================================================
// FemaleOneCarcass.
// DO NOT USE THESE AS DECORATIONS
//=============================================================================
class FemaleOneCarcass extends FemaleBody;

function ForceMeshToExist()
{
	//never called
	Spawn(class 'FemaleOne');
}

defaultproperties
{
      Physics=PHYS_Falling
      AnimSequence="Dead1"
      Mesh=LodMesh'UnrealShare.Female1'
      bBlockActors=True
      bBlockPlayers=True
}
