//=============================================================================
// ChallengeBotInfo.
//=============================================================================
class ChallengeBotInfo extends Info
	config(User);

var() config string VoiceType[32];
var() config String BotFaces[32];
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
var() config float StrafingAbility[32];
var() config string FavoriteWeapon[32];
var	  byte ConfigUsed[32];
var() config string BotClasses[32];
var() config string BotSkins[32];
var() config byte BotJumpy[32];
var string AvailableClasses[32], AvailableDescriptions[32], NextBotClass;
var int NumClasses;
var localized string Skills[8];
var string DesiredName;

var int PlayerKills, PlayerDeaths;
var float AdjustedDifficulty;

function PreBeginPlay()
{
	//DON'T Call parent prebeginplay
}

function PostBeginPlay()
{
	local String NextBotClass, NextBotDesc;

	Super.PostBeginPlay();

	NumClasses = 0;
	GetNextIntDesc("Bot", 0, NextBotClass, NextBotDesc); 
	while ( (NextBotClass != "") && (NumClasses < 32) )
	{
		AvailableClasses[NumClasses] = NextBotClass;
		AvailableDescriptions[NumClasses] = NextBotDesc;
		NumClasses++;
		GetNextIntDesc("Bot", NumClasses, NextBotClass, NextBotDesc); 
	}
}

