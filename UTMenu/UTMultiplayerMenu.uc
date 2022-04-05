class UTMultiplayerMenu expands UMenuMultiplayerMenu;

var config string OnlineServices[10];

var UWindowPulldownMenuItem OnlineServiceItems[10];
var string OnlineServiceCmdType[10];
var string OnlineServiceCmdAction[10];
var string OnlineServiceHelp[10];
var int OnlineServiceCount;

/* Examples:
 * [UTMenu.UTMultiplayerMenu]
 * OnlineServices[0]=Play online for FREE with mplayer.com!,Select this option to play online at mplayer!,CMD,mplayer
 * OnlineServices[1]=Go to the UT messageboard,Select this option to go to the UT messageboard,CMD,start http://www.unrealtournament.net/forum
 */


function string ParseOption(string Input, int Pos)
{
	local int i;

	while(True)
	{
		if(Pos == 0)
		{
			i = InStr(Input, ",");
			if(i != -1)
				Input = Left(Input, i);
			return Input;
		}

		i = InStr(Input, ",");
		if(i == -1)
			return "";

		Input = Mid(Input, i+1);
		Pos--;
	}
}

function Created()
{
	local int i;
	local string S;

	Super.Created();
	
	if(OnlineServices[0] != "")
		AddMenuItem("-", None);

	for(i=0;i<10;i++)
	{
		if(OnlineServices[i] == "")
			break;

		// stijn: skip over deprecated online services
		if(OnlineServices[i] == "LOCALIZE,MPlayer" ||
		   OnlineServices[i] == "LOCALIZE,Heat" ||
		   OnlineServices[i] == "LOCALIZE,WON")
		   continue;
	
		if(ParseOption(OnlineServices[i], 0) == "LOCALIZE")
			S = Localize("OnlineServices", ParseOption(OnlineServices[i], 1), "UTMenu");
		else
			S = OnlineServices[i];

		OnlineServiceItems[i] = AddMenuItem(ParseOption(S, 0), None);
		OnlineServiceHelp[i] = ParseOption(S, 1);
		OnlineServiceCmdType[i] = ParseOption(S, 2);
		OnlineServiceCmdAction[i] = ParseOption(S, 3);
	}

	OnlineServiceCount = i;
}

function ExecuteItem(UWindowPulldownMenuItem I) 
{
	local int j;
	local string S;

	for(j=0;j<OnlineServiceCount;j++)
	{
		if(I == OnlineServiceItems[j])
		{
			switch(OnlineServiceCmdType[j])
			{
			case "URL":
				S = GetPlayerOwner().ConsoleCommand("start "$OnlineServiceCmdAction[j]);
				break;
			case "CMD":
				S = GetPlayerOwner().ConsoleCommand(OnlineServiceCmdAction[j]);
				if(S != "")
					MessageBox(OnlineServiceItems[j].Caption, S, MB_OK, MR_OK);
				break;
			case "CMDQUIT":
				S = GetPlayerOwner().ConsoleCommand(OnlineServiceCmdAction[j]);
				if(S != "")
					MessageBox(OnlineServiceItems[j].Caption, S, MB_OK, MR_OK);
				else
					GetPlayerOwner().ConsoleCommand("exit");
				break;
			}
		}
	}

	Super.ExecuteItem(I);
}

function Select(UWindowPulldownMenuItem I)
{
	local int j;

	for(j=0;j<OnlineServiceCount;j++)
	{
		if(I == OnlineServiceItems[j])
		{
			UMenuMenuBar(GetMenuBar()).SetHelp(OnlineServiceHelp[j]);
		}
	}

	Super.Select(I);
}

defaultproperties
{
      OnlineServices(0)=""
      OnlineServices(1)=""
      OnlineServices(2)=""
      OnlineServices(3)=""
      OnlineServices(4)=""
      OnlineServices(5)=""
      OnlineServices(6)=""
      OnlineServices(7)=""
      OnlineServices(8)=""
      OnlineServices(9)=""
      OnlineServiceItems(0)=None
      OnlineServiceItems(1)=None
      OnlineServiceItems(2)=None
      OnlineServiceItems(3)=None
      OnlineServiceItems(4)=None
      OnlineServiceItems(5)=None
      OnlineServiceItems(6)=None
      OnlineServiceItems(7)=None
      OnlineServiceItems(8)=None
      OnlineServiceItems(9)=None
      OnlineServiceCmdType(0)=""
      OnlineServiceCmdType(1)=""
      OnlineServiceCmdType(2)=""
      OnlineServiceCmdType(3)=""
      OnlineServiceCmdType(4)=""
      OnlineServiceCmdType(5)=""
      OnlineServiceCmdType(6)=""
      OnlineServiceCmdType(7)=""
      OnlineServiceCmdType(8)=""
      OnlineServiceCmdType(9)=""
      OnlineServiceCmdAction(0)=""
      OnlineServiceCmdAction(1)=""
      OnlineServiceCmdAction(2)=""
      OnlineServiceCmdAction(3)=""
      OnlineServiceCmdAction(4)=""
      OnlineServiceCmdAction(5)=""
      OnlineServiceCmdAction(6)=""
      OnlineServiceCmdAction(7)=""
      OnlineServiceCmdAction(8)=""
      OnlineServiceCmdAction(9)=""
      OnlineServiceHelp(0)=""
      OnlineServiceHelp(1)=""
      OnlineServiceHelp(2)=""
      OnlineServiceHelp(3)=""
      OnlineServiceHelp(4)=""
      OnlineServiceHelp(5)=""
      OnlineServiceHelp(6)=""
      OnlineServiceHelp(7)=""
      OnlineServiceHelp(8)=""
      OnlineServiceHelp(9)=""
      OnlineServiceCount=0
      UBrowserClassName="UTBrowser.UTBrowserMainWindow"
      StartGameClassName="UTMenu.UTStartGameWindow"
}
