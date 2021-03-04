class UWindowLookAndFeel extends UWindowBase;

var() Texture	Active;			// Active widgets, window frames, etc.
var() Texture	Inactive;		// Inactive Widgets, window frames, etc.
var() Texture	ActiveS;		
var() Texture	InactiveS;

// OldUnreal hires support
var() Texture   ActiveHiRes;
var() Texture   InactiveHiRes;
var() Texture   ActiveSHiRes;
var() Texture   InactiveSHiRes;
var() float     ActiveHiResScale;
var() float     InactiveHiResScale;
var() float     ActiveSHiResScale;
var() float     InactiveSHiResScale;

var() Texture	Misc;			// Miscellaneous: backgrounds, bevels, etc.

var() Region	FrameTL;
var() Region	FrameT;
var() Region	FrameTR;

var() Region	FrameL;
var() Region	FrameR;
	
var() Region	FrameBL;
var() Region	FrameB;
var() Region	FrameBR;

var() Color		FrameActiveTitleColor;
var() Color		FrameInactiveTitleColor;
var() Color		HeadingActiveTitleColor;
var() Color		HeadingInActiveTitleColor;

var() int		FrameTitleX;
var() int		FrameTitleY;

var() Region	BevelUpTL;
var() Region	BevelUpT;
var() Region	BevelUpTR;

var() Region	BevelUpL;
var() Region	BevelUpR;
	
var() Region	BevelUpBL;
var() Region	BevelUpB;
var() Region	BevelUpBR;
var() Region	BevelUpArea;


var() Region	MiscBevelTL[4];
var() Region	MiscBevelT[4];
var() Region	MiscBevelTR[4];
var() Region	MiscBevelL[4];
var() Region	MiscBevelR[4];
var() Region	MiscBevelBL[4];
var() Region	MiscBevelB[4];
var() Region	MiscBevelBR[4];
var() Region	MiscBevelArea[4];

var() Region	ComboBtnUp;
var() Region	ComboBtnDown;
var() Region	ComboBtnDisabled;

var() int		ColumnHeadingHeight;
var() Region	HLine;

var() Color		EditBoxTextColor;
var() int		EditBoxBevel;

var() Region	TabSelectedL;
var() Region	TabSelectedM;
var() Region	TabSelectedR;

var() Region	TabUnselectedL;
var() Region	TabUnselectedM;
var() Region	TabUnselectedR;

var() Region	TabBackground;


var() float		Size_ScrollbarWidth;
var() float		Size_ScrollbarButtonHeight;		// Interchange W and H for horizontal SB's
var() float		Size_MinScrollbarHeight;

var() float		Size_TabAreaHeight;				// The height of the clickable tab area
var() float		Size_TabAreaOverhangHeight;		// The height of the tab area overhang
var() float		Size_TabSpacing;
var() float		Size_TabXOffset;

var() float		Pulldown_ItemHeight;
var() float		Pulldown_VBorder;
var() float		Pulldown_HBorder;
var() float		Pulldown_TextBorder;

function Texture GetTexture(UWindowFramedWindow W)
{
	if(W.bStatusBar)
	{
		if(W.IsActive())
			return ActiveS;
		else
			return InactiveS;
	}
	else
	{
		if(W.IsActive())
			return Active;
		else
			return Inactive;
	}
}

function Texture GetTextureEx(UWindowFramedWindow W, out float ScaleFactor)
{
	ScaleFactor = 1.0;
	
	if(W.bStatusBar)
	{
		if(W.IsActive())
		{
			if (ActiveSHiRes != none)
			{
				ScaleFactor = Max(ActiveSHiResScale, 1.0);
				return ActiveSHiRes;
			}
			return ActiveS;
		}
		else
		{
			if (InactiveSHiRes != none)
			{
				ScaleFactor = Max(InactiveSHiResScale, 1.0);
				return InactiveSHiRes;
			}
			return InactiveS;
		}
	}
	else
	{
		if(W.IsActive())
		{
			if (ActiveHiRes != none)
			{
				ScaleFactor = Max(ActiveHiResScale, 1.0);
				return ActiveHiRes;
			}
			return Active;
		}
		else
		{
			if (InactiveHiRes != none)
			{
				ScaleFactor = Max(InactiveHiResScale, 1.0);
				return InactiveHiRes;
			}
			return Inactive;
		}
	}
}

