//=============================================================================
// UnrealListMenu.
//=============================================================================
class UnrealListMenu extends UnrealMenu;

#exec TEXTURE IMPORT NAME="ListMenuTop" FILE="Textures\menu-t.pcx" MIPS=off
#exec TEXTURE IMPORT NAME="ListMenuMiddle" FILE="Textures\menu-m.pcx" MIPS=off
#exec TEXTURE IMPORT NAME="ListMenuBottom" FILE="Textures\menu-b.pcx" MIPS=off

#exec TEXTURE IMPORT NAME=ArrowDL FILE=TEXTURES\ARROW-DL.PCX GROUP="Icons" MIPS=OFF
#exec TEXTURE IMPORT NAME=ArrowDR FILE=TEXTURES\ARROW-DR.PCX GROUP="Icons" MIPS=OFF
#exec TEXTURE IMPORT NAME=ArrowUL FILE=TEXTURES\ARROW-UL.PCX GROUP="Icons" MIPS=OFF
#exec TEXTURE IMPORT NAME=ArrowUR FILE=TEXTURES\ARROW-UR.PCX GROUP="Icons" MIPS=OFF

var float PulseTime;
var bool bPulseDown;
var float TitleFadeTime;
var float MenuFadeTimes[24];
var() localized string LeftHelpMessage;
var() localized string LeftList[33];
var() localized string LeftTitle;
var int LeftOffset;
var int LeftSelection;
var int LeftMax;
var int LeftNumDrawn;
var() localized string RightHelpMessage;
var() localized string RightList[33];
var() localized string RightTitle;
var int RightOffset;
var int RightSelection;
var int RightMax;
var int RightNumDrawn;
var int Focus;
var int CenterSelection;
var float PanelWidth, PanelHeight;
var int ColumnLines;

function LeftMenuProcessInput( byte KeyNum, byte ActionNum )
{
	Super.MenuProcessInput( KeyNum, ActionNum );
}

function CenterMenuProcessInput( byte KeyNum, byte ActionNum )
{
	Super.MenuProcessInput( KeyNum, ActionNum );
}

function RightMenuProcessInput( byte KeyNum, byte ActionNum )
{
	Super.MenuProcessInput( KeyNum, ActionNum );
}

function MenuProcessInput( byte KeyNum, byte ActionNum )
{
	switch (Focus)
	{
		case -1:
			LeftMenuProcessInput( KeyNum, ActionNum );
			break;
		case 0:
			CenterMenuProcessInput( KeyNum, ActionNum );
			break;
		case 1:
			RightMenuProcessInput( KeyNum, ActionNum );
			break;
	}
}

// Background.
function DrawBackground(canvas Canvas)
{
	local float OldX, OldY;
	local int NumTiles, i;
	
	Canvas.DrawColor.R = 255;
	Canvas.DrawColor.G = 255;
	Canvas.DrawColor.B = 255;

	NumTiles = PanelHeight / 64.0;
	
	OldX = Canvas.CurX;
	OldY = Canvas.CurY;	
	Canvas.DrawIcon(texture'ListMenuTop', 1.0);
	NumTiles--;
	for (i=1; i<NumTiles; i++)
	{
		Canvas.SetPos(OldX, OldY + 64.0*i);
		Canvas.DrawIcon(texture'ListMenuMiddle', 1.0);
	}
	Canvas.SetPos(OldX, OldY + 64.0*NumTiles);
	Canvas.DrawIcon(texture'ListMenuBottom', 1.0);
}

// Fade title.
function DrawFadeTitle(canvas Canvas)
{
	local float XL, YL;
	local color DrawColor;

	Canvas.Font = Font'WhiteFont';
	Canvas.StrLen(MenuTitle, XL, YL);

	DrawColor.R = 192;
	DrawColor.G = 192;
	DrawColor.B = 192;
	
	DrawFadeString(Canvas, MenuTitle, TitleFadeTime, Canvas.ClipX/2 - XL/2, 32, DrawColor);
}

// Fade list.
function DrawFadeList(canvas Canvas, int Spacing, int StartX, int StartY)
{
	local int i;
	local color DrawColor;
	
	Canvas.Font = Font'WhiteFont';
	for (i=0; i< (MenuLength); i++ )
	{
		if (i == Selection - 1)
		{
			DrawColor.R = PulseTime * 10;
			DrawColor.G = 255;
			DrawColor.B = PulseTime * 10;
		} else {
			DrawColor.R = 0;
			DrawColor.G = 150;
			DrawColor.B = 0;
		}
		DrawFadeString(Canvas, MenuList[i + 1], MenuFadeTimes[i + 1], StartX, StartY + Spacing * i, DrawColor);
	}
}

