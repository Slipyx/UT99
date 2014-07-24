// UWindowEditBox - simple edit box, for use in other controls such as 
// UWindowComboxBoxControl, UWindowEditBoxControl etc.

class UWindowEditBox extends UWindowDialogControl;

var string		Value;
var string		Value2;
var int			CaretOffset;
var int			MaxLength;
var float		LastDrawTime;
var bool		bShowCaret;
var float		Offset;
var UWindowDialogControl	NotifyOwner;
var bool		bNumericOnly;
var bool		bNumericFloat;
var bool		bCanEdit;
var bool		bAllSelected;
var bool		bSelectOnFocus;
var bool		bDelayedNotify;
var bool		bChangePending;
var bool		bControlDown;
var bool		bShiftDown;
var bool		bHistory;
var bool		bKeyDown;
var UWindowEditBoxHistory	HistoryList;
var UWindowEditBoxHistory	CurrentHistory;

function Created()
{
	Super.Created();
	bCanEdit = True;
	bControlDown = False;
	bShiftDown = False;

	MaxLength = 255;
	CaretOffset = 0;
	Offset = 0;
	LastDrawTime = GetLevel().TimeSeconds;
}

function SetHistory(bool bInHistory)
{
	bHistory = bInHistory;

	if(bHistory && HistoryList==None)
	{
		HistoryList = new(None) class'UWindowEditBoxHistory';
		HistoryList.SetupSentinel();
		CurrentHistory = None;
	}
	else
	if(!bHistory && HistoryList!=None)
	{
		HistoryList = None;
		CurrentHistory = None;
	}
}

function SetEditable(bool bEditable)
{
	bCanEdit = bEditable;
}

function SetValue(string NewValue, optional string NewValue2)
{
	Value = NewValue;
	Value2 = NewValue2;

	if(CaretOffset > Len(Value))
		CaretOffset = Len(Value);		
	Notify(DE_Change);
}

function Clear()
{
	CaretOffset = 0;
	Value="";
	Value2="";
	bAllSelected = False;
	if(bDelayedNotify)
		bChangePending = True;
	else
		Notify(DE_Change);
}

function SelectAll()
{
	if(bCanEdit && Value != "")
	{
		CaretOffset = Len(Value);
		bAllSelected = True;
	}
}

function string GetValue()
{
	return Value;
}

function string GetValue2()
{
	return Value2;
}

function Notify(byte E)
{
	if(NotifyOwner != None)
	{
		NotifyOwner.Notify(E);
	} else {
		Super.Notify(E);
	}
}

function InsertText(string Text)
{
	local int i;

	for(i=0;i<Len(Text);i++)
		Insert(Asc(Mid(Text,i,1)));
}

// Inserts a character at the current caret position
function bool Insert(byte C)
{
	local string	NewValue;

	NewValue = Left(Value, CaretOffset) $ Chr(C) $ Mid(Value, CaretOffset);

	if(Len(NewValue) > MaxLength) 
		return False;

	CaretOffset++;

	Value = NewValue;
	if(bDelayedNotify)
		bChangePending = True;
	else
		Notify(DE_Change);
	return True;
}

function bool Backspace()
{
	local string	NewValue;

	if(CaretOffset == 0) return False;

	NewValue = Left(Value, CaretOffset - 1) $ Mid(Value, CaretOffset);
	CaretOffset--;

	Value = NewValue;
	if(bDelayedNotify)
		bChangePending = True;
	else
		Notify(DE_Change);
	return True;
}

function bool Delete()
{
	local string	NewValue;

	if(CaretOffset == Len(Value)) return False;

	NewValue = Left(Value, CaretOffset) $ Mid(Value, CaretOffset + 1);

	Value = NewValue;
	Notify(DE_Change);
	return True;
}

function bool WordLeft()
{
	while(CaretOffset > 0 && Mid(Value, CaretOffset - 1, 1) == " ")
		CaretOffset--;
	while(CaretOffset > 0 && Mid(Value, CaretOffset - 1, 1) != " ")
		CaretOffset--;

	LastDrawTime = GetLevel().TimeSeconds;
	bShowCaret = True;

	return True;	
}

function bool MoveLeft()
{
	if(CaretOffset == 0) return False;
	CaretOffset--;

	LastDrawTime = GetLevel().TimeSeconds;
	bShowCaret = True;

	return True;	
}

