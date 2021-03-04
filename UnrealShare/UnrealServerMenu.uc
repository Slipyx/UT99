//=============================================================================
// UnrealServerMenu
//=============================================================================
class UnrealServerMenu extends UnrealLongMenu;

var config string Map;
var config string GameType;
var string Games[16];
var int MaxGames;
var int CurrentGame;
var class<GameInfo> GameClass;
var bool bStandalone;
var localized string BotTitle;
var byte Difficulty;

function PostBeginPlay()
{
	local string NextGame;
	local bool bFoundSavedGameClass;

	Super.PostBeginPlay();
	Difficulty = -1; // 
	NextGame = GetNextInt("GameInfo", 0); 
	while ( (NextGame != "") && (MaxGames < 16) )
	{
		if ( !bFoundSavedGameClass && (NextGame ~= GameType) )
		{
			bFoundSavedGameClass = true;
			CurrentGame = MaxGames;
		}
		Games[MaxGames] = NextGame;
		MaxGames++;
		NextGame = GetNextInt("GameInfo", MaxGames);
	}
}

function UpdateGameClass( string NewGame, int Offset )
{
	Games[Offset] = NewGame;
}

function SetGameClass()
{
	local int i;

	GameType = Games[CurrentGame];
	GameClass = class<gameinfo>(DynamicLoadObject(GameType, class'Class'));
	if ( GameClass == None )
	{
		MaxGames--;
		if ( MaxGames > CurrentGame )
		{
			for ( i=CurrentGame; i<MaxGames; i++ )
				Games[i] = Games[i+1];
		}
		else if ( CurrentGame > 0 )
			CurrentGame--;
		SetGameClass();
		return;
	}
	Map = GetMapName(GameClass.Default.MapPrefix, Map,0);
}

function bool ProcessLeft()
{
	local int i;

	if ( Selection == 1 )
	{
		if ( MaxGames == 0 )
		{
			CurrentGame = 0;
			return true;
		}
		CurrentGame--;
		if ( CurrentGame < 0 )
			CurrentGame = MaxGames - 1;
		SetGameClass();
		if ( (GameClass == None) && (MaxGames > 0) )
			ProcessLeft();
	}
	else if ( Selection == 2 )
	{
		GameClass = class<gameinfo>(DynamicLoadObject(GameType, class'Class'));
		if ( GameClass == None )
		{
			MaxGames--;
			if ( MaxGames > CurrentGame )
			{
				for ( i=CurrentGame; i<MaxGames; i++ )
					Games[i] = Games[i+1];
			}
			else if ( CurrentGame > 0 )
				CurrentGame--;
		}
		Map = GetMapName(GameClass.Default.MapPrefix, Map, -1);
	}
	else 
		return false;

	return true;
}

function bool ProcessRight()
{
	local int i;

	if ( Selection == 1 )
	{
		if ( MaxGames == 0 )
		{
			CurrentGame = 0;
			return true;
		}
		CurrentGame++;
		if ( CurrentGame >= MaxGames )
			CurrentGame = 0;
		SetGameClass();
		if ( (GameClass == None) && (MaxGames > 0) )
			ProcessRight();
	}
	else if ( Selection == 2 )
	{
		GameClass = class<gameinfo>(DynamicLoadObject(GameType, class'Class'));
		if ( GameClass == None )
		{
			MaxGames--;
			if ( MaxGames > CurrentGame )
			{
				for ( i=CurrentGame; i<MaxGames; i++ )
					Games[i] = Games[i+1];
			}
			else if ( CurrentGame > 0 )
				CurrentGame--;
		}
		Map = GetMapName(GameClass.Default.MapPrefix, Map, 1);
	}
	else
		return false;

	return true;
}

