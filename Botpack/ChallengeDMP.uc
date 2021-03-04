class ChallengeDMP expands DeathMatchPlus;

event InitGame( string Options, out string Error )
{
	bChallengeMode = True;

	Super.InitGame( Options, Error );

	bRatedGame = true;
	TimeLimit = 0;
	RemainingTime = 0;
}

function InitRatedGame(LadderInventory LadderObj, PlayerPawn LadderPlayer)
{
	local Weapon W;

	Super.InitRatedGame(LadderObj, LadderPlayer);

	bCoopWeaponMode = True;
	ForEach AllActors(class'Weapon', W)
		W.SetWeaponStay();
}

defaultproperties
{
      LadderTypeIndex=5
      BeaconName="CTDM"
      GameName="Lightning DeathMatch"
}
