// stijn: We show this additional tab on Linux and macOS clients to show where the ini files are
class UMenuAdvancedClientWindow extends UMenuPageWindow;

var UWindowDynamicTextArea Description;
var UWindowControlFrame Frame;

var localized string HelpText[10];

function Created()
{
    local int i;
	
    Description = UWindowDynamicTextArea(CreateControl(class'UWindowDynamicTextArea', 0, 0, WinWidth , WinHeight));
    Description.SetTextColor(LookAndFeel.EditBoxTextColor);
    Description.bTopCentric = True;
    Frame = UWindowControlFrame(CreateWindow(class'UWindowControlFrame', 0, 0, WinWidth , WinHeight));
    Frame.SetFrame(Description);

    for (i = 0; i < 10; ++i)
	{
	    if (HelpText[i] != "")
		    Description.AddText(HelpText[i]);
	}

	Description.AddText(GetPlayerOwner().ConsoleCommand("GETSYSTEMINI"));
	Description.AddText(GetPlayerOwner().ConsoleCommand("GETUSERINI"));	
}

function BeforePaint(Canvas C, float X, float Y)
{
    Frame.SetSize(WinWidth - 10, WinHeight - 10);
    Frame.WinTop = 5;
    Frame.WinLeft = 5;
}

defaultproperties
{
      Description=None
      Frame=None
      HelpText(0)="The advanced preferences window is not available on your platform."
      HelpText(1)=" "
      HelpText(2)="If you want to modify advanced game settings, then please close the game and edit the following ini files:"
      HelpText(3)=" "
      HelpText(4)=""
      HelpText(5)=""
      HelpText(6)=""
      HelpText(7)=""
      HelpText(8)=""
      HelpText(9)=""
}
