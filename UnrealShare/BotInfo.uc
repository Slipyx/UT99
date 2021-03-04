//=============================================================================
// BotInfo.
//=============================================================================
class BotInfo extends Info;

var() config bool	bAdjustSkill;
var() config bool	bRandomOrder;
var   config byte	Difficulty;

var() config string BotNames[32];
var() config int BotTeams[32];
var() config float BotSkills[32];
var() config float BotAccuracy[32];
var() config float CombatStyle[32]; 
var() config float Alertness[32];
var() config float Camping[32];
var() config class<Weapon> FavoriteWeapon[32];
var	  byte ConfigUsed[32];
var() config string BotClasses[32];
var() config string BotSkins[32];
var string AvailableClasses[32], AvailableDescriptions[32], NextBotClass;
var int NumClasses;

function PreBeginPlay()
{
	//DON'T Call parent prebeginplay
}

function PostBeginPlay()
{
	local string NextBotClass, NextBotDesc;
	local int i;

	Super.PostBeginPlay();

	GetNextIntDesc("Bots", 0, NextBotClass, NextBotDesc); 
	while ( (NextBotClass != "") && (NumClasses < 32) )
	{
		AvailableClasses[NumClasses] = NextBotClass;
		AvailableDescriptions[NumClasses] = NextBotDesc;
		NumClasses++;
		GetNextIntDesc("Bots", NumClasses, NextBotClass, NextBotDesc); 
	}
}

function String GetAvailableClasses(int n)
{
	return AvailableClasses[n];
}

function int ChooseBotInfo()
{
	local int n, start;

	if ( bRandomOrder )
		n = Rand(16);
	else 
		n = 0;

	start = n;
	while ( (n < 32) && (ConfigUsed[n] == 1) )
		n++;

	if ( (n == 32) && bRandomOrder )
	{
		n = 0;
		while ( (n < start) && (ConfigUsed[n] == 1) )
			n++;
	}

	if ( n > 31 )
		n = 31;

	return n;
}

function class<bots> GetBotClass(int n)
{
	return class<bots>( DynamicLoadObject(GetBotClassName(n), class'Class') );
}

function Individualize(bots NewBot, int n, int NumBots)
{
	local texture NewSkin;

	// Set bot's skin
	if ( (n >= 0) && (n < 32) && (BotSkins[n] != "") && (BotSkins[n] != "None") )
	{
		NewSkin = texture(DynamicLoadObject(BotSkins[n], class'Texture'));
		if ( NewSkin != None )
			NewBot.Skin = NewSkin;
	}

	// Set bot's name.
	if ( (BotNames[n] == "") || (ConfigUsed[n] == 1) )
		BotNames[n] = "Bot";

	Level.Game.ChangeName( NewBot, BotNames[n], false );
	if ( BotNames[n] != NewBot.PlayerReplicationInfo.PlayerName )
		Level.Game.ChangeName( NewBot, ("Bot"$NumBots), false);

	ConfigUsed[n] = 1;

	// adjust bot skill
	NewBot.Skill = FClamp(NewBot.Skill + BotSkills[n], 0, 3);
	NewBot.ReSetSkill();
}

function SetBotClass(String ClassName, int n)
{
	BotClasses[n] = ClassName;
}

function SetBotName( coerce string NewName, int n )
{
	BotNames[n] = NewName;
}

function String GetBotName(int n)
{
	return BotNames[n];
}

function int GetBotTeam(int num)
{
	return BotTeams[Num];
}

function SetBotTeam(int NewTeam, int n)
{
	BotTeams[n] = NewTeam;
}

function int GetBotIndex( coerce string BotName )
{
	local int i;
	local bool found;

	found = false;
	for (i=0; i<ArrayCount(BotNames)-1; i++)
		if (BotNames[i] == BotName)
		{
			found = true;
			break;
		}

	if (!found)
		i = -1;

	return i;
}

function string GetBotSkin( int num )
{
	return BotSkins[Num];
}

