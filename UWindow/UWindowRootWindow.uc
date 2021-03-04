//=============================================================================
// UWindowRootWindow - the root window.
//=============================================================================
class UWindowRootWindow extends UWindowWindow;

#exec TEXTURE IMPORT NAME=MouseCursor FILE=Textures\MouseCursor.bmp GROUP="Icons" FLAGS=2 MIPS=OFF
#exec TEXTURE IMPORT NAME=MouseMove FILE=Textures\MouseMove.bmp GROUP="Icons" FLAGS=2 MIPS=OFF
#exec TEXTURE IMPORT NAME=MouseDiag1 FILE=Textures\MouseDiag1.bmp GROUP="Icons" FLAGS=2 MIPS=OFF
#exec TEXTURE IMPORT NAME=MouseDiag2 FILE=Textures\MouseDiag2.bmp GROUP="Icons" FLAGS=2 MIPS=OFF
#exec TEXTURE IMPORT NAME=MouseNS FILE=Textures\MouseNS.bmp GROUP="Icons" FLAGS=2 MIPS=OFF
#exec TEXTURE IMPORT NAME=MouseWE FILE=Textures\MouseWE.bmp GROUP="Icons" FLAGS=2 MIPS=OFF
#exec TEXTURE IMPORT NAME=MouseHand FILE=Textures\MouseHand.bmp GROUP="Icons" FLAGS=2 MIPS=OFF
#exec TEXTURE IMPORT NAME=MouseHSplit FILE=Textures\MouseHSplit.bmp GROUP="Icons" FLAGS=2 MIPS=OFF
#exec TEXTURE IMPORT NAME=MouseVSplit FILE=Textures\MouseVSplit.bmp GROUP="Icons" FLAGS=2 MIPS=OFF
#exec TEXTURE IMPORT NAME=MouseWait FILE=Textures\MouseWait.bmp GROUP="Icons" FLAGS=2 MIPS=OFF

//!! Japanese text (experimental).
//#exec OBJ LOAD FILE=..\Textures\Japanese.utx

var UWindowWindow		MouseWindow;		// The window the mouse is over
var bool				bMouseCapture;
var float				MouseX, MouseY;
var float				OldMouseX, OldMouseY;
var WindowConsole		Console;
var UWindowWindow		FocusedWindow;
var UWindowWindow		KeyFocusWindow;		// window with keyboard focus
var MouseCursor			NormalCursor, MoveCursor, DiagCursor1, HandCursor, HSplitCursor, VSplitCursor, DiagCursor2, NSCursor, WECursor, WaitCursor;
var bool				bQuickKeyEnable;
var UWindowHotkeyWindowList	HotkeyWindows;
var float               GUIScale;
var config float		ConfiguredGUIScale;
var config bool         AutoGUIScale;
var float				RealWidth, RealHeight;
var Font				Fonts[10];
var UWindowLookAndFeel	LooksAndFeels[20];
var config string		LookAndFeelClass;
var bool				bRequestQuit;
var float				QuitTime;
var bool				bAllowConsole;

function BeginPlay() 
{
	Root = Self;
	MouseWindow = Self;
	KeyFocusWindow = Self;
	GUIScale = 1.0;
}

function UWindowLookAndFeel GetLookAndFeel(String LFClassName)
{
	local int i;
	local class<UWindowLookAndFeel> LFClass;

	LFClass = class<UWindowLookAndFeel>(DynamicLoadObject(LFClassName, class'Class'));

	for(i=0;i<20;i++)
	{
		if(LooksAndFeels[i] == None)
		{
			LooksAndFeels[i] = new LFClass;
			LooksAndFeels[i].Setup();
			return LooksAndFeels[i];
		}

		if(LooksAndFeels[i].Class == LFClass)
			return LooksAndFeels[i];
	}
	Log("Out of LookAndFeel array space!!");
	return None;
}


