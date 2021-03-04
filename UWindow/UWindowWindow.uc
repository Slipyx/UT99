//=============================================================================
// UWindowWindow - the parent class for all Window objects
//=============================================================================
class UWindowWindow extends UWindowBase;

#exec TEXTURE IMPORT NAME=BlackTexture FILE=TEXTURES\Black.PCX
#exec TEXTURE IMPORT NAME=WhiteTexture FILE=TEXTURES\White.PCX

// Dimensions, offset relative to parent.
var float				WinLeft;
var float				WinTop;
var float				WinWidth;
var float				WinHeight;

// Relationships to other windows
var UWindowWindow		ParentWindow;			// Parent window
var UWindowWindow		FirstChildWindow;		// First child window - bottom window first
var UWindowWindow		LastChildWindow;		// Last child window - WinTop window first
var UWindowWindow		NextSiblingWindow;		// sibling window - next window above us
var UWindowWindow		PrevSiblingWindow;		// previous sibling window - next window below us
var UWindowWindow		ActiveWindow;			// The child of ours which is currently active
var UWindowRootWindow	Root;					// The root window
var UWindowWindow		OwnerWindow;			// Some arbitary owner window
var UWindowWindow		ModalWindow;			// Some window we've opened modally.

var bool				bWindowVisible;
var bool				bNoClip;				// Clipping disabled for this window?
var bool				bMouseDown;				// Pressed down in this window?
var bool				bRMouseDown;			// Pressed down in this window?
var bool				bMMouseDown;			// Pressed down in this window?
var bool				bAlwaysBehind;			// Window doesn't bring to front on click.
var bool				bAcceptsFocus;			// Accepts key messages
var bool				bAlwaysOnTop;			// Always on top
var bool				bLeaveOnscreen;			// Window is left onscreen when UWindow isn't active.
var bool				bUWindowActive;			// Is UWindow active?
var bool				bTransient;				// Never the active window. Used for combo dropdowns7
var bool				bAcceptsHotKeys;		// Does this window accept hotkeys?
var bool				bIgnoreLDoubleClick;
var bool				bIgnoreMDoubleClick;
var bool				bIgnoreRDoubleClick;
var bool                bHandledEvent;

var float				ClickTime;
var float				MClickTime;
var float				RClickTime;
var float				ClickX;
var float				ClickY;
var float				MClickX;
var float				MClickY;
var float				RClickX;
var float				RClickY;

var UWindowLookAndFeel	LookAndFeel;

var Region	ClippingRegion;

struct MouseCursor
{
	var Texture tex;
	var int HotX;
	var int HotY;
	var byte WindowsCursor;
};

var MouseCursor Cursor;

enum WinMessage
{
	WM_LMouseDown,
	WM_LMouseUp,
	WM_MMouseDown,
	WM_MMouseUp,
	WM_RMouseDown,
	WM_RMouseUp,
	WM_KeyUp,
	WM_KeyDown,
	WM_KeyType,
	WM_Paint,	// Window needs painting
	WM_MouseWheelDown,
	WM_MouseWheelUp
};

// Dialog messages
const DE_Created = 0;
const DE_Change	 = 1;
const DE_Click	 = 2;
const DE_Enter	 = 3;
const DE_Exit	 = 4;
const DE_MClick	 = 5;
const DE_RClick	 = 6;
const DE_EnterPressed = 7;
const DE_MouseMove = 8;
const DE_MouseLeave = 9;
const DE_LMouseDown = 10;
const DE_DoubleClick = 11;
const DE_MouseEnter = 12;
const DE_HelpChanged = 13;
const DE_WheelUpPressed = 14;
const DE_WheelDownPressed = 15;

// Ideally Key would be a EInputKey but I can't see that class here.
function WindowEvent(WinMessage Msg, Canvas C, float X, float Y, int Key) 
{
	bHandledEvent = true;
	
	switch(Msg)
	{
	case WM_Paint:
		Paint(C, X, Y);
		PaintClients(C, X, Y);
		break;
	case WM_LMouseDown:
		if(!Root.CheckCaptureMouseDown() && !MessageClients(Msg, C, X, Y, Key))
			LMouseDown(X, Y);
		break;	
	case WM_LMouseUp:
		if(!Root.CheckCaptureMouseUp() && !MessageClients(Msg, C, X, Y, Key))
			LMouseUp(X, Y);
		break;	
	case WM_RMouseDown:
		if(!MessageClients(Msg, C, X, Y, Key))
			RMouseDown(X, Y);
		break;	
	case WM_RMouseUp:
		if(!MessageClients(Msg, C, X, Y, Key))
			RMouseUp(X, Y);
		break;	
	case WM_MMouseDown:
		if(!MessageClients(Msg, C, X, Y, Key))
			MMouseDown(X, Y);
		break;	
	case WM_MMouseUp:
		if(!MessageClients(Msg, C, X, Y, Key))
			MMouseUp(X, Y);
		break;
	case WM_MouseWheelDown:
		if(!MessageClients(Msg, C, X, Y, Key))
			bHandledEvent = MouseWheelDown(float(Key));
		break;
	case WM_MouseWheelUp:
		if(!MessageClients(Msg, C, X, Y, Key))
			bHandledEvent = MouseWheelUp(float(Key));
		break;		
	case WM_KeyDown:
		if(!PropagateKey(Msg, C, X, Y, Key))
			KeyDown(Key, X, Y);
		break;	
	case WM_KeyUp:
		if(!PropagateKey(Msg, C, X, Y, Key))
			KeyUp(Key, X, Y);
		break;	
	case WM_KeyType:
		if(!PropagateKey(Msg, C, X, Y, Key))
			KeyType(Key, X, Y);
		break;	
	default:
		break;
	}
}

function SaveConfigs()
{

	// Implemented in a child class
}

final function PlayerPawn GetPlayerOwner()
{
	return Root.Console.ViewPort.Actor;
}

final function LevelInfo GetLevel()
{
	return Root.Console.ViewPort.Actor.Level;
}

final function LevelInfo GetEntryLevel()
{
	return Root.Console.ViewPort.Actor.GetEntryLevel();
}

function Resized()
{
	// Implemented in a child class
}

function BeforePaint(Canvas C, float X, float Y)
{
	// Implemented in a child class
}

function AfterPaint(Canvas C, float X, float Y)
{
	// Implemented in a child class
}

function Paint(Canvas C, float X, float Y)
{
	// Implemented in a child class
}

function Click(float X, float Y)
{
	// Implemented in a child class
}


function MClick(float X, float Y)
{
	// Implemented in a child class
}

function RClick(float X, float Y)
{
	// Implemented in a child class
}

function DoubleClick(float X, float Y)
{
	// Implemented in a child class
}

