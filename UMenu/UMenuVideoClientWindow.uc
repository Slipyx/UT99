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

// Gamma
var UWindowHSliderControl GammaSlider;
var localized string GammaText;
var localized string GammaHelp;

// GUI Scale -- stijn: no longer used but retained for compatibility with old mods that replace the menu
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

var UWindowMessageBox ConfirmSettings, ConfirmDriver, ConfirmWorldTextureDetail, ConfirmSkinTextureDetail, ConfirmSettingsRestart;
var localized string ConfirmSettingsTitle;
var localized string ConfirmSettingsText;
var localized string ConfirmSettingsCancelTitle;
var localized string ConfirmSettingsCancelText;
var localized string ConfirmTextureDetailTitle;
var localized string ConfirmTextureDetailText;
var localized string ConfirmDriverTitle;
var localized string ConfirmDriverText;
var localized string ConfirmSettingsRestartTitle;
var localized string ConfirmSettingsRestartText;

// VSync
const VSYNC_OFF = 0;
const VSYNC_ON = 1;
const VSYNC_ADAPTIVE = 2;
const VSYNC_DRIVER_CONTROLLED = 3;
const VSYNC_NOT_SUPPORTED = 4;

var UWindowCheckbox VSyncCheck;
var UWindowComboControl VSyncCombo;
var string VSyncSupportedStates[5];
var int VSyncNumSupportedStates;
var int VSyncCurrentState;
var localized string VSyncStates[5];
var localized string VSyncText;
var localized string VSyncHelp;

// Show Decals
var UWindowCheckbox ShowDecalsCheck;
var localized string ShowDecalsText;
var localized string ShowDecalsHelp;

// Min Desired Frame Rate
var UWindowEditControl MinFramerateEdit;
var localized string MinFramerateText;
var localized string MinFramerateHelp;

var UWindowEditControl MaxFramerateEdit;
var localized string MaxFramerateText;
var localized string MaxFramerateHelp;

// Dynamic Lights
var UWindowCheckbox DynamicLightsCheck;
var localized string DynamicLightsText;
var localized string DynamicLightsHelp;

// Automatic GUI scaling
var UWindowCheckbox AutoGUIScalingCheck;
var localized string AutoGUIScalingText;
var localized string AutoGUIScalingHelp;

// GUI scale
var UWindowHSliderControl GUIScalingSlider;
var localized string GUIScalingText;
var localized string GUIScalingHelp;

// In-game font scaling
var UWindowCheckbox InGameFontScalingCheck;
var localized string InGameFontScalingText;
var localized string InGameFontScalingHelp;

