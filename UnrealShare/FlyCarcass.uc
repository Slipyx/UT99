//=============================================================================
// FlyCarcass.
//=============================================================================
class FlyCarcass extends CreatureCarcass;

function CreateReplacement()
{
	if (Bugs != None)
		Bugs.Destroy();
}

function ForceMeshToExist()
{
	//never called
	Spawn(class 'Fly');
}

defaultproperties
{
      Mesh=LodMesh'UnrealShare.FlyM'
      Mass=100.000000
      Buoyancy=99.000000
}