function MDoubleClick(float X, float Y)
{
	// Implemented in a child class
}

function RDoubleClick(float X, float Y)
{
	// Implemented in a child class
}

function BeginPlay()
{
	// Implemented in a child class
}

function BeforeCreate()
{
	// Implemented in a child class
}

function Created()
{
	// Implemented in a child class
}

function AfterCreate()
{
	// Implemented in a child class
}

function MouseEnter()
{
	// Implemented in a child class
}

function Activated()
{
	// Implemented in a child class
}

function Deactivated()
{
	// Implemented in a child class
}

function MouseLeave()
{
	bMouseDown = False;
	bMMouseDown = False;
	bRMouseDown = False;
}

function MouseMove(float X, float Y)
{
}

function KeyUp(int Key, float X, float Y)
{
	// Implemented in child class
}

function KeyDown(int Key, float X, float Y)
{
	// Implemented in child class
}

function bool HotKeyDown(int Key, float X, float Y)
{
	// Implemented in child class
	//Log("UWindowWindow: Checking HotKeyDown for "$Self);
	return False;
}

function bool HotKeyUp(int Key, float X, float Y)
{
	// Implemented in child class
	//Log("UWindowWindow: Checking HotKeyUp for "$Self);
	return False;
}

function KeyType(int Key, float X, float Y)
{
	// Implemented in child class
}

function ProcessMenuKey(int Key, string KeyName)
{
	// Implemented in child class
}

function KeyFocusEnter()
{
	// Implemented in child class
}

function KeyFocusExit()
{
	// Implemented in child class
}


function RMouseDown(float X, float Y) 
{
	ActivateWindow(0, False);
	bRMouseDown = True;
}

function RMouseUp(float X, float Y) 
{
	if(bRMouseDown)
	{
		if(!bIgnoreRDoubleClick && Abs(X-RClickX) <= 1 && Abs(Y-RClickY) <= 1 && GetLevel().TimeSeconds < RClickTime + 0.600)
		{
			RDoubleClick(X, Y);
			RClickTime = 0;
		}
		else
		{
			RClickTime = GetLevel().TimeSeconds;
			RClickX = X;
			RClickY = Y;
			RClick(X, Y);
		}
	}
	bRMouseDown = False;

}

function MMouseDown(float X, float Y) 
{
	ActivateWindow(0, False);
	/* DEBUG
	HideWindow();
	*/
	bMMouseDown = True;
}

function MMouseUp(float X, float Y) 
{
	if(bMMouseDown)
	{
		if(!bIgnoreMDoubleClick && Abs(X-MClickX) <= 1 && (Y-MClickY)<=1 && GetLevel().TimeSeconds < MClickTime + 0.600)
		{
			MDoubleClick(X, Y);
			MClickTime = 0;
		}
		else
		{
			MClickTime = GetLevel().TimeSeconds;
			MClickX = X;
			MClickY = Y;
			MClick(X, Y);
		}
	}
	bMMouseDown = False;
}


function LMouseDown(float X, float Y)
{
	ActivateWindow(0, False);
	bMouseDown = True;
}

function LMouseUp(float X, float Y)
{
	if(bMouseDown)
	{
		if(!bIgnoreLDoubleClick && Abs(X-ClickX) <= 1 && (Y-ClickY) <= 1 && GetLevel().TimeSeconds < ClickTime + 0.600)
		{
			DoubleClick(X, Y);
			ClickTime = 0;
		}
		else
		{
			ClickTime = GetLevel().TimeSeconds;
			ClickX = X;
			ClickY = Y;
			Click(X, Y);
		}
	}
	bMouseDown = False;
}

function bool MouseWheelDown(float ScrollDelta)
{
	ActivateWindow(0, False);
	bMouseDown = True;
	return false;
}

function bool MouseWheelUp(float ScrollDelta)
{
	bMouseDown = False;
	return false;
}

function FocusWindow()
{
	if(Root.FocusedWindow != None && Root.FocusedWindow != Self)
		Root.FocusedWindow.FocusOtherWindow(Self);

	Root.FocusedWindow = Self;
}

function FocusOtherWindow(UWindowWindow W)
{
}

function EscClose()
{
	Close();
}

function Close(optional bool bByParent)
{
	local UWindowWindow Prev, Child;

	for(Child = LastChildWindow;Child != None;Child = Prev)
	{
		Prev = Child.PrevSiblingWindow;
		Child.Close(True);
	}
	SaveConfigs();
	if(!bByParent)
		HideWindow();
}

final function SetSize(float W, float H)
{
	if(WinWidth != W || WinHeight != H)
	{
		WinWidth = W;
		WinHeight = H;
		Resized();
	}
}

function Tick(float Delta)
{
}

final function DoTick(float Delta)
{
	local UWindowWindow Child;

	Tick(Delta);

	Child = FirstChildWindow;

	while(Child != None)
	{
		Child.bUWindowActive = bUWindowActive;

		if(bLeaveOnScreen)
			Child.bLeaveOnscreen = True;

		if(bUWindowActive || Child.bLeaveOnscreen)
		{
			Child.DoTick(Delta);
		}

		Child = Child.NextSiblingWindow;
	}
}

final function PaintClients(Canvas C, float X, float Y)
{
	local float   OrgX, OrgY;   
	local float   ClipX, ClipY; 
	local UWindowWindow Child;

	OrgX = C.OrgX;
	OrgY = C.OrgY;
	ClipX = C.ClipX;
	ClipY = C.ClipY;

	Child = FirstChildWindow;

	while(Child != None)
	{
		Child.bUWindowActive = bUWindowActive;

		C.SetPos(0,0);
		C.Style = GetPlayerOwner().ERenderStyle.STY_Normal;
		C.DrawColor.R = 255;
		C.DrawColor.G = 255;
		C.DrawColor.B = 255;
		C.SpaceX = 0;
		C.SpaceY = 0;

		Child.BeforePaint(C, X - Child.WinLeft, Y - Child.WinTop);

		if(bLeaveOnScreen)
			Child.bLeaveOnscreen = True;

		if(bUWindowActive || Child.bLeaveOnscreen)
		{

			C.OrgX = int(C.OrgX + Child.WinLeft*Root.GUIScale);
			C.OrgY = int(C.OrgY + Child.WinTop*Root.GUIScale);

			if(!Child.bNoClip)
			{
				C.ClipX = FMin(WinWidth - Child.WinLeft, Child.WinWidth)*Root.GUIScale;
				C.ClipY = FMin(WinHeight - Child.WinTop, Child.WinHeight)*Root.GUIScale;


				// Translate to child's co-ordinate system
				Child.ClippingRegion.X = ClippingRegion.X - Child.WinLeft;
				Child.ClippingRegion.Y = ClippingRegion.Y - Child.WinTop;
				Child.ClippingRegion.W = ClippingRegion.W;
				Child.ClippingRegion.H = ClippingRegion.H;

				if(Child.ClippingRegion.X < 0)
				{
					Child.ClippingRegion.W += Child.ClippingRegion.X;
					Child.ClippingRegion.X = 0;
				}

				if(Child.ClippingRegion.Y < 0)
				{
					Child.ClippingRegion.H += Child.ClippingRegion.Y;
					Child.ClippingRegion.Y = 0;
				}

				if(Child.ClippingRegion.W > Child.WinWidth - Child.ClippingRegion.X)
				{
					Child.ClippingRegion.W = Child.WinWidth - Child.ClippingRegion.X;
				}

				if(Child.ClippingRegion.H > Child.WinHeight - Child.ClippingRegion.Y)
				{
					Child.ClippingRegion.H = Child.WinHeight - Child.ClippingRegion.Y;
				}
			}

			if(Child.ClippingRegion.W > 0 && Child.ClippingRegion.H > 0) 
			{		
				Child.WindowEvent(WM_Paint, C, X - Child.WinLeft, Y - Child.WinTop, 0);
				Child.AfterPaint(C, X - Child.WinLeft, Y - Child.WinTop);
			}
	
			C.OrgX = OrgX;
			C.OrgY = OrgY;
		}

		Child = Child.NextSiblingWindow;
	}

	C.ClipX = ClipX;
	C.ClipY = ClipY;
}