function Created() 
{
	LookAndFeel = GetLookAndFeel(LookAndFeelClass);
	SetScale(ConfiguredGUIScale);
	SetupFonts();

	NormalCursor.tex = Texture'MouseCursor';
	NormalCursor.HotX = 0;
	NormalCursor.HotY = 0;
	NormalCursor.WindowsCursor = Console.Viewport.IDC_ARROW;

	MoveCursor.tex = Texture'MouseMove';
	MoveCursor.HotX = 8;
	MoveCursor.HotY = 8;
	MoveCursor.WindowsCursor = Console.Viewport.IDC_SIZEALL;
	
	DiagCursor1.tex = Texture'MouseDiag1';
	DiagCursor1.HotX = 8;
	DiagCursor1.HotY = 8;
	DiagCursor1.WindowsCursor = Console.Viewport.IDC_SIZENWSE;
	
	HandCursor.tex = Texture'MouseHand';
	HandCursor.HotX = 11;
	HandCursor.HotY = 1;
	HandCursor.WindowsCursor = Console.Viewport.IDC_ARROW;

	HSplitCursor.tex = Texture'MouseHSplit';
	HSplitCursor.HotX = 9;
	HSplitCursor.HotY = 9;
	HSplitCursor.WindowsCursor = Console.Viewport.IDC_SIZEWE;

	VSplitCursor.tex = Texture'MouseVSplit';
	VSplitCursor.HotX = 9;
	VSplitCursor.HotY = 9;
	VSplitCursor.WindowsCursor = Console.Viewport.IDC_SIZENS;

	DiagCursor2.tex = Texture'MouseDiag2';
	DiagCursor2.HotX = 7;
	DiagCursor2.HotY = 7;
	DiagCursor2.WindowsCursor = Console.Viewport.IDC_SIZENESW;

	NSCursor.tex = Texture'MouseNS';
	NSCursor.HotX = 3;
	NSCursor.HotY = 7;
	NSCursor.WindowsCursor = Console.Viewport.IDC_SIZENS;

	WECursor.tex = Texture'MouseWE';
	WECursor.HotX = 7;
	WECursor.HotY = 3;
	WECursor.WindowsCursor = Console.Viewport.IDC_SIZEWE;

	WaitCursor.tex = Texture'MouseWait';
	WaitCursor.HotX = 6;
	WaitCursor.HotY = 9;
	WaitCursor.WindowsCursor = Console.Viewport.IDC_WAIT;


	HotkeyWindows = New class'UWindowHotkeyWindowList';
	HotkeyWindows.Last = HotkeyWindows;
	HotkeyWindows.Next = None;
	HotkeyWindows.Sentinel = HotkeyWindows;

	Cursor = NormalCursor;
}

function MoveMouse(float X, float Y)
{
	local UWindowWindow NewMouseWindow;
	local float tx, ty;

	MouseX = X;
	MouseY = Y;

	if(!bMouseCapture)
		NewMouseWindow = FindWindowUnder(X, Y);
	else
		NewMouseWindow = MouseWindow;

	if(NewMouseWindow != MouseWindow)
	{
		MouseWindow.MouseLeave();
		NewMouseWindow.MouseEnter();
		MouseWindow = NewMouseWindow;
	}

	if(MouseX != OldMouseX || MouseY != OldMouseY)
	{
		OldMouseX = MouseX;
		OldMouseY = MouseY;

		MouseWindow.GetMouseXY(tx, ty);
		MouseWindow.MouseMove(tx, ty);
	}
}

