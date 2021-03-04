class UMenuGoldLookAndFeel extends UWindowLookAndFeel;

#exec TEXTURE IMPORT NAME=GoldActiveFrame FILE=Textures\G_ActiveFrame.bmp GROUP="Icons" FLAGS=2 MIPS=OFF
#exec TEXTURE IMPORT NAME=GoldActiveFrameHiRes FILE=Textures\G_ActiveFrameHiRes.bmp GROUP="Icons" MIPS=ON
#exec TEXTURE IMPORT NAME=GoldInactiveFrameHiRes FILE=Textures\G_InactiveFrameHiRes.bmp GROUP="Icons" MIPS=ON
#exec TEXTURE IMPORT NAME=GoldInactiveFrame FILE=Textures\G_InactiveFrame.bmp GROUP="Icons" FLAGS=2 MIPS=OFF
#exec TEXTURE IMPORT NAME=GoldActiveFrameS FILE=Textures\G_ActiveFrameS.bmp GROUP="Icons" FLAGS=2 MIPS=OFF
#exec TEXTURE IMPORT NAME=GoldInactiveFrameS FILE=Textures\G_InactiveFrameS.bmp GROUP="Icons" FLAGS=2 MIPS=OFF

#exec TEXTURE IMPORT NAME=Misc FILE=Textures\G_Misc.bmp GROUP="Icons" MIPS=OFF
#exec TEXTURE IMPORT NAME=GoldButton FILE=Textures\G_SmallButton.pcx GROUP="Icons" MIPS=OFF

#exec TEXTURE IMPORT NAME=ChkChecked FILE=Textures\ChkChecked.bmp GROUP="Icons" FLAGS=2 MIPS=OFF
#exec TEXTURE IMPORT NAME=ChkCheckedHiRes FILE=Textures\ChkCheckedHiRes.bmp GROUP="Icons" FLAGS=2 MIPS=OFF
#exec TEXTURE IMPORT NAME=ChkUnchecked FILE=Textures\ChkUnchecked.bmp GROUP="Icons" FLAGS=2 MIPS=OFF
#exec TEXTURE IMPORT NAME=ChkCheckedDisabled FILE=Textures\ChkCheckedDisabled.bmp GROUP="Icons" FLAGS=2 MIPS=OFF
#exec TEXTURE IMPORT NAME=ChkCheckedDisabledHiRes FILE=Textures\ChkCheckedDisabledHiRes.bmp GROUP="Icons" FLAGS=2 MIPS=OFF
#exec TEXTURE IMPORT NAME=ChkUncheckedDisabled FILE=Textures\ChkUncheckedDisabled.bmp GROUP="Icons" FLAGS=2 MIPS=OFF

#exec TEXTURE IMPORT NAME=BMenuArea FILE=Textures\G_MenuArea.bmp GROUP="Icons" MIPS=OFF
#exec TEXTURE IMPORT NAME=BMenuTL FILE=Textures\G_MenuTL.bmp GROUP="Icons" MIPS=OFF
#exec TEXTURE IMPORT NAME=BMenuT FILE=Textures\G_MenuT.bmp GROUP="Icons" MIPS=OFF
#exec TEXTURE IMPORT NAME=BMenuTR FILE=Textures\G_MenuTR.bmp GROUP="Icons" MIPS=OFF
#exec TEXTURE IMPORT NAME=BMenuL FILE=Textures\G_MenuL.bmp GROUP="Icons" MIPS=OFF
#exec TEXTURE IMPORT NAME=BMenuR FILE=Textures\G_MenuR.bmp GROUP="Icons" MIPS=OFF
#exec TEXTURE IMPORT NAME=BMenuBL FILE=Textures\G_MenuBL.bmp GROUP="Icons" MIPS=OFF
#exec TEXTURE IMPORT NAME=BMenuB FILE=Textures\G_MenuB.bmp GROUP="Icons" MIPS=OFF
#exec TEXTURE IMPORT NAME=BMenuBR FILE=Textures\G_MenuBR.bmp GROUP="Icons" MIPS=OFF
#exec TEXTURE IMPORT NAME=BMenuHL FILE=Textures\G_MenuHL.bmp GROUP="Icons" MIPS=OFF
#exec TEXTURE IMPORT NAME=BMenuHM FILE=Textures\G_MenuHM.bmp GROUP="Icons" MIPS=OFF
#exec TEXTURE IMPORT NAME=BMenuHR FILE=Textures\G_MenuHR.bmp GROUP="Icons" MIPS=OFF
#exec TEXTURE IMPORT NAME=MenuLine FILE=Textures\G_MenuLine.bmp GROUP="Icons" MIPS=OFF

#exec TEXTURE IMPORT NAME=BarL FILE=Textures\G_BarL.bmp GROUP="Icons" MIPS=OFF
#exec TEXTURE IMPORT NAME=BarTile FILE=Textures\G_BarTile.bmp GROUP="Icons" MIPS=OFF
#exec TEXTURE IMPORT NAME=BarMax FILE=Textures\G_BarMax.bmp GROUP="Icons" MIPS=OFF
#exec TEXTURE IMPORT NAME=BarWin FILE=Textures\G_BarWin.bmp GROUP="Icons" MIPS=OFF

#exec TEXTURE IMPORT NAME=BarInL FILE=Textures\G_BarInL.bmp GROUP="Icons" MIPS=OFF
#exec TEXTURE IMPORT NAME=BarInR FILE=Textures\G_BarInR.bmp GROUP="Icons" MIPS=OFF
#exec TEXTURE IMPORT NAME=BarInM FILE=Textures\G_BarInM.bmp GROUP="Icons" MIPS=OFF

#exec TEXTURE IMPORT NAME=BarOutL FILE=Textures\G_BarOutL.bmp GROUP="Icons" MIPS=OFF
#exec TEXTURE IMPORT NAME=BarOutR FILE=Textures\G_BarOutR.bmp GROUP="Icons" MIPS=OFF
#exec TEXTURE IMPORT NAME=BarOutM FILE=Textures\G_BarOutM.bmp GROUP="Icons" MIPS=OFF

#exec TEXTURE IMPORT NAME=MenuTickHiRes FILE=Textures\MenuTickHiRes.pcx GROUP="Icons" MIPS=OFF FLAGS=2

