//=============================================================================
// UnrealKeyboardMenu
//=============================================================================
class UnrealKeyboardMenu extends UnrealLongMenu;

var string MenuValues1[24];
var string MenuValues2[24];
var string AliasNames[24];
var string PendingCommands[30];
var int Pending;
var localized string OrString;
var bool bSetUp;

function SaveConfigs()
{
	ProcessPending();
}

function ProcessPending()
{
	local int i;

	for ( i=0; i<Pending; i++ )
		PlayerOwner.ConsoleCommand(PendingCommands[i]);
		
	Pending = 0;
}

function AddPending( string newCommand )
{
	PendingCommands[Pending] = newCommand;
	Pending++;
	if ( Pending == 30 )
		ProcessPending();
}
	
function SetUpMenu()
{
	local int i, j, pos;
	local string KeyName;
	local string Alias;

	bSetup = true;

	for ( i=0; i<255; i++ )
	{
		KeyName = PlayerOwner.ConsoleCommand( "KEYNAME "$i );
		if ( KeyName != "" )
		{	
			Alias = PlayerOwner.ConsoleCommand( "KEYBINDING "$KeyName );
			if ( Alias != "" )
			{
				pos = InStr(Alias, " " );
				if ( pos != -1 )
					Alias = Left(Alias, pos);
				for ( j=1; j<20; j++ )
				{
					if ( AliasNames[j] == Alias )
					{
						if ( MenuValues1[j] == "" )
							MenuValues1[j] = KeyName;
						else if ( MenuValues2[j] == "" )
							MenuValues2[j] = KeyName;
					}
				}
			}
		}
	}
}

function ProcessMenuKey( int KeyNo, string KeyName )
{
	local int i;

	if ( (KeyName == "") || (KeyName == "Escape")  
		|| ((KeyNo >= 0x70 ) && (KeyNo <= 0x79)) ) //function keys
		return;

	// make sure no overlapping
	for ( i=1; i<20; i++ )
	{
		if ( MenuValues2[i] == KeyName )
			MenuValues2[i] = "";
		if ( MenuValues1[i] == KeyName )
		{
			MenuValues1[i] = MenuValues2[i];
			MenuValues2[i] = "";
		}
	}
	if ( MenuValues1[Selection] != "_" )
		MenuValues2[Selection] = MenuValues1[Selection];
	else if ( MenuValues2[Selection] == "_" )
		MenuValues2[Selection] = "";

	MenuValues1[Selection] = KeyName;
	AddPending("SET Input"@KeyName@AliasNames[Selection]);
}

function ProcessMenuEscape();
function ProcessMenuUpdate( coerce string InputString );

function bool ProcessSelection()
{
	local int i;

	if ( Selection == MenuLength )
	{
		Pending = 0;
		PlayerOwner.ResetKeyboard();
		for ( i=0; i<24; i++ )
		{
			MenuValues1[i] = "";
			MenuValues2[i] = "";
		}
		SetupMenu();
		return true;
	}
	if ( MenuValues2[Selection] != "" )
	{
		AddPending( "SET Input"@MenuValues2[Selection]$" ");
		AddPending( "SET Input"@MenuValues1[Selection]$" ");
		MenuValues1[Selection] = "_";
		MenuValues2[Selection] = "";
	}
	else
		MenuValues2[Selection] = "_";
		
	PlayerOwner.Player.Console.GotoState('KeyMenuing');
	return true;
}

function DrawValues(canvas Canvas, Font RegFont, int Spacing, int StartX, int StartY)
{
	local int i;

	Canvas.Font = RegFont;

	for (i=0; i< MenuLength; i++ )
		if ( MenuValues1[i+1] != "" )
		{
			SetFontBrightness( Canvas, (i == Selection - 1) );
			Canvas.SetPos(StartX, StartY + Spacing * i);
			if ( MenuValues2[i+1] == "" )
				Canvas.DrawText(MenuValues1[i + 1], false);
			else
				Canvas.DrawText(MenuValues1[i + 1]$OrString$MenuValues2[i+1], false);
		}
		Canvas.DrawColor = Canvas.Default.DrawColor;
}

function DrawMenu(canvas Canvas)
{
	local int StartX, StartY, Spacing;
	
	DrawBackGround(Canvas, (Canvas.ClipY < 250));

	Spacing = Clamp(0.04 * Canvas.ClipY, 9, 32);
	StartX = Max(8, 0.5 * Canvas.ClipX - 120);

	if ( Canvas.ClipY > 280 )
	{	
		DrawTitle(Canvas);
		StartY = Max(36, 0.5 * (Canvas.ClipY - MenuLength * Spacing - 128));
	}
	else
		StartY = Max(4, 0.5 * (Canvas.ClipY - MenuLength * Spacing - 128));

	if ( !bSetup )
		SetupMenu();

	DrawList(Canvas, false, Spacing, StartX, StartY); 
	DrawValues(Canvas, Canvas.MedFont, Spacing, StartX+112, StartY);

}

