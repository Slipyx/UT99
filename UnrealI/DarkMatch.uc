//=============================================================================
// DarkMatch.
//=============================================================================
class DarkMatch extends DeathMatchGame;

function AddDefaultInventory(pawn aPlayer)
{
	local SearchLight s;

	Super.AddDefaultInventory(aPlayer);
	
	//spawn a searchlight
	if ( aPlayer.IsA('Spectator') 
		|| aPlayer.FindInventoryType(class'SearchLight') != None )
		return;
	s = Spawn(class'SearchLight',,, Location);
	if (s != None)
	{
		s.bHeldItem = true;
		s.GiveTo( aPlayer );
		s.Activate();
		aPlayer.SelectedItem = s;
	}
}

defaultproperties
{
      MapListType=Class'UnrealI.DKmaplist'
      MapPrefix="DK"
      GameName="DarkMatch"
}