#exec AUDIO IMPORT FILE="Sounds\bigselect.wav" NAME=BigSelect
#exec AUDIO IMPORT FILE="Sounds\littleselect.wav" NAME=LittleSelect
#exec AUDIO IMPORT FILE="Sounds\windowopen.wav" NAME=WindowOpen
#exec AUDIO IMPORT FILE="Sounds\windowclose.wav" NAME=WindowClose

var() Texture	SmallButton;

var() Region	SBUpUp;
var() Region	SBUpDown;
var() Region	SBUpDisabled;

var() Region	SBDownUp;
var() Region	SBDownDown;
var() Region	SBDownDisabled;

var() Region	SBLeftUp;
var() Region	SBLeftDown;
var() Region	SBLeftDisabled;

var() Region	SBRightUp;
var() Region	SBRightDown;
var() Region	SBRightDisabled;

var() Region	SBBackground;

var() Region	FrameSBL;
var() Region	FrameSB;
var() Region	FrameSBR;

var() Region	CloseBoxUp;
var() Region	CloseBoxDown;
var() int		CloseBoxOffsetX;
var() int		CloseBoxOffsetY;

var() Region    ChkCheckedUp;


const SIZEBORDER = 3;
const BRSIZEBORDER = 15;

function Region ScaleRegion(Region InRegion, float Scale)
{
	local Region OutRegion;
	
	if (Scale == 1.0)
		return InRegion;
	
	OutRegion.X = InRegion.X * Scale;
	OutRegion.Y = InRegion.Y * Scale;
	OutRegion.W = InRegion.W * Scale;
	OutRegion.H = InRegion.H * Scale;
	return OutRegion;
}

/* Framed Window Drawing Functions */
function FW_DrawWindowFrame(UWindowFramedWindow W, Canvas C)
{
	local Texture T;
	local Region R, Temp;

	C.DrawColor.r = 255;
	C.DrawColor.g = 255;
	C.DrawColor.b = 255;

	T = W.GetLookAndFeelTexture();

	R = FrameTL;
	W.DrawStretchedTextureSegment( C, 0, 0, R.W, R.H, R.X, R.Y, R.W, R.H, T );

	R = FrameT;
	W.DrawStretchedTextureSegment( C, FrameTL.W, 0, 
									W.WinWidth - FrameTL.W
									- FrameTR.W,
									R.H, R.X, R.Y, R.W, R.H, T );

	R = FrameTR;
	W.DrawStretchedTextureSegment( C, W.WinWidth - R.W, 0, R.W, R.H, R.X, R.Y, R.W, R.H, T );
	

	if(W.bStatusBar)
		Temp = FrameSBL;
	else
		Temp = FrameBL;
	
	R = FrameL;
	W.DrawStretchedTextureSegment( C, 0, FrameTL.H,
									R.W,  
									W.WinHeight - FrameTL.H
									- Temp.H,
									R.X, R.Y, R.W, R.H, T );

	R = FrameR;
	W.DrawStretchedTextureSegment( C, W.WinWidth - R.W, FrameTL.H,
									R.W,  
									W.WinHeight - FrameTL.H
									- Temp.H,
									R.X, R.Y, R.W, R.H, T );

	if(W.bStatusBar)
		R = FrameSBL;
	else
		R = FrameBL;
	W.DrawStretchedTextureSegment( C, 0, W.WinHeight - R.H, R.W, R.H, R.X, R.Y, R.W, R.H, T );

	if(W.bStatusBar)
	{
		R = FrameSB;
		W.DrawStretchedTextureSegment( C, FrameBL.W, W.WinHeight - R.H, 
										W.WinWidth - FrameSBL.W
										- FrameSBR.W,
										R.H, R.X, R.Y, R.W, R.H, T );
	}
	else
	{
		R = FrameB;
		W.DrawStretchedTextureSegment( C, FrameBL.W, W.WinHeight - R.H, 
										W.WinWidth - FrameBL.W
										- FrameBR.W,
										R.H, R.X, R.Y, R.W, R.H, T );
	}

	if(W.bStatusBar)
		R = FrameSBR;
	else
		R = FrameBR;
	W.DrawStretchedTextureSegment( C, W.WinWidth - R.W, W.WinHeight - R.H, R.W, R.H, R.X, R.Y, 
									R.W, R.H, T );


	if(W.ParentWindow.ActiveWindow == W)
	{
		C.DrawColor = FrameActiveTitleColor;
		C.Font = W.Root.Fonts[W.F_Bold];
	}
	else
	{
		C.DrawColor = FrameInactiveTitleColor;
		C.Font = W.Root.Fonts[W.F_Normal];
	}


	W.ClipTextWidth(C, FrameTitleX, FrameTitleY, 
					W.WindowTitle, W.WinWidth - 22);

	if(W.bStatusBar) 
	{
		C.Font = W.Root.Fonts[W.F_Normal];
		C.DrawColor.r = 0;
		C.DrawColor.g = 0;
		C.DrawColor.b = 0;

		W.ClipTextWidth(C, 6, W.WinHeight - 15, W.StatusBarText, W.WinWidth - 22);

		C.DrawColor.r = 255;
		C.DrawColor.g = 255;
		C.DrawColor.b = 255;
	}
}

function FW_SetupFrameButtons(UWindowFramedWindow W, Canvas C)
{
	local Texture T;
	local float Scale;

	T = W.GetLookAndFeelTextureEx(Scale);

	W.CloseBox.WinLeft = W.WinWidth - CloseBoxOffsetX - CloseBoxUp.W;
	W.CloseBox.WinTop = CloseBoxOffsetY;

	W.CloseBox.SetSize(CloseBoxUp.W, CloseBoxUp.H);
	W.CloseBox.bUseRegion = True;

	W.CloseBox.UpTexture = T;
	W.CloseBox.DownTexture = T;
	W.CloseBox.OverTexture = T;
	W.CloseBox.DisabledTexture = T;

	W.CloseBox.UpRegion = ScaleRegion(CloseBoxUp, Scale);
	W.CloseBox.DownRegion = ScaleRegion(CloseBoxDown, Scale);
	W.CloseBox.OverRegion = ScaleRegion(CloseBoxUp, Scale);
	W.CloseBox.DisabledRegion = ScaleRegion(CloseBoxUp, Scale);
	W.CloseBox.RegionScale = 1 / Scale;
}

function Region FW_GetClientArea(UWindowFramedWindow W)
{
	local Region R;

	R.X = FrameL.W;
	R.Y	= FrameT.H;
	R.W = W.WinWidth - (FrameL.W + FrameR.W);
	if(W.bStatusBar) 
		R.H = W.WinHeight - (FrameT.H + FrameSB.H);
	else
		R.H = W.WinHeight - (FrameT.H + FrameB.H);

	return R;
}