// In-game font scale
var UWindowHSliderControl InGameFontScalingSlider;
var localized string InGameFontScalingSliderText;
var localized string InGameFontScalingSliderHelp;

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

	if (GetPlayerOwner().ConsoleCommand("RELAUNCHSUPPORT") ~= "ENABLED")
	{
	    DriverButton = UWindowSmallButton(CreateControl(class'UWindowSmallButton', ControlRight, ControlOffset, 48, 16));
	    DriverButton.WinHeight = 18; // stijn: add two additional pixels so the g doesn't stick into the edge of the button
	    DriverButton.SetText(DriverButtonText);
	    DriverButton.SetFont(F_Normal);
	    DriverButton.SetHelpText(DriverButtonHelp);
	    ControlOffset += 25;
	}

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

	// Vertical Synchronization
	VSyncGetSupportedStates();
	
	if (VSyncNumSupportedStates > 0)
	{
		VSyncCombo = UWindowComboControl(CreateControl(class'UWindowComboControl', CenterPos, ControlOffset, CenterWidth, 1));
		VSyncCombo.SetText(VSyncText);
		VSyncCombo.SetHelpText(VSyncHelp);
		VSyncCombo.SetFont(F_Normal);
		VSyncCombo.SetEditable(False);
		VSyncCombo.Clear();
		for (i = 0; i < 5; ++i)
		    if (VSyncSupportedStates[i] != "")
			    VSyncCombo.AddItem(VSyncSupportedStates[i]);
		VSyncCombo.SetSelectedIndex(VSyncCombo.FindItemIndex(VSyncSupportedStates[VSyncCurrentState]));
		ControlOffset += 25;
	}

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
	BrightnessSlider.SetRange(2, 10, 0.1);
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

	// Automatic GUI scaling
	AutoGUIScalingCheck = UWindowCheckbox(CreateControl(class'UWindowCheckbox', CenterPos, ControlOffset, CenterWidth, 1));
	AutoGUIScalingCheck.bChecked = false;
	AutoGUIScalingCheck.SetText(AutoGUIScalingText);
	AutoGUIScalingCheck.SetHelpText(AutoGUIScalingHelp);
	AutoGUIScalingCheck.SetFont(F_Normal);
	AutoGUIScalingCheck.Align = TA_Left;
	ControlOffset += 25;

	// GUI Scaling
	GUIScalingSlider = UWindowHSliderControl(CreateControl(class'UWindowHSliderControl', CenterPos, ControlOffset, CenterWidth, 1));
	GUIScalingSlider.bNoSlidingNotify = True;
	GUIScalingSlider.SetRange(100, 300, 25);
	GUIScalingSlider.SetText(GUIScalingText);
	GUIScalingSlider.SetHelpText(GUIScalingHelp);
	GUIScalingSlider.SetFont(F_Normal);
	ControlOffset += 25;

	// In-game font scaling
	InGameFontScalingCheck = UWindowCheckbox(CreateControl(class'UWindowCheckbox', CenterPos, ControlOffset, CenterWidth, 1));
	InGameFontScalingCheck.bChecked = bool(GetPlayerOwner().ConsoleCommand("get Botpack.FontInfo bEnableInGameScaling"));
	InGameFontScalingCheck.SetText(InGameFontScalingText);
	InGameFontScalingCheck.SetHelpText(InGameFontScalingHelp);
	InGameFontScalingCheck.SetFont(F_Normal);
	InGameFontScalingCheck.Align = TA_Left;
	ControlOffset += 25;

	// Scaling factor control
	InGameFontScalingSlider = UWindowHSliderControl(CreateControl(class'UWindowHSliderControl', CenterPos, ControlOffset, CenterWidth, 1));
	InGameFontScalingSlider.bNoSlidingNotify = true;
	InGameFontScalingSlider.SetRange(25, 300, 25);
	InGameFontScalingSlider.SetText(InGameFontScalingSliderText);
	InGameFontScalingSlider.SetHelpText(InGameFontScalingSliderHelp);
	InGameFontScalingSlider.SetFont(F_Normal);
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
	
	// Max Framerate
	MaxFramerateEdit = UWindowEditControl(CreateControl(class'UWindowEditControl', CenterPos, ControlOffset, CenterWidth, 1));
	MaxFramerateEdit.SetText(MaxFramerateText);
	MaxFramerateEdit.SetHelpText(MaxFramerateHelp);
	MaxFramerateEdit.SetFont(F_Normal);
	MaxFramerateEdit.SetNumericOnly(True);
	MaxFramerateEdit.SetMaxLength(4);
	MaxFramerateEdit.Align = TA_Left;
	MinRate = int(GetPlayerOwner().ConsoleCommand("get ini:Engine.Engine.ViewportManager FrameRateLimit"));
	MaxFramerateEdit.SetValue(string(MinRate));
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
	GUIScalingSlider.SetValue(Max(Min(Root.ConfiguredGUIScale*100, 300), 100));
	AutoGUIScalingCheck.bChecked = !Root.AutoGUIScale;
	InGameFontScalingSlider.SetValue(Min(Max(int(float(GetPlayerOwner().ConsoleCommand("get Botpack.FontInfo InGameScalingFactor"))*100), 25), 300));

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

	if (DriverButton != None)
	{
	    DriverButton.AutoWidth(C);
	    DriverButton.WinLeft = CenterPos + CenterWidth - 100;
	}

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

	AutoGUIScalingCheck.SetSize(CenterWidth-100+16, 1);
	AutoGUIScalingCheck.WinLeft = CenterPos;

	GUIScalingSlider.SetSize(CenterWidth, 1);
	GUIScalingSlider.SliderWidth = 100;
	GUIScalingSlider.WinLeft = CenterPos;

	InGameFontScalingCheck.SetSize(CenterWidth-100+16, 1);
	InGameFontScalingCheck.WinLeft = CenterPos;

	InGameFontScalingSlider.SetSize(CenterWidth, 1);
	InGameFontScalingSlider.SliderWidth = 100;
	InGameFontScalingSlider.WinLeft = CenterPos;

	MouseSlider.SetSize(CenterWidth, 1);
	MouseSlider.SliderWidth = 100;
	MouseSlider.WinLeft = CenterPos;

	GuiSkinCombo.SetSize(CenterWidth, 1);
	GuiSkinCombo.WinLeft = CenterPos;
	GuiSkinCombo.EditBoxWidth = 100;

	ShowDecalsCheck.SetSize(CenterWidth-100+16, 1);
	ShowDecalsCheck.WinLeft = CenterPos;

	if (VSyncCombo != None)
	{
	    VSyncCombo.SetSize(CenterWidth, 1);
	    VSyncCombo.WinLeft = CenterPos;
		VSyncCombo.EditBoxWidth = 100;
	}

	DynamicLightsCheck.SetSize(CenterWidth-100+16, 1);
	DynamicLightsCheck.WinLeft = CenterPos;

	MinFramerateEdit.SetSize(CenterWidth-100+30, 1);
	MinFramerateEdit.WinLeft = CenterPos;
	MinFramerateEdit.EditBoxWidth = 30;

	MaxFramerateEdit.SetSize(CenterWidth-100+40, 1);
	MaxFramerateEdit.WinLeft = CenterPos;
	MaxFramerateEdit.EditBoxWidth = 40;
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
		case AutoGUIScalingCheck:
		case GUIScalingSlider:
			ScaleChanged();
			break;
		case InGameFontScalingCheck:
		case InGameFontScalingSlider:			
			InGameFontScaleChanged();
			break;
		case MouseSlider:
			MouseChanged();
			break;
		case ShowDecalsCheck:
			DecalsChanged();
			break;
		case VSyncCombo:
			VSyncChanged();
			break;
		case DynamicLightsCheck:
			DynamicChanged();
			break;
		case MinFramerateEdit:
			MinFramerateChanged();
			break;
		case MaxFramerateEdit:
			MaxFramerateChanged();
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
	if (bInitialized)
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
	if (bInitialized)
	{
		Root.AutoGUIScale = !AutoGUIScalingCheck.bChecked;
		Root.SetScale(GUIScalingSlider.Value / 100);
		Root.SaveConfig();
	}
}

