class UMenuBlueLookAndFeel extends UMenuGoldLookAndFeel;

#exec TEXTURE IMPORT NAME=BlueActiveFrame FILE=Textures\b_ActiveFrame.pcx GROUP="Icons" FLAGS=2 MIPS=OFF
#exec TEXTURE IMPORT NAME=BlueActiveFrameHiRes FILE=Textures\b_ActiveFrameHiRes.bmp GROUP="Icons" MIPS=OFF
#exec TEXTURE IMPORT NAME=BlueInactiveFrame FILE=Textures\b_InactiveFrame.pcx GROUP="Icons" FLAGS=2 MIPS=OFF
#exec TEXTURE IMPORT NAME=BlueActiveFrameS FILE=Textures\b_ActiveFrameS.pcx GROUP="Icons" FLAGS=2 MIPS=OFF
#exec TEXTURE IMPORT NAME=BlueInactiveFrameS FILE=Textures\b_InactiveFrameS.pcx GROUP="Icons" FLAGS=2 MIPS=OFF

#exec TEXTURE IMPORT NAME=BlueMisc FILE=Textures\b_Misc.bmp GROUP="Icons" MIPS=OFF
#exec TEXTURE IMPORT NAME=BlueButton FILE=Textures\b_SmallButton.pcx GROUP="Icons" MIPS=OFF

#exec TEXTURE IMPORT NAME=BlueMenuArea FILE=Textures\b_MenuArea.bmp GROUP="Icons" MIPS=OFF
#exec TEXTURE IMPORT NAME=BlueClientArea FILE=Textures\b_ClientArea.bmp GROUP="Icons" MIPS=OFF
#exec TEXTURE IMPORT NAME=BlueMenuTL FILE=Textures\b_MenuTL.bmp GROUP="Icons" MIPS=OFF
#exec TEXTURE IMPORT NAME=BlueMenuT FILE=Textures\b_MenuT.bmp GROUP="Icons" MIPS=OFF
#exec TEXTURE IMPORT NAME=BlueMenuTR FILE=Textures\b_MenuTR.bmp GROUP="Icons" MIPS=OFF
#exec TEXTURE IMPORT NAME=BlueMenuL FILE=Textures\b_MenuL.bmp GROUP="Icons" MIPS=OFF
#exec TEXTURE IMPORT NAME=BlueMenuR FILE=Textures\b_MenuR.bmp GROUP="Icons" MIPS=OFF
#exec TEXTURE IMPORT NAME=BlueMenuBL FILE=Textures\b_MenuBL.bmp GROUP="Icons" MIPS=OFF
#exec TEXTURE IMPORT NAME=BlueMenuB FILE=Textures\b_MenuB.bmp GROUP="Icons" MIPS=OFF
#exec TEXTURE IMPORT NAME=BlueMenuBR FILE=Textures\b_MenuBR.bmp GROUP="Icons" MIPS=OFF
#exec TEXTURE IMPORT NAME=BlueMenuHL FILE=Textures\b_MenuHL.bmp GROUP="Icons" MIPS=OFF
#exec TEXTURE IMPORT NAME=BlueMenuHM FILE=Textures\b_MenuHM.bmp GROUP="Icons" MIPS=OFF
#exec TEXTURE IMPORT NAME=BlueMenuHR FILE=Textures\b_MenuHR.bmp GROUP="Icons" MIPS=OFF
#exec TEXTURE IMPORT NAME=BlueMenuLine FILE=Textures\b_MenuLine.bmp GROUP="Icons" MIPS=OFF

#exec TEXTURE IMPORT NAME=BlueBarL FILE=Textures\b_BarL.bmp GROUP="Icons" MIPS=OFF
#exec TEXTURE IMPORT NAME=BlueBarTile FILE=Textures\b_BarTile.bmp GROUP="Icons" MIPS=OFF
#exec TEXTURE IMPORT NAME=BlueBarMax FILE=Textures\b_BarMax.bmp GROUP="Icons" MIPS=OFF
#exec TEXTURE IMPORT NAME=BlueBarWin FILE=Textures\b_BarWin.bmp GROUP="Icons" MIPS=OFF


