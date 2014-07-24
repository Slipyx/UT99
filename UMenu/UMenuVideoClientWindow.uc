class UMenuVideoClientWindow extends UMenuPageWindow;

// Driver
var bool bInitialized;
var UWindowLabelControl DriverLabel;
var UWindowLabelControl DriverDesc;
var UWindowSmallButton DriverButton;
var localized string DriverText;
var localized string DriverHelp;
var localized string DriverButtonText;
var localized string DriverButtonHelp;

// Resolution
var UWindowComboControl ResolutionCombo;
var localized string ResolutionText;
var localized string ResolutionHelp;

var string OldSettings;

// Color Depth
var UWindowComboControl ColorDepthCombo;
var localized string ColorDepthText;
var localized string ColorDepthHelp;
var localized string BitsText;

// Texture Detail
var UWindowComboControl TextureDetailCombo;
var localized string TextureDetailText;
var localized string TextureDetailHelp;
var localized string Details[3];
var int OldTextureDetail;

// Skin Detail
var UWindowComboControl SkinDetailCombo;
var localized string SkinDetailText;
var localized string SkinDetailHelp;
var int OldSkinDetail;

// Brightness
var UWindowHSliderControl BrightnessSlider;
var localized string BrightnessText;
var localized string BrightnessHelp;

// GUI Scale
var UWindowComboControl ScaleCombo;
var localized string ScaleText;
var localized string ScaleHelp;

var localized string ScaleSizes[2];

// Mouse Speed
var UWindowHSliderControl MouseSlider;
var localized string MouseText;
var localized string MouseHelp;

// GUI Skin
var UWindowComboControl GuiSkinCombo;
var localized string GuiSkinText;
var localized string GuiSkinHelp;

var float ControlOffset;

var UWindowMessageBox ConfirmSettings, ConfirmDriver, ConfirmWorldTextureDetail, ConfirmSkinTextureDetail;
var localized string ConfirmSettingsTitle;
var localized string ConfirmSettingsText;
var localized string ConfirmSettingsCancelTitle;
var localized string ConfirmSettingsCancelText;
var localized string ConfirmTextureDetailTitle;
var localized string ConfirmTextureDetailText;
var localized string ConfirmDriverTitle;
var localized string ConfirmDriverText;

// Show Decals
var UWindowCheckbox ShowDecalsCheck;
var localized string ShowDecalsText;
var localized string ShowDecalsHelp;

// Min Desired Frame Rate
var UWindowEditControl MinFramerateEdit;
var localized string MinFramerateText;
var localized string MinFramerateHelp;

// Dynamic Lights
var UWindowCheckbox DynamicLightsCheck;
var localized string DynamicLightsText;
var localized string DynamicLightsHelp;

