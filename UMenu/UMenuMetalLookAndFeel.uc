class UMenuMetalLookAndFeel extends UMenuGoldLookAndFeel;

#exec TEXTURE IMPORT NAME=MetalActiveFrame FILE=Textures\M_ActiveFrame.bmp GROUP="Icons" FLAGS=2 MIPS=OFF
#exec TEXTURE IMPORT NAME=MetalActiveFrameHiRes FILE=Textures\M_ActiveFrameHiRes.bmp GROUP="Icons" MIPS=OFF
#exec TEXTURE IMPORT NAME=MetalInactiveFrame FILE=Textures\M_InactiveFrame.bmp GROUP="Icons" FLAGS=2 MIPS=OFF
#exec TEXTURE IMPORT NAME=MetalActiveFrameS FILE=Textures\M_ActiveFrameS.bmp GROUP="Icons" FLAGS=2 MIPS=OFF
#exec TEXTURE IMPORT NAME=MetalInactiveFrameS FILE=Textures\M_InactiveFrameS.bmp GROUP="Icons" FLAGS=2 MIPS=OFF

#exec TEXTURE IMPORT NAME=MetalMisc FILE=Textures\M_Misc.bmp GROUP="Icons" MIPS=OFF
#exec TEXTURE IMPORT NAME=MetalButton FILE=Textures\M_SmallButton.pcx GROUP="Icons" MIPS=OFF

#exec TEXTURE IMPORT NAME=MetalMenuArea FILE=Textures\M_MenuArea.bmp GROUP="Icons" MIPS=OFF
#exec TEXTURE IMPORT NAME=MetalClientArea FILE=Textures\M_ClientArea.bmp GROUP="Icons" MIPS=OFF
#exec TEXTURE IMPORT NAME=MetalMenuTL FILE=Textures\M_MenuTL.bmp GROUP="Icons" MIPS=OFF
#exec TEXTURE IMPORT NAME=MetalMenuT FILE=Textures\M_MenuT.bmp GROUP="Icons" MIPS=OFF
#exec TEXTURE IMPORT NAME=MetalMenuTR FILE=Textures\M_MenuTR.bmp GROUP="Icons" MIPS=OFF
#exec TEXTURE IMPORT NAME=MetalMenuL FILE=Textures\M_MenuL.bmp GROUP="Icons" MIPS=OFF
#exec TEXTURE IMPORT NAME=MetalMenuR FILE=Textures\M_MenuR.bmp GROUP="Icons" MIPS=OFF
#exec TEXTURE IMPORT NAME=MetalMenuBL FILE=Textures\M_MenuBL.bmp GROUP="Icons" MIPS=OFF
#exec TEXTURE IMPORT NAME=MetalMenuB FILE=Textures\M_MenuB.bmp GROUP="Icons" MIPS=OFF
#exec TEXTURE IMPORT NAME=MetalMenuBR FILE=Textures\M_MenuBR.bmp GROUP="Icons" MIPS=OFF
#exec TEXTURE IMPORT NAME=MetalMenuHL FILE=Textures\M_MenuHL.bmp GROUP="Icons" MIPS=OFF
#exec TEXTURE IMPORT NAME=MetalMenuHM FILE=Textures\M_MenuHM.bmp GROUP="Icons" MIPS=OFF
#exec TEXTURE IMPORT NAME=MetalMenuHR FILE=Textures\M_MenuHR.bmp GROUP="Icons" MIPS=OFF
#exec TEXTURE IMPORT NAME=MetalMenuLine FILE=Textures\M_MenuLine.bmp GROUP="Icons" MIPS=OFF

#exec TEXTURE IMPORT NAME=MetalBarL FILE=Textures\M_BarL.bmp GROUP="Icons" MIPS=OFF
#exec TEXTURE IMPORT NAME=MetalBarTile FILE=Textures\M_BarTile.bmp GROUP="Icons" MIPS=OFF
#exec TEXTURE IMPORT NAME=MetalBarMax FILE=Textures\M_BarMax.bmp GROUP="Icons" MIPS=OFF
#exec TEXTURE IMPORT NAME=MetalBarWin FILE=Textures\M_BarWin.bmp GROUP="Icons" MIPS=OFF