function InGameFontScaleChanged()
{
	if (bInitialized)
	{
		GetPlayerOwner().ConsoleCommand("set Botpack.FontInfo bEnableInGameScaling"@InGameFontScalingCheck.bChecked);
		GetPlayerOwner().ConsoleCommand("set Botpack.FontInfo InGameScalingFactor"@(InGameFontScalingSlider.Value / 100));
	}
}

function MouseChanged()
{
	if (bInitialized)
	{
		Root.Console.MouseScale = (MouseSlider.Value / 100);
		Root.Console.SaveConfig();
	}
}

function DecalsChanged()
{
	GetPlayerOwner().ConsoleCommand("set ini:Engine.Engine.ViewportManager Decals "$ShowDecalsCheck.bChecked);
}

function VSyncChanged()
{
    local int i;
	
    if (bInitialized && VSyncCombo != None)
	{
	    for (i = 0; i < 5; ++i)
		{
		    if (VSyncSupportedStates[i] != "" && VSyncSupportedStates[i] ~= VSyncCombo.GetValue())
			{
				SetVSyncState(i);
				MessageBox(ConfirmSettingsRestartTitle, ConfirmSettingsRestartText, MB_OK, MR_OK, MR_OK);
				break;
			}
		}
	}
}

function DynamicChanged()
{
	GetPlayerOwner().ConsoleCommand("set ini:Engine.Engine.ViewportManager NoDynamicLights "$!DynamicLightsCheck.bChecked);
}

function MinFramerateChanged()
{
	GetPlayerOwner().ConsoleCommand("set ini:Engine.Engine.ViewportManager MinDesiredFrameRate "$MinFramerateEdit.EditBox.Value);
}

function MaxFramerateChanged()
{
	local float NewValue;

	NewValue = float(MaxFramerateEdit.EditBox.Value);
	if ( NewValue < 10 )
		NewValue = 0;
	GetPlayerOwner().ConsoleCommand("set ini:Engine.Engine.ViewportManager FrameRateLimit "$NewValue);
}