function FrameHitTest FW_HitTest(UWindowFramedWindow W, float X, float Y)
{
	if((X >= 3) && (X <= W.WinWidth-3) && (Y >= 3) && (Y <= 14))
		return HT_TitleBar;
	if((X < BRSIZEBORDER && Y < SIZEBORDER) || (X < SIZEBORDER && Y < BRSIZEBORDER)) 
		return HT_NW;
	if((X > W.WinWidth - SIZEBORDER && Y < BRSIZEBORDER) || (X > W.WinWidth - BRSIZEBORDER && Y < SIZEBORDER))
		return HT_NE;
	if((X < BRSIZEBORDER && Y > W.WinHeight - SIZEBORDER)|| (X < SIZEBORDER && Y > W.WinHeight - BRSIZEBORDER)) 
		return HT_SW;
	if((X > W.WinWidth - BRSIZEBORDER) && (Y > W.WinHeight - BRSIZEBORDER))
		return HT_SE;
	if(Y < SIZEBORDER)
		return HT_N;
	if(Y > W.WinHeight - SIZEBORDER)
		return HT_S;
	if(X < SIZEBORDER)
		return HT_W;
	if(X > W.WinWidth - SIZEBORDER)	
		return HT_E;

	return HT_None;	
}

/* Client Area Drawing Functions */
function DrawClientArea(UWindowClientWindow W, Canvas C)
{
	W.DrawClippedTexture(C, 0, 0, Texture'BMenuTL');
	W.DrawStretchedTexture(C, 2, 0, W.WinWidth-4, 2, Texture'BMenuT');
	W.DrawClippedTexture(C, W.WinWidth-2, 0, Texture'BMenuTR');

	W.DrawClippedTexture(C, 0, W.WinHeight-2, Texture'BMenuBL');
	W.DrawStretchedTexture(C, 2, W.WinHeight-2, W.WinWidth-4, 2, Texture'BMenuB');
	W.DrawClippedTexture(C, W.WinWidth-2, W.WinHeight-2, Texture'BMenuBR');

	W.DrawStretchedTexture(C, 0, 2, 2, W.WinHeight-4, Texture'BMenuL');
	W.DrawStretchedTexture(C, W.WinWidth-2, 2, 2, W.WinHeight-4, Texture'BMenuR');

	W.DrawStretchedTexture(C, 2, 2, W.WinWidth-4, W.WinHeight-4, Texture'BMenuArea');
}


/* Combo Drawing Functions */

function Combo_SetupSizes(UWindowComboControl W, Canvas C)
{
	local float TW, TH;

	C.Font = W.Root.Fonts[W.Font];
	W.TextSize(C, W.Text, TW, TH);
	
	W.WinHeight = 12 + MiscBevelT[2].H + MiscBevelB[2].H;
	
	switch(W.Align)
	{
	case TA_Left:
		W.EditAreaDrawX = W.WinWidth - W.EditBoxWidth;
		W.TextX = 0;
		break;
	case TA_Right:
		W.EditAreaDrawX = 0;	
		W.TextX = W.WinWidth - TW;
		break;
	case TA_Center:
		W.EditAreaDrawX = (W.WinWidth - W.EditBoxWidth) / 2;
		W.TextX = (W.WinWidth - TW) / 2;
		break;
	}

	W.EditAreaDrawY = (W.WinHeight - 2) / 2;
	W.TextY = (W.WinHeight - TH) / 2;

	W.EditBox.WinLeft = W.EditAreaDrawX + MiscBevelL[2].W;
	W.EditBox.WinTop = MiscBevelT[2].H;
	W.Button.WinWidth = ComboBtnUp.W;

	if(W.bButtons)
	{
		W.EditBox.WinWidth = W.EditBoxWidth - MiscBevelL[2].W - MiscBevelR[2].W - ComboBtnUp.W - SBLeftUp.W - SBRightUp.W;
		W.EditBox.WinHeight = W.WinHeight - MiscBevelT[2].H - MiscBevelB[2].H;
		W.Button.WinLeft = W.WinWidth - ComboBtnUp.W - MiscBevelR[2].W - SBLeftUp.W - SBRightUp.W;
		W.Button.WinTop = W.EditBox.WinTop;

		W.LeftButton.WinLeft = W.WinWidth - MiscBevelR[2].W - SBLeftUp.W - SBRightUp.W;
		W.LeftButton.WinTop = W.EditBox.WinTop;
		W.RightButton.WinLeft = W.WinWidth - MiscBevelR[2].W - SBRightUp.W;
		W.RightButton.WinTop = W.EditBox.WinTop;

		W.LeftButton.WinWidth = SBLeftUp.W;
		W.LeftButton.WinHeight = SBLeftUp.H;
		W.RightButton.WinWidth = SBRightUp.W;
		W.RightButton.WinHeight = SBRightUp.H;
	}
	else
	{
		W.EditBox.WinWidth = W.EditBoxWidth - MiscBevelL[2].W - MiscBevelR[2].W - ComboBtnUp.W;
		W.EditBox.WinHeight = W.WinHeight - MiscBevelT[2].H - MiscBevelB[2].H;
		W.Button.WinLeft = W.WinWidth - ComboBtnUp.W - MiscBevelR[2].W;
		W.Button.WinTop = W.EditBox.WinTop;
	}
	W.Button.WinHeight = W.EditBox.WinHeight;
}

function Combo_Draw(UWindowComboControl W, Canvas C)
{
	W.DrawMiscBevel(C, W.EditAreaDrawX, 0, W.EditBoxWidth, W.WinHeight, Misc, 2);

	if(W.Text != "")
	{
		C.DrawColor = W.TextColor;
		W.ClipText(C, W.TextX, W.TextY, W.Text);
		C.DrawColor.R = 255;
		C.DrawColor.G = 255;
		C.DrawColor.B = 255;
	}
}

