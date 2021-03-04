//=============================================================================
// UBrowserMainClientWindow - The main client area
//=============================================================================
class UBrowserMainClientWindow extends UWindowClientWindow;

var globalconfig string		LANTabName;
var globalconfig name ServerListNames[50];
var globalconfig bool bKeepMasterServer;

var UWindowPageControl		PageControl;
var UWindowPageControlPage	Favorites, IRC, MOTD;
var localized string		FavoritesName, IRCName, MOTDName;
var string					ServerListWindowClass;
var string					FavoriteServersClass;
var string					UpdateServerClass;
var UWindowPageControlPage	LANPage;
var UWindowTabControlItem	PageBeforeLAN;
var UBrowserServerListWindow FactoryWindows[50];
var UBrowserInfoWindow		InfoWindow;

function Created() 
{
	local int i, f, j;
	local UWindowPageControlPage P;
	local UBrowserServerListWindow W;
	local class<UBrowserServerListWindow> C;
	local class<UBrowserFavoriteServers> FC;
	local class<UBrowserUpdateServerWindow> MC;
	local string NextWindowClass, NextWindowDesc;

	Super.Created();

	InfoWindow = UBrowserInfoWindow(Root.CreateWindow(class'UBrowserInfoWindow', 10, 40, 310, 170));
	InfoWindow.HideWindow();

	PageControl = UWindowPageControl(CreateWindow(class'UWindowPageControl', 0, 0, WinWidth, WinHeight));
	PageControl.SetMultiLine(True);

	// Add MOTD
	MC = class<UBrowserUpdateServerWindow>(DynamicLoadObject(UpdateServerClass, class'Class'));
	MOTD = PageControl.AddPage(MOTDName, MC);

	IRC = PageControl.AddPage(IRCName, class'UBrowserIRCWindow');

	// Add favorites
	FC = class<UBrowserFavoriteServers>(DynamicLoadObject(FavoriteServersClass, class'Class'));
	Favorites = PageControl.AddPage(FavoritesName, FC);

	C = class<UBrowserServerListWindow>(DynamicLoadObject(ServerListWindowClass, class'Class'));

	for(i=0; i<50; i++)
	{
		if(ServerListNames[i] == '')
			break;

		P = PageControl.AddPage("", C, ServerListNames[i]);
		if(string(ServerListNames[i]) ~= LANTabName)
			LANPage = P;

		W = UBrowserServerListWindow(P.Page);
		if(W.bHidden)
			PageControl.DeletePage(P);

		if(W.ServerListTitle != "")
			P.SetCaption(W.ServerListTitle);
		else
			P.SetCaption(Localize("ServerListTitles", string(ServerListNames[i]), "UBrowser"));

		FactoryWindows[i] = W;
	}

	// Load custom UBrowser pages
	if(i < 50)
	{
		j = 0;
		GetPlayerOwner().GetNextIntDesc(ServerListWindowClass, j, NextWindowClass, NextWindowDesc); 
		while( NextWindowClass != "" && i < 50 )
		{
			C = class<UBrowserServerListWindow>(DynamicLoadObject(NextWindowClass, class'Class'));
			if( C != None )
			{
				ServerListNames[i] = '';
				P = PageControl.AddPage("", C);
				W = UBrowserServerListWindow(P.Page);
				if(W.bHidden)
					PageControl.DeletePage(P);
				if(W.ServerListTitle != "")
					P.SetCaption(W.ServerListTitle);
				else
					P.SetCaption(NextWindowDesc);
				FactoryWindows[i] = W;	
				i++;
			}
			j++;
			GetPlayerOwner().GetNextIntDesc(ServerListWindowClass, j, NextWindowClass, NextWindowDesc); 
		}
	}
}

function SelectLAN()
{
	if(LANPage != None)
	{
		PageBeforeLAN = PageControl.SelectedTab;
		PageControl.GotoTab(LANPage, True);
	}
}

function SelectInternet()
{
	if(PageBeforeLAN != None && PageControl.SelectedTab == LANPage)
		PageControl.GotoTab(PageBeforeLAN, True);
	PageBeforeLAN = None;
}

function NewMasterServer(string M)
{
	local int i, j;
	local string NewServers[10];
	local string T;
	local bool bHadNewServer;

	i = 0;
	while(M != "")
	{
		j = InStr(M, Chr(13));
		if(j != -1)
		{
			T = Left(M, j);
			M = Mid(M, j+1);
		}
		else
		{
			T = M;
			M = "";
		}
		if(T != "")
			NewServers[i++] = T;
	}	

	if(!bKeepMasterServer)
	{
		for(i=0; i<20; i++)
		{
			if(ServerListNames[i] == 'UBrowserAll')
			{
				bHadNewServer = False;
				for(j=0; j<9; j++)
				{
					if(FactoryWindows[i].ListFactories[j] != NewServers[j])
					{
						Log("Received new master server ["$j$"] from UpdateServer: "$NewServers[j]);
						FactoryWindows[i].ListFactories[j] = NewServers[j];
						FactoryWindows[i].ListFactories[j+1] = "";
						bHadNewServer = True;
					}
				}
				if(bHadNewServer)
				{
					if(FactoryWindows[i].bHadInitialRefresh)
						FactoryWindows[i].Refresh(False, True);
					FactoryWindows[i].SaveConfig();
				}
			}
		}
	}
}

