class UMenuAudioClientWindow extends UMenuPageWindow;

// Driver
var UWindowLabelControl DriverLabel;
var UWindowLabelControl DriverDesc;
var UWindowSmallButton DriverButton;
var localized string DriverText;
var localized string DriverHelp;
var localized string DriverButtonText;
var localized string DriverButtonHelp;

// Output Selection.
var UWindowComboControl OutputDeviceCombo;
var localized string OutputDeviceText;
var localized string OutputDeviceHelp;
var localized string OutputDeviceDefault;

var UWindowMessageBox ConfirmDriver, ConfirmSettingsRestart;
var localized string ConfirmDriverTitle;
var localized string ConfirmDriverText;
var localized string ConfirmSettingsRestartTitle;
var localized string ConfirmSettingsRestartText;

// Sound Quality
var UWindowComboControl SoundQualityCombo;
var localized string SoundQualityText;
var localized string SoundQualityHelp;
var localized string Details[2];

// Audio frequency
var UWindowComboControl OutputRateCombo;
var localized string OutputRateText;
var localized string OutputRateHelp;

// Music Volume
var UWindowHSliderControl MusicVolumeSlider;
var localized string MusicVolumeText;
var localized string MusicVolumeHelp;

// Sound Volume
var UWindowHSliderControl SoundVolumeSlider;
var localized string SoundVolumeText;
var localized string SoundVolumeHelp;

// Speech Volume (ALAudio)
var UWindowHSliderControl SpeechVolumeSlider;
var localized string SpeechVolumeText;
var localized string SpeechVolumeHelp;

// Voice Messages
var UWindowCheckbox VoiceMessagesCheck;
var localized string VoiceMessagesText;
var localized string VoiceMessagesHelp;

// Message Beep
var UWindowCheckbox MessageBeepCheck;
var localized string MessageBeepText;
var localized string MessageBeepHelp;

var float ControlOffset;
var bool Initialized;