function ComboList_DrawBackground(UWindowComboList W, Canvas C)
{
	W.DrawClippedTexture(C, 0, 0, Texture'UMenu.BMenuTL');
	W.DrawStretchedTexture(C, 4, 0, W.WinWidth-8, 4, Texture'UMenu.BMenuT');
	W.DrawClippedTexture(C, W.WinWidth-4, 0, Texture'UMenu.BMenuTR');

	W.DrawClippedTexture(C, 0, W.WinHeight-4, Texture'UMenu.BMenuBL');
	W.DrawStretchedTexture(C, 4, W.WinHeight-4, W.WinWidth-8, 4, Texture'UMenu.BMenuB');
	W.DrawClippedTexture(C, W.WinWidth-4, W.WinHeight-4, Texture'UMenu.BMenuBR');

	W.DrawStretchedTexture(C, 0, 4, 4, W.WinHeight-8, Texture'UMenu.BMenuL');
	W.DrawStretchedTexture(C, W.WinWidth-4, 4, 4, W.WinHeight-8, Texture'UMenu.BMenuR');

	W.DrawStretchedTexture(C, 4, 4, W.WinWidth-8, W.WinHeight-8, Texture'UMenu.BMenuArea');
}

function ComboList_DrawItem(UWindowComboList Combo, Canvas C, float X, float Y, float W, float H, string Text, bool bSelected)
{
	C.DrawColor.R = 255;
	C.DrawColor.G = 255;
	C.DrawColor.B = 255;

	if(bSelected)
	{
		Combo.DrawClippedTexture(C, X, Y, Texture'UMenu.BMenuHL');
		Combo.DrawStretchedTexture(C, X + 4, Y, W - 8, 16, Texture'UMenu.BMenuHM');
		Combo.DrawClippedTexture(C, X + W - 4, Y, Texture'UMenu.BMenuHR');
		C.DrawColor.R = 0;
		C.DrawColor.G = 0;
		C.DrawColor.B = 0;
	}
	else
	{
		C.DrawColor.R = 0;
		C.DrawColor.G = 0;
		C.DrawColor.B = 0;
	}

	Combo.ClipText(C, X + Combo.TextBorder + 2, Y + 1.5, Text);
}

function Checkbox_SetupSizes(UWindowCheckbox W, Canvas C)
{
	local float TW, TH;

	W.TextSize(C, W.Text, TW, TH);
	W.WinHeight = Max(TH+1, 16);
	
	switch(W.Align)
	{
	case TA_Left:
		W.ImageX = W.WinWidth - 16;
		W.TextX = 0;
		break;
	case TA_Right:
		W.ImageX = 0;	
		W.TextX = W.WinWidth - TW;
		break;
	case TA_Center:
		W.ImageX = (W.WinWidth - 16) / 2;
		W.TextX = (W.WinWidth - TW) / 2;
		break;
	}

	W.ImageY = (W.WinHeight - 16) / 2;
	W.TextY = (W.WinHeight - TH) / 2;

	if(W.bChecked) 
	{
		W.UpTexture = Texture'ChkCheckedHiRes';
		W.DownTexture = Texture'ChkCheckedHiRes';
		W.OverTexture = Texture'ChkCheckedHiRes';
		W.DisabledTexture = Texture'ChkCheckedDisabledHiRes';
		W.bUseRegion = true;
		W.UpRegion = ChkCheckedUp;
		W.DownRegion = ChkCheckedUp;
		W.OverRegion = ChkCheckedUp;
		W.DisabledRegion = ChkCheckedUp;
		W.RegionScale = 0.25;
	}
	else 
	{
		W.UpTexture = Texture'ChkUnchecked';
		W.DownTexture = Texture'ChkUnchecked';
		W.OverTexture = Texture'ChkUnchecked';
		W.DisabledTexture = Texture'ChkUncheckedDisabled';
		W.bUseRegion = false;
	}
}

function Combo_GetButtonBitmaps(UWindowComboButton W)
{
	local Texture T;
	local float Scale;

	T = W.GetLookAndFeelTextureEx(Scale);
	
	W.bUseRegion = True;

	W.UpTexture = T;
	W.DownTexture = T;
	W.OverTexture = T;
	W.DisabledTexture = T;

	W.UpRegion = ScaleRegion(ComboBtnUp, Scale);
	W.DownRegion = ScaleRegion(ComboBtnDown, Scale);
	W.OverRegion = ScaleRegion(ComboBtnUp, Scale);
	W.DisabledRegion = ScaleRegion(ComboBtnDisabled, Scale);
	W.RegionScale = 1 / Scale;
}

function Combo_SetupLeftButton(UWindowComboLeftButton W)
{
	local Texture T;
	local float Scale;

	T = W.GetLookAndFeelTextureEx(Scale);

	W.bUseRegion = True;

	W.UpTexture = T;
	W.DownTexture = T;
	W.OverTexture = T;
	W.DisabledTexture = T;

	W.UpRegion = ScaleRegion(SBLeftUp, Scale);
	W.DownRegion = ScaleRegion(SBLeftDown, Scale);
	W.OverRegion = ScaleRegion(SBLeftUp, Scale);
	W.DisabledRegion = ScaleRegion(SBLeftDisabled, Scale);
	W.RegionScale = 1 / Scale;
}

function Combo_SetupRightButton(UWindowComboRightButton W)
{
	local Texture T;
	local float Scale;

	T = W.GetLookAndFeelTextureEx(Scale);

	W.bUseRegion = True;

	W.UpTexture = T;
	W.DownTexture = T;
	W.OverTexture = T;
	W.DisabledTexture = T;

	W.UpRegion = ScaleRegion(SBRightUp, Scale);
	W.DownRegion = ScaleRegion(SBRightDown, Scale);
	W.OverRegion = ScaleRegion(SBRightUp, Scale);
	W.DisabledRegion = ScaleRegion(SBRightDisabled, Scale);
	W.RegionScale = 1 / Scale;
}



function Editbox_SetupSizes(UWindowEditControl W, Canvas C)
{
	local float TW, TH;
	local int B;

	B = EditBoxBevel;
		
	C.Font = W.Root.Fonts[W.Font];
	W.TextSize(C, W.Text, TW, TH);
	
	W.WinHeight = 12 + MiscBevelT[B].H + MiscBevelB[B].H;
	
	switch(W.Align)
	{
	case TA_Left:
		W.EditAreaDrawX = W.WinWidth - W.EditBoxWidth;
		W.TextX = 0;
		break;
	case TA_Right:
		W.EditAreaDrawX = 0;	
		W.TextX = W.WinWidth - TW;
		break;
	case TA_Center:
		W.EditAreaDrawX = (W.WinWidth - W.EditBoxWidth) / 2;
		W.TextX = (W.WinWidth - TW) / 2;
		break;
	}

	W.EditAreaDrawY = (W.WinHeight - 2) / 2;
	W.TextY = (W.WinHeight - TH) / 2;

	W.EditBox.WinLeft = W.EditAreaDrawX + MiscBevelL[B].W;
	W.EditBox.WinTop = MiscBevelT[B].H;
	W.EditBox.WinWidth = W.EditBoxWidth - MiscBevelL[B].W - MiscBevelR[B].W;
	W.EditBox.WinHeight = W.WinHeight - MiscBevelT[B].H - MiscBevelB[B].H;
}

