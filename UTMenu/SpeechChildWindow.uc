class SpeechChildWindow expands SpeechWindow;

var int OptionOffset;
var int MinOptions;

var int OtherOffset[32];

function Created()
{
	local int i, j;
	local int W, H;
	local float XMod, YMod;
	local color TextColor;
	local class<ChallengeVoicePack> V;

	V = class<ChallengeVoicePack>(GetPlayerOwner().PlayerReplicationInfo.VoiceType);
	if (V == None)
		Log("SpeechChildWindow: Critical error, V is none.");

	W = Root.WinWidth / 4;
	H = W;

	if(W > 256 || H > 256)
	{
		W = 256;
		H = 256;
	}

	XMod = 4*W;
	YMod = 3*H;

	CurrentType = SpeechWindow(ParentWindow).CurrentType;

	switch (CurrentType)
	{
		case 0: // Acknowledgements
			NumOptions = V.Default.numAcks;
			break;
		case 1: // Friendly Fire
			NumOptions = V.Default.numFFires;
			break;
		case 3: // Taunts
			NumOptions = V.Default.numTaunts;
			break;
		case 4: // Other
			j = 0;
			for (i=0; i<32; i++)
			{
				if (V.Static.GetOtherString(i) != "")
					OtherOffset[j++] = i;
			}
			NumOptions = j;
			break;
	}
	
	Super.Created();

	for (i=0; i<NumOptions; i++)
	{
		switch (CurrentType)
		{
			case 0: // Acknowledgements
				OptionButtons[i].Text = V.Static.GetAckString(i);
				break;
			case 1: // Friendly Fire
				OptionButtons[i].Text = V.Static.GetFFireString(i);
				break;
			case 3: // Taunts
				OptionButtons[i].Text = V.Static.GetTauntString(i);
				break;
			case 4: // Other
				OptionButtons[i].Text = V.Static.GetOtherString(OtherOffset[i]);
				break;
		}
	}

	TopButton.OverTexture = texture'OrdersTopArrow';
	TopButton.UpTexture = texture'OrdersTopArrow';
	TopButton.DownTexture = texture'OrdersTopArrow';
	TopButton.WinLeft = 0;
	BottomButton.OverTexture = texture'OrdersBtmArrow';
	BottomButton.UpTexture = texture'OrdersBtmArrow';
	BottomButton.DownTexture = texture'OrdersBtmArrow';
	BottomButton.WinLeft = 0;

	MinOptions = Min(8,NumOptions);

	WinTop = (196.0/768.0 * YMod) + (32.0/768.0 * YMod)*(CurrentType-1);
	WinLeft = 256.0/1024.0 * XMod;
	WinWidth = 256.0/1024.0 * XMod;
	WinHeight = (32.0/768.0 * YMod)*(MinOptions+2);

	SetButtonTextures(0, True, False);
}

function BeforePaint(Canvas C, float X, float Y)
{
	local int W, H;
	local float XWidth, YHeight, XMod, YMod, XPos, YPos, YOffset, BottomTop, XL, YL;
	local color TextColor;
	local int i;

	Super(NotifyWindow).BeforePaint(C, X, Y);

	W = Root.WinWidth / 4;
	H = W;

	if(W > 256 || H > 256)
	{
		W = 256;
		H = 256;
	}

	XMod = 4*W;
	YMod = 3*H;

	XWidth = 256.0/1024.0 * XMod;
	YHeight = 32.0/768.0 * YMod;

	TopButton.SetSize(XWidth, YHeight);
	TopButton.WinTop = 0;
	TopButton.MyFont = class'UTLadderStub'.Static.GetStubClass().Static.GetBigFont(Root);
	if (OptionOffset > 0)
		TopButton.bDisabled = False;
	else
		TopButton.bDisabled = True;

	for(i=0; i<OptionOffset; i++)
	{
		OptionButtons[i].HideWindow();
	}
	for(i=OptionOffset; i<MinOptions+OptionOffset; i++)
	{
		OptionButtons[i].ShowWindow();
		OptionButtons[i].SetSize(XWidth, YHeight);
		OptionButtons[i].WinLeft = 0;
		OptionButtons[i].WinTop = (32.0/768.0*YMod)*(i+1-OptionOffset);
	}
	for(i=MinOptions+OptionOffset; i<NumOptions; i++)
	{
		OptionButtons[i].HideWindow();
	}

	BottomButton.SetSize(XWidth, YHeight);
	BottomButton.WinTop = (32.0/768.0*YMod)*(MinOptions+1);
	BottomButton.MyFont = class'UTLadderStub'.Static.GetStubClass().Static.GetBigFont(Root);
	if (NumOptions > MinOptions+OptionOffset)
		BottomButton.bDisabled = False;
	else
		BottomButton.bDisabled = True;
}