function bool ProcessSelection()
{
	local Menu ChildMenu;
	local string URL;
	local GameInfo NewGame;
	local int i;

	GameClass = class<gameinfo>(DynamicLoadObject(GameType, class'Class'));
	if ( GameClass == None )
	{
		MaxGames--;
		if ( MaxGames > CurrentGame )
		{
			for ( i=CurrentGame; i<MaxGames; i++ )
				Games[i] = Games[i+1];
		}
		else if ( CurrentGame > 0 )
			CurrentGame--;
		return true;
	}

	if( Selection == 3 )
	{
		ChildMenu = spawn( GameClass.Default.GameMenuType, owner );
		HUD(Owner).MainMenu = ChildMenu;
		ChildMenu.ParentMenu = self;
		ChildMenu.PlayerOwner = PlayerOwner;
		return true;
	}
	else if ( Selection == 4 )
	{
		NewGame = Spawn(GameClass);
		NewGame.ResetGame();
		NewGame.Destroy();

		URL = Map $ "?Game="$GameType;
		if ( (Difficulty < 0) || (Difficulty > 3) )
			Difficulty = 1;
		URL = URL$"?Difficulty="$Difficulty;
		if ( Level.Game != None )
			URL = URL$"?GameSpeed="$Level.Game.GameSpeed;
		if( !bStandAlone )
			URL = URL $ "?Listen";
		SaveConfigs();
		ChildMenu = spawn(class'UnrealMeshMenu', owner);
		if ( ChildMenu != None )
		{
			UnrealMeshMenu(ChildMenu).StartMap = URL;
			HUD(Owner).MainMenu = ChildMenu;
			ChildMenu.ParentMenu = self;
			ChildMenu.PlayerOwner = PlayerOwner;
		}
		log( "URL: '" $ URL $ "'" );
		return true;
	}
	else if ( Selection == 5 )
	{
		NewGame = Spawn(GameClass);
		NewGame.ResetGame();
		NewGame.Destroy();

		URL = Map $ "?Game="$GameType;
		if ( (Difficulty < 0) || (Difficulty > 3) )
			Difficulty = 1;
		URL = URL$"?Difficulty="$Difficulty;
		SaveConfigs();
		PlayerOwner.ConsoleCommand("RELAUNCH "$URL$" -server log=server.log");
		return true;
	}
	else return false;
}

function SaveConfigs()
{
	SaveConfig();
	PlayerOwner.SaveConfig();
	//PlayerOwner.PlayerReplicationInfo.SaveConfig();
}

function DrawMenu(canvas Canvas)
{
	local int i, StartX, StartY, Spacing;
	local string MapName;

	DrawBackGround(Canvas, false);

	// Draw Title
	if ( bStandAlone )
	{
		MenuLength = 4;
		MenuTitle = BotTitle;
	}
	DrawTitle(Canvas);
		
	Spacing = Clamp(0.07 * Canvas.ClipY, 12, 48);
	StartX = Max(40, 0.5 * Canvas.ClipX - 120);
	StartY = Max(40, 0.5 * (Canvas.ClipY - MenuLength * Spacing - 128));
	Canvas.Font = Canvas.MedFont;

	// draw text
	for( i=1; i<MenuLength+1; i++ )
		MenuList[i] = Default.MenuList[i];

	DrawList(Canvas, false, Spacing, StartX, StartY);  

	// draw values
	SetGameClass();
	MenuList[1] = GameClass.Default.GameName;
	MapName = Left(Map, Len(Map) - 4 );	
	MenuList[2] = MapName;
	MenuList[3] = "";
	MenuList[4] = "";
	MenuList[5] = "";
	DrawList(Canvas, false, Spacing, StartX + 100, StartY);  

	// Draw help panel
	DrawHelpPanel(Canvas, StartY + MenuLength * Spacing + 8, 228);
}

defaultproperties
{
      Map=""
      GameType="UnrealShare.DeathMatchGame"
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
      MaxGames=0
      CurrentGame=0
      GameClass=None
      bStandalone=False
      BotTitle="BOTMATCH"
      Difficulty=0
      MenuLength=5
      HelpMessage(1)="Choose Game Type."
      HelpMessage(2)="Choose Map."
      HelpMessage(3)="Modify Game Options."
      HelpMessage(4)="Start Game."
      HelpMessage(5)="Start a dedicated server on this machine."
      MenuList(1)="Select Game"
      MenuList(2)="Select Map"
      MenuList(3)="Configure Game"
      MenuList(4)="Start Game"
      MenuList(5)="Launch Dedicated Server"
      MenuTitle="MULTIPLAYER"
}