function Created()
{
	local bool bLowSoundQuality;
	local int MusicVolume, SoundVolume;
	local int ControlWidth, ControlLeft, ControlRight;
	local int CenterWidth, CenterPos;
	local int i, MinRate;
	local string NextLook, NextDesc;
	local string VideoDriverClassName, ClassLeft, ClassRight, VideoDriverDesc;

	Super.Created();

	ControlWidth = WinWidth/2.5;
	ControlLeft = (WinWidth/2 - ControlWidth)/2;
	ControlRight = WinWidth/2 + ControlLeft;

	CenterWidth = (WinWidth/4)*3;
	CenterPos = (WinWidth - CenterWidth)/2;
	
	VideoDriverClassName = GetPlayerOwner().ConsoleCommand("get ini:Engine.Engine.GameRenderDevice Class");
	i = InStr(VideoDriverClassName, "'");
	// Get class name from class'...'
	if(i != -1)
	{
		VideoDriverClassName = Mid(VideoDriverClassName, i+1);
		i = InStr(VideoDriverClassName, "'");
		VideoDriverClassName = Left(VideoDriverClassName, i);
		ClassLeft = Left(VideoDriverClassName, InStr(VideoDriverClassName, "."));
		ClassRight = Mid(VideoDriverClassName, InStr(VideoDriverClassName, ".") + 1);
		VideoDriverDesc = Localize(ClassRight, "ClassCaption", ClassLeft);
	}
	else
		VideoDriverDesc = "VideoDriverClassName";

	// Driver
	DriverLabel = UWindowLabelControl(CreateControl(class'UWindowLabelControl', ControlLeft, ControlOffset, ControlWidth, 1));
	DriverLabel.SetText(DriverText);
	DriverLabel.SetHelpText(DriverHelp);
	DriverLabel.SetFont(F_Normal);

	DriverDesc = UWindowLabelControl(CreateControl(class'UWindowLabelControl', ControlRight, ControlOffset, ControlWidth, 1));
	DriverDesc.SetText(VideoDriverDesc);
	DriverDesc.SetHelpText(DriverHelp);
	DriverDesc.SetFont(F_Normal);
	ControlOffset += 17;

	DriverButton = UWindowSmallButton(CreateControl(class'UWindowSmallButton', ControlRight, ControlOffset, 48, 16));
	DriverButton.SetText(DriverButtonText);
	DriverButton.SetFont(F_Normal);
	DriverButton.SetHelpText(DriverButtonHelp);
	ControlOffset += 25;


	// Resolution
	ResolutionCombo = UWindowComboControl(CreateControl(class'UWindowComboControl', CenterPos, ControlOffset, CenterWidth, 1));
	ResolutionCombo.SetText(ResolutionText);
	ResolutionCombo.SetHelpText(ResolutionHelp);
	ResolutionCombo.SetFont(F_Normal);
	ResolutionCombo.SetEditable(False);
	ControlOffset += 25;

	ColorDepthCombo = UWindowComboControl(CreateControl(class'UWindowComboControl', CenterPos, ControlOffset, CenterWidth, 1));
	ColorDepthCombo.SetText(ColorDepthText);
	ColorDepthCombo.SetHelpText(ColorDepthHelp);
	ColorDepthCombo.SetFont(F_Normal);
	ColorDepthCombo.SetEditable(False);
	ControlOffset += 25;

	// Texture Detail
	TextureDetailCombo = UWindowComboControl(CreateControl(class'UWindowComboControl', CenterPos, ControlOffset, CenterWidth, 1));
	TextureDetailCombo.SetText(TextureDetailText);
	TextureDetailCombo.SetHelpText(TextureDetailHelp);
	TextureDetailCombo.SetFont(F_Normal);
	TextureDetailCombo.SetEditable(False);
	ControlOffset += 25;

	// The display names are localized.  These strings match the enums in UnCamMgr.cpp.
	TextureDetailCombo.AddItem(Details[0], "High");
	TextureDetailCombo.AddItem(Details[1], "Medium");
	TextureDetailCombo.AddItem(Details[2], "Low");

	// Skin Detail
	SkinDetailCombo = UWindowComboControl(CreateControl(class'UWindowComboControl', CenterPos, ControlOffset, CenterWidth, 1));
	SkinDetailCombo.SetText(SkinDetailText);
	SkinDetailCombo.SetHelpText(SkinDetailHelp);
	SkinDetailCombo.SetFont(F_Normal);
	SkinDetailCombo.SetEditable(False);
	SkinDetailCombo.AddItem(Details[0], "High");
	SkinDetailCombo.AddItem(Details[1], "Medium");
	SkinDetailCombo.AddItem(Details[2], "Low");
	ControlOffset += 25;

	// Brightness
	BrightnessSlider = UWindowHSliderControl(CreateControl(class'UWindowHSliderControl', CenterPos, ControlOffset, CenterWidth, 1));
	BrightnessSlider.bNoSlidingNotify = True;
	BrightnessSlider.SetRange(2, 10, 1);
	BrightnessSlider.SetText(BrightnessText);
	BrightnessSlider.SetHelpText(BrightnessHelp);
	BrightnessSlider.SetFont(F_Normal);
	ControlOffset += 25;

	// GUI Mouse speed
	MouseSlider = UWindowHSliderControl(CreateControl(class'UWindowHSliderControl', CenterPos, ControlOffset, CenterWidth, 1));
	MouseSlider.bNoSlidingNotify = True;
	MouseSlider.SetRange(40, 500, 5);
	MouseSlider.SetText(MouseText);
	MouseSlider.SetHelpText(MouseHelp);
	MouseSlider.SetFont(F_Normal);
	ControlOffset += 25;

	// GUI Scale
	ScaleCombo = UWindowComboControl(CreateControl(class'UWindowComboControl', CenterPos, ControlOffset, CenterWidth, 1));
	ScaleCombo.SetText(ScaleText);
	ScaleCombo.SetHelpText(ScaleHelp);
	ScaleCombo.SetFont(F_Normal);
	ScaleCombo.SetEditable(False);
	ScaleCombo.AddItem(ScaleSizes[0], "10");
	ScaleCombo.AddItem(ScaleSizes[1], "20");
	ControlOffset += 25;

	GuiSkinCombo = UWindowComboControl(CreateControl(class'UWindowComboControl', CenterPos, ControlOffset, CenterWidth, 1));
	GuiSkinCombo.SetText(GuiSkinText);
	GuiSkinCombo.SetHelpText(GuiSkinHelp);
	GuiSkinCombo.SetFont(F_Normal);
	GuiSkinCombo.SetEditable(False);
	ControlOffset += 25;
	i=0;
	GetPlayerOwner().GetNextIntDesc("UWindowLookAndFeel", 0, NextLook, NextDesc);
	while( (NextLook != "") && (i < 32) )
	{
		GuiSkinCombo.AddItem(NextDesc, NextLook);
		i++;
		GetPlayerOwner().GetNextIntDesc("UWindowLookAndFeel", i, NextLook, NextDesc);
	}
	GuiSkinCombo.Sort();

	// Min Desired Framerate
	MinFramerateEdit = UWindowEditControl(CreateControl(class'UWindowEditControl', CenterPos, ControlOffset, CenterWidth, 1));
	MinFramerateEdit.SetText(MinFramerateText);
	MinFramerateEdit.SetHelpText(MinFramerateHelp);
	MinFramerateEdit.SetFont(F_Normal);
	MinFramerateEdit.SetNumericOnly(True);
	MinFramerateEdit.SetMaxLength(3);
	MinFramerateEdit.Align = TA_Left;
	MinRate = int(GetPlayerOwner().ConsoleCommand("get ini:Engine.Engine.ViewportManager MinDesiredFrameRate"));
	MinFramerateEdit.SetValue(string(MinRate));
	ControlOffset += 25;

	// Show Decals
	ShowDecalsCheck = UWindowCheckbox(CreateControl(class'UWindowCheckbox', CenterPos, ControlOffset, CenterWidth, 1));
	ShowDecalsCheck.bChecked = bool(GetPlayerOwner().ConsoleCommand("get ini:Engine.Engine.ViewportManager Decals"));
	ShowDecalsCheck.SetText(ShowDecalsText);
	ShowDecalsCheck.SetHelpText(ShowDecalsHelp);
	ShowDecalsCheck.SetFont(F_Normal);
	ShowDecalsCheck.Align = TA_Left;
	ControlOffset += 25;

	// Dynamic Lights
	DynamicLightsCheck = UWindowCheckbox(CreateControl(class'UWindowCheckbox', CenterPos, ControlOffset, CenterWidth, 1));
	DynamicLightsCheck.bChecked = bool(GetPlayerOwner().ConsoleCommand("get ini:Engine.Engine.ViewportManager NoDynamicLights"));
	DynamicLightsCheck.bChecked = !DynamicLightsCheck.bChecked;
	DynamicLightsCheck.SetText(DynamicLightsText);
	DynamicLightsCheck.SetHelpText(DynamicLightsHelp);
	DynamicLightsCheck.SetFont(F_Normal);
	DynamicLightsCheck.Align = TA_Left;
	ControlOffset += 25;

	LoadAvailableSettings();
}

