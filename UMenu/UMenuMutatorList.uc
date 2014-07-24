class UMenuMutatorList expands UWindowListBoxItem;

var string MutatorName;
var string MutatorClass;

function int Compare(UWindowList T, UWindowList B)
{
	if(Caps(UMenuMutatorList(T).MutatorName) < Caps(UMenuMutatorList(B).MutatorName))
		return -1;

	return 1;
}

// Call only on sentinel
function UMenuMutatorList FindMutator(string FindMutatorClass)
{
	local UMenuMutatorList I;

	for(I = UMenuMutatorList(Next); I != None; I = UMenuMutatorList(I.Next))
		if(I.MutatorClass ~= FindMutatorClass)
			return I;

	return None;
}

defaultproperties
{
}
