class UMenuStartMatchClientWindow extends UMenuDialogClientWindow;

var UMenuBotmatchClientWindow BotmatchParent;

var bool Initialized, InGameChanged;

// Game Type
var UWindowComboControl GameCombo;
var localized string GameText;
var localized string GameHelp;
var string Games[256];
var int MaxGames;

// Map
var UWindowComboControl MapCombo;
var localized string MapText;
var localized string MapHelp;

// Map List Button
var UWindowSmallButton MapListButton;
var localized string MapListText;
var localized string MapListHelp;

var UWindowSmallButton MutatorButton;
var localized string MutatorText;
var localized string MutatorHelp;

function Created()
{
	local int i, j, Selection;
	local class<GameInfo> TempClass;
	local string TempGame;
	local string NextGame;
	local string TempGames[256];
	local bool bFoundSavedGameClass;

	local int ControlWidth, ControlLeft, ControlRight;
	local int CenterWidth, CenterPos;

	Super.Created();

	DesiredWidth = 270;
	DesiredHeight = 100;

	ControlWidth = WinWidth/2.5;
	ControlLeft = (WinWidth/2 - ControlWidth)/2;
	ControlRight = WinWidth/2 + ControlLeft;

	CenterWidth = (WinWidth/4)*3;
	CenterPos = (WinWidth - CenterWidth)/2;

	BotmatchParent = UMenuBotmatchClientWindow(GetParent(class'UMenuBotmatchClientWindow'));
	if (BotmatchParent == None)
		Log("Error: UMenuStartMatchClientWindow without UMenuBotmatchClientWindow parent.");

	// Game Type
	GameCombo = UWindowComboControl(CreateControl(class'UWindowComboControl', CenterPos, 20, CenterWidth, 1));
	GameCombo.SetButtons(True);
	GameCombo.SetText(GameText);
	GameCombo.SetHelpText(GameHelp);
	GameCombo.SetFont(F_Normal);
	GameCombo.SetEditable(False);

	// Compile a list of all gametypes.
	NextGame = GetPlayerOwner().GetNextInt("GameInfo", 0); 
	while (NextGame != "")
	{
		TempGames[i] = NextGame;
		i++;
		NextGame = GetPlayerOwner().GetNextInt("GameInfo", i);
	}

	// Fill the control.
	for (i=0; i<256; i++)
	{
		if (TempGames[i] != "")
		{
			Games[MaxGames] = TempGames[i];
			if ( !bFoundSavedGameClass && (Games[MaxGames] ~= BotmatchParent.GameType) )
			{
				bFoundSavedGameClass = true;
				Selection = MaxGames;
			}
			TempClass = Class<GameInfo>(DynamicLoadObject(Games[MaxGames], class'Class'));
			if( TempClass != None )
			{
				GameCombo.AddItem(TempClass.Default.GameName);
				MaxGames++;
			}
		}
	}

	GameCombo.SetSelectedIndex(Selection);	
	BotmatchParent.GameType = Games[Selection];
	BotmatchParent.GameClass = Class<GameInfo>(DynamicLoadObject(BotmatchParent.GameType, class'Class'));

	// Map
	MapCombo = UWindowComboControl(CreateControl(class'UWindowComboControl', CenterPos, 45, CenterWidth, 1));
	MapCombo.SetButtons(True);
	MapCombo.SetText(MapText);
	MapCombo.SetHelpText(MapHelp);
	MapCombo.SetFont(F_Normal);
	MapCombo.SetEditable(False);
	IterateMaps(BotmatchParent.Map);

	// Map List Button
	MapListButton = UWindowSmallButton(CreateControl(class'UWindowSmallButton', CenterPos, 70, 48, 16));
	MapListButton.SetText(MapListText);
	MapListButton.SetFont(F_Normal);
	MapListButton.SetHelpText(MapListHelp);

	// Mutator Button
	MutatorButton = UWindowSmallButton(CreateControl(class'UWindowSmallButton', CenterPos, 95, 48, 16));
	MutatorButton.SetText(MutatorText);
	MutatorButton.SetFont(F_Normal);
	MutatorButton.SetHelpText(MutatorHelp);

	Initialized = True;
}

function IterateMaps(string DefaultMap)
{
	local string FirstMap, NextMap, TestMap;
	local int Selected;

	FirstMap = GetPlayerOwner().GetMapName(BotmatchParent.GameClass.Default.MapPrefix, "", 0);

	MapCombo.Clear();
	NextMap = FirstMap;

	while (!(FirstMap ~= TestMap))
	{
		// Add the map.
		if(!(Left(NextMap, Len(NextMap) - 4) ~= (BotmatchParent.GameClass.Default.MapPrefix$"-tutorial")))
			MapCombo.AddItem(Left(NextMap, Len(NextMap) - 4), NextMap);

		// Get the map.
		NextMap = GetPlayerOwner().GetMapName(BotmatchParent.GameClass.Default.MapPrefix, NextMap, 1);

		// Text to see if this is the last.
		TestMap = NextMap;
	}

	// Maplists returned by GetMapName get sorted in C++ as of the Unreal Tournament 469 patch
	// MapCombo.Sort();

	MapCombo.SetSelectedIndex(Max(MapCombo.FindItemIndex2(DefaultMap, True), 0));	
}

