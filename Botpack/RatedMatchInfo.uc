//=============================================================================
// RatedMatchInfo.
// used in single player game - cannot modify
// player team (bots 0 to 7) are set up in default properties of this base class
// enemy teams are set up in default properties of sub-classes
//=============================================================================
class RatedMatchInfo extends Info;

var() int						NumBots;			// total number of bots
var() int						NumAllies;			// number of allied bots

var() float						ModifiedDifficulty;	// how much to modify base difficulty for this match (0 to 5)

var() class<RatedTeamInfo>		EnemyTeam;

var() localized string			BotNames[8];
var() localized string			BotClassifications[8];
var() int						BotTeams[8];
var() float						BotSkills[8];
var() float						BotAccuracy[8];
var() float						CombatStyle[8];
var() float						Camping[8];
var() string					FavoriteWeapon[8];
var() string 					BotClasses[8];
var() string 					BotSkins[8];
var() string 					BotFaces[8];
var() localized string			Bio[8];
var() byte						BotJumpy[8];
var() float						StrafingAbility[8];

var int							CurrentNum;
var int							CurrentAlly;

function string GetTeamName(optional bool bEnemy, optional PlayerPawn RatedPlayer)
{
	local LadderInventory LadderObj;

	if (bEnemy)
	{
		LadderObj = LadderInventory(RatedPlayer.FindInventoryType(class'LadderInventory'));

		if (EnemyTeam == LadderObj.Team)
			return class'RatedTeamInfoS'.Default.TeamName;
		else
			return EnemyTeam.Default.TeamName;
	} else {
		LadderObj = LadderInventory(RatedPlayer.FindInventoryType(class'LadderInventory'));
		return LadderObj.Team.Default.TeamName;
	}
}

function string GetTeamBio(optional bool bEnemy, optional PlayerPawn RatedPlayer)
{
	local LadderInventory LadderObj;

	if (bEnemy)
	{
		LadderObj = LadderInventory(RatedPlayer.FindInventoryType(class'LadderInventory'));

		if (EnemyTeam == LadderObj.Team)
			return class'RatedTeamInfoS'.Default.TeamBio;
		else
			return EnemyTeam.Default.TeamBio;
	} else {
		LadderObj = LadderInventory(RatedPlayer.FindInventoryType(class'LadderInventory'));
		return LadderObj.Team.Default.TeamBio;
	}
}

function texture GetTeamSymbol(optional bool bEnemy, optional PlayerPawn RatedPlayer)
{
	local LadderInventory LadderObj;

	if (bEnemy)
	{
		LadderObj = LadderInventory(RatedPlayer.FindInventoryType(class'LadderInventory'));

		if (EnemyTeam == LadderObj.Team)
			return class'RatedTeamInfoS'.Default.TeamSymbol;
		else
			return EnemyTeam.Default.TeamSymbol;
	} else {
		LadderObj = LadderInventory(RatedPlayer.FindInventoryType(class'LadderInventory'));
		return LadderObj.Team.Default.TeamSymbol;
	}
}

function string GetBotName(int n, optional bool bTeamGame, optional bool bEnemy, optional PlayerPawn RatedPlayer)
{
	local LadderInventory LadderObj;

	if (!bTeamGame)
		return Default.BotNames[n];
	else {
		if (bEnemy)
		{
			LadderObj = LadderInventory(RatedPlayer.FindInventoryType(class'LadderInventory'));

			if (EnemyTeam == LadderObj.Team)
				return class'RatedTeamInfoS'.Default.BotNames[n];
			else
				return EnemyTeam.Default.BotNames[n];
		} else {
			LadderObj = LadderInventory(RatedPlayer.FindInventoryType(class'LadderInventory'));
			return LadderObj.Team.Default.BotNames[n];
		}
	}
}

function string GetBotDesc(int n, optional bool bTeamGame, optional bool bEnemy, optional PlayerPawn RatedPlayer)
{
	local LadderInventory LadderObj;

	if (!bTeamGame)
		return Default.Bio[n];
	else {
		if (bEnemy)
		{
			LadderObj = LadderInventory(RatedPlayer.FindInventoryType(class'LadderInventory'));

			if (EnemyTeam == LadderObj.Team)
				return class'RatedTeamInfoS'.Default.BotBio[n];
			else
				return EnemyTeam.Default.BotBio[n];
		} else {
			LadderObj = LadderInventory(RatedPlayer.FindInventoryType(class'LadderInventory'));
			return LadderObj.Team.Default.BotBio[n];
		}
	}
}

