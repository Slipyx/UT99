//=============================================================================
// UnrealChooseGameMenu
// finds all the single player game types (using the .int files)
// then allows the player to choose one (if there is only one, this menu never displays)
//=============================================================================
class UnrealChooseGameMenu extends UnrealLongMenu;

var() config string StartMaps[20];
var() config string GameNames[20];

function PostBeginPlay()
{
	local string NextGame;
	local class<SinglePlayer> GameClass;

	Super.PostBeginPlay();
	MenuLength = 0;
	NextGame = GetNextInt("SinglePlayer", 0); 
	while ( (NextGame != "") && (MenuLength < 20) )
	{
		GameClass = class<SinglePlayer>(DynamicLoadObject(NextGame, class'Class'));
		if ( GameClass != None )
		{
			MenuLength++;
			StartMaps[MenuLength] = GameClass.Default.StartMap;
			GameNames[MenuLength] = GameClass.Default.GameName;
		}
		NextGame = GetNextInt("SinglePlayer", MenuLength); 
	}
}

function bool ProcessSelection()
{
	local Menu ChildMenu;

	ChildMenu = spawn(class'UnrealNewGameMenu', owner);
	HUD(Owner).MainMenu = ChildMenu;
	ChildMenu.PlayerOwner = PlayerOwner;
	PlayerOwner.UpdateURL("Game","", false);
	UnrealNewGameMenu(ChildMenu).StartMap = StartMaps[Selection];

	if ( MenuLength == 1 )
	{
		ChildMenu.ParentMenu = ParentMenu;
		Destroy();
	}
	else
		ChildMenu.ParentMenu = self;
	return false;
}

function DrawMenu(canvas Canvas)
{
	local int i, StartX, StartY, Spacing;

	if ( MenuLength == 1 )
	{
		DrawBackGround(Canvas, false);
		Selection = 1;
		ProcessSelection();
		return;
	}

	DrawBackGround(Canvas, false);
	DrawTitle(Canvas);

	Canvas.Style = 3;
	Spacing = Clamp(0.04 * Canvas.ClipY, 11, 32);
	StartX = Max(40, 0.5 * Canvas.ClipX - 120);
	StartY = Max(36, 0.5 * (Canvas.ClipY - MenuLength * Spacing - 128));

	// draw text
	for ( i=0; i<20; i++ )
		MenuList[i] = GameNames[i];
	DrawList(Canvas, false, Spacing, StartX, StartY); 

	// Draw help panel
	DrawHelpPanel(Canvas, StartY + MenuLength * Spacing + 8, 228);
}

defaultproperties
{
      StartMaps(0)=""
      StartMaps(1)=""
      StartMaps(2)=""
      StartMaps(3)=""
      StartMaps(4)=""
      StartMaps(5)=""
      StartMaps(6)=""
      StartMaps(7)=""
      StartMaps(8)=""
      StartMaps(9)=""
      StartMaps(10)=""
      StartMaps(11)=""
      StartMaps(12)=""
      StartMaps(13)=""
      StartMaps(14)=""
      StartMaps(15)=""
      StartMaps(16)=""
      StartMaps(17)=""
      StartMaps(18)=""
      StartMaps(19)=""
      GameNames(0)=""
      GameNames(1)=""
      GameNames(2)=""
      GameNames(3)=""
      GameNames(4)=""
      GameNames(5)=""
      GameNames(6)=""
      GameNames(7)=""
      GameNames(8)=""
      GameNames(9)=""
      GameNames(10)=""
      GameNames(11)=""
      GameNames(12)=""
      GameNames(13)=""
      GameNames(14)=""
      GameNames(15)=""
      GameNames(16)=""
      GameNames(17)=""
      GameNames(18)=""
      GameNames(19)=""
      HelpMessage(1)="Choose which game to play."
      HelpMessage(2)="Choose which game to play."
      HelpMessage(3)="Choose which game to play."
      HelpMessage(4)="Choose which game to play."
      HelpMessage(5)="Choose which game to play."
      HelpMessage(6)="Choose which game to play."
      HelpMessage(7)="Choose which game to play."
      HelpMessage(8)="Choose which game to play."
      HelpMessage(9)="Choose which game to play."
      HelpMessage(10)="Choose which game to play."
      HelpMessage(11)="Choose which game to play."
      HelpMessage(12)="Choose which game to play."
      HelpMessage(13)="Choose which game to play."
      HelpMessage(14)="Choose which game to play."
      HelpMessage(15)="Choose which game to play."
      HelpMessage(16)="Choose which game to play."
      HelpMessage(17)="Choose which game to play."
      HelpMessage(18)="Choose which game to play."
      HelpMessage(19)="Choose which game to play."
      MenuTitle="CHOOSE GAME"
}
