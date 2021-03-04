//=============================================================================
// UBrowserPlayerGrid
//=============================================================================
class UBrowserPlayerGrid extends UWindowGrid;

var localized string NameText;
var localized string FragsText;
var localized string PingText;
var localized string TeamText;
var localized string MeshText;
var localized string SkinText;
var localized string FaceText;
var localized string IDText;
var localized string ngSecretText;
var localized string EnabledText;
var localized string DisabledText;
var localized string BotText;
var localized string HumanText;
var int ngSecretWidth;
var UWindowGridColumn ngSecretColumn;

function Created() 
{
	Super.Created();

	RowHeight = 12;

	AddColumn(NameText, 60);
	AddColumn(FragsText, 30);
	AddColumn(PingText, 30);
	AddColumn(TeamText, 30);
	AddColumn(MeshText, 80);
	AddColumn(SkinText, 80);
	AddColumn(FaceText, 60);
	AddColumn(IDText, 30);
	ngSecretColumn = AddColumn(ngSecretText, 100);
	ngSecretWidth = 100;
}

function PaintColumn(Canvas C, UWindowGridColumn Column, float MouseX, float MouseY) 
{
	local UBrowserServerList Server;
	local UBrowserPlayerList PlayerList, l;
	local int Visible;
	local int Count;
	local int Skipped;
	local int Y;
	local int TopMargin;
	local int BottomMargin;

	if(bShowHorizSB)
		BottomMargin = LookAndFeel.Size_ScrollbarWidth;
	else
		BottomMargin = 0;

	TopMargin = LookAndFeel.ColumnHeadingHeight;

	Server = UBrowserInfoClientWindow(GetParent(class'UBrowserInfoClientWindow')).Server;
	if(Server == None)
		return;
	PlayerList = Server.PlayerList;

	if(PlayerList == None)
		return;
	Count = PlayerList.Count();
	if( ngSecretColumn.WinWidth <= 1 )
	{
		ngSecretColumn.ShowWindow();
		ngSecretColumn.WinWidth = ngSecretWidth;
	}

	C.Font = Root.Fonts[F_Normal];
	Visible = int((WinHeight - (TopMargin + BottomMargin))/RowHeight);
	
	VertSB.SetRange(0, Count+1, Visible);
	TopRow = VertSB.Pos;

	Skipped = 0;

	Y = 1;
	l = UBrowserPlayerList(PlayerList.Next);
	while((Y < RowHeight + WinHeight - RowHeight - (TopMargin + BottomMargin)) && (l != None))
	{
		if(Skipped >= VertSB.Pos)
		{
			switch(Column.ColumnNum)
			{
			case 0:
				Column.ClipText( C, 2, Y + TopMargin, l.PlayerName );
				break;
			case 1:
				Column.ClipText( C, 2, Y + TopMargin, l.PlayerFrags );
				break;
			case 2:
				Column.ClipText( C, 2, Y + TopMargin, l.PlayerPing);
				break;
			case 3:
				Column.ClipText( C, 2, Y + TopMargin, l.PlayerTeam );
				break;
			case 4:
				Column.ClipText( C, 2, Y + TopMargin, l.PlayerMesh );
				break;
			case 5:
				Column.ClipText( C, 2, Y + TopMargin, l.PlayerSkin );
				break;
			case 6:
				Column.ClipText( C, 2, Y + TopMargin, l.PlayerFace );
				break;
			case 7:
				Column.ClipText( C, 2, Y + TopMargin, l.PlayerID );
				break;
			case 8: // the column formerly known as the ngworldstats status
				if( l.PlayerStats ~= "bot" )
					Column.ClipText( C, 2, Y + TopMargin, BotText );
				else
					Column.ClipText( C, 2, Y + TopMargin, HumanText );
				break;
			}

			Y = Y + RowHeight;			
		} 
		Skipped ++;
		l = UBrowserPlayerList(l.Next);
	}
}

function RightClickRow(int Row, float X, float Y)
{
	local UBrowserInfoMenu Menu;
	local float MenuX, MenuY;
	local UWindowWindow W;

	W = GetParent(class'UBrowserInfoWindow');
	if(W == None)
		return;
	Menu = UBrowserInfoWindow(W).Menu;

	WindowToGlobal(X, Y, MenuX, MenuY);
	Menu.WinLeft = MenuX;
	Menu.WinTop = MenuY;

	Menu.ShowWindow();
}

function SortColumn(UWindowGridColumn Column) 
{
	UBrowserInfoClientWindow(GetParent(class'UBrowserInfoClientWindow')).Server.PlayerList.SortByColumn(Column.ColumnNum);
}

function SelectRow(int Row) 
{
}

defaultproperties
{
      NameText="Name"
      FragsText="Frags"
      PingText="Ping"
      TeamText="Team"
      MeshText="Mesh"
      SkinText="Skin"
      FaceText="Face"
      IDText="ID"
      ngSecretText="Player type"
      EnabledText=""
      DisabledText=""
      BotText="Bot"
      HumanText="Human"
      ngSecretWidth=0
      ngSecretColumn=None
      bNoKeyboard=True
}
