class UTBrowserServerGrid expands UBrowserServerGrid;

var UWindowGridColumn ngStats;
var UWindowGridColumn Ver;

var localized string ngStatsName;
var localized string VersionName;
var localized string EnabledText;
var UBrowserServerList ConnectToServer;
var bool bWaitingForNgStats;

var UWindowMessageBox AskNgStats;
var localized string AskNgStatsTitle;
var localized string AskNgStatsText;

var localized string ActiveText;
var localized string InactiveText;

function CreateColumns()
{
	Super.CreateColumns();

	ngStats	= AddColumn(ngStatsName, 80);
	Ver	= AddColumn(VersionName, 40);
}

function DrawCell(Canvas C, float X, float Y, UWindowGridColumn Column, UBrowserServerList List)
{
	switch(Column)
	{
	case Ver:
		Column.ClipText( C, X, Y, string(List.GameVer) );
		break;
	case ngStats:
		if( List.GameVer >= 406 && UTBrowserServerList(List).bNGWorldStats )
		{
			if( UTBrowserServerList(List).bNGWorldStatsActive )
				Column.ClipText( C, X, Y, ActiveText );
			else
				Column.ClipText( C, X, Y, InactiveText );
		}
		else
		if(UTBrowserServerList(List).bNGWorldStatsActive)
			Column.ClipText( C, X, Y, EnabledText );
		break;
	default:
		Super.DrawCell(C, X, Y, Column, List);
		break;
	}
}

function int Compare(UBrowserServerList T, UBrowserServerList B)
{
	switch(SortByColumn)
	{
	case Ver:
		if( T.GameVer == B.GameVer )
			return ByName(T, B);

		if( T.GameVer >= B.GameVer )
		{
			if(bSortDescending)
				return 1;
			else
				return -1;
		}
		else
		{
			if(bSortDescending)
				return -1;
			else
				return 1;
		}
		
		break;
	case ngStats:
		if( UTBrowserServerList(T).bNGWorldStatsActive == UTBrowserServerList(B).bNGWorldStatsActive )
		{
			if( UTBrowserServerList(T).bNGWorldStats == UTBrowserServerList(B).bNGWorldStats )
				return ByName(T, B);

			if( UTBrowserServerList(T).bNGWorldStats )
			{
				if(bSortDescending)
					return 1;
				else
					return -1;
			}
			else
			{
				if(bSortDescending)
					return -1;
				else
					return 1;
			}
		}
		if(UTBrowserServerList(T).bNGWorldStatsActive)
		{
			if(bSortDescending)
				return 1;
			else
				return -1;
		}
		else
		{
			if(bSortDescending)
				return -1;
			else
				return 1;
		}

		break;
	default:
		return Super.Compare(T, B);
		break;
	}
}

function MessageBoxDone(UWindowMessageBox W, MessageBoxResult Result)
{
	if(W == AskNgStats)
	{
		AskNgStats = None;
		if(Result == MR_Cancel)
			return;
		else
		if(Result == MR_Yes)
		{
			ShowModal(Root.CreateWindow(class<UWindowWindow>(DynamicLoadObject("UTMenu.ngWorldSecretWindow", class'Class')), 100, 100, 200, 200, Root, True));
			bWaitingForNgStats = True;
		}
		else
		{
			GetPlayerOwner().ngSecretSet = True;
			GetPlayerOwner().SaveConfig();
			ReallyJoinServer(ConnectToServer);
		}
	}
}

function JoinServer(UBrowserServerList Server)
{
	if(Server != None && Server.GamePort != 0) 
	{
		ReallyJoinServer(Server);
	}
}

function BeforePaint(Canvas C, float X, float Y)
{
	Super.BeforePaint(C, X, Y);
	if(bWaitingForNgStats && !WaitModal())
	{
		ReallyJoinServer(ConnectToServer);
		bWaitingForNgStats = False;
	}
}

function ReallyJoinServer(UBrowserServerList Server)
{
	GetPlayerOwner().ClientTravel("unreal://"$Server.IP$":"$Server.GamePort$UBrowserServerListWindow(GetParent(class'UBrowserServerListWindow')).URLAppend, TRAVEL_Absolute, false);
	GetParent(class'UWindowFramedWindow').Close();
	Root.Console.CloseUWindow();
}

defaultproperties
{
      ngStats=None
      Ver=None
      ngStatsName="Stats Logging"
      VersionName="Version"
      EnabledText="Enabled"
      ConnectToServer=None
      bWaitingForNgStats=False
      AskNgStats=None
      AskNgStatsTitle="Use ngWorldStats?"
      AskNgStatsText="This server has stat accumulation enabled. Your ngWorldStats password has not been set. If you set a new ngWorldStats password, you can record all of your gameplay stats (Kills, Suicides, etc) online! If you do not set a password you will opt out of stat accumulation.\n\nDo you want to set an ngWorldStats password?"
      ActiveText="Active"
      InactiveText="Inactive"
}
