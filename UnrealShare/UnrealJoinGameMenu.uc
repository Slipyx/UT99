//=============================================================================
// UnrealJoinGameMenu
//=============================================================================
class UnrealJoinGameMenu extends UnrealLongMenu;

var string LastServer;
var string OldLastServer;
var localized string InternetOption;
var localized string FastInternetOption;
var localized string LANOption;

function PostBeginPlay()
{
	Super.PostBeginPlay();
	OldLastServer = LastServer;
} 

function ProcessMenuInput( coerce string InputString )
{
	local UnrealMeshMenu ChildMenu;

	if ( selection == 3 )
	{
		LastServer = InputString;
		SaveConfigs();
		ChildMenu = spawn(class'UnrealMeshMenu', owner);
		if ( ChildMenu != None )
		{
			ChildMenu.StartMap = LastServer;
			HUD(Owner).MainMenu = ChildMenu;
			ChildMenu.ParentMenu = self;
			ChildMenu.PlayerOwner = PlayerOwner;
		}
	}
}

function ProcessMenuEscape()
{
	if ( selection == 3 )
		LastServer = OldLastServer;
}

function ProcessMenuUpdate( coerce string InputString )
{
	if ( selection == 3 )
		LastServer = (InputString$"_");
}

function int StepSize()
{
	if ( PlayerOwner.Player.CurrentNetSpeed < 5000 )
		return 100;
	else if ( PlayerOwner.Player.CurrentNetSpeed < 10000 )
		return 500;
	else
		return 1000;
}
 
function bool ProcessLeft()
{
	local int NewSpeed;

	if ( Selection == 4 )
	{
		if ( PlayerOwner.Player.CurrentNetSpeed <= 3000 )
			NewSpeed = 20000;
		else if ( PlayerOwner.Player.CurrentNetSpeed < 12500 )
			NewSpeed = 2600;
		else
			NewSpeed = 5000;

		PlayerOwner.ConsoleCommand("NETSPEED "$NewSpeed);
	}
	else
		ProcessRight();

	return true;
}

function bool ProcessRight()
{
	local int NewSpeed;

	if ( Selection == 3 )
	{
		LastServer = "_";
		PlayerOwner.Player.Console.GotoState('MenuTyping');
	}
	else if ( Selection == 4 )
	{
		if ( PlayerOwner.Player.CurrentNetSpeed <= 3000 )
			NewSpeed = 5000;
		else if ( PlayerOwner.Player.CurrentNetSpeed < 12500 )
			NewSpeed = 20000;
		else
			NewSpeed = 2600;

		PlayerOwner.ConsoleCommand("NETSPEED "$NewSpeed);
	}

	return true;
}

function bool ProcessSelection()
{
	local Menu ChildMenu;
	local class<Menu> ListenMenuClass;

	if ( Selection == 3 )
	{
		LastServer = "_";
		PlayerOwner.Player.Console.GotoState('MenuTyping');
	}
	else if ( Selection == 1 )
	{
		SaveConfigs();
		ListenMenuClass = class<Menu>(DynamicLoadObject("UnrealShare.UnrealListenMenu", class'Class'));
		ChildMenu = spawn(ListenMenuClass, owner);
	}
	else if ( Selection == 2 )
	{
		SaveConfigs();
		ChildMenu = spawn(class'UnrealFavoritesMenu', owner);
	}
	else if ( Selection == 5 )
	{
		PlayerOwner.ConsoleCommand("GSPYLITE");// PlayerOwner.ConsoleCommand("start http://www.unreal.com/serverlist");
	}
	if ( ChildMenu != None )
	{
		HUD(Owner).MainMenu = ChildMenu;
		ChildMenu.ParentMenu = self;
		ChildMenu.PlayerOwner = PlayerOwner;
	}
	return true;
}

function SaveConfigs()
{
	PlayerOwner.SaveConfig();
	//PlayerOwner.PlayerReplicationInfo.SaveConfig();
	SaveConfig();
}

function DrawMenu(canvas Canvas)
{
	local int StartX, StartY, Spacing;
	
	DrawBackGround(Canvas, false);	
	DrawTitle(Canvas);

	Spacing = Clamp(0.06 * Canvas.ClipY, 11, 32);
	StartX = Max(12, 0.5 * Canvas.ClipX - 120);
	StartY = Max(32, 0.5 * (Canvas.ClipY - 3 * Spacing - 128));

	DrawList(Canvas, false, Spacing, StartX, StartY); 

	Canvas.Font = Canvas.MedFont;
	SetFontBrightness( Canvas, (Selection == 3) );
	Canvas.SetPos(StartX + 100, StartY + 2 * Spacing );	
	Canvas.DrawText(LastServer, false);
	Canvas.DrawColor = Canvas.Default.DrawColor;

	SetFontBrightness( Canvas, (Selection == 4) );
	Canvas.SetPos(StartX + 100, StartY + 3 * Spacing );	
	if ( PlayerOwner.Player.CurrentNetSpeed <= 3000 )
		Canvas.DrawText(InternetOption, false);
	else if ( PlayerOwner.Player.CurrentNetSpeed < 12500 )
		Canvas.DrawText(FastInternetOption, false);
	else
		Canvas.DrawText(LANOption, false);

	Canvas.DrawColor = Canvas.Default.DrawColor;

	DrawHelpPanel(Canvas, StartY + MenuLength * Spacing + 8, 228);
}

defaultproperties
{
      LastServer=""
      OldLastServer=""
      InternetOption=" Internet (28.8 - 56K)"
      FastInternetOption=" Fast Internet (ISDN, cable modem)"
      LANOption=" LAN"
      MenuLength=5
      HelpMessage(1)="Listen for local servers"
      HelpMessage(2)="Choose a server from a list of favorites"
      HelpMessage(3)="Hit enter to type in a server address.  Hit enter again to go to this server."
      HelpMessage(4)="Set networking speed."
      HelpMessage(5)="Open GameSpy Lite"
      MenuList(1)="Find Local Servers"
      MenuList(2)="Choose From Favorites"
      MenuList(3)="Open"
      MenuList(4)="Net Speed"
      MenuList(5)="Go to the Unreal server list"
      MenuTitle="JOIN GAME"
}