function SaveConfigs()
{
	GetPlayerOwner().SaveConfig();
	Root.Console.SaveConfig();
	Super.SaveConfigs();
	if(GuiSkinCombo.GetValue2() != Root.LookAndFeelClass)
		Root.ChangeLookAndFeel(GuiSkinCombo.GetValue2());
}

function VSyncGetSupportedStates()
{
	local string Tmp, ClassString;
	local int i;

	// Renderers that support VSync:
	// UTGLR Renderers (D3D8Drv, D3D9Drv, OpenGLDrv) -> SwapInterval (int) [-1 = default (which usually means on), 0 = disabled, 1 = enabled]
	// D3DDrv -> UseVSync (bool)
	// XOpenGLDrv -> UseVSync (On/Off/Adaptive)
	// D3D10Drv -> VSync (bool)
	// D3D11Drv -> VSync (bool)
	// GlideDrv -> DisableVSync (bool)

	for (i = 0; i < 5; ++i)
	    VSyncSupportedStates[i] = "";
	VSyncNumSupportedStates = 0;

	// UTGLR
	Tmp = GetPlayerOwner().ConsoleCommand("get ini:Engine.Engine.GameRenderDevice SwapInterval");
	if (Caps(Left(Tmp, Len("Unrecognized"))) != "UNRECOGNIZED")
	{
		VSyncNumSupportedStates = 3;
		VSyncSupportedStates[VSYNC_OFF] = VSyncStates[VSYNC_OFF];
		VSyncSupportedStates[VSYNC_ON]  = VSyncStates[VSYNC_ON];
		VSyncSupportedStates[VSYNC_DRIVER_CONTROLLED] = VSyncStates[VSYNC_DRIVER_CONTROLLED];

		if (Tmp == "0")
		    VSyncCurrentState = VSYNC_OFF;
		else if (Tmp == "-1")
		    VSyncCurrentState = VSYNC_DRIVER_CONTROLLED;
		else
		    VSyncCurrentState = VSYNC_ON;
		return;
	}

	// XOpenGLDrv
	Tmp = GetPlayerOwner().ConsoleCommand("get ini:Engine.Engine.GameRenderDevice UseVSync");
	ClassString = GetPlayerOwner().ConsoleCommand("get ini:Engine.Engine.GameRenderDevice Class");
	if (Caps(Left(Tmp, Len("Unrecognized"))) != "UNRECOGNIZED" && InStr(Caps(ClassString), "XOPENGLDRV") != -1)
	{
		VSyncNumSupportedStates = 3;
		VSyncSupportedStates[VSYNC_OFF] = VSyncStates[VSYNC_OFF];
		VSyncSupportedStates[VSYNC_ON]  = VSyncStates[VSYNC_ON];
		VSyncSupportedStates[VSYNC_ADAPTIVE] = VSyncStates[VSYNC_ADAPTIVE];		

		if (Tmp ~= "On")
		    VSyncCurrentState = VSYNC_ON;
		else if (Tmp ~= "Adaptive")
		    VSyncCurrentState = VSYNC_ADAPTIVE;
		else
		    VSyncCurrentState = VSYNC_OFF;
		return;
	}

	// D3D10Drv/D3D11Drv/D3DDrv
    Tmp = GetPlayerOwner().ConsoleCommand("get ini:Engine.Engine.GameRenderDevice VSync");
	if (Caps(Left(Tmp, Len("Unrecognized"))) == "UNRECOGNIZED")
	    Tmp = GetPlayerOwner().ConsoleCommand("get ini:Engine.Engine.GameRenderDevice UseVSync");

	if (Caps(Left(Tmp, Len("Unrecognized"))) != "UNRECOGNIZED")
	{
		VSyncNumSupportedStates = 2;
		VSyncSupportedStates[VSYNC_OFF] = VSyncStates[VSYNC_OFF];
		VSyncSupportedStates[VSYNC_ON]  = VSyncStates[VSYNC_ON];

		if (Tmp ~= "On" || bool(Tmp) == true)
		    VSyncCurrentState = VSYNC_ON;
		else
		    VSyncCurrentState = VSYNC_OFF;
		return;
	}

    // GlideDrv
    Tmp = GetPlayerOwner().ConsoleCommand("get ini:Engine.Engine.GameRenderDevice DisableVSync");		
	if (Caps(Left(Tmp, Len("Unrecognized"))) != "UNRECOGNIZED")
	{
		VSyncNumSupportedStates = 2;
		VSyncSupportedStates[VSYNC_OFF] = VSyncStates[VSYNC_OFF];
		VSyncSupportedStates[VSYNC_ON]  = VSyncStates[VSYNC_ON];

		if (bool(Tmp) == true)
		    VSyncCurrentState = VSYNC_OFF;
        else
		    VSyncCurrentState = VSYNC_ON;
		return;
	}
}

