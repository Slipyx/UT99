//=============================================================================
// FemaleTwoCarcass.
// DO NOT USE THESE AS DECORATIONS
//=============================================================================
class FemaleTwoCarcass extends Female2Body;

function ForceMeshToExist()
{
	//never called
	Spawn(class 'FemaleTwo');
}

defaultproperties
{
      Physics=PHYS_Falling
      AnimSequence="Dead1"
      Mesh=LodMesh'UnrealI.Female2'
      bBlockActors=True
      bBlockPlayers=True
}