#exec TEXTURE IMPORT NAME=MetalBarInL FILE=Textures\M_BarInL.bmp GROUP="Icons" MIPS=OFF
#exec TEXTURE IMPORT NAME=MetalBarInR FILE=Textures\M_BarInR.bmp GROUP="Icons" MIPS=OFF
#exec TEXTURE IMPORT NAME=MetalBarInM FILE=Textures\M_BarInM.bmp GROUP="Icons" MIPS=OFF

#exec TEXTURE IMPORT NAME=MetalBarOutL FILE=Textures\M_BarOutL.bmp GROUP="Icons" MIPS=OFF
#exec TEXTURE IMPORT NAME=MetalBarOutR FILE=Textures\M_BarOutR.bmp GROUP="Icons" MIPS=OFF
#exec TEXTURE IMPORT NAME=MetalBarOutM FILE=Textures\M_BarOutM.bmp GROUP="Icons" MIPS=OFF


/* Client Area Drawing Functions */
function DrawClientArea(UWindowClientWindow W, Canvas C)
{
	W.DrawClippedTexture(C, 0, 0, Texture'MetalMenuTL');
	W.DrawStretchedTexture(C, 2, 0, W.WinWidth-4, 2, Texture'MetalMenuT');
	W.DrawClippedTexture(C, W.WinWidth-2, 0, Texture'MetalMenuTR');

	W.DrawClippedTexture(C, 0, W.WinHeight-2, Texture'MetalMenuBL');
	W.DrawStretchedTexture(C, 2, W.WinHeight-2, W.WinWidth-4, 2, Texture'MetalMenuB');
	W.DrawClippedTexture(C, W.WinWidth-2, W.WinHeight-2, Texture'MetalMenuBR');

	W.DrawStretchedTexture(C, 0, 2, 2, W.WinHeight-4, Texture'MetalMenuL');
	W.DrawStretchedTexture(C, W.WinWidth-2, 2, 2, W.WinHeight-4, Texture'MetalMenuR');

	W.DrawStretchedTexture(C, 2, 2, W.WinWidth-4, W.WinHeight-4, Texture'MetalClientArea');
}


/* Combo Drawing Functions */

function ComboList_DrawBackground(UWindowComboList W, Canvas C)
{
	W.DrawClippedTexture(C, 0, 0, Texture'UMenu.MetalMenuTL');
	W.DrawStretchedTexture(C, 4, 0, W.WinWidth-8, 4, Texture'UMenu.MetalMenuT');
	W.DrawClippedTexture(C, W.WinWidth-4, 0, Texture'UMenu.MetalMenuTR');

	W.DrawClippedTexture(C, 0, W.WinHeight-4, Texture'UMenu.MetalMenuBL');
	W.DrawStretchedTexture(C, 4, W.WinHeight-4, W.WinWidth-8, 4, Texture'UMenu.MetalMenuB');
	W.DrawClippedTexture(C, W.WinWidth-4, W.WinHeight-4, Texture'UMenu.MetalMenuBR');

	W.DrawStretchedTexture(C, 0, 4, 4, W.WinHeight-8, Texture'UMenu.MetalMenuL');
	W.DrawStretchedTexture(C, W.WinWidth-4, 4, 4, W.WinHeight-8, Texture'UMenu.MetalMenuR');

	W.DrawStretchedTexture(C, 4, 4, W.WinWidth-8, W.WinHeight-8, Texture'UMenu.MetalMenuArea');
}