final function UWindowWindow FindWindowUnder(float X, float Y)
{
	local UWindowWindow Child;

	// go from Topmost downwards
	Child = LastChildWindow;

	while(Child != None)
	{
		Child.bUWindowActive = bUWindowActive;

		if(bLeaveOnScreen)
			Child.bLeaveOnscreen = True;

		if(bUWindowActive || Child.bLeaveOnscreen)
		{
			if((X >= Child.WinLeft) && (X <= Child.WinLeft+Child.WinWidth) &&
			   (Y >= Child.WinTop) && (Y <= Child.WinTop+Child.WinHeight) &&
			   (!Child.CheckMousePassThrough(X-Child.WinLeft, Y-Child.WinTop)))
			{
				return Child.FindWindowUnder(X - Child.WinLeft, Y - Child.WinTop);
			}
		}
	
		Child = Child.PrevSiblingWindow;
	}

	// Doesn't correspond to any children - it's us.
	return Self;
}

final function bool PropagateKey(WinMessage Msg, Canvas C, float X, float Y, int Key)
{
	local UWindowWindow Child;

	// Check from WinTopmost for windows which accept focus
	Child = LastChildWindow;

	// HACK for always on top windows...need a better solution
	if(ActiveWindow != None && Child != ActiveWindow && !Child.bTransient)
		Child = ActiveWindow;

	while(Child != None)
	{
		Child.bUWindowActive = bUWindowActive;

		if(bLeaveOnScreen)
			Child.bLeaveOnscreen = True;

		if((bUWindowActive || Child.bLeaveOnscreen) && Child.bAcceptsFocus)
		{
			//Log("Sending keystrokes to:  "$Child);
			Child.WindowEvent(Msg, C, X - Child.WinLeft, Y - Child.WinTop, Key);
			return True;		
		}
		//else
			//Log("Ignoring child:  "$Child);
		Child = Child.PrevSiblingWindow;
	}

	return False;
}

final function UWindowWindow CheckKeyFocusWindow()
{
	local UWindowWindow Child;

	// Check from WinTopmost for windows which accept key focus
	Child = LastChildWindow;

	if(ActiveWindow != None && Child != ActiveWindow && !Child.bTransient)
		Child = ActiveWindow;

	while(Child != None)
	{
		Child.bUWindowActive = bUWindowActive;

		if(bLeaveOnScreen)
			Child.bLeaveOnscreen = True;

		if(bUWindowActive || Child.bLeaveOnscreen)
		{
			if(Child.bAcceptsFocus)
			{
				return Child.CheckKeyFocusWindow();
			}
		}
		Child = Child.PrevSiblingWindow;
	}

	return Self;
}

final function bool MessageClients(WinMessage Msg, Canvas C, float X, float Y, int Key)
{
	local UWindowWindow Child;

	// go from topmost downwards
	Child = LastChildWindow;

	while(Child != None)
	{
		Child.bUWindowActive = bUWindowActive;

		if(bLeaveOnScreen)
			Child.bLeaveOnscreen = True;

		if(bUWindowActive || Child.bLeaveOnscreen)
		{
			if((X >= Child.WinLeft) && (X <= Child.WinLeft+Child.WinWidth) &&
			   (Y >= Child.WinTop) && (Y <= Child.WinTop+Child.WinHeight)  &&
			   (!Child.CheckMousePassThrough(X-Child.WinLeft, Y-Child.WinTop))) 
			{
				Child.WindowEvent(Msg, C, X - Child.WinLeft, Y - Child.WinTop, Key);
				return Child.bHandledEvent;
			}
		}
	
		Child = Child.PrevSiblingWindow;
	}

	return False;
}

final function ActivateWindow(int Depth, bool bTransientNoDeactivate)
{
	if(Self == Root)
	{
		if(Depth == 0)
			FocusWindow();
		return;
	}

	if(WaitModal()) return;

	if(!bAlwaysBehind)
	{
		ParentWindow.HideChildWindow(Self);
		ParentWindow.ShowChildWindow(Self);
	}
	
	//Log("Activating Window "$Self);
	
	if(!(bTransient || bTransientNoDeactivate))
	{
		if(ParentWindow.ActiveWindow != None && ParentWindow.ActiveWindow != Self)
		{
			ParentWindow.ActiveWindow.Deactivated();
		}

		ParentWindow.ActiveWindow = Self;
		ParentWindow.ActivateWindow(Depth + 1, False);

		Activated();
	}
	else
	{
		ParentWindow.ActivateWindow(Depth + 1, True);
	}

	if(Depth == 0)
		FocusWindow();
}

final function BringToFront()
{
	if(Self == Root)
		return;

	if(!bAlwaysBehind && !WaitModal())
	{
		ParentWindow.HideChildWindow(Self);
		ParentWindow.ShowChildWindow(Self);
	}
	ParentWindow.BringToFront();
}

final function SendToBack()
{
	ParentWindow.HideChildWindow(Self);
	ParentWindow.ShowChildWindow(Self, True);
}

