class PhysicalChildWindow expands SpeechWindow;

var int OptionOffset;
var int MinOptions;

var string TauntCommand[30];
var localized string PhysicalTaunts[30];

function Created()
{
	local int i;
	local int W, H;
	local float XMod, YMod;

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

	NumOptions = 4;

	Super.Created();

	for (i=0; i<NumOptions; i++)
	{
		OptionButtons[i].Text = int((i + 1) % 10) @ PhysicalTaunts[i];
	}

	TopButton.OverTexture = texture'OrdersTopArrow';
	TopButton.UpTexture = texture'OrdersTopArrow';
	TopButton.DownTexture = texture'OrdersTopArrow';
	TopButton.WinLeft = 0;
	BottomButton.OverTexture = texture'OrdersBtmArrow';
	BottomButton.UpTexture = texture'OrdersBtmArrow';
	BottomButton.DownTexture = texture'OrdersBtmArrow';
	BottomButton.WinLeft = 0;

	MinOptions = Min(10,NumOptions);

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
	BottomButton.WinTop = (32.0/768.0*YMod)*(Min(MinOptions, NumOptions - OptionOffset)+1);
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
					GetPlayerOwner().ConsoleCommand(TauntCommand[i]);
			}
			if (B == TopButton)
			{
				if (OptionOffset >= 10) OptionOffset -= 10;
			}
			if (B == BottomButton)
			{
				if (NumOptions - OptionOffset > 10) OptionOffset += 10;
			}
			break;
	}
}

defaultproperties
{
      OptionOffset=0
      MinOptions=0
      TauntCommand(0)="taunt victory1"
      TauntCommand(1)="taunt thrust"
      TauntCommand(2)="taunt taunt1"
      TauntCommand(3)="taunt wave"
      TauntCommand(4)=""
      TauntCommand(5)=""
      TauntCommand(6)=""
      TauntCommand(7)=""
      TauntCommand(8)=""
      TauntCommand(9)=""
      TauntCommand(10)=""
      TauntCommand(11)=""
      TauntCommand(12)=""
      TauntCommand(13)=""
      TauntCommand(14)=""
      TauntCommand(15)=""
      TauntCommand(16)=""
      TauntCommand(17)=""
      TauntCommand(18)=""
      TauntCommand(19)=""
      TauntCommand(20)=""
      TauntCommand(21)=""
      TauntCommand(22)=""
      TauntCommand(23)=""
      TauntCommand(24)=""
      TauntCommand(25)=""
      TauntCommand(26)=""
      TauntCommand(27)=""
      TauntCommand(28)=""
      TauntCommand(29)=""
      PhysicalTaunts(0)="Basic Taunt"
      PhysicalTaunts(1)="Pelvic Thrust"
      PhysicalTaunts(2)="Victory Dance"
      PhysicalTaunts(3)="Wave"
      PhysicalTaunts(4)=""
      PhysicalTaunts(5)=""
      PhysicalTaunts(6)=""
      PhysicalTaunts(7)=""
      PhysicalTaunts(8)=""
      PhysicalTaunts(9)=""
      PhysicalTaunts(10)=""
      PhysicalTaunts(11)=""
      PhysicalTaunts(12)=""
      PhysicalTaunts(13)=""
      PhysicalTaunts(14)=""
      PhysicalTaunts(15)=""
      PhysicalTaunts(16)=""
      PhysicalTaunts(17)=""
      PhysicalTaunts(18)=""
      PhysicalTaunts(19)=""
      PhysicalTaunts(20)=""
      PhysicalTaunts(21)=""
      PhysicalTaunts(22)=""
      PhysicalTaunts(23)=""
      PhysicalTaunts(24)=""
      PhysicalTaunts(25)=""
      PhysicalTaunts(26)=""
      PhysicalTaunts(27)=""
      PhysicalTaunts(28)=""
      PhysicalTaunts(29)=""
      TopTexture=Texture'UTMenu.Skins.OrdersTop2'
      WindowTitle=""
}
