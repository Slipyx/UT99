class UTStartGameCW expands UTMenuBotmatchCW;

// Window
var UWindowSmallButton DedicatedButton;
var localized string DedicatedText;
var localized string DedicatedHelp;
var localized string ServerText;

var UWindowMessageBox ConfirmStart;
var localized string ConfirmTitle;
var localized string ConfirmText;

var UWindowPageControlPage ServerTab;

function Created()
{
	Super.Created();

	// Dedicated
	DedicatedButton = UWindowSmallButton(CreateControl(class'UWindowSmallButton', WinWidth-156, WinHeight-24, 48, 16));
	DedicatedButton.SetText(DedicatedText);
	DedicatedButton.SetHelpText(DedicatedHelp);

	ServerTab = Pages.AddPage(ServerText, class'UTServerSetupSC');
}

function Resized()
{
	Super.Resized();
	DedicatedButton.WinLeft = WinWidth-152;
	DedicatedButton.WinTop = WinHeight-20;
}

function Notify(UWindowDialogControl C, byte E)
{
	switch(E)
	{
	case DE_Click:
		switch (C)
		{
			case StartButton:
				StartPressed();
				return;
			case DedicatedButton:
				DedicatedPressed();
				return;
			default:
				Super.Notify(C, E);
				return;
		}
	default:
		Super.Notify(C, E);
		return;
	}
}

function MessageBoxDone(UWindowMessageBox W, MessageBoxResult Result)
{
	if(W == ConfirmStart)
	{
		switch(Result)
		{
		case MR_Yes:
			Root.CreateWindow(class<UWindowWindow>(DynamicLoadObject("UTMenu.ngWorldSecretWindow", class'Class')), 100, 100, 200, 200, Root, True);
			break;
		case MR_No:
			GetPlayerOwner().ngSecretSet = True;
			GetPlayerOwner().SaveConfig();
			StartPressed();
			break;
		}				
	}
}

function DedicatedPressed()
{
	local string URL;
	local GameInfo NewGame;
	local string LanPlay;

	if(UTServerSetupPage(UTServerSetupSC(ServerTab.Page).ClientArea).bLanPlay)
		LanPlay = " -lanplay";

	URL = Map $ "?Game="$GameType$"?Mutator="$MutatorList;
	URL = URL $ "?Listen";

	ParentWindow.Close();
	Root.Console.CloseUWindow();
	GetPlayerOwner().ConsoleCommand("RELAUNCH "$URL$LanPlay$" -server log="$GameClass.Default.ServerLogName);
}

// Override botmatch's start behavior
function StartPressed()
{
	local string URL, Checksum;
	local GameInfo NewGame;

	GameClass.Static.ResetGame();

	URL = Map $ "?Game="$GameType$"?Mutator="$MutatorList;
	URL = URL $ "?Listen";
	class'StatLog'.Static.GetPlayerChecksum(GetPlayerOwner(), Checksum);
	URL = URL $ "?Checksum="$Checksum;

	ParentWindow.Close();
	Root.Console.CloseUWindow();
	GetPlayerOwner().ClientTravel(URL, TRAVEL_Absolute, false);
}

defaultproperties
{
      DedicatedButton=None
      DedicatedText="Dedicated"
      DedicatedHelp="Press to launch a dedicated server."
      ServerText="Server"
      ConfirmStart=None
      ConfirmTitle=""
      ConfirmText=""
      ServerTab=None
      bNetworkGame=True
}
