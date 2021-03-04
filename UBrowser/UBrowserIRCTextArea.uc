class UBrowserIRCTextArea expands UWindowURLTextArea;

var globalconfig int IndentSize;

function UWindowDynamicTextRow AddText(string Text)
{
	local UWindowDynamicTextRow R;
	local int i, j;

	ReplaceText(Text, Chr(2), "");
	ReplaceText(Text, Chr(15), "");
	ReplaceText(Text, Chr(22), "");
	ReplaceText(Text, Chr(31), "");

	i = InStr(Text, Chr(3));
	while(i != -1)
	{
		j = 1;
		While(i+j < Len(Text) && InStr("0123456789,", Mid(Text, i+j, 1)) != -1)
			j++;

		Text = Left(Text, i) $ Mid(Text, i+j);

		i = InStr(Text, Chr(3));
	}
			
  //utpg: \n bug fix, "\n" in a string should not be replaced by an actual newline
	//R = Super.AddText(Text);
  // reuse a row if possible
	R = CheckMaxRows();

	if(R != None)
		List.AppendItem(R);
	else
		R = UWindowDynamicTextRow(List.Append(RowClass));

  R.WrapParent = None;
	R.bRowDirty = True;
	R.Text = Text;

  bDirty = True; // or else it won't wrap
  //utpg: \n bug fix -- end
   
	UBrowserIRCPageBase(OwnerWindow).AddedText();
	return R;
}

function LaunchUnrealURL(string URL)
{
	Super.LaunchUnrealURL(URL);

	GetParent(class'UWindowFramedWindow').Close();
	Root.Console.CloseUWindow();
}

function RMouseUp(float X, float Y)
{
	local UBrowserIRCPageBase P;
	local float GX, GY;

	P = UBrowserIRCPageBase(GetParent(class'UBrowserIRCPageBase'));
	WindowToGlobal(X, Y, GX, GY);
	P.GlobalToWindow(GX, GY, X, Y);
	P.RMouseUp(X, Y);
}

//utpg: improved wrapping, add IndentSize spaces in front of the wrapped line to improve readability
function float DrawTextLine(Canvas C, UWindowDynamicTextRow L, float Y)
{
	local float X, W, H;
  local int i;
  local string indent;

	if(bHCenter)
	{
		TextAreaTextSize(C, L.Text, W, H);
		if(VertSB.bWindowVisible)
			X = int(((WinWidth - VertSB.WinWidth) - W) / 2);
		else
			X = int((WinWidth - W) / 2);
	}
	else
		X = 2;
  if (L.WrapParent == none)
  	TextAreaClipText(C, X, Y, L.Text);
  else 
  {
    for (i = 0; i < IndentSize; i++) indent = indent$" ";
    TextAreaClipText(C, X, Y, indent$L.Text);
  }

	return DefaultTextHeight;
}
//utpg: improved wrapping

defaultproperties
{
      IndentSize=4
      MaxLines=500
}
