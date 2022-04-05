class UMenuInputOptionsClientWindow extends UMenuPageWindow;

// Auto Aim
var UWindowCheckbox AutoAimCheck;
var localized string AutoAimText;
var localized string AutoAimHelp;

// Joystick
var UWindowCheckbox JoystickCheck;
var localized string JoystickText;
var localized string JoystickHelp;

// Mouse Sensitivity
var UWindowEditControl SensitivityEdit;
var localized string SensitivityText;
var localized string SensitivityHelp;

// Invert Mouse
var UWindowCheckbox InvertMouseCheck;
var localized string InvertMouseText;
var localized string InvertMouseHelp;

// Look Spring
var UWindowCheckbox LookSpringCheck;
var localized string LookSpringText;
var localized string LookSpringHelp;

// Always Mouselook
var UWindowCheckbox MouselookCheck;
var localized string MouselookText;
var localized string MouselookHelp;

// Auto Slope
var UWindowCheckbox AutoSlopeCheck;
var localized string AutoSlopeText;
var localized string AutoSlopeHelp;

// Mouse Smooth
var UWindowComboControl MouseSmoothCombo;
var localized string MouseSmoothText;
var localized string MouseSmoothHelp;
var localized string MouseSmoothDetail[3];

// stijn: retained for compatibility purposes but no longer used
var UWindowCheckBox MouseSmoothCheck;
var UWindowCheckBox DirectInputCheck;
var localized string DirectInputText;
var localized string DirectInputHelp;

// Mouse Input
var UWindowComboControl MouseInputCombo;
var bool MouseInputComboEnabled;
var localized string MouseInputText;
var localized string MouseInputHelp;
var localized string MouseInputDetail[3];
var UWindowMessageBox MouseInputSettingsChangedBox;
var localized string MouseInputSettingsChangedText;
var localized string MouseInputSettingsChangedTitle;

var float ControlOffset;

