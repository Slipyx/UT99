class UMenuCustomizeClientWindow extends UMenuPageWindow;

var localized string LocalizedKeyName[255];
var string RealKeyName[255];
var int BoundKey1[100];
var int BoundKey2[100];
var UMenuLabelControl KeyNames[100];
var UMenuRaisedButton KeyButtons[100];
var UMenuRaisedButton SelectedButton;
var localized string LabelList[100];
var string AliasNames[100];
var int Selection;
var bool bPolling;
var localized string OrString;
var localized string CustomizeHelp;

var UWindowSmallButton DefaultsButton;
var localized string DefaultsText;
var localized string DefaultsHelp;

var UMenuLabelControl JoystickHeading;
var localized string JoystickText;

var UWindowComboControl JoyXCombo;
var localized string JoyXText;
var localized string JoyXHelp;
var localized string JoyXOptions[2];
var string JoyXBinding[2];

var UWindowComboControl JoyYCombo;
var localized string JoyYText;
var localized string JoyYHelp;
var localized string JoyYOptions[2];
var string JoyYBinding[2];

var int AliasCount;
var bool bLoadedExisting;
var bool bJoystick;
var float JoyDesiredHeight, NoJoyDesiredHeight;

function Created()
{
	local int ButtonWidth, ButtonLeft, ButtonTop, I, J, pos;
	local int LabelWidth, LabelLeft;
	local UMenuLabelControl Heading;
	local bool bTop;

	bIgnoreLDoubleClick = True;
	bIgnoreMDoubleClick = True;
	bIgnoreRDoubleClick = True;

	bJoystick =	bool(GetPlayerOwner().ConsoleCommand("get windrv.windowsclient usejoystick"));

	Super.Created();

	SetAcceptsFocus();

	ButtonWidth = WinWidth - 140;
	ButtonLeft = WinWidth - ButtonWidth - 40;

	LabelWidth = WinWidth - 100;
	LabelLeft = 20;

	// Defaults Button
	DefaultsButton = UWindowSmallButton(CreateControl(class'UWindowSmallButton', 30, 10, 48, 16));
	DefaultsButton.SetText(DefaultsText);
	DefaultsButton.SetFont(F_Normal);
	DefaultsButton.SetHelpText(DefaultsHelp);
	
	ButtonTop = 25;
	bTop = True;
	for (I=0; I<ArrayCount(AliasNames); I++)
	{
		if(AliasNames[I] == "")
			break;

		j = InStr(LabelList[I], ",");
		if(j != -1)
		{
			if(!bTop)
				ButtonTop += 10;
			Heading = UMenuLabelControl(CreateControl(class'UMenuLabelControl', LabelLeft-10, ButtonTop+3, WinWidth, 1));
			Heading.SetText(Left(LabelList[I], j));
			Heading.SetFont(F_Bold);
			LabelList[I] = Mid(LabelList[I], j+1);
			ButtonTop += 21;
		}
		bTop = False;

		KeyNames[I] = UMenuLabelControl(CreateControl(class'UMenuLabelControl', LabelLeft, ButtonTop+3, LabelWidth, 1));
		KeyNames[I].SetText(LabelList[I]);
		KeyNames[I].SetHelpText(CustomizeHelp);
		KeyNames[I].SetFont(F_Normal);
		KeyButtons[I] = UMenuRaisedButton(CreateControl(class'UMenuRaisedButton', ButtonLeft, ButtonTop, ButtonWidth, 1));
		KeyButtons[I].SetHelpText(CustomizeHelp);
		KeyButtons[I].bAcceptsFocus = False;
		KeyButtons[I].bIgnoreLDoubleClick = True;
		KeyButtons[I].bIgnoreMDoubleClick = True;
		KeyButtons[I].bIgnoreRDoubleClick = True;
		ButtonTop += 21;
	}
	AliasCount = I;

	NoJoyDesiredHeight = ButtonTop + 10;

	// Joystick
	ButtonTop += 10;
	JoystickHeading = UMenuLabelControl(CreateControl(class'UMenuLabelControl', LabelLeft-10, ButtonTop+3, WinWidth, 1));
	JoystickHeading.SetText(JoystickText);
	JoystickHeading.SetFont(F_Bold);
	LabelList[I] = Mid(LabelList[I], j+1);
	ButtonTop += 19;

	JoyXCombo = UWindowComboControl(CreateControl(class'UWindowComboControl', 20, ButtonTop, WinWidth - 40, 1));
	JoyXCombo.CancelAcceptsFocus();
	JoyXCombo.SetText(JoyXText);
	JoyXCombo.SetHelpText(JoyXHelp);
	JoyXCombo.SetFont(F_Normal);
	JoyXCombo.SetEditable(False);
	JoyXCombo.AddItem(JoyXOptions[0]);
	JoyXCombo.AddItem(JoyXOptions[1]);
	JoyXCombo.EditBoxWidth = ButtonWidth;
	ButtonTop += 20;

	JoyYCombo = UWindowComboControl(CreateControl(class'UWindowComboControl', 20, ButtonTop, WinWidth - 40, 1));
	JoyYCombo.CancelAcceptsFocus();
	JoyYCombo.SetText(JoyYText);
	JoyYCombo.SetHelpText(JoyYHelp);
	JoyYCombo.SetFont(F_Normal);
	JoyYCombo.SetEditable(False);
	JoyYCombo.AddItem(JoyYOptions[0]);
	JoyYCombo.AddItem(JoyYOptions[1]);
	JoyYCombo.EditBoxWidth = ButtonWidth;
	ButtonTop += 20;

	LoadExistingKeys();

	DesiredWidth = 220;
	JoyDesiredHeight = ButtonTop + 10;
	DesiredHeight = JoyDesiredHeight;
}

function WindowShown()
{
	Super.WindowShown();
	bJoystick =	bool(GetPlayerOwner().ConsoleCommand("get windrv.windowsclient usejoystick"));
}

function LoadExistingKeys()
{
	local int I, J, pos;
	local string KeyName;
	local string Alias;

	for (I=0; I<AliasCount; I++)
	{
		BoundKey1[I] = 0;
		BoundKey2[I] = 0;
	}

	for (I=0; I<255; I++)
	{
		KeyName = GetPlayerOwner().ConsoleCommand( "KEYNAME "$i );
		RealKeyName[i] = KeyName;
		if ( KeyName != "" )
		{
			Alias = GetPlayerOwner().ConsoleCommand( "KEYBINDING "$KeyName );
			if ( Alias != "" )
			{
				pos = InStr(Alias, " ");
				if ( pos != -1 )
				{
					if( !(Left(Alias, pos) ~= "taunt") &&
						!(Left(Alias, pos) ~= "getweapon") &&
						!(Left(Alias, pos) ~= "viewplayernum") &&
						!(Left(Alias, pos) ~= "button") &&
						!(Left(Alias, pos) ~= "mutate"))
						Alias = Left(Alias, pos);
				}
				for (J=0; J<AliasCount; J++)
				{
					if ( AliasNames[J] ~= Alias && AliasNames[J] != "None" )
					{
						if ( BoundKey1[J] == 0 )
							BoundKey1[J] = i;
						else
						if ( BoundKey2[J] == 0)
							BoundKey2[J] = i;
					}
				}
			}
		}
	}

	bLoadedExisting = False;
	Alias = GetPlayerOwner().ConsoleCommand( "KEYBINDING JoyX" );
	if(Alias ~= JoyXBinding[0])
		JoyXCombo.SetSelectedIndex(0);
	if(Alias ~= JoyXBinding[1])
		JoyXCombo.SetSelectedIndex(1);

	Alias = GetPlayerOwner().ConsoleCommand( "KEYBINDING JoyY" );
	if(Alias ~= JoyYBinding[0])
		JoyYCombo.SetSelectedIndex(0);
	if(Alias ~= JoyYBinding[1])
		JoyYCombo.SetSelectedIndex(1);
	bLoadedExisting = True;
}