function AfterCreate()
{
	BotmatchParent.Map = MapCombo.GetValue2();
	BotmatchParent.ScreenshotWindow.SetMap(BotmatchParent.Map);
}

function BeforePaint(Canvas C, float X, float Y)
{
	local int ControlWidth, ControlLeft, ControlRight;
	local int CenterWidth, CenterPos;

	ControlWidth = WinWidth/2.5;
	ControlLeft = (WinWidth/2 - ControlWidth)/2;
	ControlRight = WinWidth/2 + ControlLeft;

	CenterWidth = (WinWidth/4)*3;
	CenterPos = (WinWidth - CenterWidth)/2;

	GameCombo.SetSize(CenterWidth, 1);
	GameCombo.WinLeft = CenterPos;
	GameCombo.EditBoxWidth = 150;

	MapCombo.SetSize(CenterWidth, 1);
	MapCombo.WinLeft = CenterPos;
	MapCombo.EditBoxWidth = 150;

	MapListButton.AutoWidth(C);
	MutatorButton.AutoWidth(C);

	MapListButton.WinWidth = Max(MapListButton.WinWidth, MutatorButton.WinWidth);
	MutatorButton.WinWidth = MapListButton.WinWidth;

	MapListButton.WinLeft = (WinWidth - MapListButton.WinWidth)/2;
	MutatorButton.WinLeft = (WinWidth - MapListButton.WinWidth)/2;
}

function Notify(UWindowDialogControl C, byte E)
{
	Super.Notify(C, E);

	switch(E)
	{
	case DE_Change:
		switch(C)
		{
		case GameCombo:
			GameChanged();
			break;
		case MapCombo:
			MapChanged();
			break;
		}
		break;
	case DE_Click:
		switch(C)
		{
		case MapListButton:
			GetParent(class'UWindowFramedWindow').ShowModal(Root.CreateWindow(class'UMenuMapListWindow', 0, 0, 100, 100, BotmatchParent));
			break;
		case MutatorButton:
			GetParent(class'UWindowFramedWindow').ShowModal(Root.CreateWindow(class'UMenuMutatorWindow', 0, 0, 100, 100, BotmatchParent));
			break;
		}
	}
}

function GameChanged()
{
	local int CurrentGame, i;

	if (!Initialized || InGameChanged)
		return;

	InGameChanged = True;

	if(BotmatchParent.GameClass != None)
		BotmatchParent.GameClass.static.StaticSaveConfig();

	CurrentGame = GameCombo.GetSelectedIndex();
	BotmatchParent.GameType = Games[CurrentGame];
	BotmatchParent.GameClass = Class<GameInfo>(DynamicLoadObject(BotmatchParent.GameType, class'Class'));
	if ( BotmatchParent.GameClass == None )
	{
		MaxGames--;
		if ( MaxGames > CurrentGame )
		{
			for ( i=CurrentGame; i<MaxGames; i++ )
				Games[i] = Games[i+1];
		}
		else if ( CurrentGame > 0 )
			CurrentGame--;
		GameCombo.SetSelectedIndex(CurrentGame);
		InGameChanged = False;
		return;
	}
	if (MapCombo != None)
		IterateMaps(BotmatchParent.Map);
	BotmatchParent.GameChanged();
	InGameChanged = False;
}

function MapChanged()
{
	if (!Initialized)
		return;

	BotmatchParent.Map = MapCombo.GetValue2();
	BotmatchParent.ScreenshotWindow.SetMap(BotmatchParent.Map);
}