function SetVSyncState(int NewState)
{
	local string Tmp;
	local string Tmp2;

	VSyncCurrentState = NewState;

	// UTGLR
	Tmp = GetPlayerOwner().ConsoleCommand("get ini:Engine.Engine.GameRenderDevice SwapInterval");
	if (Caps(Left(Tmp, Len("Unrecognized"))) != "UNRECOGNIZED")
	{
		if (VSyncCurrentState == VSYNC_OFF)
	        GetPlayerOwner().ConsoleCommand("set ini:Engine.Engine.GameRenderDevice SwapInterval 0");
		else if (VSyncCurrentState == VSYNC_ON)
	        GetPlayerOwner().ConsoleCommand("set ini:Engine.Engine.GameRenderDevice SwapInterval 1");
		else
	        GetPlayerOwner().ConsoleCommand("set ini:Engine.Engine.GameRenderDevice SwapInterval -1");		
		return;
	}
	
	Tmp = GetPlayerOwner().ConsoleCommand("get ini:Engine.Engine.GameRenderDevice UseVSync");
	if (Caps(Left(Tmp, Len("Unrecognized"))) != "UNRECOGNIZED")
	{
		// XOpenGL
		if (Tmp ~= "Off" || Tmp ~= "On" || Tmp ~= "Adaptive")
		{
			if (VSyncCurrentState == VSYNC_OFF)
			    Tmp2 = "Off";
			else if (VSyncCurrentState == VSYNC_ON)
			    Tmp2 = "On";
			else
			    Tmp2 = "Adaptive";
		}
		// D3DDrv
		else
		{
			if (VSyncCurrentState == VSYNC_OFF)
			    Tmp2 = string(false);
			else
			    Tmp2 = string(true);
		}
	    GetPlayerOwner().ConsoleCommand("set ini:Engine.Engine.GameRenderDevice UseVSync " $ Tmp2);
		return;
	}

	// D3D10Drv/D3D11Drv
	Tmp = GetPlayerOwner().ConsoleCommand("get ini:Engine.Engine.GameRenderDevice VSync");
	if (Caps(Left(Tmp, Len("Unrecognized"))) != "UNRECOGNIZED")
	{
		if (VSyncCurrentState == VSYNC_OFF)
		    Tmp2 = string(false);
		else
		    Tmp2 = string(true);
	
	    GetPlayerOwner().ConsoleCommand("set ini:Engine.Engine.GameRenderDevice VSync " $ Tmp2);
		return;
	}

	// GlideDrv
	Tmp = GetPlayerOwner().ConsoleCommand("get ini:Engine.Engine.GameRenderDevice DisableVSync");
	if (Caps(Left(Tmp, Len("Unrecognized"))) != "UNRECOGNIZED")
	{
		if (VSyncCurrentState == VSYNC_OFF)
		    Tmp2 = string(true);
		else
		    Tmp2 = string(false);

	    GetPlayerOwner().ConsoleCommand("set ini:Engine.Engine.GameRenderDevice DisableVSync " $ Tmp2);
		return;
	}
}