function Paint(Canvas C, float X, float Y)
{
	local int i;

	Super.Paint(C, X, Y);

	// Text
	for(i=0; i<NumOptions; i++)
	{
		OptionButtons[i].FadeFactor = FadeFactor/100;
	}
}

event bool KeyEvent( byte Key, byte Action, FLOAT Delta )
{
	local byte B;
	
	if ( CurrentKey == Key )
	{
		if ( Action == 3 ) // IST_Release
			CurrentKey = -1;
		return false;
	}

	if ( SpeechChild != None )
		return SpeechChild.KeyEvent(Key, Action, Delta);

	if ( Key == 38 )
	{
		CurrentKey = Key;
		Notify( TopButton, DE_Click );
		return true;
	}

	if ( Key == 40 )
	{
		CurrentKey = Key;
		Notify( BottomButton, DE_Click );
		return true;
	}
		
	B = Key - 48;
	if ( B == 0 )
		B = 9;
	else
		B -= 1;
	if ( (B>=0) && (B<10) )
	{
		CurrentKey = Key;
		Notify( OptionButtons[B + OptionOffset], DE_Click );
		return true;
	}

	return false;		
}

function Notify(UWindowWindow B, byte E)
{
	local int i;

	switch (E)
	{
		case DE_DoubleClick:
		case DE_Click:
			GetPlayerOwner().PlaySound( Sound'SpeechWindowClick', SLOT_Interface );
			for (i=0; i<NumOptions; i++)
			{
				if (B == OptionButtons[i])
				{
					if (CurrentType == 4)
					{
						Root.GetPlayerOwner().Speech(CurrentType, OtherOffset[i], 0);
					} else
						Root.GetPlayerOwner().Speech(CurrentType, i, 0);
					break;
				}
			}
			if (B == TopButton)
			{
				if (NumOptions > 8)
				{
					if (OptionOffset > 0)
						OptionOffset--;
				}
			}
			if (B == BottomButton)
			{
				if (NumOptions > 8)
				{
					if (NumOptions - OptionOffset > 8)
						OptionOffset++;
				}
			}
			SetButtonTextures(OptionOffset, True, False);
			break;
	}
}

defaultproperties
{
      OptionOffset=0
      MinOptions=0
      OtherOffset(0)=0
      OtherOffset(1)=0
      OtherOffset(2)=0
      OtherOffset(3)=0
      OtherOffset(4)=0
      OtherOffset(5)=0
      OtherOffset(6)=0
      OtherOffset(7)=0
      OtherOffset(8)=0
      OtherOffset(9)=0
      OtherOffset(10)=0
      OtherOffset(11)=0
      OtherOffset(12)=0
      OtherOffset(13)=0
      OtherOffset(14)=0
      OtherOffset(15)=0
      OtherOffset(16)=0
      OtherOffset(17)=0
      OtherOffset(18)=0
      OtherOffset(19)=0
      OtherOffset(20)=0
      OtherOffset(21)=0
      OtherOffset(22)=0
      OtherOffset(23)=0
      OtherOffset(24)=0
      OtherOffset(25)=0
      OtherOffset(26)=0
      OtherOffset(27)=0
      OtherOffset(28)=0
      OtherOffset(29)=0
      OtherOffset(30)=0
      OtherOffset(31)=0
      TopTexture=Texture'UTMenu.Skins.OrdersTop2'
      WindowTitle=""
}
