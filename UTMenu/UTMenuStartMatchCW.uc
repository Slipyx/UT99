class UTMenuStartMatchCW expands UMenuStartMatchClientWindow;

var UWindowCheckbox ChangeLevelsCheck;
var localized string ChangeLevelsText;
var localized string ChangeLevelsHelp;

// Category
var UWindowComboControl CategoryCombo;
var localized string CategoryText;
var localized string CategoryHelp;
var localized string GeneralText;
var config string LastCategory;

function Created()
{
	local int i, j, Selection, BestCategory, CategoryCount;
	local class<GameInfo> TempClass;
	local string TempGame, NextGame;
	local string TempGames[256];
	local string NextEntry, NextCategory;
	local string Categories[256];
	local bool bFoundSavedGameClass, bAlreadyHave;

	local int ControlWidth, ControlLeft, ControlRight;
	local int CenterWidth, CenterPos;

	Super(UMenuDialogClientWindow).Created();

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

	// Category
	CategoryCombo = UWindowComboControl(CreateControl(class'UWindowComboControl', CenterPos, 20, CenterWidth, 1));
	CategoryCombo.SetButtons(True);
	CategoryCombo.SetText(CategoryText);
	CategoryCombo.SetHelpText(CategoryHelp);
	CategoryCombo.SetFont(F_Normal);
	CategoryCombo.SetEditable(False);
	CategoryCombo.AddItem(GeneralText);

	// Add all categories.
	for(i=0; i<256; i++)
	{
		bAlreadyHave = false;
		GetPlayerOwner().GetNextIntDesc("TournamentGameInfo", i, NextEntry, NextCategory);
		for(j =0; j<256; j++)
		{
			if (Categories[j] ~= NextCategory)
				bAlreadyHave = true;
		}
		if (!bAlreadyHave)
			Categories[i] = NextCategory;
	}
	for(i=0; i<256; i++)
	{
		if (Len(Categories[i]) > 0)
		{
			CategoryCombo.AddItem(Categories[i]);
			CategoryCount++;
			if (Categories[i] ~= LastCategory)
				BestCategory = CategoryCount;
		}
	}
	CategoryCombo.SetSelectedIndex(BestCategory);

	// Game Type
	GameCombo = UWindowComboControl(CreateControl(class'UWindowComboControl', CenterPos, 45, CenterWidth, 1));
	GameCombo.SetButtons(True);
	GameCombo.SetText(GameText);
	GameCombo.SetHelpText(GameHelp);
	GameCombo.SetFont(F_Normal);
	GameCombo.SetEditable(False);

	// Compile a list of all gametypes.
	i=0;
	TempClass = class'TournamentGameInfo';
	GetPlayerOwner().GetNextIntDesc("TournamentGameInfo", 0, NextGame, NextCategory);
	while (NextGame != "")
	{
		if ((CategoryCombo.GetValue() ~= GeneralText) && (NextCategory == ""))
			TempGames[i] = NextGame;
		else if (NextCategory ~= CategoryCombo.GetValue())
			TempGames[i] = NextGame;
		i++;
		if(i == 256)
		{
			Log("More than 256 gameinfos listed in int files");
			break;
		}
		GetPlayerOwner().GetNextIntDesc("TournamentGameInfo", i, NextGame, NextCategory);
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
			if (TempClass != none)
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
	MapCombo = UWindowComboControl(CreateControl(class'UWindowComboControl', CenterPos, 70, CenterWidth, 1));
	MapCombo.SetButtons(True);
	MapCombo.SetText(MapText);
	MapCombo.SetHelpText(MapHelp);
	MapCombo.SetFont(F_Normal);
	MapCombo.SetEditable(False);

	IterateMaps(BotmatchParent.Map);

	// Map List Button
	MapListButton = UWindowSmallButton(CreateControl(class'UWindowSmallButton', CenterPos, 95, 48, 16));
	MapListButton.SetText(MapListText);
	MapListButton.SetFont(F_Normal);
	MapListButton.SetHelpText(MapListHelp);

	// Mutator Button
	MutatorButton = UWindowSmallButton(CreateControl(class'UWindowSmallButton', CenterPos, 120, 48, 16));
	MutatorButton.SetText(MutatorText);
	MutatorButton.SetFont(F_Normal);
	MutatorButton.SetHelpText(MutatorHelp);

	ControlWidth = WinWidth/2.5;
	ControlLeft = (WinWidth/2 - ControlWidth)/2;
	ControlRight = WinWidth/2 + ControlLeft;

	CenterWidth = (WinWidth/4)*3;
	CenterPos = (WinWidth - CenterWidth)/2;

	ChangeLevelsCheck = UWindowCheckbox(CreateControl(class'UWindowCheckbox', CenterPos, 145, ControlWidth, 1));
	ChangeLevelsCheck.SetText(ChangeLevelsText);
	ChangeLevelsCheck.SetHelpText(ChangeLevelsHelp);
	ChangeLevelsCheck.SetFont(F_Normal);
	ChangeLevelsCheck.Align = TA_Right;

	SetChangeLevels();

	Initialized = true;
}

function BeforePaint(Canvas C, float X, float Y)
{
	local int ControlWidth, ControlLeft, ControlRight;
	local int CenterWidth, CenterPos;

	Super.BeforePaint(C, X, Y);

	ControlWidth = WinWidth/2.5;
	ControlLeft = (WinWidth/2 - ControlWidth)/2;
	ControlRight = WinWidth/2 + ControlLeft;

	CenterWidth = (WinWidth/4)*3;
	CenterPos = (WinWidth - CenterWidth)/2;

	CategoryCombo.SetSize(CenterWidth, 1);
	CategoryCombo.WinLeft = CenterPos;
	CategoryCombo.EditBoxWidth = 150;

	ChangeLevelsCheck.SetSize(ControlWidth, 1);		
	ChangeLevelsCheck.WinLeft = (WinWidth - ChangeLevelsCheck.WinWidth) / 2;
}

function CategoryChanged()
{
	local string CurCategory;
	local int i, Selection;
	local string NextGame, NextCategory;
	local string TempGames[256];
	local class<GameInfo> TempClass;
	local bool bFoundSavedGameClass;

	if (!Initialized)
		return;

	Initialized = false;

	CurCategory = CategoryCombo.GetValue();
	LastCategory = CurCategory;

	if (CurCategory == LastCategory)
	{
		Initialized = true;
		return;
	}

	GameCombo.Clear();

	for (i=0; i<256; i++)
		Games[i] = "";
	i=0;

	// Compile a list of all gametypes.
	TempClass = class'TournamentGameInfo';
	GetPlayerOwner().GetNextIntDesc("TournamentGameInfo", 0, NextGame, NextCategory);
	while (NextGame != "")
	{
		if ((CurCategory ~= GeneralText) && (NextCategory == ""))
			TempGames[i] = NextGame;
		else if (NextCategory ~= CurCategory)
			TempGames[i] = NextGame;
		i++;
		if(i == 256)
		{
			Log("More than 256 gameinfos listed in int files");
			break;
		}
		GetPlayerOwner().GetNextIntDesc("TournamentGameInfo", i, NextGame, NextCategory);
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
			GameCombo.AddItem(TempClass.Default.GameName);
			MaxGames++;
		}
	}

	GameCombo.SetSelectedIndex(0);

	Initialized = true;

	GameChanged();

	SaveConfig();
}