function BeforePaint(Canvas C, float X, float Y)
{
	local int ButtonWidth, ButtonLeft, I;
	local int LabelWidth, LabelLeft;

	ButtonWidth = WinWidth - 135;
	ButtonLeft = WinWidth - ButtonWidth - 20;

	DefaultsButton.AutoWidth(C);
	DefaultsButton.WinLeft = ButtonLeft + ButtonWidth - DefaultsButton.WinWidth;

	LabelWidth = WinWidth - 100;
	LabelLeft = 20;

	if(bJoystick)
	{
		DesiredHeight = JoyDesiredHeight;

		JoystickHeading.ShowWindow();
		JoyXCombo.ShowWindow();
		JoyYCombo.ShowWindow();

		JoyXCombo.SetSize(WinWidth - 40, 1);
		JoyXCombo.EditBoxWidth = ButtonWidth;

		JoyYCombo.SetSize(WinWidth - 40, 1);
		JoyYCombo.EditBoxWidth = ButtonWidth;
	}
	else
	{
		DesiredHeight = NoJoyDesiredHeight;

		JoystickHeading.HideWindow();
		JoyXCombo.HideWindow();
		JoyYCombo.HideWindow();
	}

	for (I=0; I<AliasCount; I++)
	{
		KeyButtons[I].SetSize(ButtonWidth, 1);
		KeyButtons[I].WinLeft = ButtonLeft;

		KeyNames[I].SetSize(LabelWidth, 1);
		KeyNames[I].WinLeft = LabelLeft;
	}

	for (I=0; I<AliasCount; I++ )
	{
		if ( BoundKey1[I] == 0 )
			KeyButtons[I].SetText("");
		else
		if ( BoundKey2[I] == 0 )
			KeyButtons[I].SetText(LocalizedKeyName[BoundKey1[I]]);
		else
			KeyButtons[I].SetText(LocalizedKeyName[BoundKey1[I]]$OrString$LocalizedKeyName[BoundKey2[I]]);
	}
}

function bool MouseWheelDown(float ScrollDelta)
{
	Super.MouseWheelDown(ScrollDelta);
	if (bPolling)
		return true;
	return false;
}

function bool MouseWheelUp(float ScrollDelta)
{
	local int Key;
	
	Super.MouseWheelUp(ScrollDelta);
	if (bPolling)
	{
		if (ScrollDelta > 0)
			Key = 0xED;
		else
			Key = 0xEC;
		ProcessMenuKey(Key, RealKeyName[Key]);
		bPolling = False;
		SelectedButton.bDisabled = False;
		return true;
	}
	return false;
}

function KeyDown( int Key, float X, float Y )
{
	if (bPolling)
	{
		ProcessMenuKey(Key, RealKeyName[Key]);
		bPolling = False;
		SelectedButton.bDisabled = False;
	}
}

function RemoveExistingKey(int KeyNo, string KeyName)
{
	local int I;

	// Remove this key from any existing binding display
	for ( I=0; I<AliasCount; I++ )
	{
		if(I != Selection)
		{
			if ( BoundKey2[I] == KeyNo )
				BoundKey2[I] = 0;

			if ( BoundKey1[I] == KeyNo )
			{
				BoundKey1[I] = BoundKey2[I];
				BoundKey2[I] = 0;
			}
		}
	}
}

function SetKey(int KeyNo, string KeyName)
{
	if ( BoundKey1[Selection] != 0 )
	{

		// if this key is already chosen, just clear out other slot
		if(KeyNo == BoundKey1[Selection])
		{
			// if 2 exists, remove it it.
			if(BoundKey2[Selection] != 0)
			{
				GetPlayerOwner().ConsoleCommand("SET Input "$RealKeyName[BoundKey2[Selection]]);
				BoundKey2[Selection] = 0;
			}
		}
		else 
		if(KeyNo == BoundKey2[Selection])
		{
			// Remove slot 1
			GetPlayerOwner().ConsoleCommand("SET Input "$RealKeyName[BoundKey1[Selection]]);
			BoundKey1[Selection] = BoundKey2[Selection];
			BoundKey2[Selection] = 0;
		}
		else
		{
			// Clear out old slot 2 if it exists
			if(BoundKey2[Selection] != 0)
			{
				GetPlayerOwner().ConsoleCommand("SET Input "$RealKeyName[BoundKey2[Selection]]);
				BoundKey2[Selection] = 0;
			}

			// move key 1 to key 2, and set ourselves in 1.
			BoundKey2[Selection] = BoundKey1[Selection];
			BoundKey1[Selection] = KeyNo;
			GetPlayerOwner().ConsoleCommand("SET Input"@KeyName@AliasNames[Selection]);		
		}
	}
	else
	{
		BoundKey1[Selection] = KeyNo;
		GetPlayerOwner().ConsoleCommand("SET Input"@KeyName@AliasNames[Selection]);		
	}
}

function ProcessMenuKey( int KeyNo, string KeyName )
{
	if ( (KeyName == "") || (KeyName == "Escape")  
		|| ((KeyNo >= 0x70 ) && (KeyNo <= 0x79)) // function keys
		|| ((KeyNo >= 0x30 ) && (KeyNo <= 0x39))) // number keys
		return;

	RemoveExistingKey(KeyNo, KeyName);
	SetKey(KeyNo, KeyName);
}