/* Setup Functions */
function Setup();
function FW_DrawWindowFrame(UWindowFramedWindow W, Canvas C);
function Region FW_GetClientArea(UWindowFramedWindow W);
function FrameHitTest FW_HitTest(UWindowFramedWindow W, float X, float Y);
function FW_SetupFrameButtons(UWindowFramedWindow W, Canvas C);
function DrawClientArea(UWindowClientWindow W, Canvas C);
function Combo_SetupSizes(UWindowComboControl W, Canvas C);
function Combo_Draw(UWindowComboControl W, Canvas C);
function Combo_GetButtonBitmaps(UWindowComboButton W);
function Combo_SetupLeftButton(UWindowComboLeftButton W);
function Combo_SetupRightButton(UWindowComboRightButton W);
function Checkbox_SetupSizes(UWindowCheckbox W, Canvas C);
function Checkbox_Draw(UWindowCheckbox W, Canvas C);
function ComboList_DrawBackground(UWindowComboList W, Canvas C);
function ComboList_DrawItem(UWindowComboList Combo, Canvas C, float X, float Y, float W, float H, string Text, bool bSelected);
function Editbox_SetupSizes(UWindowEditControl W, Canvas C);
function Editbox_Draw(UWindowEditControl W, Canvas C);
function SB_SetupUpButton(UWindowSBUpButton W);
function SB_SetupDownButton(UWindowSBDownButton W);
function SB_SetupLeftButton(UWindowSBLeftButton W);
function SB_SetupRightButton(UWindowSBRightButton W);
function SB_VDraw(UWindowVScrollbar W, Canvas C);
function SB_HDraw(UWindowHScrollbar W, Canvas C);
function Tab_DrawTab(UWindowTabControlTabArea Tab, Canvas C, bool bActiveTab, bool bLeftmostTab, float X, float Y, float W, float H, string Text, bool bShowText);
function Tab_GetTabSize(UWindowTabControlTabArea Tab, Canvas C, string Text, out float W, out float H);
function Tab_SetupLeftButton(UWindowTabControlLeftButton W);
function Tab_SetupRightButton(UWindowTabControlRightButton W);
function Tab_SetTabPageSize(UWindowPageControl W, UWindowPageWindow P);
function Tab_DrawTabPageArea(UWindowPageControl W, Canvas C, UWindowPageWindow P);
function Menu_DrawMenuBar(UWindowMenuBar W, Canvas C);
function Menu_DrawMenuBarItem(UWindowMenuBar B, UWindowMenuBarItem I, float X, float Y, float W, float H, Canvas C);
function Menu_DrawPulldownMenuBackground(UWindowPulldownMenu W, Canvas C);
function Menu_DrawPulldownMenuItem(UWindowPulldownMenu M, UWindowPulldownMenuItem Item, Canvas C, float X, float Y, float W, float H, bool bSelected);
function Button_DrawSmallButton(UWindowSmallButton B, Canvas C);
function PlayMenuSound(UWindowWindow W, MenuSound S);
function ControlFrame_SetupSizes(UWindowControlFrame W, Canvas C);
function ControlFrame_Draw(UWindowControlFrame W, Canvas C);