// Fades in a string to the specified color.
function DrawFadeString( canvas Canvas, string FadeString, out float FadeTime, float XStart, float YStart, color DrawColor )
{
	local float FadeCount, XL, YL;
	local int FadeChar;
	
	Canvas.SetPos(XStart, YStart);
	Canvas.DrawColor = DrawColor;
	
	if (FadeTime == -1.0)
	{
		// If first update, just set the FadeTime to zero.
		FadeTime = 0.0;
		return;
	} else if (FadeTime == -2.0) {
		Canvas.SetPos(XStart, YStart);
		Canvas.DrawColor = DrawColor;
		Canvas.DrawText(FadeString, false);
		return;
	}
	
	// Update FadeString.
	for ( FadeChar = 0; FadeTime - (FadeChar * 0.1) > 0.0; FadeChar++ )
	{
		FadeCount = FadeTime - (FadeChar * 0.1);
		if (FadeCount > 1.0)
			FadeCount = 1.0;
			
		if ((FadeChar == Len(FadeString) - 1) && (255 * (1.0 - FadeCount) == 0))
			FadeTime = -2.0;

		Canvas.DrawColor.R = Max(255 * (1.0 - FadeCount), DrawColor.R);
		Canvas.DrawColor.G = Max(255 * (1.0 - FadeCount), DrawColor.G);
		Canvas.DrawColor.B = Max(255 * (1.0 - FadeCount), DrawColor.B);
		Canvas.DrawText(Mid(FadeString, FadeChar, 1));
		Canvas.StrLen(Left(FadeString, FadeChar+1), XL, YL);
		Canvas.SetPos(XStart + XL, YStart);
	}
}

function DrawLeftTitle(canvas Canvas)
{
	local float XL, YL;

	Canvas.DrawColor.R = 255;
	Canvas.DrawColor.G = 255;
	Canvas.DrawColor.B = 255;
	Canvas.StrLen(LeftTitle, XL, YL);
	Canvas.SetPos(64 + (PanelWidth/2 - XL/2), 126-YL);
	Canvas.DrawText(LeftTitle, false);
}

function DrawLeftList(canvas Canvas)
{
	local float XL, YL;
	local int i;

	LeftNumDrawn = 0;
	for ( i=LeftOffset+1; i<ColumnLines+LeftOffset; i++ )
	{
		if ( (Focus == -1) && (Selection == i) )
		{
			Canvas.DrawColor.R = PulseTime * 10;
			Canvas.DrawColor.G = 255;
			Canvas.DrawColor.B = PulseTime * 10;
		} else {
			Canvas.DrawColor.R = 0;
			Canvas.DrawColor.G = 255;
			Canvas.DrawColor.B = 0;
		}
		Canvas.Font = Font'WhiteFont';
		Canvas.StrLen(LeftList[i], XL, YL);
		Canvas.SetPos(64 + (PanelWidth/2 - XL/2), 128 + ((i-LeftOffset)*2*YL));
		Canvas.DrawText(LeftList[i], false);
		LeftNumDrawn++;
	}
	LeftNumDrawn--;
}

function DrawLeftPanel(canvas Canvas)
{
	// DrawLeftTitle
	DrawLeftTitle(Canvas);

	// DrawLeftBackground
	Canvas.SetPos(64, 128);
	DrawBackground(Canvas);

	// DrawLeftList
	DrawLeftList(Canvas);
}

function DrawRightTitle(canvas Canvas)
{
	local float XL, YL;
	local int i;

	Canvas.DrawColor.R = 255;
	Canvas.DrawColor.G = 255;
	Canvas.DrawColor.B = 255;
	Canvas.StrLen(RightTitle, XL, YL);
	Canvas.SetPos(Canvas.ClipX - 64 - PanelWidth + (PanelWidth/2 - XL/2), 126-YL);
	Canvas.DrawText(RightTitle, false);
}

function DrawRightList(canvas Canvas)
{
	local float XL, YL;
	local int i;

	RightNumDrawn = 0;
	for ( i=RightOffset+1; i<ColumnLines+RightOffset; i++ )
	{
		if ( (Focus == 1) && (Selection == i) )
		{
			Canvas.DrawColor.R = PulseTime * 10;
			Canvas.DrawColor.G = 255;
			Canvas.DrawColor.B = PulseTime * 10;
		} else {
			Canvas.DrawColor.R = 0;
			Canvas.DrawColor.G = 255;
			Canvas.DrawColor.B = 0;
		}
		Canvas.Font = Font'WhiteFont';
		Canvas.StrLen(RightList[i], XL, YL);
		Canvas.SetPos(Canvas.ClipX - 64 - PanelWidth + (PanelWidth/2 - XL/2), 128 + ((i-RightOffset)*2*YL));
		Canvas.DrawText(RightList[i], false);
		RightNumDrawn++;
	}
	RightNumDrawn--;
}

function DrawRightPanel(canvas Canvas)
{
	// DrawRightTitle
	DrawRightTitle(Canvas);

	// DrawRightBackground
	Canvas.SetPos(Canvas.ClipX - 64 - PanelWidth, 128);
	DrawBackground(Canvas);

	// DrawRightList
	DrawRightList(Canvas);
}

