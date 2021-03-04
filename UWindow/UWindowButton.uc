//=============================================================================
// UWindowButton - A button
//=============================================================================
class UWindowButton extends UWindowDialogControl;

var bool		bDisabled;
var bool		bStretched;
var Texture		UpTexture, DownTexture, DisabledTexture, OverTexture;
var Region		UpRegion,  DownRegion,  DisabledRegion,  OverRegion;
var bool		bUseRegion;
var float		RegionScale;
var string		ToolTipString;
var float		ImageX, ImageY;
var sound		OverSound, DownSound;
var int			IntegerScaleBorderSize;

function Created()
{
	Super.Created();

	ImageX = 0;
	ImageY = 0;
	TextX = 0;
	TextY = 0;
	RegionScale = 1;
}

function BeforePaint(Canvas C, float X, float Y)
{
	C.Font = Root.Fonts[Font];
}

function Paint( Canvas C, float X, float Y)
{
	local Texture Tex;
	local Region R;

	C.Font = Root.Fonts[Font];

	Tex = GetButtonTexture();
	if ( Tex != None )
	{
		if ( bUseRegion )
		{
			R = GetButtonRegion();
			DrawStretchedTextureSegment( C, ImageX, ImageY, R.W*RegionScale, R.H*RegionScale, R.X, R.Y, R.W, R.H, Tex);
		}
		else if ( bStretched )
			DrawStretchedTexture( C, ImageX, ImageY, WinWidth, WinHeight, Tex);
		else
			DrawClippedTexture( C, ImageX, ImageY, Tex);
	}

	if ( Text != "" )
	{
		C.DrawColor = TextColor;
		ClipText(C, TextX, TextY, Text, True);
		C.DrawColor.R = 255;
		C.DrawColor.G = 255;
		C.DrawColor.B = 255;
	}
}

function MouseLeave()
{
	Super.MouseLeave();
	if(ToolTipString != "") ToolTip("");
}

simulated function MouseEnter()
{
	Super.MouseEnter();
	if(ToolTipString != "") ToolTip(ToolTipString);
	if (!bDisabled && (OverSound != None))
		GetPlayerOwner().PlaySound( OverSound, SLOT_Interface );
}

simulated function Click(float X, float Y) 
{
	Notify(DE_Click);
	if (!bDisabled && (DownSound != None))
		GetPlayerOwner().PlaySound( DownSound, SLOT_Interface ); // If this interruptsh OverSound sound, one can just use another Actor like LevelInfo, etc. --han
}

function DoubleClick(float X, float Y) 
{
	Notify(DE_DoubleClick);
}

function RClick(float X, float Y) 
{
	Notify(DE_RClick);
}

function MClick(float X, float Y) 
{
	Notify(DE_MClick);
}

function KeyDown(int Key, float X, float Y)
{
	local PlayerPawn P;

	P = Root.GetPlayerOwner();

	switch (Key)
	{
	case P.EInputKey.IK_Space:
		LMouseDown(X, Y);
		LMouseUp(X, Y);
		break;
	default:
		Super.KeyDown(Key, X, Y);
		break;
	}
}

function Texture GetButtonTexture()
{
	if      ( bDisabled )     return DisabledTexture;
	else if ( bMouseDown )    return DownTexture;
	else if ( MouseIsOver() ) return OverTexture;
	else                      return UpTexture;
}

function Region GetButtonRegion()
{
	if      ( bDisabled )     return DisabledRegion;
	else if ( bMouseDown )    return DownRegion;
	else if ( MouseIsOver() ) return OverRegion;
	else                      return UpRegion;
}

defaultproperties
{
      bDisabled=False
      bStretched=False
      UpTexture=None
      DownTexture=None
      DisabledTexture=None
      OverTexture=None
      UpRegion=(X=0,Y=0,W=0,H=0)
      DownRegion=(X=0,Y=0,W=0,H=0)
      DisabledRegion=(X=0,Y=0,W=0,H=0)
      OverRegion=(X=0,Y=0,W=0,H=0)
      bUseRegion=False
      RegionScale=0.000000
      ToolTipString=""
      ImageX=0.000000
      ImageY=0.000000
      OverSound=None
      DownSound=None
      IntegerScaleBorderSize=0
      bIgnoreLDoubleClick=True
      bIgnoreMDoubleClick=True
      bIgnoreRDoubleClick=True
}