function NewIRCServer(string S)
{
	UBrowserIRCWindow(IRC.Page).SystemPage.SetupClient.NewIRCServer(S);
}

function Paint(Canvas C, float X, float Y)
{
	DrawStretchedTexture(C, 0, 0, WinWidth, WinHeight, Texture'BlackTexture');
}

function Resized()
{
	Super.Resized();
	PageControl.SetSize(WinWidth, WinHeight);
}

function SaveConfigs()
{
	SaveConfig();
}

defaultproperties
{
      LANTabName="UBrowserLAN"
      ServerListNames(0)="UBrowserUT"
      ServerListNames(1)="UBrowserLAN"
      ServerListNames(2)="UBrowserPopulated"
      ServerListNames(3)="UBrowserDeathmatch"
      ServerListNames(4)="UBrowserTeamGames"
      ServerListNames(5)="UBrowserCTF"
      ServerListNames(6)="UBrowserDOM"
      ServerListNames(7)="UBrowserAS"
      ServerListNames(8)="UBrowserLMS"
      ServerListNames(9)="UBrowserAll"
      ServerListNames(10)="None"
      ServerListNames(11)="None"
      ServerListNames(12)="None"
      ServerListNames(13)="None"
      ServerListNames(14)="None"
      ServerListNames(15)="None"
      ServerListNames(16)="None"
      ServerListNames(17)="None"
      ServerListNames(18)="None"
      ServerListNames(19)="None"
      ServerListNames(20)="None"
      ServerListNames(21)="None"
      ServerListNames(22)="None"
      ServerListNames(23)="None"
      ServerListNames(24)="None"
      ServerListNames(25)="None"
      ServerListNames(26)="None"
      ServerListNames(27)="None"
      ServerListNames(28)="None"
      ServerListNames(29)="None"
      ServerListNames(30)="None"
      ServerListNames(31)="None"
      ServerListNames(32)="None"
      ServerListNames(33)="None"
      ServerListNames(34)="None"
      ServerListNames(35)="None"
      ServerListNames(36)="None"
      ServerListNames(37)="None"
      ServerListNames(38)="None"
      ServerListNames(39)="None"
      ServerListNames(40)="None"
      ServerListNames(41)="None"
      ServerListNames(42)="None"
      ServerListNames(43)="None"
      ServerListNames(44)="None"
      ServerListNames(45)="None"
      ServerListNames(46)="None"
      ServerListNames(47)="None"
      ServerListNames(48)="None"
      ServerListNames(49)="None"
      bKeepMasterServer=True
      PageControl=None
      Favorites=None
      IRC=None
      MOTD=None
      FavoritesName="Favorites"
      IRCName="Chat"
      MOTDName="News"
      ServerListWindowClass="UBrowser.UBrowserServerListWindow"
      FavoriteServersClass="UBrowser.UBrowserFavoriteServers"
      UpdateServerClass="UBrowser.UBrowserUpdateServerWindow"
      LANPage=None
      PageBeforeLAN=None
      FactoryWindows(0)=None
      FactoryWindows(1)=None
      FactoryWindows(2)=None
      FactoryWindows(3)=None
      FactoryWindows(4)=None
      FactoryWindows(5)=None
      FactoryWindows(6)=None
      FactoryWindows(7)=None
      FactoryWindows(8)=None
      FactoryWindows(9)=None
      FactoryWindows(10)=None
      FactoryWindows(11)=None
      FactoryWindows(12)=None
      FactoryWindows(13)=None
      FactoryWindows(14)=None
      FactoryWindows(15)=None
      FactoryWindows(16)=None
      FactoryWindows(17)=None
      FactoryWindows(18)=None
      FactoryWindows(19)=None
      FactoryWindows(20)=None
      FactoryWindows(21)=None
      FactoryWindows(22)=None
      FactoryWindows(23)=None
      FactoryWindows(24)=None
      FactoryWindows(25)=None
      FactoryWindows(26)=None
      FactoryWindows(27)=None
      FactoryWindows(28)=None
      FactoryWindows(29)=None
      FactoryWindows(30)=None
      FactoryWindows(31)=None
      FactoryWindows(32)=None
      FactoryWindows(33)=None
      FactoryWindows(34)=None
      FactoryWindows(35)=None
      FactoryWindows(36)=None
      FactoryWindows(37)=None
      FactoryWindows(38)=None
      FactoryWindows(39)=None
      FactoryWindows(40)=None
      FactoryWindows(41)=None
      FactoryWindows(42)=None
      FactoryWindows(43)=None
      FactoryWindows(44)=None
      FactoryWindows(45)=None
      FactoryWindows(46)=None
      FactoryWindows(47)=None
      FactoryWindows(48)=None
      FactoryWindows(49)=None
      InfoWindow=None
}