function Editbox_Draw(UWindowEditControl W, Canvas C)
{
	W.DrawMiscBevel(C, W.EditAreaDrawX, 0, W.EditBoxWidth, W.WinHeight, Misc, EditBoxBevel);

	if(W.Text != "")
	{
		C.DrawColor = W.TextColor;
		W.ClipText(C, W.TextX, W.TextY, W.Text);
		C.DrawColor.R = 255;
		C.DrawColor.G = 255;
		C.DrawColor.B = 255;
	}
}

function ControlFrame_SetupSizes(UWindowControlFrame W, Canvas C)
{
	local int B;

	B = EditBoxBevel;
		
	W.Framed.WinLeft = MiscBevelL[B].W;
	W.Framed.WinTop = MiscBevelT[B].H;
	W.Framed.SetSize(W.WinWidth - MiscBevelL[B].W - MiscBevelR[B].W, W.WinHeight - MiscBevelT[B].H - MiscBevelB[B].H);
}

function ControlFrame_Draw(UWindowControlFrame W, Canvas C)
{
	C.DrawColor.R = 255;
	C.DrawColor.G = 255;
	C.DrawColor.B = 255;
	
	W.DrawStretchedTexture(C, 0, 0, W.WinWidth, W.WinHeight, Texture'WhiteTexture');
	W.DrawMiscBevel(C, 0, 0, W.WinWidth, W.WinHeight, Misc, EditBoxBevel);
}

function Tab_DrawTab( UWindowTabControlTabArea Tab, Canvas C, bool bActiveTab, bool bLeftmostTab, float X, float Y, float W, float H, string Text, bool bShowText)
{
	local Region TabL, TabM, TabR;
	local Texture Tex;
	local float TW, TH, S;
	local int FontMode;

	C.DrawColor.R = 255;
	C.DrawColor.G = 255;
	C.DrawColor.B = 255;

	S = float(Max(Tab.Root.GUIScale,1)) / Tab.Root.GUIScale;
	Tex = Tab.GetLookAndFeelTexture();
	if ( bActiveTab )
	{
		TabL = TabSelectedL;
		TabM = TabSelectedM;
		TabR = TabSelectedR;
		FontMode = F_Bold; //1
	}
	else
	{
		TabL = TabUnselectedL;
		TabM = TabUnselectedM;
		TabR = TabUnselectedR;
		FontMode = F_Normal; //0
	}

	Tab.DrawStretchedTextureSegment( C, X             , Y, (TabL.W)*S         , TabL.H, TabL.X, TabL.Y, TabL.W, TabL.H, Tex );
	Tab.DrawStretchedTextureSegment( C, X+(TabL.W)*S  , Y, W-(TabL.W+TabR.W)*S, TabM.H, TabM.X, TabM.Y, TabM.W, TabM.H, Tex );
	Tab.DrawStretchedTextureSegment( C, X+W-(TabR.W)*S, Y, (TabR.W)*S         , TabR.H, TabR.X, TabR.Y, TabR.W, TabR.H, Tex );

	C.Font = Tab.Root.Fonts[FontMode];
	C.DrawColor.R = 0;
	C.DrawColor.G = 0;
	C.DrawColor.B = 0;

	if( bShowText )
	{
		Tab.TextSize(C, Text, TW, TH);
		Tab.ClipText(C, X + (W-TW)/2, Y + 3-FontMode, Text, True); //Bold text starts 1 more pixel to the left
	}
}

function SB_SetupUpButton(UWindowSBUpButton W)
{
	local Texture T;
	local float Scale;

	T = W.GetLookAndFeelTextureEx(Scale);

	W.bUseRegion = True;

	W.UpTexture = T;
	W.DownTexture = T;
	W.OverTexture = T;
	W.DisabledTexture = T;

	W.UpRegion = ScaleRegion(SBUpUp, Scale);
	W.DownRegion = ScaleRegion(SBUpDown, Scale);
	W.OverRegion = ScaleRegion(SBUpUp, Scale);
	W.DisabledRegion = ScaleRegion(SBUpDisabled, Scale);
	W.RegionScale = 1 / Scale;
}

function SB_SetupDownButton(UWindowSBDownButton W)
{
	local Texture T;
	local float Scale;

	T = W.GetLookAndFeelTextureEx(Scale);

	W.bUseRegion = True;

	W.UpTexture = T;
	W.DownTexture = T;
	W.OverTexture = T;
	W.DisabledTexture = T;

	W.UpRegion = ScaleRegion(SBDownUp, Scale);
	W.DownRegion = ScaleRegion(SBDownDown, Scale);
	W.OverRegion = ScaleRegion(SBDownUp, Scale);
	W.DisabledRegion = ScaleRegion(SBDownDisabled, Scale);
	W.RegionScale = 1 / Scale;
}



function SB_SetupLeftButton(UWindowSBLeftButton W)
{
	local Texture T;
	local float Scale;

	T = W.GetLookAndFeelTextureEx(Scale);

	W.bUseRegion = True;

	W.UpTexture = T;
	W.DownTexture = T;
	W.OverTexture = T;
	W.DisabledTexture = T;

	W.UpRegion = ScaleRegion(SBLeftUp, Scale);
	W.DownRegion = ScaleRegion(SBLeftDown, Scale);
	W.OverRegion = ScaleRegion(SBLeftUp, Scale);
	W.DisabledRegion = ScaleRegion(SBLeftDisabled, Scale);
	W.RegionScale = 1 / Scale;
}

function SB_SetupRightButton(UWindowSBRightButton W)
{
	local Texture T;
	local float Scale;

	T = W.GetLookAndFeelTextureEx(Scale);

	W.bUseRegion = True;

	W.UpTexture = T;
	W.DownTexture = T;
	W.OverTexture = T;
	W.DisabledTexture = T;

	W.UpRegion = ScaleRegion(SBRightUp, Scale);
	W.DownRegion = ScaleRegion(SBRightDown, Scale);
	W.OverRegion = ScaleRegion(SBRightUp, Scale);
	W.DisabledRegion = ScaleRegion(SBRightDisabled, Scale);
	W.RegionScale = 1 / Scale;
}

