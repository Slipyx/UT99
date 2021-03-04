//=============================================================================
// FontInfo
// Unreal Tournament's HUD and Scoreboard font selector.
// * Redesigned for version 469 to use dynamic fonts.
//=============================================================================
class FontInfo expands Info
	  config(User);

var float SavedWidth[7];
var Font SavedFont[7];
var float FontDiv[7];
var config bool bEnableInGameScaling;
var config float InGameScalingFactor;
var bool bCurrentInGameScaling;
var float CurrentInGameScalingFactor;
var bool bCacheSetup;

struct FontCache
{
	var() Font Font;
	var() float MinSize;
	var() float MaxSize;
};
var array<FontCache> CachedFonts;



/*------------------------------- Font selector ----------------------------------*/

function Font GetHugeFont(float Width)
{
	return GetFontIndex(6,Width);
}

function Font GetBigFont(float Width)
{
	return GetFontIndex(5,Width);
}

function Font GetMediumFont(float Width)
{
	return GetFontIndex(4,Width);
}

function Font GetSmallFont(float Width)
{
	return GetFontIndex(3,Width);
}

function Font GetSmallestFont(float Width)
{
	return GetFontIndex(2,Width);
}

function Font GetAReallySmallFont(float Width)
{
	return GetFontIndex(1,Width);
}

function Font GetACompletelyUnreadableFont(float Width)
{
	return GetFontIndex(0,Width);
}

function Font GetFontIndex(int i, float Width)
{
	if ( bCurrentInGameScaling != bEnableInGameScaling ||
		 CurrentInGameScalingFactor != InGameScalingFactor )
		SetScalingState( bEnableInGameScaling );

	if ( (SavedFont[i] != None) && (Width == SavedWidth[i]) )
		return SavedFont[i];
	
	SavedWidth[i] = Width;
	if ( bEnableInGameScaling )
	{
		//In lower resolutions fonts need to be a bit bigger
		SavedFont[i] = GetFontBySize( (Width + (6-i)*32) / FontDiv[i] );
	}
	else
	{
		switch (i)
		{
			case 0:
				 SavedFont[0] = GetStaticACompletelyUnreadableFont(Width);
				 break;
			case 1:
				 SavedFont[1] = GetStaticAReallySmallFont(Width);
				 break;
			case 2:
				 SavedFont[2] = GetStaticSmallestFont(Width);
				 break;
			case 3:
				 SavedFont[3] = GetStaticSmallFont(Width);
				 break;
			case 4:
				 SavedFont[4] = GetStaticMediumFont(Width);
				 break;
			case 5:
				 SavedFont[5] = GetStaticBigFont(Width);
				 break;
			case 6:
				 SavedFont[6] = GetStaticHugeFont(Width);
				 break;			
		}
	}
	return SavedFont[i];
}


/*---------------- (469) Dynamically create fonts and cache them -----------------*/

//Precache fonts if font scaling is enabled at game start
event PostBeginPlay()
{
	SetScalingState(bEnableInGameScaling);
}

function SetScalingState(bool bEnableScaling)
{
	local int i;

	if ( bEnableScaling )
	{
		if ( !bCacheSetup )
		{
			bCacheSetup = true;
			AddNewFontCache( Font'SmallFont', 0, 7);
			AddNewFontCache( Font(DynamicLoadObject("LadderFonts.UTLadder10", class'Font')), 7, 10);
			AddNewFontCache( Font(DynamicLoadObject("LadderFonts.UTLadder12", class'Font')), 10, 12);
			AddNewFontCache( Font(DynamicLoadObject("LadderFonts.UTLadder14", class'Font')), 12, 14);
			AddNewFontCache( Font(DynamicLoadObject("LadderFonts.UTLadder16", class'Font')), 14, 16);
			AddNewFontCache( Font(DynamicLoadObject("LadderFonts.UTLadder18", class'Font')), 16, 20);
			AddNewFontCache( Font(DynamicLoadObject("LadderFonts.UTLadder20", class'Font')), 20, 22);
			AddNewFontCache( Font(DynamicLoadObject("LadderFonts.UTLadder22", class'Font')), 22, 24);
			AddNewFontCache( Font(DynamicLoadObject("LadderFonts.UTLadder24", class'Font')), 24, 30);
			AddNewFontCache( Font(DynamicLoadObject("LadderFonts.UTLadder30", class'Font')), 30, 36);
			AddNewFontCache( Font(DynamicLoadObject("LadderFonts.UTLadder36", class'Font')), 36, 42);
			AddNewFontCache( Font(DynamicLoadObject("LadderFonts.UTLadder42", class'Font')), 42, 48);
			AddNewFontCache( Font(DynamicLoadObject("LadderFonts.UTLadder48", class'Font')), 48, 54);
			AddNewFontCache( Font(DynamicLoadObject("LadderFonts.UTLadder54", class'Font')), 54, 60);
			AddNewFontCache( Font(DynamicLoadObject("LadderFonts.UTLadder60", class'Font')), 60, 85);
		}
	}

	// Reset resolution caches to make bEnableInGameScaling changes effective immediately
	for ( i=0 ; i<7 ; ++i )
	{
		SavedFont[i]  = none;
		SavedWidth[i] = 0;
	}

	bEnableInGameScaling = bEnableScaling;
	bCurrentInGameScaling = bEnableScaling;
	CurrentInGameScalingFactor = InGameScalingFactor;
}