function Created()
{
	local int ControlWidth, ControlLeft, ControlRight;
	local int CenterWidth, CenterPos, i;
	local string Sens;

	Super.Created();

	ControlWidth = WinWidth/2.5;
	ControlLeft = (WinWidth/2 - ControlWidth)/2;
	ControlRight = WinWidth/2 + ControlLeft;

	CenterWidth = (WinWidth/4)*3;
	CenterPos = (WinWidth - CenterWidth)/2;

	// Joystick
	JoystickCheck = UWindowCheckbox(CreateControl(class'UWindowCheckbox', ControlLeft, ControlOffset, ControlWidth, 1));
	JoystickCheck.bChecked = bool(GetPlayerOwner().ConsoleCommand("get windrv.windowsclient usejoystick"));
	JoystickCheck.SetText(JoystickText);
	JoystickCheck.SetHelpText(JoystickHelp);
	JoystickCheck.SetFont(F_Normal);
	JoystickCheck.Align = TA_Right;

	// Auto Aim
	AutoAimCheck = UWindowCheckbox(CreateControl(class'UWindowCheckbox', ControlRight, ControlOffset, ControlWidth, 1));
	if (GetPlayerOwner().MyAutoAim < 1.0)
		AutoAimCheck.bChecked = true;
	AutoAimCheck.SetText(AutoAimText);
	AutoAimCheck.SetHelpText(AutoAimHelp);
	AutoAimCheck.SetFont(F_Normal);
	AutoAimCheck.Align = TA_Right;
	ControlOffset += 25;

	// Always Mouselook
	MouselookCheck = UWindowCheckbox(CreateControl(class'UWindowCheckbox', ControlLeft, ControlOffset, ControlWidth, 1));
	if (GetPlayerOwner().bAlwaysMouselook)
		MouselookCheck.bChecked = true;
	MouselookCheck.SetText(MouselookText);
	MouselookCheck.SetHelpText(MouselookHelp);
	MouselookCheck.SetFont(F_Normal);
	MouselookCheck.Align = TA_Right;
	
	// Look Spring
	LookSpringCheck = UWindowCheckbox(CreateControl(class'UWindowCheckbox', ControlRight, ControlOffset, ControlWidth, 1));
	if (GetPlayerOwner().bSnapToLevel)
		LookSpringCheck.bChecked = true;
	LookSpringCheck.SetText(LookSpringText);
	LookSpringCheck.SetHelpText(LookSpringHelp);
	LookSpringCheck.SetFont(F_Normal);
	LookSpringCheck.Align = TA_Right;
	ControlOffset += 25;

	// Auto Slope
	AutoSlopeCheck = UWindowCheckbox(CreateControl(class'UWindowCheckbox', ControlLeft, ControlOffset, ControlWidth, 1));
	if (GetPlayerOwner().bLookUpStairs)
		AutoSlopeCheck.bChecked = true;
	AutoSlopeCheck.SetText(AutoSlopeText);
	AutoSlopeCheck.SetHelpText(AutoSlopeHelp);
	AutoSlopeCheck.SetFont(F_Normal);
	AutoSlopeCheck.Align = TA_Right;

	// Mouse Sensitivity
	SensitivityEdit = UWindowEditControl(CreateControl(class'UWindowEditControl', ControlRight, ControlOffset, ControlWidth, 1));
	SensitivityEdit.SetText(SensitivityText);
	SensitivityEdit.SetHelpText(SensitivityHelp);
	SensitivityEdit.SetFont(F_Normal);
	SensitivityEdit.SetNumericOnly(True);
	SensitivityEdit.SetNumericFloat(True);
	SensitivityEdit.SetMaxLength(4);
	SensitivityEdit.Align = TA_Right;
	Sens = string(GetPlayerOwner().MouseSensitivity);
	i = InStr(Sens, ".");
	SensitivityEdit.SetValue(Left(Sens, i+3));
	ControlOffset += 25;

	// Mouse Smoothing
	MouseSmoothCombo = UWindowComboControl(CreateControl(class'UWindowComboControl', CenterPos, ControlOffset, CenterWidth, 1));
	MouseSmoothCombo.SetText(MouseSmoothText);
	MouseSmoothCombo.SetHelpText(MouseSmoothHelp);
	MouseSmoothCombo.SetFont(F_Normal);
	MouseSmoothCombo.SetEditable(False);
	MouseSmoothCombo.AddItem(MouseSmoothDetail[0]);
	MouseSmoothCombo.AddItem(MouseSmoothDetail[1]);
	MouseSmoothCombo.AddItem(MouseSmoothDetail[2]);
	if ( GetPlayerOwner().bNoMouseSmoothing )
		MouseSmoothCombo.SetSelectedIndex(0);
	else if ( GetPlayerOwner().bMaxMouseSmoothing )
		MouseSmoothCombo.SetSelectedIndex(2);
	else
		MouseSmoothCombo.SetSelectedIndex(1);
	ControlOffset += 25;
	
	// Mouse Input (only available in Windows Client)
	if ( Left(GetPlayerOwner().ConsoleCommand("get ini:Engine.Engine.ViewportManager UseRawHIDInput"),12) != "Unrecognized" )
	{
		MouseInputCombo = UWindowComboControl(CreateControl(class'UWindowComboControl', CenterPos, ControlOffset, CenterWidth, 1));
		MouseInputComboEnabled = false;
		MouseInputCombo.SetText(MouseInputText);
		MouseInputCombo.SetHelpText(MouseInputHelp);
		MouseInputCombo.SetFont(F_Normal);
		MouseInputCombo.SetEditable(False);
		MouseInputCombo.AddItem(MouseInputDetail[0]);
		MouseInputCombo.AddItem(MouseInputDetail[1]);
		MouseInputCombo.AddItem(MouseInputDetail[2]);
		if ( bool(GetPlayerOwner().ConsoleCommand("get ini:Engine.Engine.ViewportManager UseRawHIDInput")) )
			MouseInputCombo.SetSelectedIndex(2);
		else if ( bool(GetPlayerOwner().ConsoleCommand("get ini:Engine.Engine.ViewportManager UseDirectInput")) )
			MouseInputCombo.SetSelectedIndex(1);
		else
			MouseInputCombo.SetSelectedIndex(0);
		MouseInputComboEnabled = true;
		ControlOffset += 25;
	}
	
	// Invert Mouse
	InvertMouseCheck = UWindowCheckbox(CreateControl(class'UWindowCheckbox', ControlLeft, ControlOffset, ControlWidth, 1));
	if (GetPlayerOwner().bInvertMouse)
		InvertMouseCheck.bChecked = true;
	InvertMouseCheck.SetText(InvertMouseText);
	InvertMouseCheck.SetHelpText(InvertMouseHelp);
	InvertMouseCheck.SetFont(F_Normal);
	InvertMouseCheck.Align = TA_Right;
	
}