function bool MoveRight()
{
	if(CaretOffset == Len(Value)) return False;
	CaretOffset++;

	LastDrawTime = GetLevel().TimeSeconds;
	bShowCaret = True;

	return True;	
}

function bool WordRight()
{
	while(CaretOffset < Len(Value) && Mid(Value, CaretOffset, 1) != " ")
		CaretOffset++;
	while(CaretOffset < Len(Value) && Mid(Value, CaretOffset, 1) == " ")
		CaretOffset++;

	LastDrawTime = GetLevel().TimeSeconds;
	bShowCaret = True;

	return True;	
}

function bool MoveHome()
{
	CaretOffset = 0;

	LastDrawTime = GetLevel().TimeSeconds;
	bShowCaret = True;

	return True;	
}

function bool MoveEnd()
{
	CaretOffset = Len(Value);

	LastDrawTime = GetLevel().TimeSeconds;
	bShowCaret = True;

	return True;	
}

function EditCopy()
{
	if(bAllSelected || !bCanEdit)
		GetPlayerOwner().CopyToClipboard(Value);
}

function EditPaste()
{
	if(bCanEdit)
	{
		if(bAllSelected)
			Clear();
		InsertText(GetPlayerOwner().PasteFromClipboard());
	}
}

function EditCut()
{
	if(bCanEdit)
	{
		if(bAllSelected)
		{
			GetPlayerOwner().CopyToClipboard(Value);
			bAllSelected = False;
			Clear();
		}
	}
	else
		EditCopy();
}

function KeyType( int Key, float MouseX, float MouseY )
{
	if(bCanEdit && bKeyDown)
	{
		if( !bControlDown )
		{
			if(bAllSelected)
				Clear();

			bAllSelected = False;

			if(bNumericOnly)
			{
				if( Key>=0x30 && Key<=0x39 )  
				{
					Insert(Key);
				}
			}
			else
			{
				if( Key>=0x20 && Key<0x80 )
				{
					Insert(Key);
				}
			}
		}
	}
}

function KeyUp(int Key, float X, float Y)
{
	local PlayerPawn P;
	bKeyDown = False;
	P = GetPlayerOwner();
	switch (Key)
	{
	case P.EInputKey.IK_Ctrl:
		bControlDown = False;
		break;
	case P.EInputKey.IK_Shift:
		bShiftDown = False;
		break;
	}
}

function KeyDown(int Key, float X, float Y)
{
	local PlayerPawn P;

	bKeyDown = True;
	P = GetPlayerOwner();

	switch (Key)
	{
	case P.EInputKey.IK_Ctrl:
		bControlDown = True;
		break;
	case P.EInputKey.IK_Shift:
		bShiftDown = True;
		break;
	case P.EInputKey.IK_Escape:
		break;
	case P.EInputKey.IK_Enter:
		if(bCanEdit)
		{
			if(bHistory)
			{
				if(Value != "")
				{
					CurrentHistory = UWindowEditBoxHistory(HistoryList.Insert(class'UWindowEditBoxHistory'));
					CurrentHistory.HistoryText = Value;
				}
				CurrentHistory = HistoryList;
			}
			Notify(DE_EnterPressed);
		}
		break;
	case P.EInputKey.IK_MouseWheelUp:
		if(bCanEdit)
			Notify(DE_WheelUpPressed);
		break;
	case P.EInputKey.IK_MouseWheelDown:
		if(bCanEdit)
			Notify(DE_WheelDownPressed);
		break;

	case P.EInputKey.IK_Right:
		if(bCanEdit) 
		{
			if(bControlDown)
				WordRight();
			else
				MoveRight();
		}
		bAllSelected = False;
		break;
	case P.EInputKey.IK_Left:
		if(bCanEdit)
		{
			if(bControlDown)
				WordLeft();
			else
				MoveLeft();
		}
		bAllSelected = False;
		break;
	case P.EInputKey.IK_Up:
		if(bCanEdit && bHistory)
		{
			bAllSelected = False;
			if(CurrentHistory != None && CurrentHistory.Next != None)
			{
				CurrentHistory = UWindowEditBoxHistory(CurrentHistory.Next);
				SetValue(CurrentHistory.HistoryText);
				MoveEnd();
			}
		}
		break;
	case P.EInputKey.IK_Down:
		if(bCanEdit && bHistory)
		{
			bAllSelected = False;
			if(CurrentHistory != None && CurrentHistory.Prev != None)
			{
				CurrentHistory = UWindowEditBoxHistory(CurrentHistory.Prev);
				SetValue(CurrentHistory.HistoryText);
				MoveEnd();
			}
		}
		break;
	case P.EInputKey.IK_Home:
		if(bCanEdit)
			MoveHome();
		bAllSelected = False;
		break;
	case P.EInputKey.IK_End:
		if(bCanEdit)
			MoveEnd();
		bAllSelected = False;
		break;
	case P.EInputKey.IK_Backspace:
		if(bCanEdit)
		{
			if(bAllSelected)
				Clear();
			else
				Backspace();
		}
		bAllSelected = False;
		break;
	case P.EInputKey.IK_Delete:
		if(bCanEdit)
		{
			if(bAllSelected)
				Clear();
			else
				Delete();
		}
		bAllSelected = False;
		break;
	case P.EInputKey.IK_Period:
	case P.EInputKey.IK_NumPadPeriod:
		if (bNumericFloat)
			Insert(Asc("."));
		break;
	default:
		if( bControlDown )
		{
			if( Key == Asc("c") || Key == Asc("C"))
				EditCopy();

			if( Key == Asc("v") || Key == Asc("V"))
				EditPaste();

			if( Key == Asc("x") || Key == Asc("X"))
				EditCut();
		}
		else
		{
			if(NotifyOwner != None)
				NotifyOwner.KeyDown(Key, X, Y);
			else
				Super.KeyDown(Key, X, Y);
		}
		break;
	}
}