function ComboList_DrawItem(UWindowComboList Combo, Canvas C, float X, float Y, float W, float H, string Text, bool bSelected)
{
	C.DrawColor.R = 255;
	C.DrawColor.G = 255;
	C.DrawColor.B = 255;

	if(bSelected)
	{
		Combo.DrawClippedTexture(C, X, Y, Texture'UMenu.MetalMenuHL');
		Combo.DrawStretchedTexture(C, X + 4, Y, W - 8, 16, Texture'UMenu.MetalMenuHM');
		Combo.DrawClippedTexture(C, X + W - 4, Y, Texture'UMenu.MetalMenuHR');
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

function Menu_DrawMenuBar(UWindowMenuBar W, Canvas C)
{
	W.DrawClippedTexture(C, 0, 0, Texture'UMenu.MetalBarL');
	W.DrawStretchedTexture( C, 16, 0, W.WinWidth - 32, 16, Texture'UMenu.MetalBarTile');
	W.DrawClippedTexture(C, W.WinWidth - 16, 0, Texture'UMenu.MetalBarWin');
}

function Menu_DrawMenuBarItem(UWindowMenuBar B, UWindowMenuBarItem I, float X, float Y, float W, float H, Canvas C)
{
	if(B.Selected == I)
	{
		B.DrawClippedTexture(C, X, 0, Texture'MetalBarInL');
		B.DrawClippedTexture(C, X+W-1, 0, Texture'MetalBarInR');
		B.DrawStretchedTexture(C, X+1, 0, W-2, 16, Texture'MetalBarInM');
	}
	else
	if (B.Over == I)
	{
		B.DrawClippedTexture(C, X, 0, Texture'MetalBarOutL');
		B.DrawClippedTexture(C, X+W-1, 0, Texture'MetalBarOutR');
		B.DrawStretchedTexture(C, X+1, 0, W-2, 16, Texture'MetalBarOutM');
	}

	C.Font = B.Root.Fonts[F_Normal];
	C.DrawColor.R = 0;
	C.DrawColor.G = 0;
	C.DrawColor.B = 0;

	B.ClipText(C, X + B.SPACING / 2, 1.5, I.Caption, True);
}

function Menu_DrawPulldownMenuBackground(UWindowPulldownMenu W, Canvas C)
{
	W.DrawClippedTexture(C, 0, 0, Texture'UMenu.MetalMenuTL');
	W.DrawStretchedTexture(C, 4, 0, W.WinWidth-8, 4, Texture'UMenu.MetalMenuT');
	W.DrawClippedTexture(C, W.WinWidth-4, 0, Texture'UMenu.MetalMenuTR');

	W.DrawClippedTexture(C, 0, W.WinHeight-4, Texture'UMenu.MetalMenuBL');
	W.DrawStretchedTexture(C, 4, W.WinHeight-4, W.WinWidth-8, 4, Texture'UMenu.MetalMenuB');
	W.DrawClippedTexture(C, W.WinWidth-4, W.WinHeight-4, Texture'UMenu.MetalMenuBR');

	W.DrawStretchedTexture(C, 0, 4, 4, W.WinHeight-8, Texture'UMenu.MetalMenuL');
	W.DrawStretchedTexture(C, W.WinWidth-4, 4, 4, W.WinHeight-8, Texture'UMenu.MetalMenuR');
	W.DrawStretchedTexture(C, 4, 4, W.WinWidth-8, W.WinHeight-8, Texture'UMenu.MetalMenuArea');
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
		M.DrawStretchedTexture(C, X, Y+5, W, 2, Texture'UMenu.MetalMenuLine');
		return;
	}

	C.Font = M.Root.Fonts[F_Normal];

	if(bSelected)
	{
		M.DrawClippedTexture(C, X, Y, Texture'UMenu.MetalMenuHL');
		M.DrawStretchedTexture(C, X + 4, Y, W - 8, 16, Texture'UMenu.MetalMenuHM');
		M.DrawClippedTexture(C, X + W - 4, Y, Texture'UMenu.MetalMenuHR');
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

defaultproperties
{
      SmallButton=Texture'UMenu.Icons.MetalButton'
      Active=Texture'UMenu.Icons.MetalActiveFrame'
      Inactive=Texture'UMenu.Icons.MetalInactiveFrame'
      ActiveS=Texture'UMenu.Icons.MetalActiveFrameS'
      InactiveS=Texture'UMenu.Icons.MetalInactiveFrameS'
      ActiveHiRes=Texture'UMenu.Icons.MetalActiveFrameHiRes'
      ActiveSHiRes=Texture'UMenu.Icons.MetalActiveFrameHiRes'
      Misc=Texture'UMenu.Icons.MetalMisc'
}