function AfterCreate()
{
	DesiredWidth = 220;
	DesiredHeight = ControlOffset;
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

	AutoAimCheck.SetSize(ControlWidth, 1);
	AutoAimCheck.WinLeft = ControlRight;

	JoystickCheck.SetSize(ControlWidth, 1);
	JoystickCheck.WinLeft = ControlLeft;

	InvertMouseCheck.SetSize(ControlWidth, 1);
	InvertMouseCheck.WinLeft = ControlLeft;

	LookSpringCheck.SetSize(ControlWidth, 1);
	LookSpringCheck.WinLeft = ControlRight;

	MouselookCheck.SetSize(ControlWidth, 1);
	MouselookCheck.WinLeft = ControlLeft;

	AutoSlopeCheck.SetSize(ControlWidth, 1);
	AutoSlopeCheck.WinLeft = ControlLeft;

	SensitivityEdit.SetSize(ControlWidth, 1);
	SensitivityEdit.WinLeft = ControlRight;
	SensitivityEdit.EditBoxWidth = 30;

	if (MouseSmoothCombo != none)
	{
	    MouseSmoothCombo.SetSize(CenterWidth, 1);
    	MouseSmoothCombo.WinLeft = CenterPos;
    	MouseSmoothCombo.EditBoxWidth = 90;
	}

	if (MouseInputCombo != none)
	{
	    MouseInputCombo.SetSize(CenterWidth, 1);
    	MouseInputCombo.WinLeft = CenterPos;
    	MouseInputCombo.EditBoxWidth = 90;
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
		case AutoAimCheck:
			AutoAimChecked();
			break;
		case JoystickCheck:
			JoystickChecked();
			break;
		case InvertMouseCheck:
			InvertMouseChecked();
			break;
		case LookSpringCheck:
			LookSpringChecked();
			break;
		case MouselookCheck:
			MouselookChecked();
			break;
		case AutoSlopeCheck:
			AutoSlopeChecked();
			break;
		case SensitivityEdit:
			SensitivityChanged();
			break;
		case MouseSmoothCombo:
			MouseSmoothChanged();
			break;
		case MouseInputCombo:
			MouseInputChanged();
			break;
		}
	}
}

/*
 * Message Crackers
 */

function AutoAimChecked()
{
	if(AutoAimCheck.bChecked)
	{
		GetPlayerOwner().ChangeAutoAim(0.93);
	} else {
		GetPlayerOwner().ChangeAutoAim(1.0);
	}
}

function JoystickChecked()
{
	if(JoystickCheck.bChecked)
	{
		GetPlayerOwner().ConsoleCommand("set ini:Engine.Engine.ViewportManager usejoystick 1");
	} else {
		GetPlayerOwner().ConsoleCommand("set ini:Engine.Engine.ViewportManager usejoystick 0");
	}
}

function InvertMouseChecked()
{
	GetPlayerOwner().bInvertMouse = InvertMouseCheck.bChecked;
}

function LookSpringChecked()
{
	GetPlayerOwner().bSnapToLevel = LookSpringCheck.bChecked;
}

function MouselookChecked()
{
	GetPlayerOwner().bAlwaysMouseLook = MouselookCheck.bChecked;
}

function AutoSlopeChecked()
{
	GetPlayerOwner().bLookUpStairs = AutoSlopeCheck.bChecked;
}

function SensitivityChanged()
{
	GetPlayerOwner().MouseSensitivity = float(SensitivityEdit.EditBox.Value);
}

function MouseSmoothChanged()
{
	GetPlayerOwner().SetMaxMouseSmoothing( MouseSmoothCombo.GetSelectedIndex() );
}