function SetBotSkin( coerce string NewSkin, int n )
{
	BotSkins[n] = NewSkin;
}

function String GetBotClassName(int n)
{
	if ( (n < 0) || (n > 31) )
		return AvailableClasses[Rand(NumClasses)];

	if ( BotClasses[n] == "" )
		BotClasses[n] = AvailableClasses[Rand(NumClasses)];

	return BotClasses[n];
}

defaultproperties
{
      bAdjustSkill=False
      bRandomOrder=False
      Difficulty=1
      BotNames(0)="Dante"
      BotNames(1)="Ash"
      BotNames(2)="Rhiannon"
      BotNames(3)="Kurgan"
      BotNames(4)="Sonja"
      BotNames(5)="Avatar"
      BotNames(6)="Dominator"
      BotNames(7)="Cholerae"
      BotNames(8)="Apocalypse"
      BotNames(9)="Bane"
      BotNames(10)="Hippolyta"
      BotNames(11)="Eradicator"
      BotNames(12)="Nikita"
      BotNames(13)="Arcturus"
      BotNames(14)="Shiva"
      BotNames(15)="Vindicator"
      BotNames(16)=""
      BotNames(17)=""
      BotNames(18)=""
      BotNames(19)=""
      BotNames(20)=""
      BotNames(21)=""
      BotNames(22)=""
      BotNames(23)=""
      BotNames(24)=""
      BotNames(25)=""
      BotNames(26)=""
      BotNames(27)=""
      BotNames(28)=""
      BotNames(29)=""
      BotNames(30)=""
      BotNames(31)=""
      BotTeams(0)=1
      BotTeams(1)=0
      BotTeams(2)=1
      BotTeams(3)=0
      BotTeams(4)=1
      BotTeams(5)=0
      BotTeams(6)=1
      BotTeams(7)=0
      BotTeams(8)=1
      BotTeams(9)=0
      BotTeams(10)=1
      BotTeams(11)=0
      BotTeams(12)=1
      BotTeams(13)=0
      BotTeams(14)=1
      BotTeams(15)=0
      BotTeams(16)=0
      BotTeams(17)=0
      BotTeams(18)=0
      BotTeams(19)=0
      BotTeams(20)=0
      BotTeams(21)=0
      BotTeams(22)=0
      BotTeams(23)=0
      BotTeams(24)=0
      BotTeams(25)=0
      BotTeams(26)=0
      BotTeams(27)=0
      BotTeams(28)=0
      BotTeams(29)=0
      BotTeams(30)=0
      BotTeams(31)=0
      BotSkills(0)=0.000000
      BotSkills(1)=0.000000
      BotSkills(2)=0.000000
      BotSkills(3)=0.000000
      BotSkills(4)=0.000000
      BotSkills(5)=0.000000
      BotSkills(6)=0.000000
      BotSkills(7)=0.000000
      BotSkills(8)=0.000000
      BotSkills(9)=0.000000
      BotSkills(10)=0.000000
      BotSkills(11)=0.000000
      BotSkills(12)=0.000000
      BotSkills(13)=0.000000
      BotSkills(14)=0.000000
      BotSkills(15)=0.000000
      BotSkills(16)=0.000000
      BotSkills(17)=0.000000
      BotSkills(18)=0.000000
      BotSkills(19)=0.000000
      BotSkills(20)=0.000000
      BotSkills(21)=0.000000
      BotSkills(22)=0.000000
      BotSkills(23)=0.000000
      BotSkills(24)=0.000000
      BotSkills(25)=0.000000
      BotSkills(26)=0.000000
      BotSkills(27)=0.000000
      BotSkills(28)=0.000000
      BotSkills(29)=0.000000
      BotSkills(30)=0.000000
      BotSkills(31)=0.000000
      BotAccuracy(0)=0.000000
      BotAccuracy(1)=0.000000
      BotAccuracy(2)=0.000000
      BotAccuracy(3)=0.000000
      BotAccuracy(4)=0.000000
      BotAccuracy(5)=0.000000
      BotAccuracy(6)=0.000000
      BotAccuracy(7)=0.000000
      BotAccuracy(8)=0.000000
      BotAccuracy(9)=0.000000
      BotAccuracy(10)=0.000000
      BotAccuracy(11)=0.000000
      BotAccuracy(12)=0.000000
      BotAccuracy(13)=0.000000
      BotAccuracy(14)=0.000000
      BotAccuracy(15)=0.000000
      BotAccuracy(16)=0.000000
      BotAccuracy(17)=0.000000
      BotAccuracy(18)=0.000000
      BotAccuracy(19)=0.000000
      BotAccuracy(20)=0.000000
      BotAccuracy(21)=0.000000
      BotAccuracy(22)=0.000000
      BotAccuracy(23)=0.000000
      BotAccuracy(24)=0.000000
      BotAccuracy(25)=0.000000
      BotAccuracy(26)=0.000000
      BotAccuracy(27)=0.000000
      BotAccuracy(28)=0.000000
      BotAccuracy(29)=0.000000
      BotAccuracy(30)=0.000000
      BotAccuracy(31)=0.000000
      CombatStyle(0)=0.000000
      CombatStyle(1)=0.000000
      CombatStyle(2)=0.000000
      CombatStyle(3)=0.000000
      CombatStyle(4)=0.000000
      CombatStyle(5)=0.000000
      CombatStyle(6)=0.000000
      CombatStyle(7)=0.000000
      CombatStyle(8)=0.000000
      CombatStyle(9)=0.000000
      CombatStyle(10)=0.000000
      CombatStyle(11)=0.000000
      CombatStyle(12)=0.000000
      CombatStyle(13)=0.000000
      CombatStyle(14)=0.000000
      CombatStyle(15)=0.000000
      CombatStyle(16)=0.000000
      CombatStyle(17)=0.000000
      CombatStyle(18)=0.000000
      CombatStyle(19)=0.000000
      CombatStyle(20)=0.000000
      CombatStyle(21)=0.000000
      CombatStyle(22)=0.000000
      CombatStyle(23)=0.000000
      CombatStyle(24)=0.000000
      CombatStyle(25)=0.000000
      CombatStyle(26)=0.000000
      CombatStyle(27)=0.000000
      CombatStyle(28)=0.000000
      CombatStyle(29)=0.000000
      CombatStyle(30)=0.000000
      CombatStyle(31)=0.000000
      Alertness(0)=0.000000
      Alertness(1)=0.000000
      Alertness(2)=0.000000
      Alertness(3)=0.000000
      Alertness(4)=0.000000
      Alertness(5)=0.000000
      Alertness(6)=0.000000
      Alertness(7)=0.000000
      Alertness(8)=0.000000
      Alertness(9)=0.000000
      Alertness(10)=0.000000
      Alertness(11)=0.000000
      Alertness(12)=0.000000
      Alertness(13)=0.000000
      Alertness(14)=0.000000
      Alertness(15)=0.000000
      Alertness(16)=0.000000
      Alertness(17)=0.000000
      Alertness(18)=0.000000
      Alertness(19)=0.000000
      Alertness(20)=0.000000
      Alertness(21)=0.000000
      Alertness(22)=0.000000
      Alertness(23)=0.000000
      Alertness(24)=0.000000
      Alertness(25)=0.000000
      Alertness(26)=0.000000
      Alertness(27)=0.000000
      Alertness(28)=0.000000
      Alertness(29)=0.000000
      Alertness(30)=0.000000
      Alertness(31)=0.000000
      Camping(0)=0.000000
      Camping(1)=0.000000
      Camping(2)=0.000000
      Camping(3)=0.000000
      Camping(4)=0.000000
      Camping(5)=0.000000
      Camping(6)=0.000000
      Camping(7)=0.000000
      Camping(8)=0.000000
      Camping(9)=0.000000
      Camping(10)=0.000000
      Camping(11)=0.000000
      Camping(12)=0.000000
      Camping(13)=0.000000
      Camping(14)=0.000000
      Camping(15)=0.000000
      Camping(16)=0.000000
      Camping(17)=0.000000
      Camping(18)=0.000000
      Camping(19)=0.000000
      Camping(20)=0.000000
      Camping(21)=0.000000
      Camping(22)=0.000000
      Camping(23)=0.000000
      Camping(24)=0.000000
      Camping(25)=0.000000
      Camping(26)=0.000000
      Camping(27)=0.000000
      Camping(28)=0.000000
      Camping(29)=0.000000
      Camping(30)=0.000000
      Camping(31)=0.000000
      FavoriteWeapon(0)=None
      FavoriteWeapon(1)=None
      FavoriteWeapon(2)=None
      FavoriteWeapon(3)=None
      FavoriteWeapon(4)=None
      FavoriteWeapon(5)=None
      FavoriteWeapon(6)=None
      FavoriteWeapon(7)=None
      FavoriteWeapon(8)=None
      FavoriteWeapon(9)=None
      FavoriteWeapon(10)=None
      FavoriteWeapon(11)=None
      FavoriteWeapon(12)=None
      FavoriteWeapon(13)=None
      FavoriteWeapon(14)=None
      FavoriteWeapon(15)=None
      FavoriteWeapon(16)=None
      FavoriteWeapon(17)=None
      FavoriteWeapon(18)=None
      FavoriteWeapon(19)=None
      FavoriteWeapon(20)=None
      FavoriteWeapon(21)=None
      FavoriteWeapon(22)=None
      FavoriteWeapon(23)=None
      FavoriteWeapon(24)=None
      FavoriteWeapon(25)=None
      FavoriteWeapon(26)=None
      FavoriteWeapon(27)=None
      FavoriteWeapon(28)=None
      FavoriteWeapon(29)=None
      FavoriteWeapon(30)=None
      FavoriteWeapon(31)=None
      ConfigUsed(0)=0
      ConfigUsed(1)=0
      ConfigUsed(2)=0
      ConfigUsed(3)=0
      ConfigUsed(4)=0
      ConfigUsed(5)=0
      ConfigUsed(6)=0
      ConfigUsed(7)=0
      ConfigUsed(8)=0
      ConfigUsed(9)=0
      ConfigUsed(10)=0
      ConfigUsed(11)=0
      ConfigUsed(12)=0
      ConfigUsed(13)=0
      ConfigUsed(14)=0
      ConfigUsed(15)=0
      ConfigUsed(16)=0
      ConfigUsed(17)=0
      ConfigUsed(18)=0
      ConfigUsed(19)=0
      ConfigUsed(20)=0
      ConfigUsed(21)=0
      ConfigUsed(22)=0
      ConfigUsed(23)=0
      ConfigUsed(24)=0
      ConfigUsed(25)=0
      ConfigUsed(26)=0
      ConfigUsed(27)=0
      ConfigUsed(28)=0
      ConfigUsed(29)=0
      ConfigUsed(30)=0
      ConfigUsed(31)=0
      BotClasses(0)="UnrealShare.MaleThreeBot"
      BotClasses(1)="Unreali.MaleTwoBot"
      BotClasses(2)="UnrealShare.FemaleOneBot"
      BotClasses(3)="Unreali.MaleOneBot"
      BotClasses(4)="Unreali.FemaleTwoBot"
      BotClasses(5)="UnrealShare.MaleThreeBot"
      BotClasses(6)="Unreali.SkaarjPlayerBot"
      BotClasses(7)="UnrealShare.FemaleOneBot"
      BotClasses(8)="UnrealShare.MaleThreeBot"
      BotClasses(9)="Unreali.MaleTwoBot"
      BotClasses(10)="Unreali.FemaleTwoBot"
      BotClasses(11)="Unreali.SkaarjPlayerBot"
      BotClasses(12)="UnrealShare.FemaleOneBot"
      BotClasses(13)="Unreali.MaleOneBot"
      BotClasses(14)="Unreali.MaleTwoBot"
      BotClasses(15)="Unreali.SkaarjPlayerBot"
      BotClasses(16)=""
      BotClasses(17)=""
      BotClasses(18)=""
      BotClasses(19)=""
      BotClasses(20)=""
      BotClasses(21)=""
      BotClasses(22)=""
      BotClasses(23)=""
      BotClasses(24)=""
      BotClasses(25)=""
      BotClasses(26)=""
      BotClasses(27)=""
      BotClasses(28)=""
      BotClasses(29)=""
      BotClasses(30)=""
      BotClasses(31)=""
      BotSkins(0)=""
      BotSkins(1)=""
      BotSkins(2)=""
      BotSkins(3)=""
      BotSkins(4)=""
      BotSkins(5)=""
      BotSkins(6)=""
      BotSkins(7)=""
      BotSkins(8)=""
      BotSkins(9)=""
      BotSkins(10)=""
      BotSkins(11)=""
      BotSkins(12)=""
      BotSkins(13)=""
      BotSkins(14)=""
      BotSkins(15)=""
      BotSkins(16)=""
      BotSkins(17)=""
      BotSkins(18)=""
      BotSkins(19)=""
      BotSkins(20)=""
      BotSkins(21)=""
      BotSkins(22)=""
      BotSkins(23)=""
      BotSkins(24)=""
      BotSkins(25)=""
      BotSkins(26)=""
      BotSkins(27)=""
      BotSkins(28)=""
      BotSkins(29)=""
      BotSkins(30)=""
      BotSkins(31)=""
      AvailableClasses(0)=""
      AvailableClasses(1)=""
      AvailableClasses(2)=""
      AvailableClasses(3)=""
      AvailableClasses(4)=""
      AvailableClasses(5)=""
      AvailableClasses(6)=""
      AvailableClasses(7)=""
      AvailableClasses(8)=""
      AvailableClasses(9)=""
      AvailableClasses(10)=""
      AvailableClasses(11)=""
      AvailableClasses(12)=""
      AvailableClasses(13)=""
      AvailableClasses(14)=""
      AvailableClasses(15)=""
      AvailableClasses(16)=""
      AvailableClasses(17)=""
      AvailableClasses(18)=""
      AvailableClasses(19)=""
      AvailableClasses(20)=""
      AvailableClasses(21)=""
      AvailableClasses(22)=""
      AvailableClasses(23)=""
      AvailableClasses(24)=""
      AvailableClasses(25)=""
      AvailableClasses(26)=""
      AvailableClasses(27)=""
      AvailableClasses(28)=""
      AvailableClasses(29)=""
      AvailableClasses(30)=""
      AvailableClasses(31)=""
      AvailableDescriptions(0)=""
      AvailableDescriptions(1)=""
      AvailableDescriptions(2)=""
      AvailableDescriptions(3)=""
      AvailableDescriptions(4)=""
      AvailableDescriptions(5)=""
      AvailableDescriptions(6)=""
      AvailableDescriptions(7)=""
      AvailableDescriptions(8)=""
      AvailableDescriptions(9)=""
      AvailableDescriptions(10)=""
      AvailableDescriptions(11)=""
      AvailableDescriptions(12)=""
      AvailableDescriptions(13)=""
      AvailableDescriptions(14)=""
      AvailableDescriptions(15)=""
      AvailableDescriptions(16)=""
      AvailableDescriptions(17)=""
      AvailableDescriptions(18)=""
      AvailableDescriptions(19)=""
      AvailableDescriptions(20)=""
      AvailableDescriptions(21)=""
      AvailableDescriptions(22)=""
      AvailableDescriptions(23)=""
      AvailableDescriptions(24)=""
      AvailableDescriptions(25)=""
      AvailableDescriptions(26)=""
      AvailableDescriptions(27)=""
      AvailableDescriptions(28)=""
      AvailableDescriptions(29)=""
      AvailableDescriptions(30)=""
      AvailableDescriptions(31)=""
      NextBotClass=""
      NumClasses=0
}
