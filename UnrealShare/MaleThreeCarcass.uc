//=============================================================================
// MaleThreeCarcass.
// DO NOT USE THESE AS DECORATIONS
//=============================================================================
class MaleThreeCarcass extends MaleBodyThree;

function ForceMeshToExist()
{
	//never called
	Spawn(class 'MaleThree');
}

defaultproperties
{
      Physics=PHYS_Falling
      Mesh=LodMesh'UnrealShare.Male3'
      bBlockActors=True
      bBlockPlayers=True
}