function Font GetFontBySize(float IdealSize)
{
	local int i;
	local float NewBase;
	local Font NewFont;

	// Don't blow up the dynamic font cache
	IdealSize = fClamp( Abs(IdealSize) * InGameScalingFactor, 6, 100 );
	For ( i=0 ; i<CachedFonts.Length ; i++ )
		if ( (IdealSize >= CachedFonts[i].MinSize) && (IdealSize <= CachedFonts[i].MaxSize) )
			return CachedFonts[i].Font;

	// Dynamically created fonts will scale up using 'Square(X)' where X increments by 0.5
	NewBase = Sqrt(IdealSize);
	NewBase = NewBase - (NewBase % 0.5);
	NewFont = class'Canvas'.static.CreateFont( FF_Arial, int(Square(NewBase)), false, false, false, false, true);

	// Font could not be created, choose latest in cache
	if ( NewFont == None )
		return CachedFonts[CachedFonts.Length-1].Font;

	AddNewFontCache( NewFont, Square(NewBase), Square(NewBase+0.5) );
	return NewFont;
}

function AddNewFontCache( Font Font, float MinSize, float MaxSize)
{
	local int i;
	local FontCache NewCache;
	
	if ( Font == None || !bCacheSetup )
		return;

	NewCache.Font = Font;
	NewCache.MinSize = MinSize;
	NewCache.MaxSize = MaxSize;
	
	i = CachedFonts.Length;
	CachedFonts.Insert( i, 1);
	CachedFonts[i] = NewCache;
}


/*---------------- Old code, preserved for compatibility purposes ----------------*/

static function Font GetStaticHugeFont(float Width)
{
	if (Width < 512)
		return Font'SmallFont';
	else if (Width < 640)
		return Font(DynamicLoadObject("LadderFonts.UTLadder16", class'Font'));
	else if (Width < 800)
		return Font(DynamicLoadObject("LadderFonts.UTLadder20", class'Font'));
	else if (Width < 1024)
		return Font(DynamicLoadObject("LadderFonts.UTLadder22", class'Font'));
	else
		return Font(DynamicLoadObject("LadderFonts.UTLadder30", class'Font'));
}

static function Font GetStaticBigFont(float Width)
{
	if (Width < 512)
		return Font'SmallFont';
	else if (Width < 640)
		return Font(DynamicLoadObject("LadderFonts.UTLadder16", class'Font'));
	else if (Width < 800)
		return Font(DynamicLoadObject("LadderFonts.UTLadder18", class'Font'));
	else if (Width < 1024)
		return Font(DynamicLoadObject("LadderFonts.UTLadder20", class'Font'));
	else
		return Font(DynamicLoadObject("LadderFonts.UTLadder22", class'Font'));
}

static function Font GetStaticMediumFont(float Width)
{
	if (Width < 512)
		return Font'SmallFont';
	else if (Width < 800)
		return Font(DynamicLoadObject("LadderFonts.UTLadder16", class'Font'));
	else
		return Font(DynamicLoadObject("LadderFonts.UTLadder22", class'Font'));
}

static function Font GetStaticSmallFont(float Width)
{
	if (Width < 640)
		return Font'SmallFont';
	else if (Width < 800)
		return Font(DynamicLoadObject("LadderFonts.UTLadder10", class'Font'));
	else if (Width < 1024)
		return Font(DynamicLoadObject("LadderFonts.UTLadder14", class'Font'));
	else
		return Font(DynamicLoadObject("LadderFonts.UTLadder16", class'Font'));
}

static function Font GetStaticSmallestFont(float Width)
{
	if (Width < 640)
		return Font'SmallFont';
	else if (Width < 800)
		return Font(DynamicLoadObject("LadderFonts.UTLadder10", class'Font'));
	else if (Width < 1024)
		return Font(DynamicLoadObject("LadderFonts.UTLadder12", class'Font'));
	else
		return Font(DynamicLoadObject("LadderFonts.UTLadder14", class'Font'));
}

static function Font GetStaticAReallySmallFont(float Width)
{
	if (Width < 800)
		return Font'SmallFont';
	else if (Width < 1024)
		return Font(DynamicLoadObject("LadderFonts.UTLadder8", class'Font'));
	else
		return Font(DynamicLoadObject("LadderFonts.UTLadder10", class'Font'));
}

static function Font GetStaticACompletelyUnreadableFont(float Width)
{
	if (Width < 800)
		return Font'SmallFont';
	else
		return Font(DynamicLoadObject("LadderFonts.UTLadder8", class'Font'));
}

defaultproperties
{
      SavedWidth(0)=0.000000
      SavedWidth(1)=0.000000
      SavedWidth(2)=0.000000
      SavedWidth(3)=0.000000
      SavedWidth(4)=0.000000
      SavedWidth(5)=0.000000
      SavedWidth(6)=0.000000
      SavedFont(0)=None
      SavedFont(1)=None
      SavedFont(2)=None
      SavedFont(3)=None
      SavedFont(4)=None
      SavedFont(5)=None
      SavedFont(6)=None
      FontDiv(0)=160.000000
      FontDiv(1)=128.000000
      FontDiv(2)=100.000000
      FontDiv(3)=80.000000
      FontDiv(4)=60.000000
      FontDiv(5)=50.000000
      FontDiv(6)=40.000000
      bEnableInGameScaling=False
      InGameScalingFactor=1.000000
      bCurrentInGameScaling=False
      CurrentInGameScalingFactor=0.000000
      bCacheSetup=False
      CachedFonts=()
}