function DrawMouse(Canvas C) 
{
	local float X, Y;

	if(Console.Viewport.bWindowsMouseAvailable)
	{
		// Set the windows cursor...
		Console.Viewport.SelectedCursor = MouseWindow.Cursor.WindowsCursor;
	}
	else
	{
		C.DrawColor.R = 255;
		C.DrawColor.G = 255;
		C.DrawColor.B = 255;
		C.bNoSmooth = True;

		C.SetPos(MouseX * GUIScale - MouseWindow.Cursor.HotX, MouseY * GUIScale - MouseWindow.Cursor.HotY);
		C.DrawIcon(MouseWindow.Cursor.tex, 1.0);
	}



	/* DEBUG - show which window mouse is over

	MouseWindow.GetMouseXY(X, Y);
	C.Font = Fonts[F_Normal];

	C.DrawColor.R = 0;
	C.DrawColor.G = 0;
	C.DrawColor.B = 0;
	C.SetPos(MouseX * GUIScale - MouseWindow.Cursor.HotX, MouseY * GUIScale - MouseWindow.Cursor.HotY);
	C.DrawText( GetPlayerOwner().GetItemName(string(MouseWindow))$" "$int(MouseX * GUIScale)$", "$int(MouseY * GUIScale)$" ("$int(X)$", "$int(Y)$")");

	C.DrawColor.R = 255;
	C.DrawColor.G = 255;
	C.DrawColor.B = 0;
	C.SetPos(-1 + MouseX * GUIScale - MouseWindow.Cursor.HotX, -1 + MouseY * GUIScale - MouseWindow.Cursor.HotY);
	C.DrawText( GetPlayerOwner().GetItemName(string(MouseWindow))$" "$int(MouseX * GUIScale)$", "$int(MouseY * GUIScale)$" ("$int(X)$", "$int(Y)$")");

	*/
}

function bool CheckCaptureMouseUp()
{
	local float X, Y;

	if(bMouseCapture) {
		MouseWindow.GetMouseXY(X, Y);
		MouseWindow.LMouseUp(X, Y);
		bMouseCapture = False;
		return True;
	}
	return False;
}

function bool CheckCaptureMouseDown()
{
	local float X, Y;

	if(bMouseCapture) {
		MouseWindow.GetMouseXY(X, Y);
		MouseWindow.LMouseDown(X, Y);
		bMouseCapture = False;
		return True;
	}
	return False;
}


function CancelCapture()
{
	bMouseCapture = False;
}


function CaptureMouse(optional UWindowWindow W)
{
	bMouseCapture = True;
	if(W != None)
		MouseWindow = W;
	//Log(MouseWindow.Class$": Captured Mouse");
}

function Texture GetLookAndFeelTexture()
{
	Return LookAndFeel.Active;
}

function Texture GetLookAndFeelTextureEx(out float Scale)
{
	if (LookAndFeel.ActiveHiRes != none)
	{
		Scale = LookAndFeel.ActiveHiResScale;
		return LookAndFeel.ActiveHiRes;
	}
	Scale = 1.0;
	return LookAndFeel.Active;
}

function bool IsActive()
{
	Return True;
}

function AddHotkeyWindow(UWindowWindow W)
{
//	Log("Adding hotkeys for "$W);
	UWindowHotkeyWindowList(HotkeyWindows.Insert(class'UWindowHotkeyWindowList')).Window = W;
}

function RemoveHotkeyWindow(UWindowWindow W)
{
	local UWindowHotkeyWindowList L;

//	Log("Removing hotkeys for "$W);

	L = HotkeyWindows.FindWindow(W);
	if(L != None)
		L.Remove();
}


function WindowEvent(WinMessage Msg, Canvas C, float X, float Y, int Key) 
{
	switch(Msg) {
	case WM_KeyDown:
		if(HotKeyDown(Key, X, Y))
			return;
		break;
	case WM_KeyUp:
		if(HotKeyUp(Key, X, Y))
			return;
		break;
	}

	Super.WindowEvent(Msg, C, X, Y, Key);
}


function bool HotKeyDown(int Key, float X, float Y)
{
	local UWindowHotkeyWindowList l;

	l = UWindowHotkeyWindowList(HotkeyWindows.Next);
	while(l != None) 
	{
		if(l.Window != Self && l.Window.HotKeyDown(Key, X, Y)) return True;
		l = UWindowHotkeyWindowList(l.Next);
	}

	return False;
}

function bool HotKeyUp(int Key, float X, float Y)
{
	local UWindowHotkeyWindowList l;

	l = UWindowHotkeyWindowList(HotkeyWindows.Next);
	while(l != None) 
	{
		if(l.Window != Self && l.Window.HotKeyUp(Key, X, Y)) return True;
		l = UWindowHotkeyWindowList(l.Next);
	}

	return False;
}