final function HideChildWindow(UWindowWindow Child)
{
	local UWindowWindow Window;

	if(!Child.bWindowVisible) return;
	Child.bWindowVisible = False;

	if(Child.bAcceptsHotKeys)
		Root.RemoveHotkeyWindow(Child);

	// Check WinTopmost
	if(LastChildWindow == Child) 
	{
		LastChildWindow = Child.PrevSiblingWindow;
		if(LastChildWindow != None)
		{
			LastChildWindow.NextSiblingWindow = None;
		}
		else
		{
			FirstChildWindow = None;
		}
	} 
	else if(FirstChildWindow == Child) // Check bottommost
	{ 
		FirstChildWindow = Child.NextSiblingWindow;
		if(FirstChildWindow != None)
		{
			FirstChildWindow.PrevSiblingWindow = None;
		}
		else
		{
			LastChildWindow = None;
		}
	} 
	else 
	{
		// you mean I have to go looking for it???
		Window = FirstChildWindow;
		while(Window != None)
		{
			if(Window.NextSiblingWindow == Child)
			{
				Window.NextSiblingWindow = Child.NextSiblingWindow;
				Window.NextSiblingWindow.PrevSiblingWindow = Window;
				break;
			}
			Window = Window.NextSiblingWindow;
		}
	}

	// Set the active window
	ActiveWindow = None;
	Window = LastChildWindow;
	while(Window != None)
	{
		if(!Window.bAlwaysOnTop)
		{
			ActiveWindow = Window;
			break;
		}
		Window = Window.PrevSiblingWindow;
	}
	if(ActiveWindow == None) ActiveWindow = LastChildWindow;
}

final function SetAcceptsFocus()
{
	if(bAcceptsFocus) return;
	bAcceptsFocus = True;

	if(Self != Root)
		ParentWindow.SetAcceptsFocus();
}

final function CancelAcceptsFocus()
{
	local UWindowWindow Child;

	for(Child = LastChildWindow; Child != None; Child = Child.PrevSiblingWindow)
		Child.CancelAcceptsFocus();

	bAcceptsFocus = False;
}

final function GetMouseXY(out float X, out float Y)
{
	local UWindowWindow P;

	X = Int(Root.MouseX);
	Y = Int(Root.MouseY);
	
	P = Self;
	while(P != Root)
	{		
		X = X - P.WinLeft;
		Y = Y - P.WinTop;
		P = P.ParentWindow;
	}
}

final function GlobalToWindow(float GlobalX, float GlobalY, out float WinX, out float WinY)
{
	local UWindowWindow P;

	WinX = GlobalX;
	WinY = GlobalY;

	P = Self;
	while(P != Root)
	{		
		WinX -= P.WinLeft;
		WinY -= P.WinTop;
		P = P.ParentWindow;
	}
}

final function WindowToGlobal(float WinX, float WinY, out float GlobalX, out float GlobalY)
{
	local UWindowWindow P;

	GlobalX = WinX;
	GlobalY = WinY;

	P = Self;
	while(P != Root)
	{		
		GlobalX += P.WinLeft;
		GlobalY += P.WinTop;
		P = P.ParentWindow;
	}
}

final function ShowChildWindow(UWindowWindow Child, optional bool bAtBack)
{
	local UWindowWindow W;
	
	if(!Child.bTransient) ActiveWindow = Child;

	if(Child.bWindowVisible) return;
	Child.bWindowVisible = True;

	if(Child.bAcceptsHotKeys)
		Root.AddHotkeyWindow(Child);

	if(bAtBack)
	{
		if(FirstChildWindow == None)
		{
			Child.NextSiblingWindow = None;
			Child.PrevSiblingWindow = None;
			LastChildWindow = Child;
			FirstChildWindow = Child;
		}
		else
		{
			FirstChildWindow.PrevSiblingWindow = Child;
			Child.NextSiblingWindow = FirstChildWindow;
			Child.PrevSiblingWindow = None;
			FirstChildWindow = Child;
		}
	}
	else
	{
		W = LastChildWindow;
		while(True) 
		{
			if((Child.bAlwaysOnTop) || (W == None) || (!W.bAlwaysOnTop))
			{
				if(W == None)
				{	
					if(LastChildWindow == None)
					{
						// We're the only window
						Child.NextSiblingWindow = None;
						Child.PrevSiblingWindow = None;
						LastChildWindow = Child;
						FirstChildWindow = Child;
					}
					else
					{
						// We feel off the end of the list, we're the bottom (first) child window.
						Child.NextSiblingWindow = FirstChildWindow;
						Child.PrevSiblingWindow = None;
						FirstChildWindow.PrevSiblingWindow = Child;
						FirstChildWindow = Child;
					}
				}
				else
				{
					// We're either the new topmost (last) or we need to be inserted in the list.

					Child.NextSiblingWindow = W.NextSiblingWindow;
					Child.PrevSiblingWindow = W;
					if(W.NextSiblingWindow != None)
					{
						W.NextSiblingWindow.PrevSiblingWindow = Child;
					}
					else
					{
						LastChildWindow = Child;
					}
					W.NextSiblingWindow = Child;
				}
				
				// We're done.
				break;
			}
			
			W = W.PrevSiblingWindow;
		}
	}
}

function ShowWindow()
{
	ParentWindow.ShowChildWindow(Self);
	WindowShown();
}

function HideWindow()
{
	WindowHidden();
	ParentWindow.HideChildWindow(Self);
}

final function UWindowWindow CreateWindow(class<UWindowWindow> WndClass, float X, float Y, float W, float H, optional UWindowWindow OwnerW, optional bool bUnique, optional name ObjectName)
{
	local UWindowWindow Child;

	if(bUnique)
	{
		Child = Root.FindChildWindow(WndClass, True);

		if(Child != None)
		{
			Child.ShowWindow();
			Child.BringToFront();
			return Child;
		}
	}

	if(ObjectName != '')
		Child = New(None, ObjectName) WndClass;
	else
		Child = New(None) WndClass;

	Child.BeginPlay();
	Child.WinTop = Y;
	Child.WinLeft = X;
	Child.WinWidth = W;
	Child.WinHeight = H;
	Child.Root = Root;
	Child.ParentWindow = Self;
	Child.OwnerWindow = OwnerW;
	if(Child.OwnerWindow == None)
		Child.OwnerWindow = Self;
	Child.Cursor = Cursor;
	Child.bAlwaysBehind = False;
	Child.LookAndFeel = LookAndFeel;
	Child.BeforeCreate();
	Child.Created();

	// Now add it at the WinTop of the Z-Order and then adjust child list.
	ShowChildWindow(Child);

	Child.AfterCreate();

	return Child;
}

final function Tile(Canvas C, Texture T)
{
	local int X, Y;

	X = 0;
	Y = 0;

	While(X < WinWidth)
	{
		While(Y < WinHeight)
		{
			DrawClippedTexture( C, X, Y, T );
			Y += T.VSize;
		}
		X += T.USize;
		Y = 0;
	}
}