function SB_VDraw(UWindowVScrollbar W, Canvas C)
{
	local Region R;
	local Texture T;

	T = W.GetLookAndFeelTexture();

	R = SBBackground;
	W.DrawStretchedTextureSegment( C, 0, 0, W.WinWidth, W.WinHeight, R.X, R.Y, R.W, R.H, T);
	
	if(!W.bDisabled)
	{
		W.DrawUpBevel( C, 0, W.ThumbStart, Size_ScrollbarWidth,	W.ThumbHeight, T);
	}
}

function SB_HDraw(UWindowHScrollbar W, Canvas C)
{
	local Region R;
	local Texture T;

	T = W.GetLookAndFeelTexture();

	R = SBBackground;
	W.DrawStretchedTextureSegment( C, 0, 0, W.WinWidth, W.WinHeight, R.X, R.Y, R.W, R.H, T);
	
	if(!W.bDisabled) 
	{
		W.DrawUpBevel( C, W.ThumbStart, 0, W.ThumbWidth, Size_ScrollbarWidth, T);
	}
}

function Tab_SetupLeftButton(UWindowTabControlLeftButton W)
{
	local Texture T;
	local float Scale;

	T = W.GetLookAndFeelTextureEx(Scale);


	W.WinWidth = Size_ScrollbarButtonHeight;
	W.WinHeight = Size_ScrollbarWidth;
	W.WinTop = Size_TabAreaHeight - W.WinHeight;
	W.WinLeft = W.ParentWindow.WinWidth - 2*W.WinWidth;

	W.bUseRegion = True;

	W.UpTexture = T;
	W.DownTexture = T;
	W.OverTexture = T;
	W.DisabledTexture = T;

	W.UpRegion = ScaleRegion(SBLeftUp, Scale);
	W.DownRegion = ScaleRegion(SBLeftDown, Scale);
	W.OverRegion = ScaleRegion(SBLeftUp, Scale);
	W.DisabledRegion = ScaleRegion(SBLeftDisabled, Scale);
	W.RegionScale = 1 / Scale;
}

function Tab_SetupRightButton(UWindowTabControlRightButton W)
{
	local Texture T;
	local float Scale;

	T = W.GetLookAndFeelTextureEx(Scale);

	W.WinWidth = Size_ScrollbarButtonHeight;
	W.WinHeight = Size_ScrollbarWidth;
	W.WinTop = Size_TabAreaHeight - W.WinHeight;
	W.WinLeft = W.ParentWindow.WinWidth - W.WinWidth;

	W.bUseRegion = True;

	W.UpTexture = T;
	W.DownTexture = T;
	W.OverTexture = T;
	W.DisabledTexture = T;

	W.UpRegion = ScaleRegion(SBRightUp, Scale);
	W.DownRegion = ScaleRegion(SBRightDown, Scale);
	W.OverRegion = ScaleRegion(SBRightUp, Scale);
	W.DisabledRegion = ScaleRegion(SBRightDisabled, Scale);
	W.RegionScale = 1 / Scale;
}

function Tab_SetTabPageSize(UWindowPageControl W, UWindowPageWindow P)
{
	P.WinLeft = 2;
	P.WinTop = W.TabArea.WinHeight-(TabSelectedM.H-TabUnselectedM.H) + 3;
	P.SetSize(W.WinWidth - 4, W.WinHeight-(W.TabArea.WinHeight-(TabSelectedM.H-TabUnselectedM.H)) - 6);
}

function Tab_DrawTabPageArea(UWindowPageControl W, Canvas C, UWindowPageWindow P)
{
	W.DrawUpBevel( C, 0, W.TabArea.WinHeight-(TabSelectedM.H-TabUnselectedM.H), W.WinWidth, W.WinHeight-(W.TabArea.WinHeight-(TabSelectedM.H-TabUnselectedM.H)), W.GetLookAndFeelTexture());
}

function Tab_GetTabSize(UWindowTabControlTabArea Tab, Canvas C, string Text, out float W, out float H)
{
	local float TW, TH;

	C.Font = Tab.Root.Fonts[Tab.F_Bold];

	Tab.TextSize( C, Text, TW, TH );
	W = TW + Size_TabSpacing;
	H = Size_TabAreaHeight;
}

function Menu_DrawMenuBar(UWindowMenuBar W, Canvas C)
{
	W.DrawClippedTexture(C, 0, 0, Texture'UMenu.BarL');
	W.DrawStretchedTexture( C, 16, 0, W.WinWidth - 32, 16, Texture'UMenu.BarTile');
	W.DrawClippedTexture(C, W.WinWidth - 16, 0, Texture'UMenu.BarWin');
}

function Menu_DrawMenuBarItem(UWindowMenuBar B, UWindowMenuBarItem I, float X, float Y, float W, float H, Canvas C)
{
	if(B.Selected == I)
	{
		B.DrawClippedTexture(C, X, 0, Texture'BarInL');
		B.DrawClippedTexture(C, X+W-1, 0, Texture'BarInR');
		B.DrawStretchedTexture(C, X+1, 0, W-2, 16, Texture'BarInM');
	}
	else
	if (B.Over == I)
	{
		B.DrawClippedTexture(C, X, 0, Texture'BarOutL');
		B.DrawClippedTexture(C, X+W-1, 0, Texture'BarOutR');
		B.DrawStretchedTexture(C, X+1, 0, W-2, 16, Texture'BarOutM');
	}

	C.Font = B.Root.Fonts[F_Normal];
	C.DrawColor.R = 0;
	C.DrawColor.G = 0;
	C.DrawColor.B = 0;

	B.ClipText(C, X + B.SPACING / 2, 1.5, I.Caption, True);
}

