//=============================================================================
// MaleTwoCarcass.
// DO NOT USE THESE AS DECORATIONS
//=============================================================================
class MaleTwoCarcass extends MaleBodyTwo;

function ForceMeshToExist()
{
	//never called
	Spawn(class 'MaleTwo');
}

defaultproperties
{
      Physics=PHYS_Falling
      Mesh=LodMesh'UnrealI.Male2'
      bBlockActors=True
      bBlockPlayers=True
}
