//=============================================================================
// DeadMales.
//=============================================================================
class DeadMales extends HumanCarcass
	abstract;

function SpawnHead()
{
	local carcass carc;

	carc = Spawn(class'MaleHead');
	if ( carc != None )
		carc.Initfor(self);
}

defaultproperties
{
      MasterReplacement=Class'UnrealShare.MaleMasterChunk'
      Physics=PHYS_None
}