function Menu_DrawPulldownMenuBackground(UWindowPulldownMenu W, Canvas C)
{
	W.DrawClippedTexture(C, 0, 0, Texture'UMenu.BMenuTL');
	W.DrawStretchedTexture(C, 4, 0, W.WinWidth-8, 4, Texture'UMenu.BMenuT');
	W.DrawClippedTexture(C, W.WinWidth-4, 0, Texture'UMenu.BMenuTR');

	W.DrawClippedTexture(C, 0, W.WinHeight-4, Texture'UMenu.BMenuBL');
	W.DrawStretchedTexture(C, 4, W.WinHeight-4, W.WinWidth-8, 4, Texture'UMenu.BMenuB');
	W.DrawClippedTexture(C, W.WinWidth-4, W.WinHeight-4, Texture'UMenu.BMenuBR');

	W.DrawStretchedTexture(C, 0, 4, 4, W.WinHeight-8, Texture'UMenu.BMenuL');
	W.DrawStretchedTexture(C, W.WinWidth-4, 4, 4, W.WinHeight-8, Texture'UMenu.BMenuR');
	W.DrawStretchedTexture(C, 4, 4, W.WinWidth-8, W.WinHeight-8, Texture'UMenu.BMenuArea');
}

function Menu_DrawPulldownMenuItem(UWindowPulldownMenu M, UWindowPulldownMenuItem Item, Canvas C, float X, float Y, float W, float H, bool bSelected)
{
	C.DrawColor.R = 255;
	C.DrawColor.G = 255;
	C.DrawColor.B = 255;

	Item.ItemTop = Y + M.WinTop;

	if(Item.Caption == "-")
	{
		C.DrawColor.R = 255;
		C.DrawColor.G = 255;
		C.DrawColor.B = 255;
		M.DrawStretchedTexture(C, X, Y+5, W, 2, Texture'UMenu.MenuLine');
		return;
	}

	C.Font = M.Root.Fonts[F_Normal];

	if(bSelected)
	{
		M.DrawClippedTexture(C, X, Y, Texture'UMenu.BMenuHL');
		M.DrawStretchedTexture(C, X + 4, Y, W - 8, 16, Texture'UMenu.BMenuHM');
		M.DrawClippedTexture(C, X + W - 4, Y, Texture'UMenu.BMenuHR');
	}

	if(Item.bDisabled) 
	{
		// Black Shadow
		C.DrawColor.R = 96;
		C.DrawColor.G = 96;
		C.DrawColor.B = 96;
	}
	else
	{
		C.DrawColor.R = 0;
		C.DrawColor.G = 0;
		C.DrawColor.B = 0;
	}

	// DrawColor will render the tick black white or gray.
	if(Item.bChecked)
		M.DrawStretchedTextureSegment( C, X + 1, Y + 3, 8, 8, 0, 0, 64, 64, Texture'MenuTickHiRes');
		
	if(Item.SubMenu != None)
		M.DrawClippedTexture(C, X + W - 9, Y + 3, Texture'MenuSubArrow');

	M.ClipText(C, X + M.TextBorder + 2, Y + 1.5, Item.Caption, True);	
}

function Button_DrawSmallButton( UWindowSmallButton B, Canvas C)
{
	local float Y, H, W;
	local float S, SB;

	if      ( B.bDisabled )  Y = 34;
	else if ( B.bMouseDown ) Y = 17;
	else                     Y = 0;

	S = float(Max(B.Root.GUIScale,1)) / B.Root.GUIScale;

	//Scale does not contain fractions, 3 drawcalls are enough
	if ( S == 1 )
	{
		W = B.WinWidth;
		H = B.WinHeight;
		B.DrawStretchedTextureSegment(C, 0  , 0, 3  , H, 0 , Y, 3 , 16, SmallButton); //L
		B.DrawStretchedTextureSegment(C, 3  , 0, W-6, H, 3 , Y, 42, 16, SmallButton); //C
		B.DrawStretchedTextureSegment(C, W-3, 0, 3  , H, 45, Y, 3 , 16, SmallButton); //R
	}
	//Button needs to be rendered with unstretched borders
	else
	{
		SB = 3.0 * S;
		W = B.WinWidth;
		H = B.WinHeight;
		B.DrawStretchedTextureSegment(C, 0      , 0   , SB    , SB    , 0 , Y   , 3 , 3  , SmallButton); //TL
		B.DrawStretchedTextureSegment(C, 0      , SB  , SB    , H-SB*2, 0 , Y+3 , 3 , 10 , SmallButton); //CL
		B.DrawStretchedTextureSegment(C, 0      , H-SB, SB    , SB    , 0 , Y+13, 3 , 3  , SmallButton); //BL
		B.DrawStretchedTextureSegment(C, SB     , 0   , W-SB*2, SB    , 3 , Y   , 42, 3  , SmallButton); //T
		B.DrawStretchedTextureSegment(C, SB     , SB  , W-SB*2, H-SB*2, 3 , Y+3 , 42, 10 , SmallButton); //C
		B.DrawStretchedTextureSegment(C, SB     , H-SB, W-SB*2, SB    , 3 , Y+13, 42, 3  , SmallButton); //B
		B.DrawStretchedTextureSegment(C, W-SB   , 0   , SB    , SB    , 45, Y   , 3 , 3  , SmallButton); //TR
		B.DrawStretchedTextureSegment(C, W-SB   , SB  , SB    , H-SB*2, 45, Y+3 , 3 , 10 , SmallButton); //CR
		B.DrawStretchedTextureSegment(C, W-SB   , H-SB, SB    , SB    , 45, Y+13, 3 , 3  , SmallButton); //BR
	}
}

simulated function PlayMenuSound(UWindowWindow W, MenuSound S)
{
	switch(S)
	{
	case MS_MenuPullDown:
		W.GetPlayerOwner().PlaySound(sound'WindowOpen', SLOT_Interface);
		break;
	case MS_MenuCloseUp:
		break;
	case MS_MenuItem:
		W.GetPlayerOwner().PlaySound(sound'LittleSelect', SLOT_Interface);
		break;
	case MS_WindowOpen:
		W.GetPlayerOwner().PlaySound(sound'BigSelect', SLOT_Interface);
		break;
	case MS_WindowClose:
		break;
	case MS_ChangeTab:
		W.GetPlayerOwner().PlaySound(sound'LittleSelect', SLOT_Interface);
		break;
	}
}