function string GetBotClassification(int n, optional bool bTeamGame, optional bool bEnemy, optional PlayerPawn RatedPlayer)
{
	local LadderInventory LadderObj;

	if (!bTeamGame)
		return Default.BotClassifications[n];
	else {
		if (bEnemy)
		{
			LadderObj = LadderInventory(RatedPlayer.FindInventoryType(class'LadderInventory'));

			if (EnemyTeam == LadderObj.Team)
				return class'RatedTeamInfoS'.Default.BotClassifications[n];
			else
				return EnemyTeam.Default.BotClassifications[n];
		} else {
			LadderObj = LadderInventory(RatedPlayer.FindInventoryType(class'LadderInventory'));
			return LadderObj.Team.Default.BotClassifications[n];
		}
	}
}

function int GetBotTeam(int n, optional bool bTeamGame, optional bool bEnemy, optional PlayerPawn RatedPlayer)
{
	return Default.BotTeams[n];
}

function string GetBotSkin(int n, optional bool bTeamGame, optional bool bEnemy, optional PlayerPawn RatedPlayer)
{
	local LadderInventory LadderObj;

	if (!bTeamGame)
		return Default.BotSkins[n];
	else {
		if (bEnemy)
		{
			LadderObj = LadderInventory(RatedPlayer.FindInventoryType(class'LadderInventory'));

			if (EnemyTeam == LadderObj.Team)
				return class'RatedTeamInfoS'.Default.BotSkins[n];
			else
				return EnemyTeam.Default.BotSkins[n];
		} else {
			LadderObj = LadderInventory(RatedPlayer.FindInventoryType(class'LadderInventory'));
			return LadderObj.Team.Default.BotSkins[n];
		}
	}
}

function string GetBotFace(int n, optional bool bTeamGame, optional bool bEnemy, optional PlayerPawn RatedPlayer)
{
	local LadderInventory LadderObj;

	if (!bTeamGame)
		return Default.BotFaces[n];
	else {
		if (bEnemy)
		{
			LadderObj = LadderInventory(RatedPlayer.FindInventoryType(class'LadderInventory'));

			if (EnemyTeam == LadderObj.Team)
				return class'RatedTeamInfoS'.Default.BotFaces[n];
			else
				return EnemyTeam.Default.BotFaces[n];
		} else {
			LadderObj = LadderInventory(RatedPlayer.FindInventoryType(class'LadderInventory'));
			return LadderObj.Team.Default.BotFaces[n];			
		}
	}
}

function string GetBotClassName(int n, optional bool bTeamGame, optional bool bEnemy, optional PlayerPawn RatedPlayer)
{
	local LadderInventory LadderObj;

	if (!bTeamGame)
		return Default.BotClasses[n];
	else {
		if (bEnemy)
		{
			LadderObj = LadderInventory(RatedPlayer.FindInventoryType(class'LadderInventory'));
		
			if (EnemyTeam == LadderObj.Team)
				return class'RatedTeamInfoS'.Default.BotClasses[n];
			else
				return EnemyTeam.Default.BotClasses[n];
		} else {
			LadderObj = LadderInventory(RatedPlayer.FindInventoryType(class'LadderInventory'));
			return LadderObj.Team.Default.BotClasses[n];
		}
	}
}

function class<bot> GetBotClass(int n, optional bool bTeamGame, optional bool bEnemy, optional PlayerPawn RatedPlayer)
{
	local LadderInventory LadderObj;

	if (!bTeamGame)
		return class<bot>( DynamicLoadObject(BotClasses[n], class'Class') );
	else {
		if (bEnemy)
		{
			LadderObj = LadderInventory(RatedPlayer.FindInventoryType(class'LadderInventory'));

			if (EnemyTeam == LadderObj.Team)
				return class<bot>( DynamicLoadObject(class'RatedTeamInfoS'.Default.BotClasses[n], class'Class') );
			else
				return class<bot>( DynamicLoadObject(EnemyTeam.Default.BotClasses[n], class'Class') );
		} else {
			LadderObj = LadderInventory(RatedPlayer.FindInventoryType(class'LadderInventory'));

			return LadderObj.Team.static.GetBotClass(n);
		}
	}
}