// The help panel for list menus.  Oriented somewhat differently
// because it is not restricted by the green background.
function DrawHelpPanel(canvas Canvas, int StartY, int XClip)
{
	local int StartX;

	StartX = 0.5 * Canvas.ClipX - 128;

	Canvas.bCenter = false;
	Canvas.Font = Canvas.MedFont;
	Canvas.SetOrigin(StartX + 18, StartY + 16);
	Canvas.SetClip(XClip,64);
	Canvas.SetPos(0,0);
	Canvas.Style = 1;
	switch (Focus)
	{
		case -1:
			Canvas.DrawText(LeftHelpMessage, False);
			break;
		case 0:
			if ( Selection < 20 )
				Canvas.DrawText(HelpMessage[Selection], False);
			break;
		case 1:
			Canvas.DrawText(RightHelpMessage, False);
			break;
	}
	Canvas.SetPos(0,32);
}

function MenuTick( float DeltaTime )
{
	if ( Level.Pauser == "" )
		return;

	// Update PulseTime.
	if (bPulseDown)
	{
		if (PulseTime > 0.0)
		{
			PulseTime -= DeltaTime * 30;
			if (PulseTime < 0.0)
				PulseTime = 0.0;
		} else {
			PulseTime = 0.0;
			bPulseDown = false;
		}
	} else {
		if (PulseTime < 25.5)
		{
			PulseTime += DeltaTime * 30;
			if (PulseTime > 25.5)
				PulseTime = 25.5;
		} else {
			PulseTime = 25.5;
			bPulseDown = true;
		}
	}
}

defaultproperties
{
      PulseTime=0.000000
      bPulseDown=False
      TitleFadeTime=0.000000
      MenuFadeTimes(0)=0.000000
      MenuFadeTimes(1)=0.000000
      MenuFadeTimes(2)=0.000000
      MenuFadeTimes(3)=0.000000
      MenuFadeTimes(4)=0.000000
      MenuFadeTimes(5)=0.000000
      MenuFadeTimes(6)=0.000000
      MenuFadeTimes(7)=0.000000
      MenuFadeTimes(8)=0.000000
      MenuFadeTimes(9)=0.000000
      MenuFadeTimes(10)=0.000000
      MenuFadeTimes(11)=0.000000
      MenuFadeTimes(12)=0.000000
      MenuFadeTimes(13)=0.000000
      MenuFadeTimes(14)=0.000000
      MenuFadeTimes(15)=0.000000
      MenuFadeTimes(16)=0.000000
      MenuFadeTimes(17)=0.000000
      MenuFadeTimes(18)=0.000000
      MenuFadeTimes(19)=0.000000
      MenuFadeTimes(20)=0.000000
      MenuFadeTimes(21)=0.000000
      MenuFadeTimes(22)=0.000000
      MenuFadeTimes(23)=0.000000
      LeftHelpMessage=""
      LeftList(0)=""
      LeftList(1)=""
      LeftList(2)=""
      LeftList(3)=""
      LeftList(4)=""
      LeftList(5)=""
      LeftList(6)=""
      LeftList(7)=""
      LeftList(8)=""
      LeftList(9)=""
      LeftList(10)=""
      LeftList(11)=""
      LeftList(12)=""
      LeftList(13)=""
      LeftList(14)=""
      LeftList(15)=""
      LeftList(16)=""
      LeftList(17)=""
      LeftList(18)=""
      LeftList(19)=""
      LeftList(20)=""
      LeftList(21)=""
      LeftList(22)=""
      LeftList(23)=""
      LeftList(24)=""
      LeftList(25)=""
      LeftList(26)=""
      LeftList(27)=""
      LeftList(28)=""
      LeftList(29)=""
      LeftList(30)=""
      LeftList(31)=""
      LeftList(32)=""
      LeftTitle=""
      LeftOffset=0
      LeftSelection=0
      LeftMax=0
      LeftNumDrawn=0
      RightHelpMessage=""
      RightList(0)=""
      RightList(1)=""
      RightList(2)=""
      RightList(3)=""
      RightList(4)=""
      RightList(5)=""
      RightList(6)=""
      RightList(7)=""
      RightList(8)=""
      RightList(9)=""
      RightList(10)=""
      RightList(11)=""
      RightList(12)=""
      RightList(13)=""
      RightList(14)=""
      RightList(15)=""
      RightList(16)=""
      RightList(17)=""
      RightList(18)=""
      RightList(19)=""
      RightList(20)=""
      RightList(21)=""
      RightList(22)=""
      RightList(23)=""
      RightList(24)=""
      RightList(25)=""
      RightList(26)=""
      RightList(27)=""
      RightList(28)=""
      RightList(29)=""
      RightList(30)=""
      RightList(31)=""
      RightList(32)=""
      RightTitle=""
      RightOffset=0
      RightSelection=0
      RightMax=0
      RightNumDrawn=0
      Focus=0
      CenterSelection=0
      PanelWidth=0.000000
      PanelHeight=0.000000
      ColumnLines=0
}