defaultproperties
{
      SmallButton=Texture'UMenu.Icons.GoldButton'
      SBUpUp=(X=20,Y=16,W=12,H=10)
      SBUpDown=(X=32,Y=16,W=12,H=10)
      SBUpDisabled=(X=44,Y=16,W=12,H=10)
      SBDownUp=(X=20,Y=26,W=12,H=10)
      SBDownDown=(X=32,Y=26,W=12,H=10)
      SBDownDisabled=(X=44,Y=26,W=12,H=10)
      SBLeftUp=(X=20,Y=48,W=10,H=12)
      SBLeftDown=(X=30,Y=48,W=10,H=12)
      SBLeftDisabled=(X=40,Y=48,W=10,H=12)
      SBRightUp=(X=20,Y=36,W=10,H=12)
      SBRightDown=(X=30,Y=36,W=10,H=12)
      SBRightDisabled=(X=40,Y=36,W=10,H=12)
      SBBackground=(X=4,Y=79,W=1,H=1)
      FrameSBL=(X=0,Y=112,W=2,H=16)
      FrameSB=(X=32,Y=112,W=1,H=16)
      FrameSBR=(X=112,Y=112,W=16,H=16)
      CloseBoxUp=(X=4,Y=32,W=11,H=11)
      CloseBoxDown=(X=4,Y=43,W=11,H=11)
      CloseBoxOffsetX=2
      CloseBoxOffsetY=2
      ChkCheckedUp=(X=0,Y=0,W=64,H=64)
      Active=Texture'UMenu.Icons.GoldActiveFrame'
      Inactive=Texture'UMenu.Icons.GoldInactiveFrame'
      ActiveS=Texture'UMenu.Icons.GoldActiveFrameS'
      InactiveS=Texture'UMenu.Icons.GoldInactiveFrameS'
      ActiveHiRes=Texture'UMenu.Icons.GoldActiveFrameHiRes'
      InactiveHiRes=Texture'UMenu.Icons.GoldInactiveFrameHiRes'
      ActiveSHiRes=Texture'UMenu.Icons.GoldActiveFrameHiRes'
      InactiveSHiRes=Texture'UMenu.Icons.GoldInactiveFrameHiRes'
      ActiveHiResScale=8.000000
      InactiveHiResScale=8.000000
      ActiveSHiResScale=8.000000
      InactiveSHiResScale=8.000000
      Misc=Texture'UWindow.Icons.Misc'
      FrameTL=(W=2,H=16)
      FrameT=(X=32,W=1,H=16)
      FrameTR=(X=126,W=2,H=16)
      FrameL=(Y=32,W=2,H=1)
      FrameR=(X=126,Y=32,W=2,H=1)
      FrameBL=(Y=125,W=2,H=3)
      FrameB=(X=32,Y=125,W=1,H=3)
      FrameBR=(X=126,Y=125,W=2,H=3)
      FrameInactiveTitleColor=(R=255,G=255,B=255)
      HeadingInActiveTitleColor=(R=255,G=255,B=255)
      FrameTitleX=6
      FrameTitleY=2
      BevelUpTL=(X=4,Y=16,W=2,H=2)
      BevelUpT=(X=10,Y=16,W=1,H=2)
      BevelUpTR=(X=18,Y=16,W=2,H=2)
      BevelUpL=(X=4,Y=20,W=2,H=1)
      BevelUpR=(X=18,Y=20,W=2,H=1)
      BevelUpBL=(X=4,Y=30,W=2,H=2)
      BevelUpB=(X=10,Y=30,W=1,H=2)
      BevelUpBR=(X=18,Y=30,W=2,H=2)
      BevelUpArea=(X=8,Y=20,W=1,H=1)
      MiscBevelTL(0)=(Y=17,W=3,H=3)
      MiscBevelTL(1)=(W=3,H=3)
      MiscBevelTL(2)=(Y=33,W=2,H=2)
      MiscBevelT(0)=(X=3,Y=17,W=116,H=3)
      MiscBevelT(1)=(X=3,W=116,H=3)
      MiscBevelT(2)=(X=2,Y=33,W=1,H=2)
      MiscBevelTR(0)=(X=119,Y=17,W=3,H=3)
      MiscBevelTR(1)=(X=119,W=3,H=3)
      MiscBevelTR(2)=(X=11,Y=33,W=2,H=2)
      MiscBevelL(0)=(Y=20,W=3,H=10)
      MiscBevelL(1)=(Y=3,W=3,H=10)
      MiscBevelL(2)=(Y=36,W=2,H=1)
      MiscBevelR(0)=(X=119,Y=20,W=3,H=10)
      MiscBevelR(1)=(X=119,Y=3,W=3,H=10)
      MiscBevelR(2)=(X=11,Y=36,W=2,H=1)
      MiscBevelBL(0)=(Y=30,W=3,H=3)
      MiscBevelBL(1)=(Y=14,W=3,H=3)
      MiscBevelBL(2)=(Y=44,W=2,H=2)
      MiscBevelB(0)=(X=3,Y=30,W=116,H=3)
      MiscBevelB(1)=(X=3,Y=14,W=116,H=3)
      MiscBevelB(2)=(X=2,Y=44,W=1,H=2)
      MiscBevelBR(0)=(X=119,Y=30,W=3,H=3)
      MiscBevelBR(1)=(X=119,Y=14,W=3,H=3)
      MiscBevelBR(2)=(X=11,Y=44,W=2,H=2)
      MiscBevelArea(0)=(X=3,Y=20,W=116,H=10)
      MiscBevelArea(1)=(X=3,Y=3,W=116,H=10)
      MiscBevelArea(2)=(X=2,Y=35,W=9,H=9)
      ComboBtnUp=(X=20,Y=60,W=12,H=12)
      ComboBtnDown=(X=32,Y=60,W=12,H=12)
      ComboBtnDisabled=(X=44,Y=60,W=12,H=12)
      ColumnHeadingHeight=16
      HLine=(X=5,Y=78,W=1,H=2)
      EditBoxBevel=2
      TabSelectedL=(X=4,Y=80,W=3,H=17)
      TabSelectedM=(X=7,Y=80,W=1,H=17)
      TabSelectedR=(X=55,Y=80,W=2,H=17)
      TabUnselectedL=(X=57,Y=80,W=3,H=15)
      TabUnselectedM=(X=60,Y=80,W=1,H=15)
      TabUnselectedR=(X=109,Y=80,W=2,H=15)
      TabBackground=(X=4,Y=79,W=1,H=1)
      Size_ScrollbarWidth=12.000000
      Size_ScrollbarButtonHeight=10.000000
      Size_MinScrollbarHeight=6.000000
      Size_TabAreaHeight=15.000000
      Size_TabAreaOverhangHeight=2.000000
      Size_TabSpacing=20.000000
      Size_TabXOffset=1.000000
      Pulldown_ItemHeight=16.000000
      Pulldown_VBorder=4.000000
      Pulldown_HBorder=3.000000
      Pulldown_TextBorder=9.000000
}