defaultproperties
{
      bInitialized=False
      DriverLabel=None
      DriverDesc=None
      DriverButton=None
      DriverText="Video Driver"
      DriverHelp="This is the current video driver.  Use the Change button to change video drivers."
      DriverButtonText="Change"
      DriverButtonHelp="Press this button to change your video driver."
      ResolutionCombo=None
      ResolutionText="Resolution"
      ResolutionHelp="Select a new screen resolution."
      OldSettings=""
      ColorDepthCombo=None
      ColorDepthText="Color Depth"
      ColorDepthHelp="Select a new color depth."
      BitsText="bit"
      TextureDetailCombo=None
      TextureDetailText="World Texture Detail"
      TextureDetailHelp="Change the texture detail of world geometry.  Use a lower texture detail to improve game performance."
      Details(0)="High"
      Details(1)="Medium"
      Details(2)="Low"
      OldTextureDetail=0
      SkinDetailCombo=None
      SkinDetailText="Skin Detail"
      SkinDetailHelp="Change the detail of player skins.  Use a lower skin detail to improve game performance."
      OldSkinDetail=0
      BrightnessSlider=None
      BrightnessText="Brightness"
      BrightnessHelp="Adjust display brightness."
      GammaSlider=None
      GammaText=""
      GammaHelp=""
      ScaleCombo=None
      ScaleText=""
      ScaleHelp=""
      ScaleSizes(0)=""
      ScaleSizes(1)=""
      MouseSlider=None
      MouseText="GUI Mouse Speed"
      MouseHelp="Adjust the speed of the mouse in the User Interface."
      GuiSkinCombo=None
      GuiSkinText="GUI Skin"
      GuiSkinHelp="Change the look of the User Interface windows to a custom skin."
      ControlOffset=20.000000
      ConfirmSettings=None
      ConfirmDriver=None
      ConfirmWorldTextureDetail=None
      ConfirmSkinTextureDetail=None
      ConfirmSettingsRestart=None
      ConfirmSettingsTitle="Confirm Video Settings Change"
      ConfirmSettingsText="Are you sure you wish to keep these new video settings?"
      ConfirmSettingsCancelTitle="Video Settings Change"
      ConfirmSettingsCancelText="Your previous video settings have been restored."
      ConfirmTextureDetailTitle="Confirm Texture Detail"
      ConfirmTextureDetailText="Increasing texture detail above its default value may degrade performance on some machines.\n\nAre you sure you want to make this change?"
      ConfirmDriverTitle="Change Video Driver"
      ConfirmDriverText="This option will restart Unreal now, and enable you to change your video driver.  Do you want to do this?"
      ConfirmSettingsRestartTitle="Video Settings Changed"
      ConfirmSettingsRestartText="Your updated video settings will take effect after restarting the game."
      VSyncCheck=None
      VSyncCombo=None
      VSyncSupportedStates(0)=""
      VSyncSupportedStates(1)=""
      VSyncSupportedStates(2)=""
      VSyncSupportedStates(3)=""
      VSyncSupportedStates(4)=""
      VSyncNumSupportedStates=0
      VSyncCurrentState=0
      VSyncStates(0)="Disabled"
      VSyncStates(1)="Enabled"
      VSyncStates(2)="Adaptive"
      VSyncStates(3)="Driver-Controlled"
      VSyncStates(4)="Not Supported"
      VSyncText="VSync"
      VSyncHelp="VSync synchronizes the frame rate of the game with the refresh rate of your monitor. This can reduce screen tearing."
      ShowDecalsCheck=None
      ShowDecalsText="Show Decals"
      ShowDecalsHelp="If checked, impact and gore decals will be used in game."
      MinFramerateEdit=None
      MinFramerateText="Min Desired Framerate"
      MinFramerateHelp="If your framerate falls below this value, Unreal Tournament will reduce special effects to increase your framerate."
      MaxFramerateEdit=None
      MaxFramerateText="Framerate Limit"
      MaxFramerateHelp="Limits the framerate to the specified value. A value of zero means no limit."
      DynamicLightsCheck=None
      DynamicLightsText="Use Dynamic Lighting"
      DynamicLightsHelp="If checked, dynamic lighting will be used in game."
      AutoGUIScalingCheck=None
      AutoGUIScalingText="Override GUI Scaling"
      AutoGUIScalingHelp="If checked, you can control the scale of the menu and in-game windows."
      GUIScalingSlider=None
      GUIScalingText="GUI Scaling Factor"
      GUIScalingHelp="Adjust the scale of the user interface."
      InGameFontScalingCheck=None
      InGameFontScalingText="Override Font Scaling"
      InGameFontScalingHelp="If checked, you can control the scale of your in-game fonts using the slider below."
      InGameFontScalingSlider=None
      InGameFontScalingSliderText="Font Scaling Factor"
      InGameFontScalingSliderHelp="Adjust the scale of the in-game fonts."
}