final function DrawHorizTiledPieces( Canvas C, float DestX, float DestY, float DestW, float DestH, TexRegion T1, TexRegion T2, TexRegion T3, TexRegion T4, TexRegion T5, float Scale )
{
	local TexRegion Pieces[5], R;
	local int PieceCount;
	local int j;
	local float X, L;

	Pieces[0] = T1; if(T1.T != None) PieceCount = 1;
	Pieces[1] = T2; if(T2.T != None) PieceCount = 2;
	Pieces[2] = T3; if(T3.T != None) PieceCount = 3;
	Pieces[3] = T4; if(T4.T != None) PieceCount = 4;
	Pieces[4] = T5; if(T5.T != None) PieceCount = 5;

	j = 0;
	X = DestX;
	while( X < DestX + DestW )
	{
		L = DestW - (X - DestX);
		R = Pieces[j];
		DrawStretchedTextureSegment( C, X, DestY, FMin(R.W*Scale, L), R.H*Scale, R.X, R.Y, FMin(R.W, L/Scale), R.H, R.T );
		X += FMin(R.W*Scale, L);
		j = (j+1)%PieceCount;
	}
}

final function DrawVertTiledPieces( Canvas C, float DestX, float DestY, float DestW, float DestH, TexRegion T1, TexRegion T2, TexRegion T3, TexRegion T4, TexRegion T5, float Scale )
{
	local TexRegion Pieces[5], R;
	local int PieceCount;
	local int j;
	local float Y, L;

	Pieces[0] = T1; if(T1.T != None) PieceCount = 1;
	Pieces[1] = T2; if(T2.T != None) PieceCount = 2;
	Pieces[2] = T3; if(T3.T != None) PieceCount = 3;
	Pieces[3] = T4; if(T4.T != None) PieceCount = 4;
	Pieces[4] = T5; if(T5.T != None) PieceCount = 5;

	j = 0;
	Y = DestY;
	while( Y < DestY + DestH )
	{
		L = DestH - (Y - DestY);
		R = Pieces[j];
		DrawStretchedTextureSegment( C, DestX, Y, R.W*Scale, FMin(R.H*Scale, L), R.X, R.Y, R.W, FMin(R.H, L/Scale), R.T );
		Y += FMin(R.H*Scale, L);
		j = (j+1)%PieceCount;
	}
}


final function DrawClippedTexture( Canvas C, float X, float Y, texture Tex )
{
	DrawStretchedTextureSegment( C, X, Y, Tex.USize, Tex.VSize, 0, 0, Tex.USize, Tex.VSize, Tex);
}

final function DrawStretchedTexture( Canvas C, float X, float Y, float W, float H, texture Tex )
{
	DrawStretchedTextureSegment( C, X, Y, W, H, 0, 0, Tex.USize, Tex.VSize, Tex);
}

final function DrawStretchedTextureSegment( Canvas C, float X, float Y, float W, float H, 
									  float tX, float tY, float tW, float tH, texture Tex ) 
{
	local float OrgX, OrgY, ClipX, ClipY;

	OrgX = C.OrgX;
	OrgY = C.OrgY;
	ClipX = C.ClipX;
	ClipY = C.ClipY;

	C.SetOrigin(OrgX + ClippingRegion.X*Root.GUIScale, OrgY + ClippingRegion.Y*Root.GUIScale);
	C.SetClip(ClippingRegion.W*Root.GUIScale, ClippingRegion.H*Root.GUIScale);

	C.SetPos((X - ClippingRegion.X)*Root.GUIScale, (Y - ClippingRegion.Y)*Root.GUIScale);
	C.DrawTileClipped( Tex, W*Root.GUIScale, H*Root.GUIScale, tX, tY, tW, tH);
	
	C.SetClip(ClipX, ClipY);
	C.SetOrigin(OrgX, OrgY);
}

//Higor: added in v469 to draw elements with clean and sharp borders.
//The space between OuterRect and InnerRect represents the integer-scaled borders.
final function DrawIntegerScaledBorders( Canvas C, float X, float Y, float W, float H, Region OuterRect, Region InnerRect, Texture Tex, optional bool bDrawInner)
{
	local float OrgX, OrgY, ClipX, ClipY;
	local int S, LX, RX, TY, BY;

	OrgX = C.OrgX;
	OrgY = C.OrgY;
	ClipX = C.ClipX;
	ClipY = C.ClipY;
	S = Max( Root.GUIScale, 1);
	LX = InnerRect.X - OuterRect.X;
	RX = OuterRect.W - (LX + InnerRect.W);
	TY = InnerRect.Y - OuterRect.Y;
	BY = OuterRect.H - (TY + InnerRect.H);
	
	C.SetOrigin( OrgX + ClippingRegion.X*Root.GUIScale, OrgY + ClippingRegion.Y*Root.GUIScale);
	C.SetClip( ClippingRegion.W*Root.GUIScale, ClippingRegion.H*Root.GUIScale);

	X = (X-ClippingRegion.X) * Root.GUIScale;
	Y = (Y-ClippingRegion.Y) * Root.GUIScale;
	W *= Root.GUIScale;
	H *= Root.GUIScale;
	
	C.SetPos( X         , Y); 
	C.DrawTileClipped( Tex, LX*S       , TY*S       , OuterRect.X   , OuterRect.Y   , LX         , TY); //Top Left
	C.SetPos( X + LX*S  , Y); 
	C.DrawTileClipped( Tex, W-(LX+RX)*S, TY*S       , InnerRect.X   , OuterRect.Y   , InnerRect.W, TY); //Top
	C.SetPos( X + W-RX*S, Y); 
	C.DrawTileClipped( Tex, RX*S       , TY*S       , OuterRect.W-RX, OuterRect.Y   , RX         , TY); //Top Right
	C.SetPos( X + W-RX*S, Y + TY*S); 
	C.DrawTileClipped( Tex, RX*S       , H-(TY+BY)*S, OuterRect.W-RX, InnerRect.Y   , RX         , InnerRect.H); //Right
	C.SetPos( X + W-RX*S, Y + H-BY*S);
	C.DrawTileClipped( Tex, RX*S       , BY*S       , OuterRect.W-RX, OuterRect.H-BY, RX         , BY); //Bottom Right
	C.SetPos( X + LX*S  , Y + H-BY*S);
	C.DrawTileClipped( Tex, W-(LX+RX)*S, BY*S       , InnerRect.X   , OuterRect.H-BY, InnerRect.W, BY); //Bottom
	C.SetPos( X         , Y + H-BY*S);
	C.DrawTileClipped( Tex, LX*S       , BY*S       , OuterRect.X   , OuterRect.H-BY, LX         , BY); //Bottom Left
	C.SetPos( X         , Y + TY*S);
	C.DrawTileClipped( Tex, LX*S       , H-(TY+BY)*S, OuterRect.X   , InnerRect.Y   , LX         , InnerRect.H); //Left
	
	if ( bDrawInner )
	{
		C.SetPos( X + LX*S, Y + TY*S);
		C.DrawTileClipped( Tex, W-(LX+RX)*S, H-(TY+BY)*S, InnerRect.X, InnerRect.Y, InnerRect.W, InnerRect.H); //Center
	}
	
	C.SetClip( ClipX, ClipY);
	C.SetOrigin( OrgX, OrgY);
}