defaultproperties
{
      Active=None
      Inactive=None
      ActiveS=None
      InactiveS=None
      ActiveHiRes=None
      InactiveHiRes=None
      ActiveSHiRes=None
      InactiveSHiRes=None
      ActiveHiResScale=0.000000
      InactiveHiResScale=0.000000
      ActiveSHiResScale=0.000000
      InactiveSHiResScale=0.000000
      Misc=None
      FrameTL=(X=0,Y=0,W=0,H=0)
      FrameT=(X=0,Y=0,W=0,H=0)
      FrameTR=(X=0,Y=0,W=0,H=0)
      FrameL=(X=0,Y=0,W=0,H=0)
      FrameR=(X=0,Y=0,W=0,H=0)
      FrameBL=(X=0,Y=0,W=0,H=0)
      FrameB=(X=0,Y=0,W=0,H=0)
      FrameBR=(X=0,Y=0,W=0,H=0)
      FrameActiveTitleColor=(R=0,G=0,B=0,A=0)
      FrameInactiveTitleColor=(R=0,G=0,B=0,A=0)
      HeadingActiveTitleColor=(R=0,G=0,B=0,A=0)
      HeadingInActiveTitleColor=(R=0,G=0,B=0,A=0)
      FrameTitleX=0
      FrameTitleY=0
      BevelUpTL=(X=0,Y=0,W=0,H=0)
      BevelUpT=(X=0,Y=0,W=0,H=0)
      BevelUpTR=(X=0,Y=0,W=0,H=0)
      BevelUpL=(X=0,Y=0,W=0,H=0)
      BevelUpR=(X=0,Y=0,W=0,H=0)
      BevelUpBL=(X=0,Y=0,W=0,H=0)
      BevelUpB=(X=0,Y=0,W=0,H=0)
      BevelUpBR=(X=0,Y=0,W=0,H=0)
      BevelUpArea=(X=0,Y=0,W=0,H=0)
      MiscBevelTL(0)=(X=0,Y=0,W=0,H=0)
      MiscBevelTL(1)=(X=0,Y=0,W=0,H=0)
      MiscBevelTL(2)=(X=0,Y=0,W=0,H=0)
      MiscBevelTL(3)=(X=0,Y=0,W=0,H=0)
      MiscBevelT(0)=(X=0,Y=0,W=0,H=0)
      MiscBevelT(1)=(X=0,Y=0,W=0,H=0)
      MiscBevelT(2)=(X=0,Y=0,W=0,H=0)
      MiscBevelT(3)=(X=0,Y=0,W=0,H=0)
      MiscBevelTR(0)=(X=0,Y=0,W=0,H=0)
      MiscBevelTR(1)=(X=0,Y=0,W=0,H=0)
      MiscBevelTR(2)=(X=0,Y=0,W=0,H=0)
      MiscBevelTR(3)=(X=0,Y=0,W=0,H=0)
      MiscBevelL(0)=(X=0,Y=0,W=0,H=0)
      MiscBevelL(1)=(X=0,Y=0,W=0,H=0)
      MiscBevelL(2)=(X=0,Y=0,W=0,H=0)
      MiscBevelL(3)=(X=0,Y=0,W=0,H=0)
      MiscBevelR(0)=(X=0,Y=0,W=0,H=0)
      MiscBevelR(1)=(X=0,Y=0,W=0,H=0)
      MiscBevelR(2)=(X=0,Y=0,W=0,H=0)
      MiscBevelR(3)=(X=0,Y=0,W=0,H=0)
      MiscBevelBL(0)=(X=0,Y=0,W=0,H=0)
      MiscBevelBL(1)=(X=0,Y=0,W=0,H=0)
      MiscBevelBL(2)=(X=0,Y=0,W=0,H=0)
      MiscBevelBL(3)=(X=0,Y=0,W=0,H=0)
      MiscBevelB(0)=(X=0,Y=0,W=0,H=0)
      MiscBevelB(1)=(X=0,Y=0,W=0,H=0)
      MiscBevelB(2)=(X=0,Y=0,W=0,H=0)
      MiscBevelB(3)=(X=0,Y=0,W=0,H=0)
      MiscBevelBR(0)=(X=0,Y=0,W=0,H=0)
      MiscBevelBR(1)=(X=0,Y=0,W=0,H=0)
      MiscBevelBR(2)=(X=0,Y=0,W=0,H=0)
      MiscBevelBR(3)=(X=0,Y=0,W=0,H=0)
      MiscBevelArea(0)=(X=0,Y=0,W=0,H=0)
      MiscBevelArea(1)=(X=0,Y=0,W=0,H=0)
      MiscBevelArea(2)=(X=0,Y=0,W=0,H=0)
      MiscBevelArea(3)=(X=0,Y=0,W=0,H=0)
      ComboBtnUp=(X=0,Y=0,W=0,H=0)
      ComboBtnDown=(X=0,Y=0,W=0,H=0)
      ComboBtnDisabled=(X=0,Y=0,W=0,H=0)
      ColumnHeadingHeight=0
      HLine=(X=0,Y=0,W=0,H=0)
      EditBoxTextColor=(R=0,G=0,B=0,A=0)
      EditBoxBevel=0
      TabSelectedL=(X=0,Y=0,W=0,H=0)
      TabSelectedM=(X=0,Y=0,W=0,H=0)
      TabSelectedR=(X=0,Y=0,W=0,H=0)
      TabUnselectedL=(X=0,Y=0,W=0,H=0)
      TabUnselectedM=(X=0,Y=0,W=0,H=0)
      TabUnselectedR=(X=0,Y=0,W=0,H=0)
      TabBackground=(X=0,Y=0,W=0,H=0)
      Size_ScrollbarWidth=0.000000
      Size_ScrollbarButtonHeight=0.000000
      Size_MinScrollbarHeight=0.000000
      Size_TabAreaHeight=0.000000
      Size_TabAreaOverhangHeight=0.000000
      Size_TabSpacing=0.000000
      Size_TabXOffset=0.000000
      Pulldown_ItemHeight=0.000000
      Pulldown_VBorder=0.000000
      Pulldown_HBorder=0.000000
      Pulldown_TextBorder=0.000000
}