function GameChanged()
{
	if (!Initialized)
		return;

	Super.GameChanged();
	SetChangeLevels();
}

function SetChangeLevels()
{
	local class<DeathMatchPlus> DMP;

	DMP = class<DeathMatchPlus>(BotmatchParent.GameClass);
	if(DMP == None)
	{
		ChangeLevelsCheck.HideWindow();
	}
	else
	{
		ChangeLevelsCheck.ShowWindow();
		ChangeLevelsCheck.bChecked = DMP.default.bChangeLevels;
	}
}

function Notify(UWindowDialogControl C, byte E)
{
	Super.Notify(C, E);

	switch(E)
	{
	case DE_Change:
		switch(C)
		{
		case CategoryCombo:
			CategoryChanged();
			break;
		case ChangeLevelsCheck:
			ChangeLevelsChanged();
			break;
		}
		break;
	}
}

function ChangeLevelsChanged()
{
	local class<DeathMatchPlus> DMP;

	DMP = class<DeathMatchPlus>(BotmatchParent.GameClass);
	if(DMP != None)
	{
		DMP.default.bChangeLevels = ChangeLevelsCheck.bChecked;
		DMP.static.StaticSaveConfig();
	}
}

defaultproperties
{
      ChangeLevelsCheck=None
      ChangeLevelsText="Auto Change Levels"
      ChangeLevelsHelp="If this setting is checked, the server will change levels according to the map list for this game type."
      CategoryCombo=None
      CategoryText="Category:"
      CategoryHelp="Select a category of gametype!"
      GeneralText="Unreal Tournament"
      LastCategory=""
}
