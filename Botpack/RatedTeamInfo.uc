class RatedTeamInfo expands Info;

var() localized string		TeamName;
var() texture		TeamSymbol;
var() localized string		TeamBio;

var() localized string		BotNames[8];
var() localized string		BotClassifications[8];
var() float			BotSkills[8];
var() float			BotAccuracy[8];
var() float			CombatStyle[8];
var() float			Camping[8];
var() string		FavoriteWeapon[8];
var() string		BotClasses[8];
var() string		BotSkins[8];
var() string		BotFaces[8];
var() localized string		BotBio[8];
var() byte			BotJumpy[8];

var() class<TournamentPlayer> MaleClass;
var() string		MaleSkin;

var() class<TournamentPlayer> FemaleClass;
var() string		FemaleSkin;

static function string GetBotName(int n)
{
	return Default.BotNames[n];
}

static function string GetBotDesc(int n)
{
	return Default.BotBio[n];
}

static function string GetBotClassification(int n)
{
	return Default.BotClassifications[n];
}

static function string GetBotSkin(int n)
{
	return Default.BotSkins[n];
}

static function string GetBotFace(int n)
{
	return Default.BotFaces[n];
}

static function string GetBotClassName(int n)
{
	return Default.BotClasses[n];
}

static function class<bot> GetBotClass(int n)
{
	return class<bot>( DynamicLoadObject(Default.BotClasses[n], class'Class') );
}

static function int GetBotCount()
{
	local int i;
	
	for ( i=0; i<8; i++)
		if ( Default.BotClasses[i] == "" || Default.BotNames[i] == "" )
			break;
			
	return i;
}

static function string GetTeamName()
{
	return Default.TeamName;
}

static function string GetTeamBio()
{
	return Default.TeamBio;
}

static function texture GetTeamSymbol()
{
	return Default.TeamSymbol;
}

static function class<TournamentPlayer> GetMaleClass()
{
	return Default.MaleClass;
}

static function class<TournamentPlayer> GetFemaleClass()
{
	return Default.FemaleClass;
}

function Individualize( Bot NewBot, int n, int NumBots, bool bEnemy, float BaseDifficulty)
{
	if ( (n<0) || (n>7) )
	{
		log("Accessed RatedTeamInfo out of range!");
		return;
	}

	// Set bot's name.
	Level.Game.ChangeName( NewBot, BotNames[n], false );
	if ( BotNames[n] != NewBot.PlayerReplicationInfo.PlayerName )
		Level.Game.ChangeName( NewBot, "Bot", false);

	// Set Bot Team
	if ( bEnemy )
	{
		if (DeathMatchPlus(Level.Game).RatedPlayer.PlayerReplicationInfo.Team == 1)
			NewBot.PlayerReplicationInfo.Team = 0;
		else if (DeathMatchPlus(Level.Game).RatedPlayer.PlayerReplicationInfo.Team == 0)
			NewBot.PlayerReplicationInfo.Team = 1;
	} else {
		NewBot.PlayerReplicationInfo.Team = DeathMatchPlus(Level.Game).RatedPlayer.PlayerReplicationInfo.Team;
	}

	NewBot.Static.SetMultiSkin(NewBot, BotSkins[n], BotFaces[n], NewBot.PlayerReplicationInfo.Team);

	// adjust bot skill
	NewBot.InitializeSkill(BaseDifficulty + BotSkills[n]);

	if ( (FavoriteWeapon[n] != "") && (FavoriteWeapon[n] != "None") )
		NewBot.FavoriteWeapon = class<Weapon>(DynamicLoadObject(FavoriteWeapon[n],class'Class'));
	NewBot.CombatStyle = NewBot.Default.CombatStyle + 0.7 * CombatStyle[n];
	NewBot.BaseAggressiveness = 0.5 * (NewBot.Default.Aggressiveness + NewBot.CombatStyle);
	NewBot.CampingRate = Camping[n];
	NewBot.bJumpy = ( BotJumpy[n] != 0 );
	NewBot.PlayerReplicationInfo.VoiceType = class<VoicePack>(DynamicLoadObject(NewBot.VoiceType, class'Class'));
}

defaultproperties
{
      TeamName=""
      TeamSymbol=None
      TeamBio=""
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
      BotBio(0)=""
      BotBio(1)=""
      BotBio(2)=""
      BotBio(3)=""
      BotBio(4)=""
      BotBio(5)=""
      BotBio(6)=""
      BotBio(7)=""
      BotJumpy(0)=0
      BotJumpy(1)=0
      BotJumpy(2)=0
      BotJumpy(3)=0
      BotJumpy(4)=0
      BotJumpy(5)=0
      BotJumpy(6)=0
      BotJumpy(7)=0
      MaleClass=None
      MaleSkin=""
      FemaleClass=None
      FemaleSkin=""
}