function AdjustSkill(Bot B, bool bWinner)
{
	local float BotSkill;

	BotSkill = B.Skill;
	if ( !b.bNovice )
		BotSkill += 4;

	if ( bWinner )
	{
		PlayerKills += 1;
		AdjustedDifficulty = FMax(0, AdjustedDifficulty - 2/Min(PlayerKills, 10));
		if ( BotSkill > AdjustedDifficulty )
			B.Skill = AdjustedDifficulty;
		if ( B.Skill < 4 )
		{
			B.bNovice = true;
			if ( B.Skill > 3 )
			{
				B.Skill = 3;
				B.bThreePlus = true;
			}
		}
		else
		{
			B.Skill -= 4;
			B.bNovice = false;
		}
	}
	else
	{
		PlayerDeaths += 1;
		AdjustedDifficulty += FMin(7,2/Min(PlayerDeaths, 10));
		if ( BotSkill < AdjustedDifficulty )
			B.Skill = AdjustedDifficulty;
		if ( B.Skill < 4 )
		{
			B.bNovice = true;
			if ( B.Skill > 3 )
			{
				B.Skill = 3;
				B.bThreePlus = true;
			}
		}
		else
		{
			B.Skill -= 4;
			B.bNovice = false;
		}
	}
	if ( abs(AdjustedDifficulty - Difficulty) >= 1 )
	{
		Difficulty = AdjustedDifficulty;
		SaveConfig();
	}
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

function SetBotFace(coerce string NewFace, int n)
{
	BotFaces[n] = NewFace;
}

function String GetBotFace(int n)
{
	return BotFaces[n];
}

function CHIndividualize(bot NewBot, int n, int NumBots)
{
	n = Clamp(n,0,31);

	// Set bot's skin
	NewBot.Static.SetMultiSkin(NewBot, BotSkins[n], BotFaces[n], BotTeams[n]);

	// Set bot's name.
	if ( (BotNames[n] == "") || (ConfigUsed[n] == 1) )
		BotNames[n] = "Bot";

	Level.Game.ChangeName( NewBot, BotNames[n], false );
	if ( BotNames[n] != NewBot.PlayerReplicationInfo.PlayerName )
		Level.Game.ChangeName( NewBot, ("Bot"$NumBots), false);

	ConfigUsed[n] = 1;

	// adjust bot skill
	NewBot.InitializeSkill(Difficulty + BotSkills[n]);

	if ( (FavoriteWeapon[n] != "") && (FavoriteWeapon[n] != "None") )
		NewBot.FavoriteWeapon = class<Weapon>(DynamicLoadObject(FavoriteWeapon[n],class'Class'));
	NewBot.Accuracy = BotAccuracy[n];
	NewBot.CombatStyle = NewBot.Default.CombatStyle + 0.7 * CombatStyle[n];
	NewBot.BaseAggressiveness = 0.5 * (NewBot.Default.Aggressiveness + NewBot.CombatStyle);
	NewBot.BaseAlertness = Alertness[n];
	NewBot.CampingRate = Camping[n];
	NewBot.bJumpy = ( BotJumpy[n] != 0 );
	NewBot.StrafingAbility = StrafingAbility[n];

	if ( VoiceType[n] != "" && VoiceType[n] != "None" )
		NewBot.PlayerReplicationInfo.VoiceType = class<VoicePack>(DynamicLoadObject(VoiceType[n], class'Class'));
	
	if(NewBot.PlayerReplicationInfo.VoiceType == None)
		NewBot.PlayerReplicationInfo.VoiceType = class<VoicePack>(DynamicLoadObject(NewBot.VoiceType, class'Class'));
}

function String GetAvailableClasses(int n)
{
	return AvailableClasses[n];
}

function int ChooseBotInfo()
{
	local int n, start;

	if ( DesiredName != "" )
	{
		for ( n=0; n<32; n++ )
			if ( BotNames[n] ~= DesiredName )
			{
				DesiredName = "";
				return n;
			}
		DesiredName = "";
	}

	if ( bRandomOrder )
		n = Rand(32);
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

function class<bot> CHGetBotClass(int n)
{
	return class<bot>( DynamicLoadObject(GetBotClassName(n), class'Class') );
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

defaultproperties
{
     BotFaces(0)="CommandoSkins.Blake"
     BotFaces(1)="SGirlSkins.Aryss"
     BotFaces(2)="SoldierSkins.Malcom"
     BotFaces(3)="CommandoSkins.Luthor"
     BotFaces(4)="FCommandoSkins.Cryss"
     BotFaces(5)="FCommandoSkins.Visse"
     BotFaces(6)="SoldierSkins.Kregore"
     BotFaces(7)="SGirlSkins.Cilia"
     BotFaces(8)="CommandoSkins.Kragoth"
     BotFaces(9)="FCommandoSkins.Tanya"
     BotFaces(10)="SoldierSkins.Johnson"
     BotFaces(11)="CommandoSkins.Boris"
     BotFaces(12)="SGirlSkins.Vixen"
     BotFaces(13)="SGirlSkins.Sara"
     BotFaces(14)="SoldierSkins.Othello"
     BotFaces(15)="FCommandoSkins.Kyla"
     BotFaces(16)="CommandoSkins.Gorn"
     BotFaces(17)="SGirlSkins.Annaka"
     BotFaces(18)="SoldierSkins.Riker"
     BotFaces(19)="FCommandoSkins.Malise"
     BotFaces(20)="CommandoSkins.Ramirez"
     BotFaces(21)="FCommandoSkins.Freylis"
     BotFaces(22)="SoldierSkins.Arkon"
     BotFaces(23)="SGirlSkins.Sarena"
     BotFaces(24)="CommandoSkins.Grail"
     BotFaces(25)="FCommandoSkins.Mariana"
     BotFaces(26)="SoldierSkins.Rankin"
     BotFaces(27)="SGirlSkins.Isis"
     BotFaces(28)="CommandoSkins.Graves"
     BotFaces(29)="SGirlSkins.Lauren"
     BotFaces(30)="SoldierSkins.Malcom"
     BotFaces(31)="FCommandoSkins.Jayce"
     bAdjustSkill=True
     bRandomOrder=True
     Difficulty=2
     BotNames(0)="Archon"
     BotNames(1)="Aryss"
     BotNames(2)="Alarik"
     BotNames(3)="Dessloch"
     BotNames(4)="Cryss"
     BotNames(5)="Nikita"
     BotNames(6)="Drimacus"
     BotNames(7)="Rhea"
     BotNames(8)="Raynor"
     BotNames(9)="Kira"
     BotNames(10)="Karag"
     BotNames(11)="Zenith"
     BotNames(12)="Cali"
     BotNames(13)="Alys"
     BotNames(14)="Kosak"
     BotNames(15)="Illana"
     BotNames(16)="Barak"
     BotNames(17)="Kara"
     BotNames(18)="Tamerlane"
     BotNames(19)="Arachne"
     BotNames(20)="Liche"
     BotNames(21)="Jared"
     BotNames(22)="Ichthys"
     BotNames(23)="Tamara"
     BotNames(24)="Loque"
     BotNames(25)="Athena"
     BotNames(26)="Cilia"
     BotNames(27)="Sarena"
     BotNames(28)="Malakai"
     BotNames(29)="Visse"
     BotNames(30)="Necroth"
     BotNames(31)="Kragoth"
     BotTeams(0)=255
     BotTeams(2)=255
     BotTeams(3)=1
     BotTeams(4)=255
     BotTeams(5)=2
     BotTeams(6)=255
     BotTeams(7)=3
     BotTeams(8)=255
     BotTeams(10)=255
     BotTeams(11)=1
     BotTeams(12)=255
     BotTeams(13)=2
     BotTeams(14)=255
     BotTeams(15)=3
     BotTeams(16)=255
     BotTeams(18)=255
     BotTeams(19)=1
     BotTeams(20)=255
     BotTeams(21)=2
     BotTeams(22)=255
     BotTeams(23)=3
     BotTeams(24)=255
     BotTeams(26)=255
     BotTeams(27)=1
     BotTeams(28)=255
     BotTeams(29)=2
     BotTeams(30)=255
     BotTeams(31)=3
     BotAccuracy(17)=0.200000
     BotAccuracy(18)=0.900000
     BotAccuracy(19)=0.600000
     BotAccuracy(20)=0.500000
     BotAccuracy(24)=1.000000
     BotAccuracy(27)=0.500000
     BotAccuracy(28)=0.500000
     BotAccuracy(29)=0.600000
     CombatStyle(16)=0.500000
     CombatStyle(18)=-0.500000
     CombatStyle(19)=-0.500000
     CombatStyle(20)=-1.000000
     CombatStyle(21)=-0.500000
     CombatStyle(22)=0.500000
     CombatStyle(23)=1.000000
     CombatStyle(26)=0.500000
     CombatStyle(30)=0.500000
     Alertness(18)=-0.300000
     Alertness(20)=0.300000
     Alertness(22)=0.300000
     Alertness(24)=0.300000
     Alertness(29)=0.400000
     Camping(18)=1.000000
     Camping(28)=0.500000
     StrafingAbility(17)=0.500000
     StrafingAbility(20)=0.500000
     StrafingAbility(21)=1.000000
     StrafingAbility(22)=0.500000
     StrafingAbility(23)=0.500000
     StrafingAbility(24)=0.500000
     StrafingAbility(25)=0.500000
     StrafingAbility(26)=0.500000
     StrafingAbility(29)=1.000000
     FavoriteWeapon(16)="Botpack.UT_FlakCannon"
     FavoriteWeapon(17)="Botpack.UT_Eightball"
     FavoriteWeapon(18)="Botpack.SniperRifle"
     FavoriteWeapon(19)="Botpack.SniperRifle"
     FavoriteWeapon(22)="Botpack.PulseGun"
     FavoriteWeapon(25)="Botpack.Minigun2"
     FavoriteWeapon(27)="Botpack.ShockRifle"
     FavoriteWeapon(28)="Botpack.ShockRifle"
     BotClasses(0)="BotPack.TMale1Bot"
     BotClasses(1)="BotPack.TFemale2Bot"
     BotClasses(2)="BotPack.TMale2Bot"
     BotClasses(3)="BotPack.TMale1Bot"
     BotClasses(4)="BotPack.TFemale1Bot"
     BotClasses(5)="BotPack.TFemale1Bot"
     BotClasses(6)="BotPack.TMale2Bot"
     BotClasses(7)="BotPack.TFemale2Bot"
     BotClasses(8)="BotPack.TMale1Bot"
     BotClasses(9)="BotPack.TFemale1Bot"
     BotClasses(10)="BotPack.TMale2Bot"
     BotClasses(11)="BotPack.TMale1Bot"
     BotClasses(12)="BotPack.TFemale2Bot"
     BotClasses(13)="BotPack.TFemale2Bot"
     BotClasses(14)="BotPack.TMale2Bot"
     BotClasses(15)="BotPack.TFemale1Bot"
     BotClasses(16)="BotPack.TMale1Bot"
     BotClasses(17)="BotPack.TFemale2Bot"
     BotClasses(18)="BotPack.TMale2Bot"
     BotClasses(19)="BotPack.TFemale1Bot"
     BotClasses(20)="BotPack.TMale1Bot"
     BotClasses(21)="BotPack.TFemale1Bot"
     BotClasses(22)="BotPack.TMale2Bot"
     BotClasses(23)="BotPack.TFemale2Bot"
     BotClasses(24)="BotPack.TMale1Bot"
     BotClasses(25)="BotPack.TFemale1Bot"
     BotClasses(26)="BotPack.TMale2Bot"
     BotClasses(27)="BotPack.TFemale2Bot"
     BotClasses(28)="BotPack.TMale1Bot"
     BotClasses(29)="BotPack.TFemale2Bot"
     BotClasses(30)="BotPack.TMale2Bot"
     BotClasses(31)="BotPack.TFemale1Bot"
     BotSkins(0)="CommandoSkins.cmdo"
     BotSkins(1)="SGirlSkins.fbth"
     BotSkins(2)="SoldierSkins.blkt"
     BotSkins(3)="CommandoSkins.daco"
     BotSkins(4)="FCommandoSkins.goth"
     BotSkins(5)="FCommandoSkins.goth"
     BotSkins(6)="SoldierSkins.RawS"
     BotSkins(7)="SGirlSkins.Venm"
     BotSkins(8)="CommandoSkins.goth"
     BotSkins(9)="FCommandoSkins.daco"
     BotSkins(10)="SoldierSkins.sldr"
     BotSkins(11)="CommandoSkins.daco"
     BotSkins(12)="SGirlSkins.Garf"
     BotSkins(13)="SGirlSkins.army"
     BotSkins(14)="SoldierSkins.blkt"
     BotSkins(15)="FCommandoSkins.daco"
     BotSkins(16)="CommandoSkins.cmdo"
     BotSkins(17)="SGirlSkins.fbth"
     BotSkins(18)="SoldierSkins.blkt"
     BotSkins(19)="FCommandoSkins.goth"
     BotSkins(20)="CommandoSkins.daco"
     BotSkins(21)="FCommandoSkins.goth"
     BotSkins(22)="SoldierSkins.RawS"
     BotSkins(23)="SGirlSkins.Venm"
     BotSkins(24)="CommandoSkins.goth"
     BotSkins(25)="FCommandoSkins.daco"
     BotSkins(26)="SoldierSkins.sldr"
     BotSkins(27)="SGirlSkins.Garf"
     BotSkins(28)="CommandoSkins.daco"
     BotSkins(29)="SGirlSkins.army"
     BotSkins(30)="SoldierSkins.blkt"
     BotSkins(31)="FCommandoSkins.daco"
     BotJumpy(30)=1
     BotJumpy(31)=1
     Skills(0)="Novice"
     Skills(1)="Average"
     Skills(2)="Experienced"
     Skills(3)="Skilled"
     Skills(4)="Adept"
     Skills(5)="Masterful"
     Skills(6)="Inhuman"
     Skills(7)="Godlike"
}
