class LadderTransition extends UTIntro;

var bool bTransitionInit;

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

function AcceptInventory( Pawn PlayerPawn)
{
	Super.AcceptInventory(PlayerPawn);
	if ( (LadderObj != None) && !bTransitionInit )
	{
		bTransitionInit = true;
		if (LadderObj.PendingChange > 0)
			TournamentConsole(PlayerPawn(PlayerPawn).Player.Console).EvaluateMatch(LadderObj.PendingChange, True);
		else
			TournamentConsole(PlayerPawn(PlayerPawn).Player.Console).EvaluateMatch(LadderObj.LastMatchType, False);
	}
}

function PlayTeleportEffect( actor Incoming, bool bOut, bool bSound)
{
}

defaultproperties
{
      bTransitionInit=False
}
