//=============================================================================
// Menu: An in-game menu.
// This is a built-in Unreal class and it shouldn't be modified.
//
// Serves as a generic menu master class.  Can be used with any style
// of menu implementation.  Offers menu services such as reading input.
// Not dependent on any visual style.
//=============================================================================
class Menu extends Actor
	native;

var Menu	ParentMenu;
var int		Selection;
var() int	MenuLength;
var bool	bConfigChanged;
var bool    bExitAllMenus;
var PlayerPawn PlayerOwner;

var() localized string HelpMessage[24];
var() localized string MenuList[24];
var() localized string LeftString;
var() localized string RightString;
var() localized string CenterString;
var() localized string EnabledString;
var() localized string DisabledString;
var() localized string MenuTitle;
var() localized string YesString;
var() localized string NoString;

function bool ProcessSelection();
function bool ProcessLeft();
function bool ProcessRight();
function bool ProcessYes();
function bool ProcessNo();
function SaveConfigs();
function PlaySelectSound();
function PlayModifySound();
function PlayEnterSound();
function ProcessMenuInput( coerce string InputString );
function ProcessMenuUpdate( coerce string InputString );
function ProcessMenuEscape();
function ProcessMenuKey( int KeyNo, string KeyName );
function MenuTick( float DeltaTime );
function MenuInit();

function DrawMenu(canvas Canvas);

function ExitAllMenus()
{
	while ( Hud(Owner).MainMenu != None )
		Hud(Owner).MainMenu.ExitMenu();
}

function Menu ExitMenu()
{
	Hud(Owner).MainMenu = ParentMenu;
	if ( bConfigChanged )
		SaveConfigs();
	if ( ParentMenu == None )
	{
		PlayerOwner.bShowMenu = false;
		PlayerOwner.Player.Console.GotoState('');
		if( Level.Netmode == NM_Standalone )
			PlayerOwner.SetPause(False);
	}

	Destroy();
	return none;
}

function SetFontBrightness(canvas Canvas, bool bBright)
{
	if ( bBright )
	{
		Canvas.DrawColor.R = 255;
		Canvas.DrawColor.G = 255;
		Canvas.DrawColor.B = 255;
	}
	else 
		Canvas.DrawColor = Canvas.Default.DrawColor;
}

function MenuProcessInput( byte KeyNum, byte ActionNum )
{
	if ( KeyNum == EInputKey.IK_Escape )
	{
		PlayEnterSound();
		ExitMenu();
		return;
	}	
	else if ( KeyNum == EInputKey.IK_Up )
	{
		PlaySelectSound();
		Selection--;
		if ( Selection < 1 )
			Selection = MenuLength;
	}
	else if ( KeyNum == EInputKey.IK_Down )
	{
		PlaySelectSound();
		Selection++;
		if ( Selection > MenuLength )
			Selection = 1;
	}
	else if ( KeyNum == EInputKey.IK_Enter )
	{
		bConfigChanged=true;
		if ( ProcessSelection() )
			PlayEnterSound();
	}
	else if ( KeyNum == EInputKey.IK_Left )
	{
		bConfigChanged=true;
		if ( ProcessLeft() )
			PlayModifySound();
	}
	else if ( KeyNum == EInputKey.IK_Right )
	{
		bConfigChanged=true;
		if ( ProcessRight() )
			PlayModifySound();
	}
	else if ( Chr(KeyNum) ~= left(YesString, 1) ) 
	{
		bConfigChanged=true;
		if ( ProcessYes() )
			PlayModifySound();
	}
	else if ( Chr(KeyNum) ~= left(NoString, 1) )
	{
		bConfigChanged=true;
		if ( ProcessNo() )
			PlayModifySound();
	}

	if ( bExitAllMenus )
		ExitAllMenus(); 
	
}

defaultproperties
{
      ParentMenu=None
      Selection=1
      MenuLength=0
      bConfigChanged=False
      bExitAllMenus=False
      PlayerOwner=None
      HelpMessage(0)=""
      HelpMessage(1)="This menu has not yet been implemented."
      HelpMessage(2)=""
      HelpMessage(3)=""
      HelpMessage(4)=""
      HelpMessage(5)=""
      HelpMessage(6)=""
      HelpMessage(7)=""
      HelpMessage(8)=""
      HelpMessage(9)=""
      HelpMessage(10)=""
      HelpMessage(11)=""
      HelpMessage(12)=""
      HelpMessage(13)=""
      HelpMessage(14)=""
      HelpMessage(15)=""
      HelpMessage(16)=""
      HelpMessage(17)=""
      HelpMessage(18)=""
      HelpMessage(19)=""
      HelpMessage(20)=""
      HelpMessage(21)=""
      HelpMessage(22)=""
      HelpMessage(23)=""
      MenuList(0)=""
      MenuList(1)=""
      MenuList(2)=""
      MenuList(3)=""
      MenuList(4)=""
      MenuList(5)=""
      MenuList(6)=""
      MenuList(7)=""
      MenuList(8)=""
      MenuList(9)=""
      MenuList(10)=""
      MenuList(11)=""
      MenuList(12)=""
      MenuList(13)=""
      MenuList(14)=""
      MenuList(15)=""
      MenuList(16)=""
      MenuList(17)=""
      MenuList(18)=""
      MenuList(19)=""
      MenuList(20)=""
      MenuList(21)=""
      MenuList(22)=""
      MenuList(23)=""
      LeftString="Left"
      RightString="Right"
      CenterString="Center"
      EnabledString="Enabled"
      DisabledString="Disabled"
      MenuTitle=""
      YesString="yes"
      NoString="no"
      bHidden=True
}
