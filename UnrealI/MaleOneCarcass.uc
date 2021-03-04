//=============================================================================
// MaleOneCarcass.
// DO NOT USE THESE AS DECORATIONS
//=============================================================================
class MaleOneCarcass extends MaleBody;

function ForceMeshToExist()
{
	//never called
	Spawn(class 'MaleOne');
}

defaultproperties
{
      Physics=PHYS_Falling
      Mesh=LodMesh'UnrealI.Male1'
      bBlockActors=True
      bBlockPlayers=True
}
