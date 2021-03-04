class UTFadeTextArea extends UWindowWrappedTextArea;

var float FadeTime[32];
var font MyFont;

var int ScrollingOffset;
var int NumLines, PrintLines;

var bool bAutoScrolling, bNowAutoScrolling, bMousePassThrough;

var int CurrentPendingString;
var string PendingString[20];

var int FadeLines;

var float FadeFactor;

function Created()
{
	Super.Created();
}

function BeforePaint( Canvas C, float X, float Y)
{
	local int i;

	C.Font = MyFont;
	for (i=0; i<20; i++)
	{
		if (PendingString[i] != "")
		{
			AddString(C, i);
			PendingString[i] = "";
		}
	}
}

function Paint( Canvas C, float X, float Y )
{
	local int i, j, Line;
	local int TempHead, TempTail;
	local float XL, YL;
	local bool bNextLine;

	C.Font = MyFont;
	C.DrawColor = TextColor;

	TextSize(C, "TEST", XL, YL);
	VisibleRows = WinHeight / YL;

	TempHead = Head;
	TempTail = Tail;
	Line = TempTail + ScrollingOffset;

	bNextLine = True;
	for (i=0; i<NumLines; i++)
	{
		bNextLine = LocalWrappedClipText(C, 0, YL*i, Line, TextArea[Line], false, bNextLine);
		Line++;
	}

	if (bNowAutoScrolling)
	{
		if (FadeLines-1 == VisibleRows+ScrollingOffset)
			ScrollingOffset++;
	}

	C.DrawColor.R = 255;
	C.DrawColor.G = 255;
	C.DrawColor.B = 255;
}

function Tick(float Delta)
{
	local int i;

	FadeLines = 0;
	// Update FadeTime
	for (i=0; i<NumLines; i++)
	{
		if (FadeTime[i] >= 0.0) {
			FadeLines++;
			FadeTime[i] += Delta*FadeFactor;
		} else if (FadeTime[i] == -2.0) {
			FadeLines++;
		}
	}
	if ((NumLines != 0) && (FadeTime[NumLines-1] == -2.0))
		bNowAutoScrolling = False;
}

function AddText(string S)
{
	PendingString[CurrentPendingString] = S;
	CurrentPendingString++;
}

function AddString(Canvas C, int Index)
{
	local string S, Out, Temp, Line;
	local int WordBoundary, TotalPos;
	local float W, H;
	local float X, Y;
	local float LineSize;
	local bool bSentry;

	S = PendingString[Index];

	// Early out for small lines.
	TextSize(C, S, X, Y);
	if (X < WinWidth)
	{
		NumLines++;
		Super.AddText(S);
		return;
	}

	// Cut up large lines.
	X = 0;
	bSentry = True;
	while( bSentry )
	{
		// Get the line to be drawn.
		if(Out == "")
			Out = S;

		// Find the word boundary.
		WordBoundary = InStr(Out, " ");
				
		// Get the current word.
		C.SetPos(0, 0);
		if(WordBoundary == -1)
			Temp = Out;
		else
			Temp = Left(Out, WordBoundary)$" ";
		TotalPos += WordBoundary;

		TextSize(C, Temp, W, H);

		if(W+X > WinWidth)
		{
			NumLines++;
			Super.AddText(Line);
			Line = "";
			X = 0;
		}
		Line = Line$Temp;
		X += W;

		Out = Mid(Out, Len(Temp));
		if (Out == "")
			bSentry = False;
	}
	NumLines++;
	Super.AddText(Line);
}

function bool LocalWrappedClipText(Canvas C, float X, float Y, int I, coerce string S, optional bool bCheckHotkey, optional bool bInitFadeTime)
{
	local float FadeCount, X2, Y2, XL, YL;
	local int FadeChar, FadeLength;

	if (S == "")
		return true;

	C.Style = 3;

	if (FadeTime[I] == -1.0 && bInitFadeTime)
	{
		// If first update, just set the FadeTime to zero.
		FadeTime[I] = 0.0;
		return false;
	} else if (FadeTime[I] == -2.0) {
		ClipText(C, X, Y, S, bCheckHotKey);
		return true;
	}

	for ( FadeChar = 0; FadeTime[I] - (FadeChar * 0.1) > 0.0; FadeChar++ )
	{
		FadeCount = FadeTime[I] - (FadeChar * 0.1);
		if ((FadeChar == Len(S) - 1) && (255 * (1.0 - FadeCount) < 0))
			FadeTime[I] = -2.0;

		C.DrawColor.R = Min(255 * (0.0 + FadeCount), TextColor.R);
		C.DrawColor.G = Min(255 * (0.0 + FadeCount), TextColor.G);
		C.DrawColor.B = Min(255 * (0.0 + FadeCount), TextColor.B);
		ClipText(C, X+X2, Y+Y2, Mid(S, FadeChar, 1));
		TextSize(C, Left(S, FadeChar+1), XL, YL);
		X2 = XL;

		FadeLength = XL;
	}
	C.Style = 1;
	TextSize(C, S, XL, YL);
	if (XL == FadeLength)
		return true;

	return false;
}

function Clear()
{
	local int i;

	Super.Clear();
	for (i=0; i<750; i++) {
		TextArea[i] = "";
	}
	for (i=0; i<32; i++) {
		FadeTime[i] = -1.0;
	}

	ScrollingOffset = 0;

	if (bAutoScrolling)
		bNowAutoScrolling = True;

	NumLines = 0;
	CurrentPendingString = 0;
}

function bool CheckMousePassThrough(float X, float Y)
{
	if (bMousePassThrough)
		return True;
	else
		return False;
}

defaultproperties
{
      FadeTime(0)=-1.000000
      FadeTime(1)=0.000000
      FadeTime(2)=0.000000
      FadeTime(3)=0.000000
      FadeTime(4)=0.000000
      FadeTime(5)=0.000000
      FadeTime(6)=0.000000
      FadeTime(7)=0.000000
      FadeTime(8)=0.000000
      FadeTime(9)=0.000000
      FadeTime(10)=0.000000
      FadeTime(11)=0.000000
      FadeTime(12)=0.000000
      FadeTime(13)=0.000000
      FadeTime(14)=0.000000
      FadeTime(15)=0.000000
      FadeTime(16)=0.000000
      FadeTime(17)=0.000000
      FadeTime(18)=0.000000
      FadeTime(19)=0.000000
      FadeTime(20)=0.000000
      FadeTime(21)=0.000000
      FadeTime(22)=0.000000
      FadeTime(23)=0.000000
      FadeTime(24)=0.000000
      FadeTime(25)=0.000000
      FadeTime(26)=0.000000
      FadeTime(27)=0.000000
      FadeTime(28)=0.000000
      FadeTime(29)=0.000000
      FadeTime(30)=0.000000
      FadeTime(31)=0.000000
      MyFont=None
      ScrollingOffset=0
      numLines=0
      PrintLines=0
      bAutoScrolling=False
      bNowAutoScrolling=False
      bMousePassThrough=False
      CurrentPendingString=0
      PendingString(0)=""
      PendingString(1)=""
      PendingString(2)=""
      PendingString(3)=""
      PendingString(4)=""
      PendingString(5)=""
      PendingString(6)=""
      PendingString(7)=""
      PendingString(8)=""
      PendingString(9)=""
      PendingString(10)=""
      PendingString(11)=""
      PendingString(12)=""
      PendingString(13)=""
      PendingString(14)=""
      PendingString(15)=""
      PendingString(16)=""
      PendingString(17)=""
      PendingString(18)=""
      PendingString(19)=""
      FadeLines=0
      FadeFactor=2.000000
}