defaultproperties
{
      MenuValues1(0)=""
      MenuValues1(1)=""
      MenuValues1(2)=""
      MenuValues1(3)=""
      MenuValues1(4)=""
      MenuValues1(5)=""
      MenuValues1(6)=""
      MenuValues1(7)=""
      MenuValues1(8)=""
      MenuValues1(9)=""
      MenuValues1(10)=""
      MenuValues1(11)=""
      MenuValues1(12)=""
      MenuValues1(13)=""
      MenuValues1(14)=""
      MenuValues1(15)=""
      MenuValues1(16)=""
      MenuValues1(17)=""
      MenuValues1(18)=""
      MenuValues1(19)=""
      MenuValues1(20)=""
      MenuValues1(21)=""
      MenuValues1(22)=""
      MenuValues1(23)=""
      MenuValues2(0)=""
      MenuValues2(1)=""
      MenuValues2(2)=""
      MenuValues2(3)=""
      MenuValues2(4)=""
      MenuValues2(5)=""
      MenuValues2(6)=""
      MenuValues2(7)=""
      MenuValues2(8)=""
      MenuValues2(9)=""
      MenuValues2(10)=""
      MenuValues2(11)=""
      MenuValues2(12)=""
      MenuValues2(13)=""
      MenuValues2(14)=""
      MenuValues2(15)=""
      MenuValues2(16)=""
      MenuValues2(17)=""
      MenuValues2(18)=""
      MenuValues2(19)=""
      MenuValues2(20)=""
      MenuValues2(21)=""
      MenuValues2(22)=""
      MenuValues2(23)=""
      AliasNames(0)=""
      AliasNames(1)="Fire"
      AliasNames(2)="AltFire"
      AliasNames(3)="MoveForward"
      AliasNames(4)="MoveBackward"
      AliasNames(5)="TurnLeft"
      AliasNames(6)="TurnRight"
      AliasNames(7)="StrafeLeft"
      AliasNames(8)="StrafeRight"
      AliasNames(9)="Jump"
      AliasNames(10)="Duck"
      AliasNames(11)="Look"
      AliasNames(12)="InventoryActivate"
      AliasNames(13)="InventoryNext"
      AliasNames(14)="InventoryPrevious"
      AliasNames(15)="LookUp"
      AliasNames(16)="LookDown"
      AliasNames(17)="CenterView"
      AliasNames(18)="Walking"
      AliasNames(19)="Strafe"
      AliasNames(20)="NextWeapon"
      AliasNames(21)=""
      AliasNames(22)=""
      AliasNames(23)=""
      PendingCommands(0)=""
      PendingCommands(1)=""
      PendingCommands(2)=""
      PendingCommands(3)=""
      PendingCommands(4)=""
      PendingCommands(5)=""
      PendingCommands(6)=""
      PendingCommands(7)=""
      PendingCommands(8)=""
      PendingCommands(9)=""
      PendingCommands(10)=""
      PendingCommands(11)=""
      PendingCommands(12)=""
      PendingCommands(13)=""
      PendingCommands(14)=""
      PendingCommands(15)=""
      PendingCommands(16)=""
      PendingCommands(17)=""
      PendingCommands(18)=""
      PendingCommands(19)=""
      PendingCommands(20)=""
      PendingCommands(21)=""
      PendingCommands(22)=""
      PendingCommands(23)=""
      PendingCommands(24)=""
      PendingCommands(25)=""
      PendingCommands(26)=""
      PendingCommands(27)=""
      PendingCommands(28)=""
      PendingCommands(29)=""
      Pending=0
      OrString=" or "
      bSetUp=False
      MenuLength=21
      HelpMessage(1)=""
      MenuList(1)="Fire"
      MenuList(2)="Alternate Fire"
      MenuList(3)="Move Forward"
      MenuList(4)="Move Backward"
      MenuList(5)="Turn Left"
      MenuList(6)="Turn Right"
      MenuList(7)="Strafe Left"
      MenuList(8)="Strafe Right"
      MenuList(9)="Jump/Up"
      MenuList(10)="Crouch/Down"
      MenuList(11)="Mouse Look"
      MenuList(12)="Activate Item"
      MenuList(13)="Next Item"
      MenuList(14)="Previous Item"
      MenuList(15)="Look Up"
      MenuList(16)="Look Down"
      MenuList(17)="Center View"
      MenuList(18)="Walk"
      MenuList(19)="Strafe"
      MenuList(20)="Next Weapon"
      MenuList(21)="RESET TO DEFAULTS"
      MenuTitle="CONTROLS"
}