final function ClipText(Canvas C, float X, float Y, coerce string S, optional bool bCheckHotkey)
{
	local float OrgX, OrgY, ClipX, ClipY;

	OrgX = C.OrgX;
	OrgY = C.OrgY;
	ClipX = C.ClipX;
	ClipY = C.ClipY;

	C.SetOrigin(OrgX + ClippingRegion.X*Root.GUIScale, OrgY + ClippingRegion.Y*Root.GUIScale);
	C.SetClip(ClippingRegion.W*Root.GUIScale, ClippingRegion.H*Root.GUIScale);

	C.SetPos((X - ClippingRegion.X)*Root.GUIScale, (Y - ClippingRegion.Y)*Root.GUIScale);
	C.DrawTextClipped(S, bCheckHotKey);

	C.SetClip(ClipX, ClipY);
	C.SetOrigin(OrgX, OrgY);
}

final function int WrapClipText(Canvas C, float X, float Y, coerce string S, optional bool bCheckHotkey, optional int Length, optional int PaddingLength, optional bool bNoDraw)
{
	local float W, H;
	local int SpacePos, CRPos, WordPos, TotalPos;
	local string Out, Temp, Padding;
	local bool bCR, bSentry;
	local int i;
	local int NumLines;
	local float pW, pH;

	// replace \\n's with Chr(13)'s
	i = InStr(S, "\\n");
	while(i != -1)
	{
		S = Left(S, i) $ Chr(13) $ Mid(S, i + 2);
		i = InStr(S, "\\n");
	}

	i = 0;
	bSentry = True;
	Out = "";
	NumLines = 1;
	while( bSentry && Y < WinHeight )
	{
		// Get the line to be drawn.
		if(Out == "")
		{
			i++;
			if (Length > 0)
				Out = Left(S, Length);
			else
				Out = S;
		}

		// Find the word boundary.
		SpacePos = InStr(Out, " ");
		CRPos = InStr(Out, Chr(13));
		
		bCR = False;
		if(CRPos != -1 && (CRPos < SpacePos || SpacePos == -1))
		{
			WordPos = CRPos;
			bCR = True;
		}
		else
		{
			WordPos = SpacePos;
		}
		
		// Get the current word.
		C.SetPos(0, 0);
		if(WordPos == -1)
			Temp = Out;
		else
			Temp = Left(Out, WordPos)$" ";
		TotalPos += WordPos;

		TextSize(C, Temp, W, H);

		// Calculate draw offset.
		if ( (Mid(Out, Len(Temp)) == "") && (PaddingLength > 0) )
		{
			Padding = Mid(S, Length, PaddingLength);
			TextSize(C, Padding, pW, pH);
			if(W + X + pW > WinWidth && X > 0)
			{
				if (H <= 0)
					TextSize(C, "A", W, H);
				X = 0;
				Y += H;
				NumLines++;
			}
		}
		else
		{
			if(W + X > WinWidth && X > 0)
			{
				X = 0;
				if (H <= 0)
					TextSize(C, "A", W, H);
				Y += H;
				NumLines++;
			}
		}

		// Draw the line.
		if(!bNoDraw)
			ClipText(C, X, Y, Temp, bCheckHotKey);

		// Increment the draw offset.
		X += W;
		if(bCR)
		{
			X =0;
			if (H <= 0)
				TextSize(C, "A", W, H);
			Y += H;
			NumLines++;
		}
		Out = Mid(Out, Len(Temp));
		if ((Out == "") && (i > 0))
			bSentry = False;
	}
	return NumLines;
}

final function ClipTextWidth(Canvas C, float X, float Y, coerce string S, float W)
{
	ClipText(C, X, Y, S);
}

final function DrawClippedActor( Canvas C, float X, float Y, Actor A, bool WireFrame, rotator RotOffset, vector LocOffset )
{
	local vector MeshLoc;
	local float FOV;

	FOV = GetPlayerOwner().FOVAngle * Pi / 180;

	// (Anth) Adjusted the mesh projection calculation because it didn't account for widescreen resolutions
	MeshLoc.X = 5 * ClippingRegion.W / ClippingRegion.H / tan(FOV/2);
	MeshLoc.Y = 0;
	MeshLoc.Z = 0;

	A.SetRotation(RotOffset);
	A.SetLocation(MeshLoc + LocOffset);

	C.DrawClippedActor(A, WireFrame, ClippingRegion.W * Root.GUIScale, ClippingRegion.H * Root.GUIScale, C.OrgX + ClippingRegion.X * Root.GUIScale, C.OrgY + ClippingRegion.Y * Root.GUIScale, True);
}

final function DrawUpBevel( Canvas C, float X, float Y, float W, float H, Texture Tex)
{
	//Higor: The borders of the bevel will be drawn in integer scale so they won't look ugly
	local float S;
	local Region TL, T, TR, L, R, BL, B, BR, Area;

	if ( Root.GUIScale > 1 )
		S = float(int(Root.GUIScale)) / Root.GUIScale;
	else
		S = 1;

	TL = LookAndFeel.BevelUpTL;
	T = LookAndFeel.BevelUpT;
	TR = LookAndFeel.BevelUpTR;
	L = LookAndFeel.BevelUpL;
	R = LookAndFeel.BevelUpR;
	BL = LookAndFeel.BevelUpBL;
	B = LookAndFeel.BevelUpB;
	BR = LookAndFeel.BevelUpBR;
	Area = LookAndFeel.BevelUpArea;

	DrawStretchedTextureSegment( C, X             , Y             ,     (TL.W)*S     ,     (TL.H)*S     , TL.X, TL.Y, TL.W, TL.H, Tex );
	DrawStretchedTextureSegment( C, X   + (TL.W)*S, Y             , W - (TL.W+TR.W)*S,     (T.H)*S      ,  T.X,  T.Y,  T.W,  T.H, Tex );
	DrawStretchedTextureSegment( C, X+W - (TR.W)*S, Y             ,     (TR.W)*S     ,     (TR.H)*S     , TR.X, TR.Y, TR.W, TR.H, Tex );
	DrawStretchedTextureSegment( C, X             , Y   + (TL.H)*S,     (L.W)*S      , H - (TL.H+BL.H)*S,  L.X,  L.Y,  L.W,  L.H, Tex );
	DrawStretchedTextureSegment( C, X+W - ( R.W)*S, Y   + (TL.H)*S,     (R.W)*S      , H - (TL.H+BL.H)*S,  R.X,  R.Y,  R.W,  R.H, Tex );
	DrawStretchedTextureSegment( C, X             , Y+H - (BL.H)*S,     (BL.W)*S     ,     (BL.H)*S     , BL.X, BL.Y, BL.W, BL.H, Tex );
	DrawStretchedTextureSegment( C, X   + (BL.W)*S, Y+H - ( B.H)*S, W - (BL.W+BR.W)*S,     (B.H)*S      ,  B.X,  B.Y,  B.W,  B.H, Tex );
	DrawStretchedTextureSegment( C, X+W - (BR.W)*S, Y+H - (BR.H)*S,     (BR.W)*S     ,     (BR.H)*S     , BR.X, BR.Y, BR.W, BR.H, Tex );
	DrawStretchedTextureSegment( C, X   + (TL.W)*S, Y   + (TL.H)*S, W - (BL.W+BR.W)*S, H - (TL.H+BL.H)*S, Area.X, Area.Y, Area.W, Area.H, Tex );
}

