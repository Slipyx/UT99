class LadderNewGame extends UTIntro;

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

	for( Inv=PlayerPawn.Inventory; Inv!=None; Inv=Next )
	{
		Inv.Destroy();
	}

	TournamentConsole(PlayerPawn(PlayerPawn).Player.Console).StartNewGame();
	PlayerPawn.Weapon = None;
	PlayerPawn.SelectedItem = None;
}

function PlayTeleportEffect( actor Incoming, bool bOut, bool bSound)
{
}

defaultproperties
{
}