#exec TEXTURE IMPORT NAME=BlueBarInL FILE=Textures\b_BarInL.bmp GROUP="Icons" MIPS=OFF
#exec TEXTURE IMPORT NAME=BlueBarInR FILE=Textures\b_BarInR.bmp GROUP="Icons" MIPS=OFF
#exec TEXTURE IMPORT NAME=BlueBarInM FILE=Textures\b_BarInM.bmp GROUP="Icons" MIPS=OFF

#exec TEXTURE IMPORT NAME=BlueBarOutL FILE=Textures\b_BarOutL.bmp GROUP="Icons" MIPS=OFF
#exec TEXTURE IMPORT NAME=BlueBarOutR FILE=Textures\b_BarOutR.bmp GROUP="Icons" MIPS=OFF
#exec TEXTURE IMPORT NAME=BlueBarOutM FILE=Textures\b_BarOutM.bmp GROUP="Icons" MIPS=OFF

/* Client Area Drawing Functions */
function DrawClientArea(UWindowClientWindow W, Canvas C)
{
	W.DrawClippedTexture(C, 0, 0, Texture'BlueMenuTL');
	W.DrawStretchedTexture(C, 2, 0, W.WinWidth-4, 2, Texture'BlueMenuT');
	W.DrawClippedTexture(C, W.WinWidth-2, 0, Texture'BlueMenuTR');

	W.DrawClippedTexture(C, 0, W.WinHeight-2, Texture'BlueMenuBL');
	W.DrawStretchedTexture(C, 2, W.WinHeight-2, W.WinWidth-4, 2, Texture'BlueMenuB');
	W.DrawClippedTexture(C, W.WinWidth-2, W.WinHeight-2, Texture'BlueMenuBR');

	W.DrawStretchedTexture(C, 0, 2, 2, W.WinHeight-4, Texture'BlueMenuL');
	W.DrawStretchedTexture(C, W.WinWidth-2, 2, 2, W.WinHeight-4, Texture'BlueMenuR');

	W.DrawStretchedTexture(C, 2, 2, W.WinWidth-4, W.WinHeight-4, Texture'BlueClientArea');
}


/* Combo Drawing Functions */

function ComboList_DrawBackground(UWindowComboList W, Canvas C)
{
	W.DrawClippedTexture(C, 0, 0, Texture'UMenu.BlueMenuTL');
	W.DrawStretchedTexture(C, 4, 0, W.WinWidth-8, 4, Texture'UMenu.BlueMenuT');
	W.DrawClippedTexture(C, W.WinWidth-4, 0, Texture'UMenu.BlueMenuTR');

	W.DrawClippedTexture(C, 0, W.WinHeight-4, Texture'UMenu.BlueMenuBL');
	W.DrawStretchedTexture(C, 4, W.WinHeight-4, W.WinWidth-8, 4, Texture'UMenu.BlueMenuB');
	W.DrawClippedTexture(C, W.WinWidth-4, W.WinHeight-4, Texture'UMenu.BlueMenuBR');

	W.DrawStretchedTexture(C, 0, 4, 4, W.WinHeight-8, Texture'UMenu.BlueMenuL');
	W.DrawStretchedTexture(C, W.WinWidth-4, 4, 4, W.WinHeight-8, Texture'UMenu.BlueMenuR');

	W.DrawStretchedTexture(C, 4, 4, W.WinWidth-8, W.WinHeight-8, Texture'UMenu.BlueMenuArea');
}