final function DrawMiscBevel( Canvas C, float X, float Y, float W, float H, Texture Tex, int BevelType)
{
	//Higor: The borders of the bevel will be drawn in integer scale so they won't look ugly
	local float S;
	local Region TL, T, TR, L, R, BL, B, BR, Area;

	if ( Root.GUIScale > 1 )
		S = float(int(Root.GUIScale)) / Root.GUIScale;
	else
		S = 1;

	TL = LookAndFeel.MiscBevelTL[BevelType];
	T = LookAndFeel.MiscBevelT[BevelType];
	TR = LookAndFeel.MiscBevelTR[BevelType];
	L = LookAndFeel.MiscBevelL[BevelType];
	R = LookAndFeel.MiscBevelR[BevelType];
	BL = LookAndFeel.MiscBevelBL[BevelType];
	B = LookAndFeel.MiscBevelB[BevelType];
	BR = LookAndFeel.MiscBevelBR[BevelType];
	Area = LookAndFeel.MiscBevelArea[BevelType];


	DrawStretchedTextureSegment( C, X             , Y             ,     (TL.W)*S     ,     (TL.H)*S     , TL.X, TL.Y, TL.W, TL.H, Tex );
	DrawStretchedTextureSegment( C, X   + (TL.W)*S, Y             , W - (TL.W+TR.W)*S,     (T.H)*S      ,  T.X,  T.Y,  T.W,  T.H, Tex );
	DrawStretchedTextureSegment( C, X+W - (TR.W)*S, Y             ,     (TR.W)*S     ,     (TR.H)*S     , TR.X, TR.Y, TR.W, TR.H, Tex );
	DrawStretchedTextureSegment( C, X             , Y   + (TL.H)*S,     (L.W)*S      , H - (TL.H+BL.H)*S,  L.X,  L.Y,  L.W,  L.H, Tex );
	DrawStretchedTextureSegment( C, X+W - ( R.W)*S, Y   + (TL.H)*S,     (R.W)*S      , H - (TL.H+BL.H)*S,  R.X,  R.Y,  R.W,  R.H, Tex );
	DrawStretchedTextureSegment( C, X             , Y+H - (BL.H)*S,     (BL.W)*S     ,     (BL.H)*S     , BL.X, BL.Y, BL.W, BL.H, Tex );
	DrawStretchedTextureSegment( C, X   + (BL.W)*S, Y+H - ( B.H)*S, W - (BL.W+BR.W)*S,     (B.H)*S      ,  B.X,  B.Y,  B.W,  B.H, Tex );
	DrawStretchedTextureSegment( C, X+W - (BR.W)*S, Y+H - (BR.H)*S,     (BR.W)*S     ,     (BR.H)*S     , BR.X, BR.Y, BR.W, BR.H, Tex );
	DrawStretchedTextureSegment( C, X   + (TL.W)*S, Y   + (TL.H)*S, W - (BL.W+BR.W)*S, H - (TL.H+BL.H)*S, Area.X, Area.Y, Area.W, Area.H, Tex );
}

final function string RemoveAmpersand(string S)
{
	local string Result;
	local string Underline;

	ParseAmpersand(S, Result, Underline, False);

	return Result;
}

final function byte ParseAmpersand(string S, out string Result, out string Underline, bool bCalcUnderline)
{
	local string Temp;
	local int Pos, NewPos;
	local int i;
	local byte HotKey;
	
	HotKey = 0;
	Pos = 0;
	Result = "";
	Underline = "";

	while(True)
	{
		Temp = Mid(S, Pos);

		NewPos = InStr(Temp, "&");
		
		if(NewPos == -1) break;
		Pos += NewPos;

		if(Mid(Temp, NewPos + 1, 1) == "&")
		{
			// It's a double &, lets add one to the output.
			Result = Result $ Left(Temp, NewPos) $ "&";
			
			if(bCalcUnderline) 
				Underline = Underline $ " ";

			Pos++;
		}
		else
		{
			if(HotKey == 0)
				HotKey = Asc(Caps(Mid(Temp, NewPos + 1, 1)));

			Result = Result $ Left(Temp, NewPos);
			
			if(bCalcUnderline)
			{
				for(i=0;i<NewPos - 1;i++) 
					Underline = Underline $ " ";
				Underline = Underline $ "_";
			}
		}

		Pos++;
	}
	Result = Result $ Temp;

	return HotKey;
}

final function bool MouseIsOver()
{
	return (Root.MouseWindow == Self);
}

function ToolTip(string strTip) 
{
	if(ParentWindow != Root) ParentWindow.ToolTip(strTip);
}

// Sets mouse window for mouse capture.
final function SetMouseWindow()
{
	Root.MouseWindow = Self;
}

function Texture GetLookAndFeelTexture()
{
	return ParentWindow.GetLookAndFeelTexture();
}

function Texture GetLookAndFeelTextureEx(out float ScaleFactor)
{
	return ParentWindow.GetLookAndFeelTextureEx(ScaleFactor);
}

function bool IsActive()
{
	return ParentWindow.IsActive();
}

function SetAcceptsHotKeys(bool bNewAccpetsHotKeys)
{
	if(bNewAccpetsHotKeys && !bAcceptsHotKeys && bWindowVisible)
		Root.AddHotkeyWindow(Self);
	
	if(!bNewAccpetsHotKeys && bAcceptsHotKeys && bWindowVisible)
		Root.RemoveHotkeyWindow(Self);

	bAcceptsHotKeys = bNewAccpetsHotKeys;
}