function Created()
{
	local bool bLowSoundQuality;
	local int MusicVolume, SoundVolume, SpeechVolume;
	local int ControlWidth, ControlLeft, ControlRight;
	local int CenterWidth, CenterPos;
	local string AudioDriverClassName, ClassLeft, ClassRight, AudioDriverDesc, Tmp;
	local int i, NumDevices;

	Super.Created();

	ControlWidth = WinWidth/2.5;
	ControlLeft = (WinWidth/2 - ControlWidth)/2;
	ControlRight = WinWidth/2 + ControlLeft;

	CenterWidth = (WinWidth/4)*3;
	CenterPos = (WinWidth - CenterWidth)/2;

	AudioDriverClassName = GetPlayerOwner().ConsoleCommand("get ini:Engine.Engine.AudioDevice Class");
	i = InStr(AudioDriverClassName, "'");
	// Get class name from class'...'
	if(i != -1)
	{
		AudioDriverClassName = Mid(AudioDriverClassName, i+1);
		i = InStr(AudioDriverClassName, "'");
		AudioDriverClassName = Left(AudioDriverClassName, i);
		ClassLeft = Left(AudioDriverClassName, InStr(AudioDriverClassName, "."));
		ClassRight = Mid(AudioDriverClassName, InStr(AudioDriverClassName, ".") + 1);
		AudioDriverDesc = Localize(ClassRight, "ClassCaption", ClassLeft);
	}
	else
		AudioDriverDesc = "AudioDriverClassName";

	// Driver
	DriverLabel = UWindowLabelControl(CreateControl(class'UWindowLabelControl', ControlLeft, ControlOffset, ControlWidth, 1));
	DriverLabel.SetText(DriverText);
	DriverLabel.SetHelpText(DriverHelp);
	DriverLabel.SetFont(F_Normal);

	DriverDesc = UWindowLabelControl(CreateControl(class'UWindowLabelControl', ControlRight, ControlOffset, ControlWidth, 1));
	DriverDesc.SetText(AudioDriverDesc);
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
	else
	{
	    ControlOffset += 8;
    }

	// Output Selection.
	Tmp = GetPlayerOwner().ConsoleCommand("audiooutput getnumdevices");
	if (Tmp != "" && Left(Tmp, 12) != "Unrecognized")
	{
	    NumDevices = int(Tmp);
		
		OutputDeviceCombo = UWindowComboControl(CreateControl(class'UWindowComboControl', CenterPos, ControlOffset, CenterWidth, 1));
		OutputDeviceCombo.SetText(OutputDeviceText);
		OutputDeviceCombo.SetHelpText(OutputDeviceHelp);
		OutputDeviceCombo.SetFont(F_Normal);
		OutputDeviceCombo.SetEditable(False);
		OutputDeviceCombo.AddItem(OutputDeviceDefault);

		for (i = 0; i < NumDevices; ++i)
		{
            Tmp = GetPlayerOwner().ConsoleCommand("audiooutput getdevicename " $ i);
			if (Tmp != "" && Tmp != "Unknown Device")
			    OutputDeviceCombo.AddItem(Tmp);
        }

		Tmp = GetPlayerOwner().ConsoleCommand("audiooutput getdevice");
		if (Tmp != "")
		{
		    i = int(Tmp);
			OutputDeviceCombo.SetSelectedIndex(i + 1);
		}
		ControlOffset += 25;
    }

	// Voice Messages
	VoiceMessagesCheck = UWindowCheckbox(CreateControl(class'UWindowCheckbox', CenterPos, ControlOffset, CenterWidth, 1));
	VoiceMessagesCheck.bChecked = !GetPlayerOwner().bNoVoices;
	VoiceMessagesCheck.SetText(VoiceMessagesText);
	VoiceMessagesCheck.SetHelpText(VoiceMessagesHelp);
	VoiceMessagesCheck.SetFont(F_Normal);
	VoiceMessagesCheck.Align = TA_Left;
	ControlOffset += 25;

	// Message Beep
	MessageBeepCheck = UWindowCheckbox(CreateControl(class'UWindowCheckbox', CenterPos, ControlOffset, CenterWidth, 1));
	MessageBeepCheck.bChecked = GetPlayerOwner().bMessageBeep;
	MessageBeepCheck.SetText(MessageBeepText);
	MessageBeepCheck.SetHelpText(MessageBeepHelp);
	MessageBeepCheck.SetFont(F_Normal);
	MessageBeepCheck.Align = TA_Left;
	ControlOffset += 25;

	ExtraMessageOptions();

	// Sound Quality
	if ( Left(GetPlayerOwner().ConsoleCommand("get ini:Engine.Engine.AudioDevice LowSoundQuality"),12) != "Unrecognized" )
	{
		SoundQualityCombo = UWindowComboControl(CreateControl(class'UWindowComboControl', CenterPos, ControlOffset, CenterWidth, 1));
		SoundQualityCombo.SetText(SoundQualityText);
		SoundQualityCombo.SetHelpText(SoundQualityHelp);
		SoundQualityCombo.SetFont(F_Normal);
		SoundQualityCombo.SetEditable(False);
		SoundQualityCombo.AddItem(Details[0]);
		SoundQualityCombo.AddItem(Details[1]);
		bLowSoundQuality = bool(GetPlayerOwner().ConsoleCommand("get ini:Engine.Engine.AudioDevice LowSoundQuality"));
		if (bLowSoundQuality)
			SoundQualityCombo.SetSelectedIndex(0);
		else
			SoundQualityCombo.SetSelectedIndex(1);
		ControlOffset += 25;
	}
	
	// Output Rate
	if ( Left(GetPlayerOwner().ConsoleCommand("get ini:Engine.Engine.AudioDevice OutputRate"),12) != "Unrecognized" )
	{
		OutputRateCombo = UWindowComboControl(CreateControl(class'UWindowComboControl', CenterPos, ControlOffset, CenterWidth, 1));
		OutputRateCombo.SetText(OutputRateText);
		OutputRateCombo.SetHelpText(OutputRateHelp);
		OutputRateCombo.SetFont(F_Normal);
		OutputRateCombo.SetEditable(False);
		OutputRateCombo.AddItem("8000Hz");
		OutputRateCombo.AddItem("11025Hz");
		OutputRateCombo.AddItem("16000Hz");
		OutputRateCombo.AddItem("22050Hz");
		OutputRateCombo.AddItem("32000Hz");
		OutputRateCombo.AddItem("44100Hz");
		OutputRateCombo.AddItem("48000Hz");
		OutputRateCombo.AddItem("96000Hz");
		OutputRateCombo.AddItem("192000Hz");
		ReadOutputRate();
		ControlOffset += 25;
	}

	// Music Volume
	MusicVolumeSlider = UWindowHSliderControl(CreateControl(class'UWindowHSliderControl', CenterPos, ControlOffset, CenterWidth, 1));
	MusicVolumeSlider.SetRange(0, 255, 16);
	MusicVolume = int(GetPlayerOwner().ConsoleCommand("get ini:Engine.Engine.AudioDevice MusicVolume"));
	MusicVolumeSlider.SetValue(MusicVolume);
	MusicVolumeSlider.SetText(MusicVolumeText);
	MusicVolumeSlider.SetHelpText(MusicVolumeHelp);
	MusicVolumeSlider.SetFont(F_Normal);
	ControlOffset += 25;

	// Sound Volume
	SoundVolumeSlider = UWindowHSliderControl(CreateControl(class'UWindowHSliderControl', CenterPos, ControlOffset, CenterWidth, 1));
	SoundVolumeSlider.SetRange(0, 255, 16);
	SoundVolume = int(GetPlayerOwner().ConsoleCommand("get ini:Engine.Engine.AudioDevice SoundVolume"));
	SoundVolumeSlider.SetValue(SoundVolume);
	SoundVolumeSlider.SetText(SoundVolumeText);
	SoundVolumeSlider.SetHelpText(SoundVolumeHelp);
	SoundVolumeSlider.SetFont(F_Normal);
	ControlOffset += 25;

	// Speech Volume (only available when the device supports it)
	if ( Left(GetPlayerOwner().ConsoleCommand("get ini:Engine.Engine.AudioDevice SpeechVolume"),12) != "Unrecognized" )
	{
		SpeechVolumeSlider = UWindowHSliderControl(CreateControl(class'UWindowHSliderControl', CenterPos, ControlOffset, CenterWidth, 1));
		SpeechVolumeSlider.SetRange(0, 255, 16);
		SpeechVolume = int(GetPlayerOwner().ConsoleCommand("get ini:Engine.Engine.AudioDevice SpeechVolume"));
		SpeechVolumeSlider.SetValue(SpeechVolume);
		SpeechVolumeSlider.SetText(SpeechVolumeText);
		SpeechVolumeSlider.SetHelpText(SpeechVolumeHelp);
		SpeechVolumeSlider.SetFont(F_Normal);
		ControlOffset += 25;
	}

    Initialized = true;
}

