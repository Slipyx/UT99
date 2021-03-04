class UMenuMapListWindow expands UWindowFramedWindow;

var UWindowSmallCloseButton CloseButton;

function Created() 
{
	bStatusBar = False;
	bSizable = True;

	Super.Created();

	WinWidth = Min(400, Root.WinWidth - 50);
	WinHeight = Min(210, Root.WinHeight - 50);

	WinLeft = Root.WinWidth/2 - WinWidth/2;
	WinTop = Root.WinHeight/2 - WinHeight/2;

	CloseButton = UWindowSmallCloseButton(CreateWindow(class'UWindowSmallCloseButton', WinWidth-56, WinHeight-24, 48, 16));

	MinWinWidth = 200;
}

function Resized()
{
	Super.Resized();
	ClientArea.SetSize(ClientArea.WinWidth, ClientArea.WinHeight-24);
	CloseButton.WinLeft = ClientArea.WinLeft+ClientArea.WinWidth-52;
	CloseButton.WinTop = ClientArea.WinTop+ClientArea.WinHeight+4;
}

function Paint(Canvas C, float X, float Y)
{
	local Texture T;

	T = GetLookAndFeelTexture();
	DrawUpBevel( C, ClientArea.WinLeft, ClientArea.WinTop + ClientArea.WinHeight, ClientArea.WinWidth, 24, T);

	Super.Paint(C, X, Y);
}

defaultproperties
{
      CloseButton=None
      ClientClass=Class'UMenu.UMenuMapListCW'
      WindowTitle="Map List"
}