defaultproperties
{
      BotmatchParent=None
      Initialized=False
      InGameChanged=False
      GameCombo=None
      GameText="Game Type:"
      GameHelp="Select the type of game to play."
      Games(0)=""
      Games(1)=""
      Games(2)=""
      Games(3)=""
      Games(4)=""
      Games(5)=""
      Games(6)=""
      Games(7)=""
      Games(8)=""
      Games(9)=""
      Games(10)=""
      Games(11)=""
      Games(12)=""
      Games(13)=""
      Games(14)=""
      Games(15)=""
      Games(16)=""
      Games(17)=""
      Games(18)=""
      Games(19)=""
      Games(20)=""
      Games(21)=""
      Games(22)=""
      Games(23)=""
      Games(24)=""
      Games(25)=""
      Games(26)=""
      Games(27)=""
      Games(28)=""
      Games(29)=""
      Games(30)=""
      Games(31)=""
      Games(32)=""
      Games(33)=""
      Games(34)=""
      Games(35)=""
      Games(36)=""
      Games(37)=""
      Games(38)=""
      Games(39)=""
      Games(40)=""
      Games(41)=""
      Games(42)=""
      Games(43)=""
      Games(44)=""
      Games(45)=""
      Games(46)=""
      Games(47)=""
      Games(48)=""
      Games(49)=""
      Games(50)=""
      Games(51)=""
      Games(52)=""
      Games(53)=""
      Games(54)=""
      Games(55)=""
      Games(56)=""
      Games(57)=""
      Games(58)=""
      Games(59)=""
      Games(60)=""
      Games(61)=""
      Games(62)=""
      Games(63)=""
      Games(64)=""
      Games(65)=""
      Games(66)=""
      Games(67)=""
      Games(68)=""
      Games(69)=""
      Games(70)=""
      Games(71)=""
      Games(72)=""
      Games(73)=""
      Games(74)=""
      Games(75)=""
      Games(76)=""
      Games(77)=""
      Games(78)=""
      Games(79)=""
      Games(80)=""
      Games(81)=""
      Games(82)=""
      Games(83)=""
      Games(84)=""
      Games(85)=""
      Games(86)=""
      Games(87)=""
      Games(88)=""
      Games(89)=""
      Games(90)=""
      Games(91)=""
      Games(92)=""
      Games(93)=""
      Games(94)=""
      Games(95)=""
      Games(96)=""
      Games(97)=""
      Games(98)=""
      Games(99)=""
      Games(100)=""
      Games(101)=""
      Games(102)=""
      Games(103)=""
      Games(104)=""
      Games(105)=""
      Games(106)=""
      Games(107)=""
      Games(108)=""
      Games(109)=""
      Games(110)=""
      Games(111)=""
      Games(112)=""
      Games(113)=""
      Games(114)=""
      Games(115)=""
      Games(116)=""
      Games(117)=""
      Games(118)=""
      Games(119)=""
      Games(120)=""
      Games(121)=""
      Games(122)=""
      Games(123)=""
      Games(124)=""
      Games(125)=""
      Games(126)=""
      Games(127)=""
      Games(128)=""
      Games(129)=""
      Games(130)=""
      Games(131)=""
      Games(132)=""
      Games(133)=""
      Games(134)=""
      Games(135)=""
      Games(136)=""
      Games(137)=""
      Games(138)=""
      Games(139)=""
      Games(140)=""
      Games(141)=""
      Games(142)=""
      Games(143)=""
      Games(144)=""
      Games(145)=""
      Games(146)=""
      Games(147)=""
      Games(148)=""
      Games(149)=""
      Games(150)=""
      Games(151)=""
      Games(152)=""
      Games(153)=""
      Games(154)=""
      Games(155)=""
      Games(156)=""
      Games(157)=""
      Games(158)=""
      Games(159)=""
      Games(160)=""
      Games(161)=""
      Games(162)=""
      Games(163)=""
      Games(164)=""
      Games(165)=""
      Games(166)=""
      Games(167)=""
      Games(168)=""
      Games(169)=""
      Games(170)=""
      Games(171)=""
      Games(172)=""
      Games(173)=""
      Games(174)=""
      Games(175)=""
      Games(176)=""
      Games(177)=""
      Games(178)=""
      Games(179)=""
      Games(180)=""
      Games(181)=""
      Games(182)=""
      Games(183)=""
      Games(184)=""
      Games(185)=""
      Games(186)=""
      Games(187)=""
      Games(188)=""
      Games(189)=""
      Games(190)=""
      Games(191)=""
      Games(192)=""
      Games(193)=""
      Games(194)=""
      Games(195)=""
      Games(196)=""
      Games(197)=""
      Games(198)=""
      Games(199)=""
      Games(200)=""
      Games(201)=""
      Games(202)=""
      Games(203)=""
      Games(204)=""
      Games(205)=""
      Games(206)=""
      Games(207)=""
      Games(208)=""
      Games(209)=""
      Games(210)=""
      Games(211)=""
      Games(212)=""
      Games(213)=""
      Games(214)=""
      Games(215)=""
      Games(216)=""
      Games(217)=""
      Games(218)=""
      Games(219)=""
      Games(220)=""
      Games(221)=""
      Games(222)=""
      Games(223)=""
      Games(224)=""
      Games(225)=""
      Games(226)=""
      Games(227)=""
      Games(228)=""
      Games(229)=""
      Games(230)=""
      Games(231)=""
      Games(232)=""
      Games(233)=""
      Games(234)=""
      Games(235)=""
      Games(236)=""
      Games(237)=""
      Games(238)=""
      Games(239)=""
      Games(240)=""
      Games(241)=""
      Games(242)=""
      Games(243)=""
      Games(244)=""
      Games(245)=""
      Games(246)=""
      Games(247)=""
      Games(248)=""
      Games(249)=""
      Games(250)=""
      Games(251)=""
      Games(252)=""
      Games(253)=""
      Games(254)=""
      Games(255)=""
      MaxGames=0
      MapCombo=None
      MapText="Map Name:"
      MapHelp="Select the map to play."
      MapListButton=None
      MapListText="Map List"
      MapListHelp="Click this button to change the list of maps which will be cycled."
      MutatorButton=None
      MutatorText="Mutators"
      MutatorHelp="Mutators are scripts which modify gameplay.  Press this button to choose which mutators to use."
}
