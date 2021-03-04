class LadderTransition extends UTIntro;

event playerpawn Login
(
	string Portal,
	string Options,
	out string Error,
	class<playerpawn> SpawnClass
)
{
	return Super.Login(Portal, Options, Error, SpawnClass);
}

function AcceptInventory(pawn PlayerPawn)
{
	local inventory Inv, Next;
	local LadderInventory LadderObj;

	// DeathMatchPlus accepts LadderInventory
	for( Inv=PlayerPawn.Inventory; Inv!=None; Inv=Next )
	{
		Next = Inv.Inventory;
		if (Inv.IsA('LadderInventory'))
		{
			LadderObj = LadderInventory(Inv);
			if (LadderObj != None) 
			{
				if (LadderObj.PendingChange > 0)
					TournamentConsole(PlayerPawn(PlayerPawn).Player.Console).EvaluateMatch(LadderObj.PendingChange, True);
				else
					TournamentConsole(PlayerPawn(PlayerPawn).Player.Console).EvaluateMatch(LadderObj.LastMatchType, False);
			}
		} else {	
			Inv.Destroy();
		}
	}
	PlayerPawn.Weapon = None;
	PlayerPawn.SelectedItem = None;
}

function PlayTeleportEffect( actor Incoming, bool bOut, bool bSound)
{
}

defaultproperties
{
}