function AfterCreate()
{
	Super.AfterCreate();

	DesiredWidth = 220;
	DesiredHeight = ControlOffset;
}

function LoadAvailableSettings()
{
	local float Brightness;
	local int P;
	local string CurrentDepth;
	local string ParseString;

	bInitialized = False;

	// Load available video drivers and current video driver here.

	ResolutionCombo.Clear();
	ParseString = GetPlayerOwner().ConsoleCommand("GetRes");
	P = InStr(ParseString, " ");
	while (P != -1) 
	{
		ResolutionCombo.AddItem(Left(ParseString, P));
		ParseString = Mid(ParseString, P+1);
		P = InStr(ParseString, " ");
	}
	ResolutionCombo.AddItem(ParseString);
	ResolutionCombo.SetValue(GetPlayerOwner().ConsoleCommand("GetCurrentRes"));

	ColorDepthCombo.Clear();
	ParseString = GetPlayerOwner().ConsoleCommand("GetColorDepths");
	P = InStr(ParseString, " ");
	while (P != -1) 
	{
		ColorDepthCombo.AddItem(Left(ParseString, P)@BitsText, Left(ParseString, P));
		ParseString = Mid(ParseString, P+1);
		P = InStr(ParseString, " ");
	}
	ColorDepthCombo.AddItem(ParseString@BitsText, ParseString);
	CurrentDepth = GetPlayerOwner().ConsoleCommand("GetCurrentColorDepth");
	ColorDepthCombo.SetValue(CurrentDepth@BitsText, CurrentDepth);

	GuiSkinCombo.SetSelectedIndex(Max(GuiSkinCombo.FindItemIndex2(Root.LookAndFeelClass, True), 0));
	OldTextureDetail = Max(0, TextureDetailCombo.FindItemIndex2(GetPlayerOwner().ConsoleCommand("get ini:Engine.Engine.ViewportManager TextureDetail")));
	TextureDetailCombo.SetSelectedIndex(OldTextureDetail);
	OldSkinDetail = Max(0, SkinDetailCombo.FindItemIndex2(GetPlayerOwner().ConsoleCommand("get ini:Engine.Engine.ViewportManager SkinDetail")));
	SkinDetailCombo.SetSelectedIndex(OldSkinDetail);
	Brightness = int(float(GetPlayerOwner().ConsoleCommand("get ini:Engine.Engine.ViewportManager Brightness")) * 10);
	BrightnessSlider.SetValue(Brightness);
	MouseSlider.SetValue(Root.Console.MouseScale * 100);
	ScaleCombo.SetSelectedIndex(Max(ScaleCombo.FindItemIndex2(string(int(Root.GUIScale*10))), 0));

	bInitialized = True;
}