function CloseActiveWindow()
{
	if(ActiveWindow != None)
		ActiveWindow.EscClose();
	else
		Console.CloseUWindow();
}

function Resized()
{
	ResolutionChanged(WinWidth, WinHeight);
}

function SetScale(float NewScale)
{
	ConfiguredGUIScale = NewScale;
	CalculateEffectiveGUIScale();
	
	WinWidth = RealWidth / GUIScale;
	WinHeight = RealHeight / GUIScale;

	ClippingRegion.X = 0;
	ClippingRegion.Y = 0;
	ClippingRegion.W = WinWidth;
	ClippingRegion.H = WinHeight;

	SetupFonts();

	Resized();
}

function CalculateEffectiveGUIScale()
{
	local int DPI;
	local float Scale;
	local int ClosestSupportedScale;

	if (AutoGUIScale)
	{
		DPI = class'Canvas'.static.GetDesktopDPI();
		Scale = DPI*100 / 96;

		ClosestSupportedScale = int(Scale);
		// make sure it's divisible by 25
		ClosestSupportedScale -= ClosestSupportedScale % 25;
		// clamp
		ClosestSupportedScale = Max(Min(ClosestSupportedScale, 300), 100);

		GUIScale = float(ClosestSupportedScale) / 100.0;
		Log("Calculated Effective GUI Scale:"@GUIScale);
	}
	else
	{
		GUIScale = ConfiguredGUIScale;
		Log("Using Configured GUI Scale:"@GUIScale);
	}
}