final function UWindowWindow GetParent(class<UWindowWindow> ParentClass, optional bool bExactClass)
{
	local UWindowWindow P;

	P = ParentWindow;
	while(P != Root)
	{
		if(bExactClass)
		{
			if(P.Class == ParentClass)
				return P;
		}
		else
		{
			if(ClassIsChildOf(P.Class, ParentClass))
				return P;
		}
		P = P.ParentWindow;
	}

	return None;
}

final function UWindowWindow FindChildWindow(class<UWindowWindow> ChildClass, optional bool bExactClass)
{
	local UWindowWindow Child, Found;

	for(Child = LastChildWindow;Child != None;Child = Child.PrevSiblingWindow)
	{
		if(bExactClass)
		{
			if(Child.Class == ChildClass) return Child;
		}
		else
		{
			if(ClassIsChildOf(Child.Class, ChildClass)) return Child;
		}

		Found = Child.FindChildWindow(ChildClass);
		if(Found != None) return Found;
	}

	return None;
}

function GetDesiredDimensions(out float W, out float H)
{
	local float MaxW, MaxH, TW, TH;
	local UWindowWindow Child;
	
	MaxW = 0;
	MaxH = 0;

	for(Child = LastChildWindow;Child != None;Child = Child.PrevSiblingWindow)
	{
		Child.GetDesiredDimensions(TW, TH);
		//Log("Calling: "$GetPlayerOwner().GetItemName(string(Child)));
		

		if(TW > MaxW) MaxW = TW;
		if(TH > MaxH) MaxH = TH;
	}
	W = MaxW;
	H = MaxH;
	//Log(GetPlayerOwner().GetItemName(string(Self))$": DesiredHeight: "$H);
}

final function TextSize(Canvas C, string Text, out float W, out float H)
{
	C.SetPos(0, 0);
	C.TextSize(Text, W, H);
	W = W / Root.GUIScale;
	H = H / Root.GUIScale;
}

function ResolutionChanged(float W, float H)
{
	local UWindowWindow Child;

	for(Child = LastChildWindow;Child != None;Child = Child.PrevSiblingWindow)
	{
		Child.ResolutionChanged(W, H);
	}
}

function ShowModal(UWindowWindow W)
{
	ModalWindow = W;
	W.ShowWindow();
	W.BringToFront();		
}

function bool WaitModal()
{
	if(ModalWindow != None && ModalWindow.bWindowVisible)
		return True;

	ModalWindow = None;

	return False;
}

function WindowHidden()
{
	local UWindowWindow Child;

	for(Child = LastChildWindow;Child != None;Child = Child.PrevSiblingWindow)
		Child.WindowHidden();
}

function WindowShown()
{
	local UWindowWindow Child;

	for(Child = LastChildWindow;Child != None;Child = Child.PrevSiblingWindow)
		Child.WindowShown();
}

// Should mouse events at these co-ordinates be passed through to underlying windows?
function bool CheckMousePassThrough(float X, float Y)
{
	return False;
}

final function bool WindowIsVisible()
{
	if(Self == Root)
		return True;

	if(!bWindowVisible)
		return False;
	return ParentWindow.WindowIsVisible();
}

function SetParent(UWindowWindow NewParent)
{
	HideWindow();
	ParentWindow = NewParent;
	ShowWindow();
}

function UWindowMessageBox MessageBox(string Title, string Message, MessageBoxButtons Buttons, MessageBoxResult ESCResult, optional MessageBoxResult EnterResult, optional int TimeOut)
{
	local UWindowMessageBox W;
	local UWindowFramedWindow F;
	
	W = UWindowMessageBox(Root.CreateWindow(class'UWindowMessageBox', 100, 100, 100, 100, Self));
	W.SetupMessageBox(Title, Message, Buttons, ESCResult, EnterResult, TimeOut);
	F = UWindowFramedWindow(GetParent(class'UWindowFramedWindow'));

	if(F!= None)
		F.ShowModal(W);
	else
		Root.ShowModal(W);

	return W;
}

function MessageBoxDone(UWindowMessageBox W, MessageBoxResult Result)
{
}

function NotifyQuitUnreal()
{
	local UWindowWindow Child;

	for(Child = LastChildWindow;Child != None;Child = Child.PrevSiblingWindow)
		Child.NotifyQuitUnreal();
}

function NotifyBeforeLevelChange()
{
	local UWindowWindow Child;

	for(Child = LastChildWindow;Child != None;Child = Child.PrevSiblingWindow)
		Child.NotifyBeforeLevelChange();
}

function SetCursor(MouseCursor C)
{
	local UWindowWindow Child;

	Cursor = C;

	for(Child = LastChildWindow;Child != None;Child = Child.PrevSiblingWindow)
		Child.SetCursor(C);
}

function NotifyAfterLevelChange()
{
	local UWindowWindow Child;

	for(Child = LastChildWindow;Child != None;Child = Child.PrevSiblingWindow)
		Child.NotifyAfterLevelChange();
}

final function ReplaceText(out string Text, string Replace, string With)
{
	local int i;
	local string Input;
		
	Input = Text;
	Text = "";
	i = InStr(Input, Replace);
	while(i != -1)
	{	
		Text = Text $ Left(Input, i) $ With;
		Input = Mid(Input, i + Len(Replace));	
		i = InStr(Input, Replace);
	}
	Text = Text $ Input;
}

function StripCRLF(out string Text)
{
	ReplaceText(Text, Chr(13)$Chr(10), "");
	ReplaceText(Text, Chr(13), "");
	ReplaceText(Text, Chr(10), "");
}

defaultproperties
{
      WinLeft=0.000000
      WinTop=0.000000
      WinWidth=0.000000
      WinHeight=0.000000
      ParentWindow=None
      FirstChildWindow=None
      LastChildWindow=None
      NextSiblingWindow=None
      PrevSiblingWindow=None
      ActiveWindow=None
      Root=None
      OwnerWindow=None
      ModalWindow=None
      bWindowVisible=False
      bNoClip=False
      bMouseDown=False
      bRMouseDown=False
      bMMouseDown=False
      bAlwaysBehind=False
      bAcceptsFocus=False
      bAlwaysOnTop=False
      bLeaveOnscreen=False
      bUWindowActive=False
      bTransient=False
      bAcceptsHotKeys=False
      bIgnoreLDoubleClick=False
      bIgnoreMDoubleClick=False
      bIgnoreRDoubleClick=False
      bHandledEvent=False
      ClickTime=0.000000
      MClickTime=0.000000
      RClickTime=0.000000
      ClickX=0.000000
      ClickY=0.000000
      MClickX=0.000000
      MClickY=0.000000
      RClickX=0.000000
      RClickY=0.000000
      LookAndFeel=None
      ClippingRegion=(X=0,Y=0,W=0,H=0)
      Cursor=(Tex=None,HotX=0,HotY=0,WindowsCursor=0)
}