function ResolutionChanged(float W, float H)
{
	Super.ResolutionChanged(H, H);
	if(GetPlayerOwner().ConsoleCommand("GetCurrentRes") != ResolutionCombo.GetValue())
		LoadAvailableSettings();
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

	DriverLabel.SetSize(CenterWidth-100, 1);
	DriverLabel.WinLeft = CenterPos;

	DriverDesc.SetSize(200, 1);
	DriverDesc.WinLeft = CenterPos + CenterWidth - 100;

	DriverButton.AutoWidth(C);
	DriverButton.WinLeft = CenterPos + CenterWidth - 100;

	ResolutionCombo.SetSize(CenterWidth, 1);
	ResolutionCombo.WinLeft = CenterPos;
	ResolutionCombo.EditBoxWidth = 100;

	ColorDepthCombo.SetSize(CenterWidth, 1);
	ColorDepthCombo.WinLeft = CenterPos;
	ColorDepthCombo.EditBoxWidth = 100;

	TextureDetailCombo.SetSize(CenterWidth, 1);
	TextureDetailCombo.WinLeft = CenterPos;
	TextureDetailCombo.EditBoxWidth = 100;

	SkinDetailCombo.SetSize(CenterWidth, 1);
	SkinDetailCombo.WinLeft = CenterPos;
	SkinDetailCombo.EditBoxWidth = 100;

	BrightnessSlider.SetSize(CenterWidth, 1);
	BrightnessSlider.SliderWidth = 100;
	BrightnessSlider.WinLeft = CenterPos;

	ScaleCombo.SetSize(CenterWidth, 1);
	ScaleCombo.WinLeft = CenterPos;
	ScaleCombo.EditBoxWidth = 100;

	MouseSlider.SetSize(CenterWidth, 1);
	MouseSlider.SliderWidth = 100;
	MouseSlider.WinLeft = CenterPos;

	GuiSkinCombo.SetSize(CenterWidth, 1);
	GuiSkinCombo.WinLeft = CenterPos;
	GuiSkinCombo.EditBoxWidth = 100;

	ShowDecalsCheck.SetSize(CenterWidth-100+16, 1);
	ShowDecalsCheck.WinLeft = CenterPos;

	DynamicLightsCheck.SetSize(CenterWidth-100+16, 1);
	DynamicLightsCheck.WinLeft = CenterPos;

	MinFramerateEdit.SetSize(CenterWidth-100+30, 1);
	MinFramerateEdit.WinLeft = CenterPos;
	MinFramerateEdit.EditBoxWidth = 30;
}