function SetupFonts()
{
	//!! Japanese text (experimental).
	/*if( true )
	{
		Fonts[F_Normal]    = Font(DynamicLoadObject("Japanese.Japanese", class'Font'));
		Fonts[F_Bold]      = Font(DynamicLoadObject("Japanese.Japanese", class'Font'));
		Fonts[F_Large]     = Font(DynamicLoadObject("Japanese.Japanese", class'Font'));
		Fonts[F_LargeBold] = Font(DynamicLoadObject("Japanese.Japanese", class'Font'));
		return;
	}*/
	if(GUIScale == 3)
	{
		Fonts[F_Normal] = Font(DynamicLoadObject("UWindowFonts.Tahoma30", class'Font'));
		Fonts[F_Bold] = Font(DynamicLoadObject("UWindowFonts.TahomaB30", class'Font'));
		Fonts[F_Large] = Font(DynamicLoadObject("UWindowFonts.Tahoma40", class'Font'));
		Fonts[F_LargeBold] = Font(DynamicLoadObject("UWindowFonts.TahomaB40", class'Font'));
	}
	else if(GUIScale == 2.75)
	{
		Fonts[F_Normal] = Font(DynamicLoadObject("UWindowFonts.Tahoma27", class'Font'));
		Fonts[F_Bold] = Font(DynamicLoadObject("UWindowFonts.TahomaB27", class'Font'));
		Fonts[F_Large] = Font(DynamicLoadObject("UWindowFonts.Tahoma37", class'Font'));
		Fonts[F_LargeBold] = Font(DynamicLoadObject("UWindowFonts.TahomaB37", class'Font'));
	}
	else if(GUIScale == 2.5)
	{
		Fonts[F_Normal] = Font(DynamicLoadObject("UWindowFonts.Tahoma25", class'Font'));
		Fonts[F_Bold] = Font(DynamicLoadObject("UWindowFonts.TahomaB25", class'Font'));
		Fonts[F_Large] = Font(DynamicLoadObject("UWindowFonts.Tahoma35", class'Font'));
		Fonts[F_LargeBold] = Font(DynamicLoadObject("UWindowFonts.TahomaB35", class'Font'));
	}
	else if(GUIScale == 2.25)
	{
		Fonts[F_Normal] = Font(DynamicLoadObject("UWindowFonts.Tahoma22", class'Font'));
		Fonts[F_Bold] = Font(DynamicLoadObject("UWindowFonts.TahomaB22", class'Font'));
		Fonts[F_Large] = Font(DynamicLoadObject("UWindowFonts.Tahoma32", class'Font'));
		Fonts[F_LargeBold] = Font(DynamicLoadObject("UWindowFonts.TahomaB32", class'Font'));
	}
	else if(GUIScale == 2)
	{
		Fonts[F_Normal] = Font(DynamicLoadObject("UWindowFonts.Tahoma20", class'Font'));
		Fonts[F_Bold] = Font(DynamicLoadObject("UWindowFonts.TahomaB20", class'Font'));
		Fonts[F_Large] = Font(DynamicLoadObject("UWindowFonts.Tahoma30", class'Font'));
		Fonts[F_LargeBold] = Font(DynamicLoadObject("UWindowFonts.TahomaB30", class'Font'));
	}
	else if(GUIScale == 1.75)
	{
		Fonts[F_Normal] = Font(DynamicLoadObject("UWindowFonts.Tahoma17", class'Font'));
		Fonts[F_Bold] = Font(DynamicLoadObject("UWindowFonts.TahomaB17", class'Font'));
		Fonts[F_Large] = Font(DynamicLoadObject("UWindowFonts.Tahoma27", class'Font'));
		Fonts[F_LargeBold] = Font(DynamicLoadObject("UWindowFonts.TahomaB27", class'Font'));
	}
	else if(GUIScale == 1.5)
	{
		Fonts[F_Normal] = Font(DynamicLoadObject("UWindowFonts.Tahoma15", class'Font'));
		Fonts[F_Bold] = Font(DynamicLoadObject("UWindowFonts.TahomaB15", class'Font'));
		Fonts[F_Large] = Font(DynamicLoadObject("UWindowFonts.Tahoma25", class'Font'));
		Fonts[F_LargeBold] = Font(DynamicLoadObject("UWindowFonts.TahomaB25", class'Font'));
	}
	else if(GUIScale == 1.25)
	{
		Fonts[F_Normal] = Font(DynamicLoadObject("UWindowFonts.Tahoma12", class'Font'));
		Fonts[F_Bold] = Font(DynamicLoadObject("UWindowFonts.TahomaB12", class'Font'));
		Fonts[F_Large] = Font(DynamicLoadObject("UWindowFonts.Tahoma22", class'Font'));
		Fonts[F_LargeBold] = Font(DynamicLoadObject("UWindowFonts.TahomaB20", class'Font'));
	}
	else if(GUIScale == 1)
	{
		Fonts[F_Normal] = Font(DynamicLoadObject("UWindowFonts.Tahoma10", class'Font'));
		Fonts[F_Bold] = Font(DynamicLoadObject("UWindowFonts.TahomaB10", class'Font'));
		Fonts[F_Large] = Font(DynamicLoadObject("UWindowFonts.Tahoma20", class'Font'));
		Fonts[F_LargeBold] = Font(DynamicLoadObject("UWindowFonts.TahomaB20", class'Font'));
	}	
	else
	{
		Fonts[F_Normal] = class'Canvas'.static.CreateFont(FF_Tahoma, 10*GUIScale, false, false, false, false, true);
		Fonts[F_Bold] = class'Canvas'.static.CreateFont(FF_Tahoma, 10*GUIScale, true, false, false, false, true);
		Fonts[F_Large] = class'Canvas'.static.CreateFont(FF_Tahoma, 20*GUIScale, false, false, false, false, true);
		Fonts[F_LargeBold] = class'Canvas'.static.CreateFont(FF_Tahoma, 20*GUIScale, true, false, false, false, true);
	}

	if (Fonts[F_Normal] == none ||
	   Fonts[F_Bold] == none ||
	   Fonts[F_Large] == none ||
	   Fonts[F_LargeBold] == none)
	{
		Fonts[F_Normal] = Font(DynamicLoadObject("UWindowFonts.Tahoma10", class'Font'));
		Fonts[F_Bold] = Font(DynamicLoadObject("UWindowFonts.TahomaB10", class'Font'));
		Fonts[F_Large] = Font(DynamicLoadObject("UWindowFonts.Tahoma20", class'Font'));
		Fonts[F_LargeBold] = Font(DynamicLoadObject("UWindowFonts.TahomaB20", class'Font'));
	}
}