function int ChooseBotInfo(optional bool bTeamGame, optional bool bEnemy)
{
	if ( !bTeamGame )
		return CurrentNum++;
	else
	{
		if (bEnemy)
			return CurrentNum++;
		else
			return CurrentAlly++;
	}
}

// Added in version 469, attempts to select an unused bot name for the player's team.
function int ChooseAlliedBotInfo( PlayerPawn RatedPlayer)
{
	local int i, BotCount, Taken[8]; // 1=taken by bot, 2=taken by player
	local PlayerReplicationInfo PRI;
	local LadderInventory LadderObj;
	
	LadderObj = LadderInventory( RatedPlayer.FindInventoryType(class'LadderInventory'));
	BotCount = LadderObj.Team.static.GetBotCount();
	
	ForEach AllActors( class'PlayerReplicationInfo', PRI)
		if ( (PRI.Owner != None) && (PRI.Team == RatedPlayer.PlayerReplicationInfo.Team) )
		{
			for ( i=0; i<BotCount; i++)
				if ( LadderObj.Team.static.GetBotName(i) ~= PRI.PlayerName )
				{
					Taken[i] = 1 + int(PRI.Owner.IsA('PlayerPawn'));
					break;
				}
		}
		
	for ( i=0; i<BotCount; i++) // Try unused names
		if ( Taken[i] == 0 )
			return i;
	
	for ( i=0; i<BotCount; i++) // Try name used by player (will join as 'Bot')
		if ( Taken[i] == 2 )
			return i;
			
	return 0; //!!
}

function Individualize(bot NewBot, int n, int NumBots, optional bool bTeamGame, optional bool bEnemy)
{
	local LadderInventory LadderObj;
	local PlayerPawn RatedPlayer;
	local RatedTeamInfo RTI;

	if ( (n<0) || (n>7) )
	{
		log("Accessed RatedMatchInfo out of range!");
		return;
	}

	if (!bTeamGame)
	{
		NewBot.Static.SetMultiSkin(NewBot, BotSkins[n], BotFaces[n], BotTeams[n]);

		// Set bot's name.
		Level.Game.ChangeName( NewBot, BotNames[n], false );
		if ( BotNames[n] != NewBot.PlayerReplicationInfo.PlayerName )
			Level.Game.ChangeName( NewBot, "Bot", false);

		// Set Bot Team
		if ( BotTeams[n] == 0 )
			NewBot.PlayerReplicationInfo.Team = DeathMatchPlus(Level.Game).RatedPlayer.PlayerReplicationInfo.Team;
		else if ( DeathMatchPlus(Level.Game).RatedPlayer.PlayerReplicationInfo.Team == 0 )
			NewBot.PlayerReplicationInfo.Team = 1;
		else
			NewBot.PlayerReplicationInfo.Team = 1;

		// adjust bot skill
		RatedPlayer = DeathMatchPlus(Level.Game).RatedPlayer;
		LadderObj = LadderInventory(RatedPlayer.FindInventoryType(class'LadderInventory'));
		NewBot.InitializeSkill(LadderObj.TournamentDifficulty + ModifiedDifficulty + BotSkills[n]);

		if ( (FavoriteWeapon[n] != "") && (FavoriteWeapon[n] != "None") )
			NewBot.FavoriteWeapon = class<Weapon>(DynamicLoadObject(FavoriteWeapon[n],class'Class'));
		NewBot.CombatStyle = NewBot.Default.CombatStyle + 0.7 * CombatStyle[n];
		NewBot.BaseAggressiveness = 0.5 * (NewBot.Default.Aggressiveness + NewBot.CombatStyle);
		NewBot.CampingRate = Camping[n];
		NewBot.bJumpy = ( BotJumpy[n] != 0 );
		NewBot.PlayerReplicationInfo.VoiceType = class<VoicePack>(DynamicLoadObject(NewBot.VoiceType, class'Class'));
		NewBot.StrafingAbility = StrafingAbility[n];
	} 
	else 
	{
		if ( bEnemy )
		{
			RatedPlayer = DeathMatchPlus(Level.Game).RatedPlayer;
			LadderObj = LadderInventory(RatedPlayer.FindInventoryType(class'LadderInventory'));

			if (EnemyTeam == LadderObj.Team)
				RTI = Spawn(class'RatedTeamInfoS');
			else
				RTI = Spawn(EnemyTeam);
			RTI.Individualize(NewBot, n, NumBots, bEnemy, LadderObj.TournamentDifficulty + ModifiedDifficulty);
		} 
		else 
		{
			RatedPlayer = DeathMatchPlus(Level.Game).RatedPlayer;
			LadderObj = LadderInventory(RatedPlayer.FindInventoryType(class'LadderInventory'));
			RTI = Spawn(LadderObj.Team);
			RTI.Individualize(NewBot, n, NumBots, bEnemy, LadderObj.TournamentDifficulty + ModifiedDifficulty);
		}
	}
}