function Notify(UWindowDialogControl C, byte E)
{
	Super.Notify(C, E);

	switch(E)
	{
	case DE_Click:
		switch(C)
		{
		case DriverButton:
			DriverChange();
			break;
		}
		break;
	case DE_Change:
		switch(C)
		{
		case ResolutionCombo:
		case ColorDepthCombo:
			SettingsChanged();
			break;
		case TextureDetailCombo:
			TextureDetailChanged();
			break;
		case SkinDetailCombo:
			SkinDetailChanged();
			break;
		case BrightnessSlider:
			BrightnessChanged();
			break;
		case ScaleCombo:
			ScaleChanged();
			break;
		case MouseSlider:
			MouseChanged();
			break;
		case ShowDecalsCheck:
			DecalsChanged();
			break;
		case DynamicLightsCheck:
			DynamicChanged();
			break;
		case MinFramerateEdit:
			MinFramerateChanged();
			break;
		}
		break;
	}
}

/*
 * Message Crackers
 */


function DriverChange()
{
	ConfirmDriver = MessageBox(ConfirmDriverTitle, ConfirmDriverText, MB_YesNo, MR_No);
}

function SettingsChanged()
{
	local string NewSettings;

	if(bInitialized)
	{
		OldSettings = GetPlayerOwner().ConsoleCommand("GetCurrentRes")$"x"$GetPlayerOwner().ConsoleCommand("GetCurrentColorDepth");
		NewSettings = ResolutionCombo.GetValue()$"x"$ColorDepthCombo.GetValue2();

		if(NewSettings != OldSettings)
		{
			GetPlayerOwner().ConsoleCommand("SetRes "$NewSettings);
			LoadAvailableSettings();
			ConfirmSettings = MessageBox(ConfirmSettingsTitle, ConfirmSettingsText, MB_YesNo, MR_No, MR_None, 10);
		}
	}
}

function MessageBoxDone(UWindowMessageBox W, MessageBoxResult Result)
{
	if(W == ConfirmSettings)
	{
		ConfirmSettings = None;
		if(Result != MR_Yes)
		{
			GetPlayerOwner().ConsoleCommand("SetRes "$OldSettings);
			LoadAvailableSettings();			
			MessageBox(ConfirmSettingsCancelTitle, ConfirmSettingsCancelText, MB_OK, MR_OK, MR_OK);
		}
	}
	else
	if(W == ConfirmDriver)
	{
		ConfirmDriver = None;
		if(Result == MR_Yes)
		{
			GetParent(class'UWindowFramedWindow').Close();
			Root.Console.CloseUWindow();
			GetPlayerOwner().ConsoleCommand("RELAUNCH -changevideo");
		}
	}
	if(W == ConfirmSkinTextureDetail)
	{
		if(Result == MR_Yes)
			OldSkinDetail = SkinDetailCombo.GetSelectedIndex();
		else
			SkinDetailCombo.SetSelectedIndex(OldSkinDetail);
	}
	if(W == ConfirmWorldTextureDetail)
	{
		if(Result == MR_Yes)
			OldTextureDetail = TextureDetailCombo.GetSelectedIndex();
		else
			TextureDetailCombo.SetSelectedIndex(OldTextureDetail);
	}
}

function TextureDetailChanged()
{
	if(bInitialized)
	{
		TextureDetailSet();
		if( TextureDetailCombo.GetSelectedIndex() < OldTextureDetail )
			ConfirmWorldTextureDetail = MessageBox(ConfirmTextureDetailTitle, ConfirmTextureDetailText, MB_YesNo, MR_No, MR_None);	
		else
			OldTextureDetail = TextureDetailCombo.GetSelectedIndex();
	}
}

function TextureDetailSet()
{
	GetPlayerOwner().ConsoleCommand("set ini:Engine.Engine.ViewportManager TextureDetail "$TextureDetailCombo.GetValue2());
}

function SkinDetailChanged()
{
	local int D;
	if(bInitialized)
	{
		SkinDetailSet();
		if( SkinDetailCombo.GetSelectedIndex() < OldSkinDetail )
			ConfirmSkinTextureDetail = MessageBox(ConfirmTextureDetailTitle, ConfirmTextureDetailText, MB_YesNo, MR_No, MR_None);	
		else
			OldSkinDetail = SkinDetailCombo.GetSelectedIndex();
	}
}