function ChangeLookAndFeel(string NewLookAndFeel)
{
	LookAndFeelClass = NewLookAndFeel;
	SaveConfig();

	// Completely restart UWindow system on the next paint
	Console.ResetUWindow();
}

function HideWindow()
{
}

function SetMousePos(float X, float Y)
{
	Console.MouseX = X;
	Console.MouseY = Y;
}

function QuitGame()
{
	bRequestQuit = True;
	QuitTime = 0;
	NotifyQuitUnreal();
}

function DoQuitGame()
{
	SaveConfig();
	Console.SaveConfig();
	Console.ViewPort.Actor.SaveConfig();
	Close();
	Console.Viewport.Actor.ConsoleCommand("exit");
}

function Tick(float Delta)
{
	if(bRequestQuit)
	{
		// Give everything time to close itself down (ie sockets).
		if(QuitTime > 0.25)
			DoQuitGame();
		QuitTime += Delta;
	}

	Super.Tick(Delta);
}

defaultproperties
{
      MouseWindow=None
      bMouseCapture=False
      MouseX=0.000000
      MouseY=0.000000
      OldMouseX=0.000000
      OldMouseY=0.000000
      Console=None
      FocusedWindow=None
      KeyFocusWindow=None
      NormalCursor=(Tex=None,HotX=0,HotY=0,WindowsCursor=0)
      MoveCursor=(Tex=None,HotX=0,HotY=0,WindowsCursor=0)
      DiagCursor1=(Tex=None,HotX=0,HotY=0,WindowsCursor=0)
      HandCursor=(Tex=None,HotX=0,HotY=0,WindowsCursor=0)
      HSplitCursor=(Tex=None,HotX=0,HotY=0,WindowsCursor=0)
      VSplitCursor=(Tex=None,HotX=0,HotY=0,WindowsCursor=0)
      DiagCursor2=(Tex=None,HotX=0,HotY=0,WindowsCursor=0)
      NSCursor=(Tex=None,HotX=0,HotY=0,WindowsCursor=0)
      WECursor=(Tex=None,HotX=0,HotY=0,WindowsCursor=0)
      WaitCursor=(Tex=None,HotX=0,HotY=0,WindowsCursor=0)
      bQuickKeyEnable=False
      HotkeyWindows=None
      GUIScale=0.000000
      ConfiguredGUIScale=1.000000
      AutoGUIScale=True
      RealWidth=0.000000
      RealHeight=0.000000
      Fonts(0)=None
      Fonts(1)=None
      Fonts(2)=None
      Fonts(3)=None
      Fonts(4)=None
      Fonts(5)=None
      Fonts(6)=None
      Fonts(7)=None
      Fonts(8)=None
      Fonts(9)=None
      LooksAndFeels(0)=None
      LooksAndFeels(1)=None
      LooksAndFeels(2)=None
      LooksAndFeels(3)=None
      LooksAndFeels(4)=None
      LooksAndFeels(5)=None
      LooksAndFeels(6)=None
      LooksAndFeels(7)=None
      LooksAndFeels(8)=None
      LooksAndFeels(9)=None
      LooksAndFeels(10)=None
      LooksAndFeels(11)=None
      LooksAndFeels(12)=None
      LooksAndFeels(13)=None
      LooksAndFeels(14)=None
      LooksAndFeels(15)=None
      LooksAndFeels(16)=None
      LooksAndFeels(17)=None
      LooksAndFeels(18)=None
      LooksAndFeels(19)=None
      LookAndFeelClass=""
      bRequestQuit=False
      QuitTime=0.000000
      bAllowConsole=True
}