function Notify(UWindowDialogControl C, byte E)
{
	local int I;

	Super.Notify(C, E);

	if(C == DefaultsButton && E == DE_Click)
	{
		GetPlayerOwner().ResetKeyboard();
		LoadExistingKeys();
		return;
	} 

	switch(E)
	{
	case DE_Change:
		switch(C)
		{
		case JoyXCombo:
			if(bLoadedExisting)
				GetPlayerOwner().ConsoleCommand("SET Input JoyX "$JoyXBinding[JoyXCombo.GetSelectedIndex()]);
			break;
		case JoyYCombo:
			if(bLoadedExisting)
				GetPlayerOwner().ConsoleCommand("SET Input JoyY "$JoyYBinding[JoyYCombo.GetSelectedIndex()]);
			break;
		}
		break;
	case DE_Click:
		if (bPolling)
		{
			bPolling = False;
			SelectedButton.bDisabled = False;

			if(C == SelectedButton)
			{
				ProcessMenuKey(1, RealKeyName[1]);
				return;
			}
		}

		if (UMenuRaisedButton(C) != None)
		{
			SelectedButton = UMenuRaisedButton(C);
			for ( I=0; I<AliasCount; I++ )
			{
				if (KeyButtons[I] == C)
					Selection = I;
			}
			bPolling = True;
			SelectedButton.bDisabled = True;
		}
		break;
	case DE_RClick:
		if (bPolling)
			{
				bPolling = False;
				SelectedButton.bDisabled = False;

				if(C == SelectedButton)
				{
					ProcessMenuKey(2, RealKeyName[2]);
					return;
				}
			}
		break;
	case DE_MClick:
		if (bPolling)
			{
				bPolling = False;
				SelectedButton.bDisabled = False;

				if(C == SelectedButton)
				{
					ProcessMenuKey(4, RealKeyName[4]);
					return;
				}			
			}
		break;
	}
}

function GetDesiredDimensions(out float W, out float H)
{	
	Super.GetDesiredDimensions(W, H);
	H = 200;
}