function Click(float X, float Y)
{
	Notify(DE_Click);
}

function LMouseDown(float X, float Y)
{
	Super.LMouseDown(X, Y);
	Notify(DE_LMouseDown);
}

function Paint(Canvas C, float X, float Y)
{
	local float W, H;
	local float TextY;

	C.Font = Root.Fonts[Font];

	TextSize(C, "A", W, H);
	TextY = (WinHeight - H) / 2;

	TextSize(C, Left(Value, CaretOffset), W, H);

	C.DrawColor.R = 255;
	C.DrawColor.G = 255;
	C.DrawColor.B = 255;

	if(W + Offset < 0)
		Offset = -W;

	if(W + Offset > (WinWidth - 2))
	{
		Offset = (WinWidth - 2) - W;
		if(Offset > 0) Offset = 0;
	}

	C.DrawColor = TextColor;

	if(bAllSelected)
	{
		DrawStretchedTexture(C, Offset + 1, TextY, W, H, Texture'UWindow.WhiteTexture');

		// Invert Colors
		C.DrawColor.R = 255 ^ C.DrawColor.R;
		C.DrawColor.G = 255 ^ C.DrawColor.G;
		C.DrawColor.B = 255 ^ C.DrawColor.B;
	}

	ClipText(C, Offset + 1, TextY,  Value);

	if((!bHasKeyboardFocus) || (!bCanEdit))
		bShowCaret = False;
	else
	{
		if((GetLevel().TimeSeconds > LastDrawTime + 0.3) || (GetLevel().TimeSeconds < LastDrawTime))
		{
			LastDrawTime = GetLevel().TimeSeconds;
			bShowCaret = !bShowCaret;
		}
	}

	if(bShowCaret)
		ClipText(C, Offset + W - 1, TextY, "|");
}

function Close(optional bool bByParent)
{
	if(bChangePending)
	{
		bChangePending = False;
		Notify(DE_Change);
	}
	bKeyDown = False;
	Super.Close(bByParent);
}

function FocusOtherWindow(UWindowWindow W)
{
	if(bChangePending)
	{
		bChangePending = False;
		Notify(DE_Change);
	}

	if(NotifyOwner != None)
		NotifyOwner.FocusOtherWindow(W);
	else
		Super.FocusOtherWindow(W);
}

function KeyFocusEnter()
{
	if(bSelectOnFocus && !bHasKeyboardFocus)
		SelectAll();

	Super.KeyFocusEnter();
}

function DoubleClick(float X, float Y)
{
	Super.DoubleClick(X, Y);
	SelectAll();
}

function KeyFocusExit()
{
	bAllSelected = False;
	Super.KeyFocusExit();
}
	

defaultproperties
{
}
