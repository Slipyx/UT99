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
      VoiceType(0)=""
      VoiceType(1)=""
      VoiceType(2)=""
      VoiceType(3)=""
      VoiceType(4)=""
      VoiceType(5)=""
      VoiceType(6)=""
      VoiceType(7)=""
      VoiceType(8)=""
      VoiceType(9)=""
      VoiceType(10)=""
      VoiceType(11)=""
      VoiceType(12)=""
      VoiceType(13)=""
      VoiceType(14)=""
      VoiceType(15)=""
      VoiceType(16)=""
      VoiceType(17)=""
      VoiceType(18)=""
      VoiceType(19)=""
      VoiceType(20)=""
      VoiceType(21)=""
      VoiceType(22)=""
      VoiceType(23)=""
      VoiceType(24)=""
      VoiceType(25)=""
      VoiceType(26)=""
      VoiceType(27)=""
      VoiceType(28)=""
      VoiceType(29)=""
      VoiceType(30)=""
      VoiceType(31)=""
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
      bAdjustSkill=False
      bRandomOrder=True
      Difficulty=1
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
      BotTeams(1)=0
      BotTeams(2)=255
      BotTeams(3)=1
      BotTeams(4)=255
      BotTeams(5)=2
      BotTeams(6)=255
      BotTeams(7)=3
      BotTeams(8)=255
      BotTeams(9)=0
      BotTeams(10)=255
      BotTeams(11)=1
      BotTeams(12)=255
      BotTeams(13)=2
      BotTeams(14)=255
      BotTeams(15)=3
      BotTeams(16)=255
      BotTeams(17)=0
      BotTeams(18)=255
      BotTeams(19)=1
      BotTeams(20)=255
      BotTeams(21)=2
      BotTeams(22)=255
      BotTeams(23)=3
      BotTeams(24)=255
      BotTeams(25)=0
      BotTeams(26)=255
      BotTeams(27)=1
      BotTeams(28)=255
      BotTeams(29)=2
      BotTeams(30)=255
      BotTeams(31)=3
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
      BotAccuracy(17)=0.200000
      BotAccuracy(18)=0.900000
      BotAccuracy(19)=0.600000
      BotAccuracy(20)=0.500000
      BotAccuracy(21)=0.000000
      BotAccuracy(22)=0.000000
      BotAccuracy(23)=0.000000
      BotAccuracy(24)=1.000000
      BotAccuracy(25)=0.000000
      BotAccuracy(26)=0.000000
      BotAccuracy(27)=0.500000
      BotAccuracy(28)=0.500000
      BotAccuracy(29)=0.600000
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
      CombatStyle(16)=0.500000
      CombatStyle(17)=0.000000
      CombatStyle(18)=-0.500000
      CombatStyle(19)=-0.500000
      CombatStyle(20)=-1.000000
      CombatStyle(21)=-0.500000
      CombatStyle(22)=0.500000
      CombatStyle(23)=1.000000
      CombatStyle(24)=0.000000
      CombatStyle(25)=0.000000
      CombatStyle(26)=0.500000
      CombatStyle(27)=0.000000
      CombatStyle(28)=0.000000
      CombatStyle(29)=0.000000
      CombatStyle(30)=0.500000
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
      Alertness(18)=-0.300000
      Alertness(19)=0.000000
      Alertness(20)=0.300000
      Alertness(21)=0.000000
      Alertness(22)=0.300000
      Alertness(23)=0.000000
      Alertness(24)=0.300000
      Alertness(25)=0.000000
      Alertness(26)=0.000000
      Alertness(27)=0.000000
      Alertness(28)=0.000000
      Alertness(29)=0.400000
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
      Camping(18)=1.000000
      Camping(19)=0.000000
      Camping(20)=0.000000
      Camping(21)=0.000000
      Camping(22)=0.000000
      Camping(23)=0.000000
      Camping(24)=0.000000
      Camping(25)=0.000000
      Camping(26)=0.000000
      Camping(27)=0.000000
      Camping(28)=0.500000
      Camping(29)=0.000000
      Camping(30)=0.000000
      Camping(31)=0.000000
      StrafingAbility(0)=0.000000
      StrafingAbility(1)=0.000000
      StrafingAbility(2)=0.000000
      StrafingAbility(3)=0.000000
      StrafingAbility(4)=0.000000
      StrafingAbility(5)=0.000000
      StrafingAbility(6)=0.000000
      StrafingAbility(7)=0.000000
      StrafingAbility(8)=0.000000
      StrafingAbility(9)=0.000000
      StrafingAbility(10)=0.000000
      StrafingAbility(11)=0.000000
      StrafingAbility(12)=0.000000
      StrafingAbility(13)=0.000000
      StrafingAbility(14)=0.000000
      StrafingAbility(15)=0.000000
      StrafingAbility(16)=0.000000
      StrafingAbility(17)=0.500000
      StrafingAbility(18)=0.000000
      StrafingAbility(19)=0.000000
      StrafingAbility(20)=0.500000
      StrafingAbility(21)=1.000000
      StrafingAbility(22)=0.500000
      StrafingAbility(23)=0.500000
      StrafingAbility(24)=0.500000
      StrafingAbility(25)=0.500000
      StrafingAbility(26)=0.500000
      StrafingAbility(27)=0.000000
      StrafingAbility(28)=0.000000
      StrafingAbility(29)=1.000000
      StrafingAbility(30)=0.000000
      StrafingAbility(31)=0.000000
      FavoriteWeapon(0)=""
      FavoriteWeapon(1)=""
      FavoriteWeapon(2)=""
      FavoriteWeapon(3)=""
      FavoriteWeapon(4)=""
      FavoriteWeapon(5)=""
      FavoriteWeapon(6)=""
      FavoriteWeapon(7)=""
      FavoriteWeapon(8)=""
      FavoriteWeapon(9)=""
      FavoriteWeapon(10)=""
      FavoriteWeapon(11)=""
      FavoriteWeapon(12)=""
      FavoriteWeapon(13)=""
      FavoriteWeapon(14)=""
      FavoriteWeapon(15)=""
      FavoriteWeapon(16)="Botpack.UT_FlakCannon"
      FavoriteWeapon(17)="Botpack.UT_Eightball"
      FavoriteWeapon(18)="Botpack.SniperRifle"
      FavoriteWeapon(19)="Botpack.SniperRifle"
      FavoriteWeapon(20)=""
      FavoriteWeapon(21)=""
      FavoriteWeapon(22)="Botpack.PulseGun"
      FavoriteWeapon(23)=""
      FavoriteWeapon(24)=""
      FavoriteWeapon(25)="Botpack.Minigun2"
      FavoriteWeapon(26)=""
      FavoriteWeapon(27)="Botpack.ShockRifle"
      FavoriteWeapon(28)="Botpack.ShockRifle"
      FavoriteWeapon(29)=""
      FavoriteWeapon(30)=""
      FavoriteWeapon(31)=""
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
      BotJumpy(0)=0
      BotJumpy(1)=0
      BotJumpy(2)=0
      BotJumpy(3)=0
      BotJumpy(4)=0
      BotJumpy(5)=0
      BotJumpy(6)=0
      BotJumpy(7)=0
      BotJumpy(8)=0
      BotJumpy(9)=0
      BotJumpy(10)=0
      BotJumpy(11)=0
      BotJumpy(12)=0
      BotJumpy(13)=0
      BotJumpy(14)=0
      BotJumpy(15)=0
      BotJumpy(16)=0
      BotJumpy(17)=0
      BotJumpy(18)=0
      BotJumpy(19)=0
      BotJumpy(20)=0
      BotJumpy(21)=0
      BotJumpy(22)=0
      BotJumpy(23)=0
      BotJumpy(24)=0
      BotJumpy(25)=0
      BotJumpy(26)=0
      BotJumpy(27)=0
      BotJumpy(28)=0
      BotJumpy(29)=0
      BotJumpy(30)=1
      BotJumpy(31)=1
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
      Skills(0)="Novice"
      Skills(1)="Average"
      Skills(2)="Experienced"
      Skills(3)="Skilled"
      Skills(4)="Adept"
      Skills(5)="Masterful"
      Skills(6)="Inhuman"
      Skills(7)="Godlike"
      DesiredName=""
      PlayerKills=0
      PlayerDeaths=0
      AdjustedDifficulty=0.000000
}