defaultproperties
{
      LocalizedKeyName(0)=""
      LocalizedKeyName(1)="LeftMouse"
      LocalizedKeyName(2)="RightMouse"
      LocalizedKeyName(3)="Cancel"
      LocalizedKeyName(4)="MiddleMouse"
      LocalizedKeyName(5)="Unknown05"
      LocalizedKeyName(6)="Unknown06"
      LocalizedKeyName(7)="Unknown07"
      LocalizedKeyName(8)="Backspace"
      LocalizedKeyName(9)="Tab"
      LocalizedKeyName(10)="Unknown0A"
      LocalizedKeyName(11)="Unknown0B"
      LocalizedKeyName(12)="Unknown0C"
      LocalizedKeyName(13)="Enter"
      LocalizedKeyName(14)="Unknown0E"
      LocalizedKeyName(15)="Unknown0F"
      LocalizedKeyName(16)="Shift"
      LocalizedKeyName(17)="Ctrl"
      LocalizedKeyName(18)="Alt"
      LocalizedKeyName(19)="Pause"
      LocalizedKeyName(20)="CapsLock"
      LocalizedKeyName(21)="MouseButton4"
      LocalizedKeyName(22)="MouseButton5"
      LocalizedKeyName(23)="MouseButton6"
      LocalizedKeyName(24)="MouseButton7"
      LocalizedKeyName(25)="MouseButton8"
      LocalizedKeyName(26)="Unknown1A"
      LocalizedKeyName(27)="Escape"
      LocalizedKeyName(28)="Unknown1C"
      LocalizedKeyName(29)="Unknown1D"
      LocalizedKeyName(30)="Unknown1E"
      LocalizedKeyName(31)="Unknown1F"
      LocalizedKeyName(32)="Space"
      LocalizedKeyName(33)="PageUp"
      LocalizedKeyName(34)="PageDown"
      LocalizedKeyName(35)="End"
      LocalizedKeyName(36)="Home"
      LocalizedKeyName(37)="Left"
      LocalizedKeyName(38)="Up"
      LocalizedKeyName(39)="Right"
      LocalizedKeyName(40)="Down"
      LocalizedKeyName(41)="Select"
      LocalizedKeyName(42)="Print"
      LocalizedKeyName(43)="Execute"
      LocalizedKeyName(44)="PrintScrn"
      LocalizedKeyName(45)="Insert"
      LocalizedKeyName(46)="Delete"
      LocalizedKeyName(47)="Help"
      LocalizedKeyName(48)="0"
      LocalizedKeyName(49)="1"
      LocalizedKeyName(50)="2"
      LocalizedKeyName(51)="3"
      LocalizedKeyName(52)="4"
      LocalizedKeyName(53)="5"
      LocalizedKeyName(54)="6"
      LocalizedKeyName(55)="7"
      LocalizedKeyName(56)="8"
      LocalizedKeyName(57)="9"
      LocalizedKeyName(58)="Unknown3A"
      LocalizedKeyName(59)="Unknown3B"
      LocalizedKeyName(60)="Unknown3C"
      LocalizedKeyName(61)="Unknown3D"
      LocalizedKeyName(62)="Unknown3E"
      LocalizedKeyName(63)="Unknown3F"
      LocalizedKeyName(64)="Unknown40"
      LocalizedKeyName(65)="A"
      LocalizedKeyName(66)="B"
      LocalizedKeyName(67)="C"
      LocalizedKeyName(68)="D"
      LocalizedKeyName(69)="E"
      LocalizedKeyName(70)="F"
      LocalizedKeyName(71)="G"
      LocalizedKeyName(72)="H"
      LocalizedKeyName(73)="I"
      LocalizedKeyName(74)="J"
      LocalizedKeyName(75)="K"
      LocalizedKeyName(76)="L"
      LocalizedKeyName(77)="M"
      LocalizedKeyName(78)="N"
      LocalizedKeyName(79)="O"
      LocalizedKeyName(80)="P"
      LocalizedKeyName(81)="Q"
      LocalizedKeyName(82)="R"
      LocalizedKeyName(83)="S"
      LocalizedKeyName(84)="T"
      LocalizedKeyName(85)="U"
      LocalizedKeyName(86)="V"
      LocalizedKeyName(87)="W"
      LocalizedKeyName(88)="X"
      LocalizedKeyName(89)="Y"
      LocalizedKeyName(90)="Z"
      LocalizedKeyName(91)="Unknown5B"
      LocalizedKeyName(92)="Unknown5C"
      LocalizedKeyName(93)="Unknown5D"
      LocalizedKeyName(94)="Unknown5E"
      LocalizedKeyName(95)="Unknown5F"
      LocalizedKeyName(96)="NumPad0"
      LocalizedKeyName(97)="NumPad1"
      LocalizedKeyName(98)="NumPad2"
      LocalizedKeyName(99)="NumPad3"
      LocalizedKeyName(100)="NumPad4"
      LocalizedKeyName(101)="NumPad5"
      LocalizedKeyName(102)="NumPad6"
      LocalizedKeyName(103)="NumPad7"
      LocalizedKeyName(104)="NumPad8"
      LocalizedKeyName(105)="NumPad9"
      LocalizedKeyName(106)="GreyStar"
      LocalizedKeyName(107)="GreyPlus"
      LocalizedKeyName(108)="Separator"
      LocalizedKeyName(109)="GreyMinus"
      LocalizedKeyName(110)="NumPadPeriod"
      LocalizedKeyName(111)="GreySlash"
      LocalizedKeyName(112)="F1"
      LocalizedKeyName(113)="F2"
      LocalizedKeyName(114)="F3"
      LocalizedKeyName(115)="F4"
      LocalizedKeyName(116)="F5"
      LocalizedKeyName(117)="F6"
      LocalizedKeyName(118)="F7"
      LocalizedKeyName(119)="F8"
      LocalizedKeyName(120)="F9"
      LocalizedKeyName(121)="F10"
      LocalizedKeyName(122)="F11"
      LocalizedKeyName(123)="F12"
      LocalizedKeyName(124)="F13"
      LocalizedKeyName(125)="F14"
      LocalizedKeyName(126)="F15"
      LocalizedKeyName(127)="F16"
      LocalizedKeyName(128)="F17"
      LocalizedKeyName(129)="F18"
      LocalizedKeyName(130)="F19"
      LocalizedKeyName(131)="F20"
      LocalizedKeyName(132)="F21"
      LocalizedKeyName(133)="F22"
      LocalizedKeyName(134)="F23"
      LocalizedKeyName(135)="F24"
      LocalizedKeyName(136)="Unknown88"
      LocalizedKeyName(137)="Unknown89"
      LocalizedKeyName(138)="Unknown8A"
      LocalizedKeyName(139)="Unknown8B"
      LocalizedKeyName(140)="Unknown8C"
      LocalizedKeyName(141)="Unknown8D"
      LocalizedKeyName(142)="Unknown8E"
      LocalizedKeyName(143)="Unknown8F"
      LocalizedKeyName(144)="NumLock"
      LocalizedKeyName(145)="ScrollLock"
      LocalizedKeyName(146)="Unknown92"
      LocalizedKeyName(147)="Unknown93"
      LocalizedKeyName(148)="Unknown94"
      LocalizedKeyName(149)="Unknown95"
      LocalizedKeyName(150)="Unknown96"
      LocalizedKeyName(151)="Unknown97"
      LocalizedKeyName(152)="Unknown98"
      LocalizedKeyName(153)="Unknown99"
      LocalizedKeyName(154)="Unknown9A"
      LocalizedKeyName(155)="Unknown9B"
      LocalizedKeyName(156)="Unknown9C"
      LocalizedKeyName(157)="Unknown9D"
      LocalizedKeyName(158)="Unknown9E"
      LocalizedKeyName(159)="Unknown9F"
      LocalizedKeyName(160)="LShift"
      LocalizedKeyName(161)="RShift"
      LocalizedKeyName(162)="LControl"
      LocalizedKeyName(163)="RControl"
      LocalizedKeyName(164)="UnknownA4"
      LocalizedKeyName(165)="UnknownA5"
      LocalizedKeyName(166)="UnknownA6"
      LocalizedKeyName(167)="UnknownA7"
      LocalizedKeyName(168)="UnknownA8"
      LocalizedKeyName(169)="UnknownA9"
      LocalizedKeyName(170)="UnknownAA"
      LocalizedKeyName(171)="UnknownAB"
      LocalizedKeyName(172)="UnknownAC"
      LocalizedKeyName(173)="UnknownAD"
      LocalizedKeyName(174)="UnknownAE"
      LocalizedKeyName(175)="UnknownAF"
      LocalizedKeyName(176)="UnknownB0"
      LocalizedKeyName(177)="UnknownB1"
      LocalizedKeyName(178)="UnknownB2"
      LocalizedKeyName(179)="UnknownB3"
      LocalizedKeyName(180)="UnknownB4"
      LocalizedKeyName(181)="UnknownB5"
      LocalizedKeyName(182)="UnknownB6"
      LocalizedKeyName(183)="UnknownB7"
      LocalizedKeyName(184)="UnknownB8"
      LocalizedKeyName(185)="UnknownB9"
      LocalizedKeyName(186)="Semicolon"
      LocalizedKeyName(187)="Equals"
      LocalizedKeyName(188)="Comma"
      LocalizedKeyName(189)="Minus"
      LocalizedKeyName(190)="Period"
      LocalizedKeyName(191)="Slash"
      LocalizedKeyName(192)="Tilde"
      LocalizedKeyName(193)="UnknownC1"
      LocalizedKeyName(194)="UnknownC2"
      LocalizedKeyName(195)="UnknownC3"
      LocalizedKeyName(196)="UnknownC4"
      LocalizedKeyName(197)="UnknownC5"
      LocalizedKeyName(198)="UnknownC6"
      LocalizedKeyName(199)="UnknownC7"
      LocalizedKeyName(200)="Joy1"
      LocalizedKeyName(201)="Joy2"
      LocalizedKeyName(202)="Joy3"
      LocalizedKeyName(203)="Joy4"
      LocalizedKeyName(204)="Joy5"
      LocalizedKeyName(205)="Joy6"
      LocalizedKeyName(206)="Joy7"
      LocalizedKeyName(207)="Joy8"
      LocalizedKeyName(208)="Joy9"
      LocalizedKeyName(209)="Joy10"
      LocalizedKeyName(210)="Joy11"
      LocalizedKeyName(211)="Joy12"
      LocalizedKeyName(212)="Joy13"
      LocalizedKeyName(213)="Joy14"
      LocalizedKeyName(214)="Joy15"
      LocalizedKeyName(215)="Joy16"
      LocalizedKeyName(216)="UnknownD8"
      LocalizedKeyName(217)="UnknownD9"
      LocalizedKeyName(218)="UnknownDA"
      LocalizedKeyName(219)="LeftBracket"
      LocalizedKeyName(220)="Backslash"
      LocalizedKeyName(221)="RightBracket"
      LocalizedKeyName(222)="SingleQuote"
      LocalizedKeyName(223)="UnknownDF"
      LocalizedKeyName(224)="JoyX"
      LocalizedKeyName(225)="JoyY"
      LocalizedKeyName(226)="JoyZ"
      LocalizedKeyName(227)="JoyR"
      LocalizedKeyName(228)="MouseX"
      LocalizedKeyName(229)="MouseY"
      LocalizedKeyName(230)="MouseZ"
      LocalizedKeyName(231)="MouseW"
      LocalizedKeyName(232)="JoyU"
      LocalizedKeyName(233)="JoyV"
      LocalizedKeyName(234)="UnknownEA"
      LocalizedKeyName(235)="UnknownEB"
      LocalizedKeyName(236)="MouseWheelUp"
      LocalizedKeyName(237)="MouseWheelDown"
      LocalizedKeyName(238)="Unknown10E"
      LocalizedKeyName(239)="Unknown10F"
      LocalizedKeyName(240)="JoyPovUp"
      LocalizedKeyName(241)="JoyPovDown"
      LocalizedKeyName(242)="JoyPovLeft"
      LocalizedKeyName(243)="JoyPovRight"
      LocalizedKeyName(244)="UnknownF4"
      LocalizedKeyName(245)="UnknownF5"
      LocalizedKeyName(246)="Attn"
      LocalizedKeyName(247)="CrSel"
      LocalizedKeyName(248)="ExSel"
      LocalizedKeyName(249)="ErEof"
      LocalizedKeyName(250)="Play"
      LocalizedKeyName(251)="Zoom"
      LocalizedKeyName(252)="NoName"
      LocalizedKeyName(253)="PA1"
      LocalizedKeyName(254)="OEMClear"
      RealKeyName(0)=""
      RealKeyName(1)=""
      RealKeyName(2)=""
      RealKeyName(3)=""
      RealKeyName(4)=""
      RealKeyName(5)=""
      RealKeyName(6)=""
      RealKeyName(7)=""
      RealKeyName(8)=""
      RealKeyName(9)=""
      RealKeyName(10)=""
      RealKeyName(11)=""
      RealKeyName(12)=""
      RealKeyName(13)=""
      RealKeyName(14)=""
      RealKeyName(15)=""
      RealKeyName(16)=""
      RealKeyName(17)=""
      RealKeyName(18)=""
      RealKeyName(19)=""
      RealKeyName(20)=""
      RealKeyName(21)=""
      RealKeyName(22)=""
      RealKeyName(23)=""
      RealKeyName(24)=""
      RealKeyName(25)=""
      RealKeyName(26)=""
      RealKeyName(27)=""
      RealKeyName(28)=""
      RealKeyName(29)=""
      RealKeyName(30)=""
      RealKeyName(31)=""
      RealKeyName(32)=""
      RealKeyName(33)=""
      RealKeyName(34)=""
      RealKeyName(35)=""
      RealKeyName(36)=""
      RealKeyName(37)=""
      RealKeyName(38)=""
      RealKeyName(39)=""
      RealKeyName(40)=""
      RealKeyName(41)=""
      RealKeyName(42)=""
      RealKeyName(43)=""
      RealKeyName(44)=""
      RealKeyName(45)=""
      RealKeyName(46)=""
      RealKeyName(47)=""
      RealKeyName(48)=""
      RealKeyName(49)=""
      RealKeyName(50)=""
      RealKeyName(51)=""
      RealKeyName(52)=""
      RealKeyName(53)=""
      RealKeyName(54)=""
      RealKeyName(55)=""
      RealKeyName(56)=""
      RealKeyName(57)=""
      RealKeyName(58)=""
      RealKeyName(59)=""
      RealKeyName(60)=""
      RealKeyName(61)=""
      RealKeyName(62)=""
      RealKeyName(63)=""
      RealKeyName(64)=""
      RealKeyName(65)=""
      RealKeyName(66)=""
      RealKeyName(67)=""
      RealKeyName(68)=""
      RealKeyName(69)=""
      RealKeyName(70)=""
      RealKeyName(71)=""
      RealKeyName(72)=""
      RealKeyName(73)=""
      RealKeyName(74)=""
      RealKeyName(75)=""
      RealKeyName(76)=""
      RealKeyName(77)=""
      RealKeyName(78)=""
      RealKeyName(79)=""
      RealKeyName(80)=""
      RealKeyName(81)=""
      RealKeyName(82)=""
      RealKeyName(83)=""
      RealKeyName(84)=""
      RealKeyName(85)=""
      RealKeyName(86)=""
      RealKeyName(87)=""
      RealKeyName(88)=""
      RealKeyName(89)=""
      RealKeyName(90)=""
      RealKeyName(91)=""
      RealKeyName(92)=""
      RealKeyName(93)=""
      RealKeyName(94)=""
      RealKeyName(95)=""
      RealKeyName(96)=""
      RealKeyName(97)=""
      RealKeyName(98)=""
      RealKeyName(99)=""
      RealKeyName(100)=""
      RealKeyName(101)=""
      RealKeyName(102)=""
      RealKeyName(103)=""
      RealKeyName(104)=""
      RealKeyName(105)=""
      RealKeyName(106)=""
      RealKeyName(107)=""
      RealKeyName(108)=""
      RealKeyName(109)=""
      RealKeyName(110)=""
      RealKeyName(111)=""
      RealKeyName(112)=""
      RealKeyName(113)=""
      RealKeyName(114)=""
      RealKeyName(115)=""
      RealKeyName(116)=""
      RealKeyName(117)=""
      RealKeyName(118)=""
      RealKeyName(119)=""
      RealKeyName(120)=""
      RealKeyName(121)=""
      RealKeyName(122)=""
      RealKeyName(123)=""
      RealKeyName(124)=""
      RealKeyName(125)=""
      RealKeyName(126)=""
      RealKeyName(127)=""
      RealKeyName(128)=""
      RealKeyName(129)=""
      RealKeyName(130)=""
      RealKeyName(131)=""
      RealKeyName(132)=""
      RealKeyName(133)=""
      RealKeyName(134)=""
      RealKeyName(135)=""
      RealKeyName(136)=""
      RealKeyName(137)=""
      RealKeyName(138)=""
      RealKeyName(139)=""
      RealKeyName(140)=""
      RealKeyName(141)=""
      RealKeyName(142)=""
      RealKeyName(143)=""
      RealKeyName(144)=""
      RealKeyName(145)=""
      RealKeyName(146)=""
      RealKeyName(147)=""
      RealKeyName(148)=""
      RealKeyName(149)=""
      RealKeyName(150)=""
      RealKeyName(151)=""
      RealKeyName(152)=""
      RealKeyName(153)=""
      RealKeyName(154)=""
      RealKeyName(155)=""
      RealKeyName(156)=""
      RealKeyName(157)=""
      RealKeyName(158)=""
      RealKeyName(159)=""
      RealKeyName(160)=""
      RealKeyName(161)=""
      RealKeyName(162)=""
      RealKeyName(163)=""
      RealKeyName(164)=""
      RealKeyName(165)=""
      RealKeyName(166)=""
      RealKeyName(167)=""
      RealKeyName(168)=""
      RealKeyName(169)=""
      RealKeyName(170)=""
      RealKeyName(171)=""
      RealKeyName(172)=""
      RealKeyName(173)=""
      RealKeyName(174)=""
      RealKeyName(175)=""
      RealKeyName(176)=""
      RealKeyName(177)=""
      RealKeyName(178)=""
      RealKeyName(179)=""
      RealKeyName(180)=""
      RealKeyName(181)=""
      RealKeyName(182)=""
      RealKeyName(183)=""
      RealKeyName(184)=""
      RealKeyName(185)=""
      RealKeyName(186)=""
      RealKeyName(187)=""
      RealKeyName(188)=""
      RealKeyName(189)=""
      RealKeyName(190)=""
      RealKeyName(191)=""
      RealKeyName(192)=""
      RealKeyName(193)=""
      RealKeyName(194)=""
      RealKeyName(195)=""
      RealKeyName(196)=""
      RealKeyName(197)=""
      RealKeyName(198)=""
      RealKeyName(199)=""
      RealKeyName(200)=""
      RealKeyName(201)=""
      RealKeyName(202)=""
      RealKeyName(203)=""
      RealKeyName(204)=""
      RealKeyName(205)=""
      RealKeyName(206)=""
      RealKeyName(207)=""
      RealKeyName(208)=""
      RealKeyName(209)=""
      RealKeyName(210)=""
      RealKeyName(211)=""
      RealKeyName(212)=""
      RealKeyName(213)=""
      RealKeyName(214)=""
      RealKeyName(215)=""
      RealKeyName(216)=""
      RealKeyName(217)=""
      RealKeyName(218)=""
      RealKeyName(219)=""
      RealKeyName(220)=""
      RealKeyName(221)=""
      RealKeyName(222)=""
      RealKeyName(223)=""
      RealKeyName(224)=""
      RealKeyName(225)=""
      RealKeyName(226)=""
      RealKeyName(227)=""
      RealKeyName(228)=""
      RealKeyName(229)=""
      RealKeyName(230)=""
      RealKeyName(231)=""
      RealKeyName(232)=""
      RealKeyName(233)=""
      RealKeyName(234)=""
      RealKeyName(235)=""
      RealKeyName(236)=""
      RealKeyName(237)=""
      RealKeyName(238)=""
      RealKeyName(239)=""
      RealKeyName(240)=""
      RealKeyName(241)=""
      RealKeyName(242)=""
      RealKeyName(243)=""
      RealKeyName(244)=""
      RealKeyName(245)=""
      RealKeyName(246)=""
      RealKeyName(247)=""
      RealKeyName(248)=""
      RealKeyName(249)=""
      RealKeyName(250)=""
      RealKeyName(251)=""
      RealKeyName(252)=""
      RealKeyName(253)=""
      RealKeyName(254)=""
      BoundKey1(0)=0
      BoundKey1(1)=0
      BoundKey1(2)=0
      BoundKey1(3)=0
      BoundKey1(4)=0
      BoundKey1(5)=0
      BoundKey1(6)=0
      BoundKey1(7)=0
      BoundKey1(8)=0
      BoundKey1(9)=0
      BoundKey1(10)=0
      BoundKey1(11)=0
      BoundKey1(12)=0
      BoundKey1(13)=0
      BoundKey1(14)=0
      BoundKey1(15)=0
      BoundKey1(16)=0
      BoundKey1(17)=0
      BoundKey1(18)=0
      BoundKey1(19)=0
      BoundKey1(20)=0
      BoundKey1(21)=0
      BoundKey1(22)=0
      BoundKey1(23)=0
      BoundKey1(24)=0
      BoundKey1(25)=0
      BoundKey1(26)=0
      BoundKey1(27)=0
      BoundKey1(28)=0
      BoundKey1(29)=0
      BoundKey1(30)=0
      BoundKey1(31)=0
      BoundKey1(32)=0
      BoundKey1(33)=0
      BoundKey1(34)=0
      BoundKey1(35)=0
      BoundKey1(36)=0
      BoundKey1(37)=0
      BoundKey1(38)=0
      BoundKey1(39)=0
      BoundKey1(40)=0
      BoundKey1(41)=0
      BoundKey1(42)=0
      BoundKey1(43)=0
      BoundKey1(44)=0
      BoundKey1(45)=0
      BoundKey1(46)=0
      BoundKey1(47)=0
      BoundKey1(48)=0
      BoundKey1(49)=0
      BoundKey1(50)=0
      BoundKey1(51)=0
      BoundKey1(52)=0
      BoundKey1(53)=0
      BoundKey1(54)=0
      BoundKey1(55)=0
      BoundKey1(56)=0
      BoundKey1(57)=0
      BoundKey1(58)=0
      BoundKey1(59)=0
      BoundKey1(60)=0
      BoundKey1(61)=0
      BoundKey1(62)=0
      BoundKey1(63)=0
      BoundKey1(64)=0
      BoundKey1(65)=0
      BoundKey1(66)=0
      BoundKey1(67)=0
      BoundKey1(68)=0
      BoundKey1(69)=0
      BoundKey1(70)=0
      BoundKey1(71)=0
      BoundKey1(72)=0
      BoundKey1(73)=0
      BoundKey1(74)=0
      BoundKey1(75)=0
      BoundKey1(76)=0
      BoundKey1(77)=0
      BoundKey1(78)=0
      BoundKey1(79)=0
      BoundKey1(80)=0
      BoundKey1(81)=0
      BoundKey1(82)=0
      BoundKey1(83)=0
      BoundKey1(84)=0
      BoundKey1(85)=0
      BoundKey1(86)=0
      BoundKey1(87)=0
      BoundKey1(88)=0
      BoundKey1(89)=0
      BoundKey1(90)=0
      BoundKey1(91)=0
      BoundKey1(92)=0
      BoundKey1(93)=0
      BoundKey1(94)=0
      BoundKey1(95)=0
      BoundKey1(96)=0
      BoundKey1(97)=0
      BoundKey1(98)=0
      BoundKey1(99)=0
      BoundKey2(0)=0
      BoundKey2(1)=0
      BoundKey2(2)=0
      BoundKey2(3)=0
      BoundKey2(4)=0
      BoundKey2(5)=0
      BoundKey2(6)=0
      BoundKey2(7)=0
      BoundKey2(8)=0
      BoundKey2(9)=0
      BoundKey2(10)=0
      BoundKey2(11)=0
      BoundKey2(12)=0
      BoundKey2(13)=0
      BoundKey2(14)=0
      BoundKey2(15)=0
      BoundKey2(16)=0
      BoundKey2(17)=0
      BoundKey2(18)=0
      BoundKey2(19)=0
      BoundKey2(20)=0
      BoundKey2(21)=0
      BoundKey2(22)=0
      BoundKey2(23)=0
      BoundKey2(24)=0
      BoundKey2(25)=0
      BoundKey2(26)=0
      BoundKey2(27)=0
      BoundKey2(28)=0
      BoundKey2(29)=0
      BoundKey2(30)=0
      BoundKey2(31)=0
      BoundKey2(32)=0
      BoundKey2(33)=0
      BoundKey2(34)=0
      BoundKey2(35)=0
      BoundKey2(36)=0
      BoundKey2(37)=0
      BoundKey2(38)=0
      BoundKey2(39)=0
      BoundKey2(40)=0
      BoundKey2(41)=0
      BoundKey2(42)=0
      BoundKey2(43)=0
      BoundKey2(44)=0
      BoundKey2(45)=0
      BoundKey2(46)=0
      BoundKey2(47)=0
      BoundKey2(48)=0
      BoundKey2(49)=0
      BoundKey2(50)=0
      BoundKey2(51)=0
      BoundKey2(52)=0
      BoundKey2(53)=0
      BoundKey2(54)=0
      BoundKey2(55)=0
      BoundKey2(56)=0
      BoundKey2(57)=0
      BoundKey2(58)=0
      BoundKey2(59)=0
      BoundKey2(60)=0
      BoundKey2(61)=0
      BoundKey2(62)=0
      BoundKey2(63)=0
      BoundKey2(64)=0
      BoundKey2(65)=0
      BoundKey2(66)=0
      BoundKey2(67)=0
      BoundKey2(68)=0
      BoundKey2(69)=0
      BoundKey2(70)=0
      BoundKey2(71)=0
      BoundKey2(72)=0
      BoundKey2(73)=0
      BoundKey2(74)=0
      BoundKey2(75)=0
      BoundKey2(76)=0
      BoundKey2(77)=0
      BoundKey2(78)=0
      BoundKey2(79)=0
      BoundKey2(80)=0
      BoundKey2(81)=0
      BoundKey2(82)=0
      BoundKey2(83)=0
      BoundKey2(84)=0
      BoundKey2(85)=0
      BoundKey2(86)=0
      BoundKey2(87)=0
      BoundKey2(88)=0
      BoundKey2(89)=0
      BoundKey2(90)=0
      BoundKey2(91)=0
      BoundKey2(92)=0
      BoundKey2(93)=0
      BoundKey2(94)=0
      BoundKey2(95)=0
      BoundKey2(96)=0
      BoundKey2(97)=0
      BoundKey2(98)=0
      BoundKey2(99)=0
      KeyNames(0)=None
      KeyNames(1)=None
      KeyNames(2)=None
      KeyNames(3)=None
      KeyNames(4)=None
      KeyNames(5)=None
      KeyNames(6)=None
      KeyNames(7)=None
      KeyNames(8)=None
      KeyNames(9)=None
      KeyNames(10)=None
      KeyNames(11)=None
      KeyNames(12)=None
      KeyNames(13)=None
      KeyNames(14)=None
      KeyNames(15)=None
      KeyNames(16)=None
      KeyNames(17)=None
      KeyNames(18)=None
      KeyNames(19)=None
      KeyNames(20)=None
      KeyNames(21)=None
      KeyNames(22)=None
      KeyNames(23)=None
      KeyNames(24)=None
      KeyNames(25)=None
      KeyNames(26)=None
      KeyNames(27)=None
      KeyNames(28)=None
      KeyNames(29)=None
      KeyNames(30)=None
      KeyNames(31)=None
      KeyNames(32)=None
      KeyNames(33)=None
      KeyNames(34)=None
      KeyNames(35)=None
      KeyNames(36)=None
      KeyNames(37)=None
      KeyNames(38)=None
      KeyNames(39)=None
      KeyNames(40)=None
      KeyNames(41)=None
      KeyNames(42)=None
      KeyNames(43)=None
      KeyNames(44)=None
      KeyNames(45)=None
      KeyNames(46)=None
      KeyNames(47)=None
      KeyNames(48)=None
      KeyNames(49)=None
      KeyNames(50)=None
      KeyNames(51)=None
      KeyNames(52)=None
      KeyNames(53)=None
      KeyNames(54)=None
      KeyNames(55)=None
      KeyNames(56)=None
      KeyNames(57)=None
      KeyNames(58)=None
      KeyNames(59)=None
      KeyNames(60)=None
      KeyNames(61)=None
      KeyNames(62)=None
      KeyNames(63)=None
      KeyNames(64)=None
      KeyNames(65)=None
      KeyNames(66)=None
      KeyNames(67)=None
      KeyNames(68)=None
      KeyNames(69)=None
      KeyNames(70)=None
      KeyNames(71)=None
      KeyNames(72)=None
      KeyNames(73)=None
      KeyNames(74)=None
      KeyNames(75)=None
      KeyNames(76)=None
      KeyNames(77)=None
      KeyNames(78)=None
      KeyNames(79)=None
      KeyNames(80)=None
      KeyNames(81)=None
      KeyNames(82)=None
      KeyNames(83)=None
      KeyNames(84)=None
      KeyNames(85)=None
      KeyNames(86)=None
      KeyNames(87)=None
      KeyNames(88)=None
      KeyNames(89)=None
      KeyNames(90)=None
      KeyNames(91)=None
      KeyNames(92)=None
      KeyNames(93)=None
      KeyNames(94)=None
      KeyNames(95)=None
      KeyNames(96)=None
      KeyNames(97)=None
      KeyNames(98)=None
      KeyNames(99)=None
      KeyButtons(0)=None
      KeyButtons(1)=None
      KeyButtons(2)=None
      KeyButtons(3)=None
      KeyButtons(4)=None
      KeyButtons(5)=None
      KeyButtons(6)=None
      KeyButtons(7)=None
      KeyButtons(8)=None
      KeyButtons(9)=None
      KeyButtons(10)=None
      KeyButtons(11)=None
      KeyButtons(12)=None
      KeyButtons(13)=None
      KeyButtons(14)=None
      KeyButtons(15)=None
      KeyButtons(16)=None
      KeyButtons(17)=None
      KeyButtons(18)=None
      KeyButtons(19)=None
      KeyButtons(20)=None
      KeyButtons(21)=None
      KeyButtons(22)=None
      KeyButtons(23)=None
      KeyButtons(24)=None
      KeyButtons(25)=None
      KeyButtons(26)=None
      KeyButtons(27)=None
      KeyButtons(28)=None
      KeyButtons(29)=None
      KeyButtons(30)=None
      KeyButtons(31)=None
      KeyButtons(32)=None
      KeyButtons(33)=None
      KeyButtons(34)=None
      KeyButtons(35)=None
      KeyButtons(36)=None
      KeyButtons(37)=None
      KeyButtons(38)=None
      KeyButtons(39)=None
      KeyButtons(40)=None
      KeyButtons(41)=None
      KeyButtons(42)=None
      KeyButtons(43)=None
      KeyButtons(44)=None
      KeyButtons(45)=None
      KeyButtons(46)=None
      KeyButtons(47)=None
      KeyButtons(48)=None
      KeyButtons(49)=None
      KeyButtons(50)=None
      KeyButtons(51)=None
      KeyButtons(52)=None
      KeyButtons(53)=None
      KeyButtons(54)=None
      KeyButtons(55)=None
      KeyButtons(56)=None
      KeyButtons(57)=None
      KeyButtons(58)=None
      KeyButtons(59)=None
      KeyButtons(60)=None
      KeyButtons(61)=None
      KeyButtons(62)=None
      KeyButtons(63)=None
      KeyButtons(64)=None
      KeyButtons(65)=None
      KeyButtons(66)=None
      KeyButtons(67)=None
      KeyButtons(68)=None
      KeyButtons(69)=None
      KeyButtons(70)=None
      KeyButtons(71)=None
      KeyButtons(72)=None
      KeyButtons(73)=None
      KeyButtons(74)=None
      KeyButtons(75)=None
      KeyButtons(76)=None
      KeyButtons(77)=None
      KeyButtons(78)=None
      KeyButtons(79)=None
      KeyButtons(80)=None
      KeyButtons(81)=None
      KeyButtons(82)=None
      KeyButtons(83)=None
      KeyButtons(84)=None
      KeyButtons(85)=None
      KeyButtons(86)=None
      KeyButtons(87)=None
      KeyButtons(88)=None
      KeyButtons(89)=None
      KeyButtons(90)=None
      KeyButtons(91)=None
      KeyButtons(92)=None
      KeyButtons(93)=None
      KeyButtons(94)=None
      KeyButtons(95)=None
      KeyButtons(96)=None
      KeyButtons(97)=None
      KeyButtons(98)=None
      KeyButtons(99)=None
      SelectedButton=None
      LabelList(0)="Fire"
      LabelList(1)="Alternate Fire"
      LabelList(2)="Move Forward"
      LabelList(3)="Move Backward"
      LabelList(4)="Turn Left"
      LabelList(5)="Turn Right"
      LabelList(6)="Strafe Left"
      LabelList(7)="Strafe Right"
      LabelList(8)="Jump/Up"
      LabelList(9)="Crouch/Down"
      LabelList(10)="Mouse Look"
      LabelList(11)="Activate Item"
      LabelList(12)="Next Item"
      LabelList(13)="Previous Item"
      LabelList(14)="Look Up"
      LabelList(15)="Look Down"
      LabelList(16)="Center View"
      LabelList(17)="Walk"
      LabelList(18)="Strafe"
      LabelList(19)="Next Weapon"
      LabelList(20)="Throw Weapon"
      LabelList(21)="Feign Death"
      LabelList(22)=""
      LabelList(23)=""
      LabelList(24)=""
      LabelList(25)=""
      LabelList(26)=""
      LabelList(27)=""
      LabelList(28)=""
      LabelList(29)=""
      LabelList(30)=""
      LabelList(31)=""
      LabelList(32)=""
      LabelList(33)=""
      LabelList(34)=""
      LabelList(35)=""
      LabelList(36)=""
      LabelList(37)=""
      LabelList(38)=""
      LabelList(39)=""
      LabelList(40)=""
      LabelList(41)=""
      LabelList(42)=""
      LabelList(43)=""
      LabelList(44)=""
      LabelList(45)=""
      LabelList(46)=""
      LabelList(47)=""
      LabelList(48)=""
      LabelList(49)=""
      LabelList(50)=""
      LabelList(51)=""
      LabelList(52)=""
      LabelList(53)=""
      LabelList(54)=""
      LabelList(55)=""
      LabelList(56)=""
      LabelList(57)=""
      LabelList(58)=""
      LabelList(59)=""
      LabelList(60)=""
      LabelList(61)=""
      LabelList(62)=""
      LabelList(63)=""
      LabelList(64)=""
      LabelList(65)=""
      LabelList(66)=""
      LabelList(67)=""
      LabelList(68)=""
      LabelList(69)=""
      LabelList(70)=""
      LabelList(71)=""
      LabelList(72)=""
      LabelList(73)=""
      LabelList(74)=""
      LabelList(75)=""
      LabelList(76)=""
      LabelList(77)=""
      LabelList(78)=""
      LabelList(79)=""
      LabelList(80)=""
      LabelList(81)=""
      LabelList(82)=""
      LabelList(83)=""
      LabelList(84)=""
      LabelList(85)=""
      LabelList(86)=""
      LabelList(87)=""
      LabelList(88)=""
      LabelList(89)=""
      LabelList(90)=""
      LabelList(91)=""
      LabelList(92)=""
      LabelList(93)=""
      LabelList(94)=""
      LabelList(95)=""
      LabelList(96)=""
      LabelList(97)=""
      LabelList(98)=""
      LabelList(99)=""
      AliasNames(0)="Fire"
      AliasNames(1)="AltFire"
      AliasNames(2)="MoveForward"
      AliasNames(3)="MoveBackward"
      AliasNames(4)="TurnLeft"
      AliasNames(5)="TurnRight"
      AliasNames(6)="StrafeLeft"
      AliasNames(7)="StrafeRight"
      AliasNames(8)="Jump"
      AliasNames(9)="Duck"
      AliasNames(10)="Look"
      AliasNames(11)="InventoryActivate"
      AliasNames(12)="InventoryNext"
      AliasNames(13)="InventoryPrevious"
      AliasNames(14)="LookUp"
      AliasNames(15)="LookDown"
      AliasNames(16)="CenterView"
      AliasNames(17)="Walking"
      AliasNames(18)="Strafe"
      AliasNames(19)="NextWeapon"
      AliasNames(20)="ThrowWeapon"
      AliasNames(21)="FeignDeath"
      AliasNames(22)=""
      AliasNames(23)=""
      AliasNames(24)=""
      AliasNames(25)=""
      AliasNames(26)=""
      AliasNames(27)=""
      AliasNames(28)=""
      AliasNames(29)=""
      AliasNames(30)=""
      AliasNames(31)=""
      AliasNames(32)=""
      AliasNames(33)=""
      AliasNames(34)=""
      AliasNames(35)=""
      AliasNames(36)=""
      AliasNames(37)=""
      AliasNames(38)=""
      AliasNames(39)=""
      AliasNames(40)=""
      AliasNames(41)=""
      AliasNames(42)=""
      AliasNames(43)=""
      AliasNames(44)=""
      AliasNames(45)=""
      AliasNames(46)=""
      AliasNames(47)=""
      AliasNames(48)=""
      AliasNames(49)=""
      AliasNames(50)=""
      AliasNames(51)=""
      AliasNames(52)=""
      AliasNames(53)=""
      AliasNames(54)=""
      AliasNames(55)=""
      AliasNames(56)=""
      AliasNames(57)=""
      AliasNames(58)=""
      AliasNames(59)=""
      AliasNames(60)=""
      AliasNames(61)=""
      AliasNames(62)=""
      AliasNames(63)=""
      AliasNames(64)=""
      AliasNames(65)=""
      AliasNames(66)=""
      AliasNames(67)=""
      AliasNames(68)=""
      AliasNames(69)=""
      AliasNames(70)=""
      AliasNames(71)=""
      AliasNames(72)=""
      AliasNames(73)=""
      AliasNames(74)=""
      AliasNames(75)=""
      AliasNames(76)=""
      AliasNames(77)=""
      AliasNames(78)=""
      AliasNames(79)=""
      AliasNames(80)=""
      AliasNames(81)=""
      AliasNames(82)=""
      AliasNames(83)=""
      AliasNames(84)=""
      AliasNames(85)=""
      AliasNames(86)=""
      AliasNames(87)=""
      AliasNames(88)=""
      AliasNames(89)=""
      AliasNames(90)=""
      AliasNames(91)=""
      AliasNames(92)=""
      AliasNames(93)=""
      AliasNames(94)=""
      AliasNames(95)=""
      AliasNames(96)=""
      AliasNames(97)=""
      AliasNames(98)=""
      AliasNames(99)=""
      Selection=0
      bPolling=False
      OrString=" or "
      CustomizeHelp="Click the blue rectangle and then press the key to bind to this control."
      DefaultsButton=None
      DefaultsText="Reset"
      DefaultsHelp="Reset all controls to their default settings."
      JoystickHeading=None
      JoystickText="Joystick"
      JoyXCombo=None
      JoyXText="X Axis"
      JoyXHelp="Select the behavior for the left-right axis of your joystick."
      JoyXOptions(0)="Strafe Left/Right"
      JoyXOptions(1)="Turn Left/Right"
      JoyXBinding(0)="Axis aStrafe speed=2"
      JoyXBinding(1)="Axis aBaseX speed=0.7"
      JoyYCombo=None
      JoyYText="Y Axis"
      JoyYHelp="Select the behavior for the up-down axis of your joystick."
      JoyYOptions(0)="Move Forward/Back"
      JoyYOptions(1)="Look Up/Down"
      JoyYBinding(0)="Axis aBaseY speed=2"
      JoyYBinding(1)="Axis aLookup speed=-0.4"
      AliasCount=0
      bLoadedExisting=False
      bJoystick=False
      JoyDesiredHeight=0.000000
      NoJoyDesiredHeight=0.000000
}