defaultproperties
{
      NumBots=0
      NumAllies=0
      ModifiedDifficulty=0.000000
      EnemyTeam=None
      BotNames(0)=""
      BotNames(1)=""
      BotNames(2)=""
      BotNames(3)=""
      BotNames(4)=""
      BotNames(5)=""
      BotNames(6)=""
      BotNames(7)=""
      BotClassifications(0)=""
      BotClassifications(1)=""
      BotClassifications(2)=""
      BotClassifications(3)=""
      BotClassifications(4)=""
      BotClassifications(5)=""
      BotClassifications(6)=""
      BotClassifications(7)=""
      BotTeams(0)=0
      BotTeams(1)=0
      BotTeams(2)=0
      BotTeams(3)=0
      BotTeams(4)=0
      BotTeams(5)=0
      BotTeams(6)=0
      BotTeams(7)=0
      BotSkills(0)=0.000000
      BotSkills(1)=0.000000
      BotSkills(2)=0.000000
      BotSkills(3)=0.000000
      BotSkills(4)=0.000000
      BotSkills(5)=0.000000
      BotSkills(6)=0.000000
      BotSkills(7)=0.000000
      BotAccuracy(0)=0.000000
      BotAccuracy(1)=0.000000
      BotAccuracy(2)=0.000000
      BotAccuracy(3)=0.000000
      BotAccuracy(4)=0.000000
      BotAccuracy(5)=0.000000
      BotAccuracy(6)=0.000000
      BotAccuracy(7)=0.000000
      CombatStyle(0)=0.000000
      CombatStyle(1)=0.000000
      CombatStyle(2)=0.000000
      CombatStyle(3)=0.000000
      CombatStyle(4)=0.000000
      CombatStyle(5)=0.000000
      CombatStyle(6)=0.000000
      CombatStyle(7)=0.000000
      Camping(0)=0.000000
      Camping(1)=0.000000
      Camping(2)=0.000000
      Camping(3)=0.000000
      Camping(4)=0.000000
      Camping(5)=0.000000
      Camping(6)=0.000000
      Camping(7)=0.000000
      FavoriteWeapon(0)=""
      FavoriteWeapon(1)=""
      FavoriteWeapon(2)=""
      FavoriteWeapon(3)=""
      FavoriteWeapon(4)=""
      FavoriteWeapon(5)=""
      FavoriteWeapon(6)=""
      FavoriteWeapon(7)=""
      BotClasses(0)=""
      BotClasses(1)=""
      BotClasses(2)=""
      BotClasses(3)=""
      BotClasses(4)=""
      BotClasses(5)=""
      BotClasses(6)=""
      BotClasses(7)=""
      BotSkins(0)=""
      BotSkins(1)=""
      BotSkins(2)=""
      BotSkins(3)=""
      BotSkins(4)=""
      BotSkins(5)=""
      BotSkins(6)=""
      BotSkins(7)=""
      BotFaces(0)=""
      BotFaces(1)=""
      BotFaces(2)=""
      BotFaces(3)=""
      BotFaces(4)=""
      BotFaces(5)=""
      BotFaces(6)=""
      BotFaces(7)=""
      Bio(0)=""
      Bio(1)=""
      Bio(2)=""
      Bio(3)=""
      Bio(4)=""
      Bio(5)=""
      Bio(6)=""
      Bio(7)=""
      BotJumpy(0)=0
      BotJumpy(1)=0
      BotJumpy(2)=0
      BotJumpy(3)=0
      BotJumpy(4)=0
      BotJumpy(5)=0
      BotJumpy(6)=0
      BotJumpy(7)=0
      StrafingAbility(0)=0.000000
      StrafingAbility(1)=0.000000
      StrafingAbility(2)=0.000000
      StrafingAbility(3)=0.000000
      StrafingAbility(4)=0.000000
      StrafingAbility(5)=0.000000
      StrafingAbility(6)=0.000000
      StrafingAbility(7)=0.000000
      CurrentNum=0
      CurrentAlly=0
}