function SkinDetailSet()
{
	GetPlayerOwner().ConsoleCommand("set ini:Engine.Engine.ViewportManager SkinDetail "$SkinDetailCombo.GetValue2());
}

function BrightnessChanged()
{
	if(bInitialized)
	{
		GetPlayerOwner().ConsoleCommand("set ini:Engine.Engine.ViewportManager Brightness "$(BrightnessSlider.Value / 10));
		GetPlayerOwner().ConsoleCommand("FLUSH");
	}
}

function ScaleChanged()
{
	if(bInitialized)
	{
		Root.SetScale(float(ScaleCombo.GetValue2())/10);
		Root.SaveConfig();
	}
}

function MouseChanged()
{
	if(bInitialized)
	{
		Root.Console.MouseScale = (MouseSlider.Value / 100);
		Root.Console.SaveConfig();
	}
}

function DecalsChanged()
{
	GetPlayerOwner().ConsoleCommand("set ini:Engine.Engine.ViewportManager Decals "$ShowDecalsCheck.bChecked);
}

function DynamicChanged()
{
	GetPlayerOwner().ConsoleCommand("set ini:Engine.Engine.ViewportManager NoDynamicLights "$!DynamicLightsCheck.bChecked);
}

function MinFramerateChanged()
{
	GetPlayerOwner().ConsoleCommand("set ini:Engine.Engine.ViewportManager MinDesiredFrameRate "$MinFramerateEdit.EditBox.Value);
}

function SaveConfigs()
{
	GetPlayerOwner().SaveConfig();
	Root.Console.SaveConfig();
	Super.SaveConfigs();
	if(GuiSkinCombo.GetValue2() != Root.LookAndFeelClass)
		Root.ChangeLookAndFeel(GuiSkinCombo.GetValue2());
}

defaultproperties
{
     DriverText="Video Driver"
     DriverHelp="This is the current video driver.  Use the Change button to change video drivers."
     DriverButtonText="Change"
     DriverButtonHelp="Press this button to change your video driver."
     ResolutionText="Resolution"
     ResolutionHelp="Select a new screen resolution."
     ColorDepthText="Color Depth"
     ColorDepthHelp="Select a new color depth."
     BitsText="bit"
     TextureDetailText="World Texture Detail"
     TextureDetailHelp="Change the texture detail of world geometry.  Use a lower texture detail to improve game performance."
     Details(0)="High"
     Details(1)="Medium"
     Details(2)="Low"
     SkinDetailText="Skin Detail"
     SkinDetailHelp="Change the detail of player skins.  Use a lower skin detail to improve game performance."
     BrightnessText="Brightness"
     BrightnessHelp="Adjust display brightness."
     ScaleText="Font Size"
     ScaleHelp="Adjust the size of elements in the User Interface."
     ScaleSizes(0)="Normal"
     ScaleSizes(1)="Double"
     MouseText="GUI Mouse Speed"
     MouseHelp="Adjust the speed of the mouse in the User Interface."
     GuiSkinText="GUI Skin"
     GuiSkinHelp="Change the look of the User Interface windows to a custom skin."
     ControlOffset=20.000000
     ConfirmSettingsTitle="Confirm Video Settings Change"
     ConfirmSettingsText="Are you sure you wish to keep these new video settings?"
     ConfirmSettingsCancelTitle="Video Settings Change"
     ConfirmSettingsCancelText="Your previous video settings have been restored."
     ConfirmTextureDetailTitle="Confirm Texture Detail"
     ConfirmTextureDetailText="Increasing texture detail above its default value may degrade performance on some machines.\n\nAre you sure you want to make this change?"
     ConfirmDriverTitle="Change Video Driver"
     ConfirmDriverText="This option will restart Unreal now, and enable you to change your video driver.  Do you want to do this?"
     ShowDecalsText="Show Decals"
     ShowDecalsHelp="If checked, impact and gore decals will be used in game."
     MinFramerateText="Min Desired Framerate"
     MinFramerateHelp="If your framerate falls below this value, Unreal Tournament will reduce special effects to increase your framerate."
     DynamicLightsText="Use Dynamic Lighting"
     DynamicLightsHelp="If checked, dynamic lighting will be used in game."
}