function ComboList_DrawItem(UWindowComboList Combo, Canvas C, float X, float Y, float W, float H, string Text, bool bSelected)
{
	C.DrawColor.R = 255;
	C.DrawColor.G = 255;
	C.DrawColor.B = 255;

	if(bSelected)
	{
		Combo.DrawClippedTexture(C, X, Y, Texture'UMenu.BlueMenuHL');
		Combo.DrawStretchedTexture(C, X + 4, Y, W - 8, 16, Texture'UMenu.BlueMenuHM');
		Combo.DrawClippedTexture(C, X + W - 4, Y, Texture'UMenu.BlueMenuHR');
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
	W.DrawClippedTexture(C, 0, 0, Texture'UMenu.BlueBarL');
	W.DrawStretchedTexture( C, 16, 0, W.WinWidth - 32, 16, Texture'UMenu.BlueBarTile');
	W.DrawClippedTexture(C, W.WinWidth - 16, 0, Texture'UMenu.BlueBarWin');
}

function Menu_DrawMenuBarItem(UWindowMenuBar B, UWindowMenuBarItem I, float X, float Y, float W, float H, Canvas C)
{
	if(B.Selected == I)
	{
		B.DrawClippedTexture(C, X, 0, Texture'BlueBarInL');
		B.DrawClippedTexture(C, X+W-1, 0, Texture'BlueBarInR');
		B.DrawStretchedTexture(C, X+1, 0, W-2, 16, Texture'BlueBarInM');
	}
	else
	if (B.Over == I)
	{
		B.DrawClippedTexture(C, X, 0, Texture'BlueBarOutL');
		B.DrawClippedTexture(C, X+W-1, 0, Texture'BlueBarOutR');
		B.DrawStretchedTexture(C, X+1, 0, W-2, 16, Texture'BlueBarOutM');
	}

	C.Font = B.Root.Fonts[F_Normal];
	C.DrawColor.R = 0;
	C.DrawColor.G = 0;
	C.DrawColor.B = 0;

	B.ClipText(C, X + B.SPACING / 2, 1.5, I.Caption, True);
}

function Menu_DrawPulldownMenuBackground(UWindowPulldownMenu W, Canvas C)
{
	W.DrawClippedTexture(C, 0, 0, Texture'UMenu.BlueMenuTL');
	W.DrawStretchedTexture(C, 4, 0, W.WinWidth-8, 4, Texture'UMenu.BlueMenuT');
	W.DrawClippedTexture(C, W.WinWidth-4, 0, Texture'UMenu.BlueMenuTR');

	W.DrawClippedTexture(C, 0, W.WinHeight-4, Texture'UMenu.BlueMenuBL');
	W.DrawStretchedTexture(C, 4, W.WinHeight-4, W.WinWidth-8, 4, Texture'UMenu.BlueMenuB');
	W.DrawClippedTexture(C, W.WinWidth-4, W.WinHeight-4, Texture'UMenu.BlueMenuBR');

	W.DrawStretchedTexture(C, 0, 4, 4, W.WinHeight-8, Texture'UMenu.BlueMenuL');
	W.DrawStretchedTexture(C, W.WinWidth-4, 4, 4, W.WinHeight-8, Texture'UMenu.BlueMenuR');
	W.DrawStretchedTexture(C, 4, 4, W.WinWidth-8, W.WinHeight-8, Texture'UMenu.BlueMenuArea');
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
		M.DrawStretchedTexture(C, X, Y+5, W, 2, Texture'UMenu.BlueMenuLine');
		return;
	}

	C.Font = M.Root.Fonts[F_Normal];

	if(bSelected)
	{
		M.DrawClippedTexture(C, X, Y, Texture'UMenu.BlueMenuHL');
		M.DrawStretchedTexture(C, X + 4, Y, W - 8, 16, Texture'UMenu.BlueMenuHM');
		M.DrawClippedTexture(C, X + W - 4, Y, Texture'UMenu.BlueMenuHR');
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
      SmallButton=Texture'UMenu.Icons.BlueButton'
      Active=Texture'UMenu.Icons.BlueActiveFrame'
      Inactive=Texture'UMenu.Icons.BlueInactiveFrame'
      ActiveS=Texture'UMenu.Icons.BlueActiveFrameS'
      InactiveS=Texture'UMenu.Icons.BlueInactiveFrameS'
      ActiveHiRes=Texture'UMenu.Icons.BlueActiveFrameHiRes'
      ActiveSHiRes=Texture'UMenu.Icons.BlueActiveFrameHiRes'
      Misc=Texture'UMenu.Icons.BlueMisc'
}