function AfterCreate()
{
	Super.AfterCreate();

	DesiredWidth = 220;
	DesiredHeight = ControlOffset;
}

function ExtraMessageOptions()
{
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

	DriverLabel.SetSize(CenterWidth-90, 1);
	DriverLabel.WinLeft = CenterPos;

	DriverDesc.SetSize(200, 1);
	DriverDesc.WinLeft = CenterPos + CenterWidth - 90;

	if (DriverButton != None)
	{
	    DriverButton.AutoWidth(C);
	    DriverButton.WinLeft = CenterPos + CenterWidth - 90;
	}

	if ( OutputDeviceCombo != None )
	{
		OutputDeviceCombo.SetSize(CenterWidth, 1);
		OutputDeviceCombo.WinLeft = CenterPos;
		OutputDeviceCombo.EditBoxWidth = 90;
	}

	VoiceMessagesCheck.SetSize(CenterWidth-90+16, 1);
	VoiceMessagesCheck.WinLeft = CenterPos;

	MessageBeepCheck.SetSize(CenterWidth-90+16, 1);
	MessageBeepCheck.WinLeft = CenterPos;

	if ( SoundQualityCombo != None )
	{
		SoundQualityCombo.SetSize(CenterWidth, 1);
		SoundQualityCombo.WinLeft = CenterPos;
		SoundQualityCombo.EditBoxWidth = 90;
	}

	if ( OutputRateCombo != None )
	{
		OutputRateCombo.SetSize(CenterWidth, 1);
		OutputRateCombo.WinLeft = CenterPos;
		OutputRateCombo.EditBoxWidth = 90;
	}

	MusicVolumeSlider.SetSize(CenterWidth, 1);
	MusicVolumeSlider.SliderWidth = 90;
	MusicVolumeSlider.WinLeft = CenterPos;

	SoundVolumeSlider.SetSize(CenterWidth, 1);
	SoundVolumeSlider.SliderWidth = 90;
	SoundVolumeSlider.WinLeft = CenterPos;
	
	if ( SpeechVolumeSlider != None )
	{
		SpeechVolumeSlider.SetSize(CenterWidth, 1);
		SpeechVolumeSlider.SliderWidth = 90;
		SpeechVolumeSlider.WinLeft = CenterPos;
	}
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
		case VoiceMessagesCheck:
			VoiceMessagesChecked();
			break;
		case MessageBeepCheck:
			MessageBeepChecked();
			break;
		case SoundQualityCombo:
			SoundQualityChanged();
			break;
		case OutputRateCombo:
			OutputRateChanged();
			break;
		case MusicVolumeSlider:
			MusicVolumeChanged();
			break;
		case SoundVolumeSlider:
			SoundVolumeChanged();
			break;
		case SpeechVolumeSlider:
			SpeechVolumeChanged();
			break;
		case OutputDeviceCombo:
		    OutputDeviceChanged();
			break;
		}
	}
}

/*
 * Message Crackers
*/

function DriverChange()
{
	ConfirmDriver = MessageBox(ConfirmDriverTitle, ConfirmDriverText, MB_YesNo, MR_No);
}