function MouseInputChanged()
{
	if ( MouseInputCombo != None )
	{
		if ( MouseInputCombo.GetSelectedIndex() == 2 )
		{
			GetPlayerOwner().ConsoleCommand("set ini:Engine.Engine.ViewportManager UseRawHIDInput 1");
			GetPlayerOwner().ConsoleCommand("set ini:Engine.Engine.ViewportManager UseDirectInput 0");
		}
		else if ( MouseInputCombo.GetSelectedIndex() == 1 )
		{
			GetPlayerOwner().ConsoleCommand("set ini:Engine.Engine.ViewportManager UseRawHIDInput 0");
			GetPlayerOwner().ConsoleCommand("set ini:Engine.Engine.ViewportManager UseDirectInput 1");
		}
		else
		{
			GetPlayerOwner().ConsoleCommand("set ini:Engine.Engine.ViewportManager UseRawHIDInput 0");
			GetPlayerOwner().ConsoleCommand("set ini:Engine.Engine.ViewportManager UseDirectInput 0");
		}

		if (MouseInputComboEnabled)
			MouseInputSettingsChangedBox = MessageBox(MouseInputSettingsChangedTitle, MouseInputSettingsChangedText, MB_YesNo, MR_No);
	}	
}

function MessageBoxDone(UWindowMessageBox W, MessageBoxResult Result)
{
	if(W == MouseInputSettingsChangedBox)
	{
		MouseInputSettingsChangedBox = None;
		if(Result == MR_Yes)
		{
			SaveConfigs();
			GetParent(class'UWindowFramedWindow').Close();
			Root.Console.CloseUWindow();
			GetPlayerOwner().ConsoleCommand("RELAUNCH");
		}
	}
}

function SaveConfigs()
{
	GetPlayerOwner().SaveConfig();
	Super.SaveConfigs();
}

defaultproperties
{
      AutoAimCheck=None
      AutoAimText="Auto Aim"
      AutoAimHelp="Enable or disable vertical aiming help."
      JoystickCheck=None
      JoystickText="Joystick"
      JoystickHelp="Enable or disable joystick."
      SensitivityEdit=None
      SensitivityText="Mouse Sensitivity"
      SensitivityHelp="Adjust the mouse sensitivity, or how far you have to move the mouse to produce a given motion in the game."
      InvertMouseCheck=None
      InvertMouseText="Invert Mouse"
      InvertMouseHelp="Invert the mouse X axis.  When true, pushing the mouse forward causes you to look down rather than up."
      LookSpringCheck=None
      LookSpringText="Look Spring"
      LookSpringHelp="If checked, releasing the mouselook key will automatically center the view. Only valid if Mouselook is disabled."
      MouselookCheck=None
      MouselookText="Mouselook"
      MouselookHelp="If checked, the mouse is always used for controlling your view direction."
      AutoSlopeCheck=None
      AutoSlopeText="Auto Slope"
      AutoSlopeHelp="If checked, your view will automatically adjust to look up and down slopes and stairs. Only valid if Mouselook is disabled."
      MouseSmoothCombo=None
      MouseSmoothText="Mouse Smoothing"
      MouseSmoothHelp="If checked, mouse input will be smoothed to improve Mouselook smoothness."
      MouseSmoothDetail(0)="Disable"
      MouseSmoothDetail(1)="Normal"
      MouseSmoothDetail(2)="Full"
      MouseSmoothCheck=None
      DirectInputCheck=None
      DirectInputText=""
      DirectInputHelp=""
      MouseInputCombo=None
      MouseInputComboEnabled=False
      MouseInputText="Mouse Input"
      MouseInputHelp="Selects the source of Mouse Input. You must restart the game for this setting to take effect."
      MouseInputDetail(0)="Cursor"
      MouseInputDetail(1)="DirectInput"
      MouseInputDetail(2)="Raw Input"
      MouseInputSettingsChangedBox=None
      MouseInputSettingsChangedText="This setting will take effect when the game restarts. Do you want to restart the game now?"
      MouseInputSettingsChangedTitle="Mouse Input Settings Changed"
      ControlOffset=20.000000
}