function SoundQualityChanged()
{
	local bool bLowSoundQuality;
	if ( SoundQualityCombo != None )
	{
		bLowSoundQuality = bool(SoundQualityCombo.GetSelectedIndex());
		bLowSoundQuality = !bLowSoundQuality;
		GetPlayerOwner().ConsoleCommand("set ini:Engine.Engine.AudioDevice LowSoundQuality "$bLowSoundQuality);
	}
}

function OutputRateChanged()
{
	if ( OutputRateCombo != None )
	{
		GetPlayerOwner().ConsoleCommand("set ini:Engine.Engine.AudioDevice OutputRate "$OutputRateCombo.GetValue() );
		ReadOutputRate(); //Fix if Audio Subsystem doesn't support this value
	}
}

singular function ReadOutputRate()
{
	local string S;
	S = GetPlayerOwner().ConsoleCommand("get ini:Engine.Engine.AudioDevice OutputRate");
	OutputRateCombo.SetSelectedIndex( OutputRateCombo.FindItemIndex(S, true) );
}

function VoiceMessagesChecked()
{
	GetPlayerOwner().bNoVoices = !VoiceMessagesCheck.bChecked;
}

function MessageBeepChecked()
{
	GetPlayerOwner().bMessageBeep = MessageBeepCheck.bChecked;
}

function MusicVolumeChanged()
{
	GetPlayerOwner().ConsoleCommand("set ini:Engine.Engine.AudioDevice MusicVolume "$MusicVolumeSlider.Value);
}

function SoundVolumeChanged()
{
	GetPlayerOwner().ConsoleCommand("set ini:Engine.Engine.AudioDevice SoundVolume "$SoundVolumeSlider.Value);
}

function SpeechVolumeChanged()
{
	if ( SpeechVolumeSlider != None ) //This field is optional
		GetPlayerOwner().ConsoleCommand("set ini:Engine.Engine.AudioDevice SpeechVolume "$SpeechVolumeSlider.Value);
}

function OutputDeviceChanged()
{
    local string Tmp;
	
    if ( Initialized && OutputDeviceCombo != None )
	{
        Tmp = GetPlayerOwner().ConsoleCommand("audiooutput setdevice " $ (OutputDeviceCombo.GetSelectedIndex() - 1));

		if (Tmp ~= "Restart")
            MessageBox(ConfirmSettingsRestartTitle, ConfirmSettingsRestartText, MB_OK, MR_OK, MR_OK);
    }
}

function MessageBoxDone(UWindowMessageBox W, MessageBoxResult Result)
{
	if (W == ConfirmDriver)
	{
		ConfirmDriver = None;
		if(Result == MR_Yes)
		{
			GetParent(class'UWindowFramedWindow').Close();
			Root.Console.CloseUWindow();
			GetPlayerOwner().ConsoleCommand("RELAUNCH -changesound");
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
      DriverLabel=None
      DriverDesc=None
      DriverButton=None
      DriverText="Audio Driver"
      DriverHelp="This is the current audio driver.  Use the Change button to change audio drivers."
      DriverButtonText="Change"
      DriverButtonHelp="Press this button to change your audio driver."
      OutputDeviceCombo=None
      OutputDeviceText="Output Device"
      OutputDeviceHelp="This is your current audio output device."
      OutputDeviceDefault="System Default"
      ConfirmDriver=None
      ConfirmSettingsRestart=None
      ConfirmDriverTitle="Change Audio Driver"
      ConfirmDriverText="This option will restart Unreal now, and enable you to change your audio driver.  Do you want to do this?"
      ConfirmSettingsRestartTitle="Audio Settings Changed"
      ConfirmSettingsRestartText="Your updated audio settings will take effect after restarting the game."
      SoundQualityCombo=None
      SoundQualityText="Sound Quality"
      SoundQualityHelp="Use low sound quality to improve game performance on machines with less than 32 Mb memory."
      Details(0)="Low"
      Details(1)="High"
      OutputRateCombo=None
      OutputRateText="Output Rate"
      OutputRateHelp="Changes the audio sampling rate, affecting sound quality."
      MusicVolumeSlider=None
      MusicVolumeText="Music Volume"
      MusicVolumeHelp="Increase or decrease music volume."
      SoundVolumeSlider=None
      SoundVolumeText="Sound Volume"
      SoundVolumeHelp="Increase or decrease sound effects volume."
      SpeechVolumeSlider=None
      SpeechVolumeText="Speech Volume"
      SpeechVolumeHelp="Increase or decrease speech volume."
      VoiceMessagesCheck=None
      VoiceMessagesText="Voice Messages"
      VoiceMessagesHelp="If checked, you will hear voice messages and commands from other players."
      MessageBeepCheck=None
      MessageBeepText="Message Beep"
      MessageBeepHelp="If checked, you will hear a beep sound when chat message received."
      ControlOffset=20.000000
      Initialized=False
}
