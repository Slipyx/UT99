//=======================================================================================
//  WaterTexture: Base class for fractal water textures. Parent of Wave- and WetTexture.
//  This is a built-in Unreal class and it shouldn't be modified.
//=======================================================================================

class WaterTexture extends FractalTexture
	native
	noexport
	abstract;

//
// Water drops.
//

enum WDrop
{
	DROP_FixedDepth			, // Fixed depth spot, A=depth
	DROP_PhaseSpot			, // Phased depth spot, A=frequency B=phase
	DROP_ShallowSpot		, // Shallower phased depth spot, A=frequency B=phase
	DROP_HalfAmpl           , // Half-amplitude (only 128+ values)
	DROP_RandomMover		, // Randomly moves around
	DROP_FixedRandomSpot	, // Fixed spot with random output
	DROP_WhirlyThing		, // Moves in small circles, A=speed B=depth
	DROP_BigWhirly			, // Moves in large circles, A=speed B=depth
	DROP_HorizontalLine		, // Horizontal line segment
	DROP_VerticalLine		, // Vertical line segment
	DROP_DiagonalLine1		, // Diagonal '/'
	DROP_DiagonalLine2		, // Diagonal '\'
	DROP_HorizontalOsc		, // Horizontal oscillating line segment
	DROP_VerticalOsc		, // Vertical oscillating line segment
	DROP_DiagonalOsc1		, // Diagonal oscillating '/'
	DROP_DiagonalOsc2		, // Diagonal oscillating '\'
	DROP_RainDrops			, // General random raindrops, A=depth B=distribution radius
	DROP_AreaClamp          , // Clamp spots to indicate shallow/dry areas
	DROP_LeakyTap			,
	DROP_DrippyTap			,
};


//
// Information about a single drop.
//

struct ADrop
{
    var WDrop Type;   // Drop type.
    var byte  Depth;  // Drop heat.
    var byte  X;      // Spark X location (0 - Xdimension-1).
    var byte  Y;      // Spark Y location (0 - Ydimension-1).

    var byte  ByteA;  // X-speed.
    var byte  ByteB;  // Y-speed.
    var byte  ByteC;  // Age, Emitter freq. etc.
    var byte  ByteD;  // Exp.Time etc.
};


//
// Water parameters.
//

var(WaterPaint)					WDrop  DropType;
var(WaterPaint)					byte   WaveAmp;

var(WaterPaint)					byte   FX_Frequency;
var(WaterPaint)					byte   FX_Phase;
var(WaterPaint)					byte   FX_Amplitude;
var(WaterPaint)					byte   FX_Speed;
var(WaterPaint)					byte   FX_Radius;
var(WaterPaint)					byte   FX_Size;
var(WaterPaint)					byte   FX_Depth;
var(WaterPaint)                 byte   FX_Time;

var								int    NumDrops;
var								ADrop  Drops[256];

var		 			transient   pointer    SourceFields;
var					transient   byte   RenderTable[1028];
var					transient	byte   WaterTable[1536];
var					transient	byte   WaterParity;
var					transient	int    OldWaveAmp;

defaultproperties
{
      DropType=DROP_FixedDepth
      WaveAmp=0
      FX_Frequency=0
      FX_Phase=0
      FX_Amplitude=0
      FX_Speed=0
      FX_Radius=0
      FX_Size=0
      FX_Depth=0
      FX_Time=0
      NumDrops=0
      Drops(0)=(Type=DROP_FixedDepth,depth=0,X=0,Y=0,ByteA=0,ByteB=0,ByteC=0,ByteD=0)
      Drops(1)=(Type=DROP_FixedDepth,depth=0,X=0,Y=0,ByteA=0,ByteB=0,ByteC=0,ByteD=0)
      Drops(2)=(Type=DROP_FixedDepth,depth=0,X=0,Y=0,ByteA=0,ByteB=0,ByteC=0,ByteD=0)
      Drops(3)=(Type=DROP_FixedDepth,depth=0,X=0,Y=0,ByteA=0,ByteB=0,ByteC=0,ByteD=0)
      Drops(4)=(Type=DROP_FixedDepth,depth=0,X=0,Y=0,ByteA=0,ByteB=0,ByteC=0,ByteD=0)
      Drops(5)=(Type=DROP_FixedDepth,depth=0,X=0,Y=0,ByteA=0,ByteB=0,ByteC=0,ByteD=0)
      Drops(6)=(Type=DROP_FixedDepth,depth=0,X=0,Y=0,ByteA=0,ByteB=0,ByteC=0,ByteD=0)
      Drops(7)=(Type=DROP_FixedDepth,depth=0,X=0,Y=0,ByteA=0,ByteB=0,ByteC=0,ByteD=0)
      Drops(8)=(Type=DROP_FixedDepth,depth=0,X=0,Y=0,ByteA=0,ByteB=0,ByteC=0,ByteD=0)
      Drops(9)=(Type=DROP_FixedDepth,depth=0,X=0,Y=0,ByteA=0,ByteB=0,ByteC=0,ByteD=0)
      Drops(10)=(Type=DROP_FixedDepth,depth=0,X=0,Y=0,ByteA=0,ByteB=0,ByteC=0,ByteD=0)
      Drops(11)=(Type=DROP_FixedDepth,depth=0,X=0,Y=0,ByteA=0,ByteB=0,ByteC=0,ByteD=0)
      Drops(12)=(Type=DROP_FixedDepth,depth=0,X=0,Y=0,ByteA=0,ByteB=0,ByteC=0,ByteD=0)
      Drops(13)=(Type=DROP_FixedDepth,depth=0,X=0,Y=0,ByteA=0,ByteB=0,ByteC=0,ByteD=0)
      Drops(14)=(Type=DROP_FixedDepth,depth=0,X=0,Y=0,ByteA=0,ByteB=0,ByteC=0,ByteD=0)
      Drops(15)=(Type=DROP_FixedDepth,depth=0,X=0,Y=0,ByteA=0,ByteB=0,ByteC=0,ByteD=0)
      Drops(16)=(Type=DROP_FixedDepth,depth=0,X=0,Y=0,ByteA=0,ByteB=0,ByteC=0,ByteD=0)
      Drops(17)=(Type=DROP_FixedDepth,depth=0,X=0,Y=0,ByteA=0,ByteB=0,ByteC=0,ByteD=0)
      Drops(18)=(Type=DROP_FixedDepth,depth=0,X=0,Y=0,ByteA=0,ByteB=0,ByteC=0,ByteD=0)
      Drops(19)=(Type=DROP_FixedDepth,depth=0,X=0,Y=0,ByteA=0,ByteB=0,ByteC=0,ByteD=0)
      Drops(20)=(Type=DROP_FixedDepth,depth=0,X=0,Y=0,ByteA=0,ByteB=0,ByteC=0,ByteD=0)
      Drops(21)=(Type=DROP_FixedDepth,depth=0,X=0,Y=0,ByteA=0,ByteB=0,ByteC=0,ByteD=0)
      Drops(22)=(Type=DROP_FixedDepth,depth=0,X=0,Y=0,ByteA=0,ByteB=0,ByteC=0,ByteD=0)
      Drops(23)=(Type=DROP_FixedDepth,depth=0,X=0,Y=0,ByteA=0,ByteB=0,ByteC=0,ByteD=0)
      Drops(24)=(Type=DROP_FixedDepth,depth=0,X=0,Y=0,ByteA=0,ByteB=0,ByteC=0,ByteD=0)
      Drops(25)=(Type=DROP_FixedDepth,depth=0,X=0,Y=0,ByteA=0,ByteB=0,ByteC=0,ByteD=0)
      Drops(26)=(Type=DROP_FixedDepth,depth=0,X=0,Y=0,ByteA=0,ByteB=0,ByteC=0,ByteD=0)
      Drops(27)=(Type=DROP_FixedDepth,depth=0,X=0,Y=0,ByteA=0,ByteB=0,ByteC=0,ByteD=0)
      Drops(28)=(Type=DROP_FixedDepth,depth=0,X=0,Y=0,ByteA=0,ByteB=0,ByteC=0,ByteD=0)
      Drops(29)=(Type=DROP_FixedDepth,depth=0,X=0,Y=0,ByteA=0,ByteB=0,ByteC=0,ByteD=0)
      Drops(30)=(Type=DROP_FixedDepth,depth=0,X=0,Y=0,ByteA=0,ByteB=0,ByteC=0,ByteD=0)
      Drops(31)=(Type=DROP_FixedDepth,depth=0,X=0,Y=0,ByteA=0,ByteB=0,ByteC=0,ByteD=0)
      Drops(32)=(Type=DROP_FixedDepth,depth=0,X=0,Y=0,ByteA=0,ByteB=0,ByteC=0,ByteD=0)
      Drops(33)=(Type=DROP_FixedDepth,depth=0,X=0,Y=0,ByteA=0,ByteB=0,ByteC=0,ByteD=0)
      Drops(34)=(Type=DROP_FixedDepth,depth=0,X=0,Y=0,ByteA=0,ByteB=0,ByteC=0,ByteD=0)
      Drops(35)=(Type=DROP_FixedDepth,depth=0,X=0,Y=0,ByteA=0,ByteB=0,ByteC=0,ByteD=0)
      Drops(36)=(Type=DROP_FixedDepth,depth=0,X=0,Y=0,ByteA=0,ByteB=0,ByteC=0,ByteD=0)
      Drops(37)=(Type=DROP_FixedDepth,depth=0,X=0,Y=0,ByteA=0,ByteB=0,ByteC=0,ByteD=0)
      Drops(38)=(Type=DROP_FixedDepth,depth=0,X=0,Y=0,ByteA=0,ByteB=0,ByteC=0,ByteD=0)
      Drops(39)=(Type=DROP_FixedDepth,depth=0,X=0,Y=0,ByteA=0,ByteB=0,ByteC=0,ByteD=0)
      Drops(40)=(Type=DROP_FixedDepth,depth=0,X=0,Y=0,ByteA=0,ByteB=0,ByteC=0,ByteD=0)
      Drops(41)=(Type=DROP_FixedDepth,depth=0,X=0,Y=0,ByteA=0,ByteB=0,ByteC=0,ByteD=0)
      Drops(42)=(Type=DROP_FixedDepth,depth=0,X=0,Y=0,ByteA=0,ByteB=0,ByteC=0,ByteD=0)
      Drops(43)=(Type=DROP_FixedDepth,depth=0,X=0,Y=0,ByteA=0,ByteB=0,ByteC=0,ByteD=0)
      Drops(44)=(Type=DROP_FixedDepth,depth=0,X=0,Y=0,ByteA=0,ByteB=0,ByteC=0,ByteD=0)
      Drops(45)=(Type=DROP_FixedDepth,depth=0,X=0,Y=0,ByteA=0,ByteB=0,ByteC=0,ByteD=0)
      Drops(46)=(Type=DROP_FixedDepth,depth=0,X=0,Y=0,ByteA=0,ByteB=0,ByteC=0,ByteD=0)
      Drops(47)=(Type=DROP_FixedDepth,depth=0,X=0,Y=0,ByteA=0,ByteB=0,ByteC=0,ByteD=0)
      Drops(48)=(Type=DROP_FixedDepth,depth=0,X=0,Y=0,ByteA=0,ByteB=0,ByteC=0,ByteD=0)
      Drops(49)=(Type=DROP_FixedDepth,depth=0,X=0,Y=0,ByteA=0,ByteB=0,ByteC=0,ByteD=0)
      Drops(50)=(Type=DROP_FixedDepth,depth=0,X=0,Y=0,ByteA=0,ByteB=0,ByteC=0,ByteD=0)
      Drops(51)=(Type=DROP_FixedDepth,depth=0,X=0,Y=0,ByteA=0,ByteB=0,ByteC=0,ByteD=0)
      Drops(52)=(Type=DROP_FixedDepth,depth=0,X=0,Y=0,ByteA=0,ByteB=0,ByteC=0,ByteD=0)
      Drops(53)=(Type=DROP_FixedDepth,depth=0,X=0,Y=0,ByteA=0,ByteB=0,ByteC=0,ByteD=0)
      Drops(54)=(Type=DROP_FixedDepth,depth=0,X=0,Y=0,ByteA=0,ByteB=0,ByteC=0,ByteD=0)
      Drops(55)=(Type=DROP_FixedDepth,depth=0,X=0,Y=0,ByteA=0,ByteB=0,ByteC=0,ByteD=0)
      Drops(56)=(Type=DROP_FixedDepth,depth=0,X=0,Y=0,ByteA=0,ByteB=0,ByteC=0,ByteD=0)
      Drops(57)=(Type=DROP_FixedDepth,depth=0,X=0,Y=0,ByteA=0,ByteB=0,ByteC=0,ByteD=0)
      Drops(58)=(Type=DROP_FixedDepth,depth=0,X=0,Y=0,ByteA=0,ByteB=0,ByteC=0,ByteD=0)
      Drops(59)=(Type=DROP_FixedDepth,depth=0,X=0,Y=0,ByteA=0,ByteB=0,ByteC=0,ByteD=0)
      Drops(60)=(Type=DROP_FixedDepth,depth=0,X=0,Y=0,ByteA=0,ByteB=0,ByteC=0,ByteD=0)
      Drops(61)=(Type=DROP_FixedDepth,depth=0,X=0,Y=0,ByteA=0,ByteB=0,ByteC=0,ByteD=0)
      Drops(62)=(Type=DROP_FixedDepth,depth=0,X=0,Y=0,ByteA=0,ByteB=0,ByteC=0,ByteD=0)
      Drops(63)=(Type=DROP_FixedDepth,depth=0,X=0,Y=0,ByteA=0,ByteB=0,ByteC=0,ByteD=0)
      Drops(64)=(Type=DROP_FixedDepth,depth=0,X=0,Y=0,ByteA=0,ByteB=0,ByteC=0,ByteD=0)
      Drops(65)=(Type=DROP_FixedDepth,depth=0,X=0,Y=0,ByteA=0,ByteB=0,ByteC=0,ByteD=0)
      Drops(66)=(Type=DROP_FixedDepth,depth=0,X=0,Y=0,ByteA=0,ByteB=0,ByteC=0,ByteD=0)
      Drops(67)=(Type=DROP_FixedDepth,depth=0,X=0,Y=0,ByteA=0,ByteB=0,ByteC=0,ByteD=0)
      Drops(68)=(Type=DROP_FixedDepth,depth=0,X=0,Y=0,ByteA=0,ByteB=0,ByteC=0,ByteD=0)
      Drops(69)=(Type=DROP_FixedDepth,depth=0,X=0,Y=0,ByteA=0,ByteB=0,ByteC=0,ByteD=0)
      Drops(70)=(Type=DROP_FixedDepth,depth=0,X=0,Y=0,ByteA=0,ByteB=0,ByteC=0,ByteD=0)
      Drops(71)=(Type=DROP_FixedDepth,depth=0,X=0,Y=0,ByteA=0,ByteB=0,ByteC=0,ByteD=0)
      Drops(72)=(Type=DROP_FixedDepth,depth=0,X=0,Y=0,ByteA=0,ByteB=0,ByteC=0,ByteD=0)
      Drops(73)=(Type=DROP_FixedDepth,depth=0,X=0,Y=0,ByteA=0,ByteB=0,ByteC=0,ByteD=0)
      Drops(74)=(Type=DROP_FixedDepth,depth=0,X=0,Y=0,ByteA=0,ByteB=0,ByteC=0,ByteD=0)
      Drops(75)=(Type=DROP_FixedDepth,depth=0,X=0,Y=0,ByteA=0,ByteB=0,ByteC=0,ByteD=0)
      Drops(76)=(Type=DROP_FixedDepth,depth=0,X=0,Y=0,ByteA=0,ByteB=0,ByteC=0,ByteD=0)
      Drops(77)=(Type=DROP_FixedDepth,depth=0,X=0,Y=0,ByteA=0,ByteB=0,ByteC=0,ByteD=0)
      Drops(78)=(Type=DROP_FixedDepth,depth=0,X=0,Y=0,ByteA=0,ByteB=0,ByteC=0,ByteD=0)
      Drops(79)=(Type=DROP_FixedDepth,depth=0,X=0,Y=0,ByteA=0,ByteB=0,ByteC=0,ByteD=0)
      Drops(80)=(Type=DROP_FixedDepth,depth=0,X=0,Y=0,ByteA=0,ByteB=0,ByteC=0,ByteD=0)
      Drops(81)=(Type=DROP_FixedDepth,depth=0,X=0,Y=0,ByteA=0,ByteB=0,ByteC=0,ByteD=0)
      Drops(82)=(Type=DROP_FixedDepth,depth=0,X=0,Y=0,ByteA=0,ByteB=0,ByteC=0,ByteD=0)
      Drops(83)=(Type=DROP_FixedDepth,depth=0,X=0,Y=0,ByteA=0,ByteB=0,ByteC=0,ByteD=0)
      Drops(84)=(Type=DROP_FixedDepth,depth=0,X=0,Y=0,ByteA=0,ByteB=0,ByteC=0,ByteD=0)
      Drops(85)=(Type=DROP_FixedDepth,depth=0,X=0,Y=0,ByteA=0,ByteB=0,ByteC=0,ByteD=0)
      Drops(86)=(Type=DROP_FixedDepth,depth=0,X=0,Y=0,ByteA=0,ByteB=0,ByteC=0,ByteD=0)
      Drops(87)=(Type=DROP_FixedDepth,depth=0,X=0,Y=0,ByteA=0,ByteB=0,ByteC=0,ByteD=0)
      Drops(88)=(Type=DROP_FixedDepth,depth=0,X=0,Y=0,ByteA=0,ByteB=0,ByteC=0,ByteD=0)
      Drops(89)=(Type=DROP_FixedDepth,depth=0,X=0,Y=0,ByteA=0,ByteB=0,ByteC=0,ByteD=0)
      Drops(90)=(Type=DROP_FixedDepth,depth=0,X=0,Y=0,ByteA=0,ByteB=0,ByteC=0,ByteD=0)
      Drops(91)=(Type=DROP_FixedDepth,depth=0,X=0,Y=0,ByteA=0,ByteB=0,ByteC=0,ByteD=0)
      Drops(92)=(Type=DROP_FixedDepth,depth=0,X=0,Y=0,ByteA=0,ByteB=0,ByteC=0,ByteD=0)
      Drops(93)=(Type=DROP_FixedDepth,depth=0,X=0,Y=0,ByteA=0,ByteB=0,ByteC=0,ByteD=0)
      Drops(94)=(Type=DROP_FixedDepth,depth=0,X=0,Y=0,ByteA=0,ByteB=0,ByteC=0,ByteD=0)
      Drops(95)=(Type=DROP_FixedDepth,depth=0,X=0,Y=0,ByteA=0,ByteB=0,ByteC=0,ByteD=0)
      Drops(96)=(Type=DROP_FixedDepth,depth=0,X=0,Y=0,ByteA=0,ByteB=0,ByteC=0,ByteD=0)
      Drops(97)=(Type=DROP_FixedDepth,depth=0,X=0,Y=0,ByteA=0,ByteB=0,ByteC=0,ByteD=0)
      Drops(98)=(Type=DROP_FixedDepth,depth=0,X=0,Y=0,ByteA=0,ByteB=0,ByteC=0,ByteD=0)
      Drops(99)=(Type=DROP_FixedDepth,depth=0,X=0,Y=0,ByteA=0,ByteB=0,ByteC=0,ByteD=0)
      Drops(100)=(Type=DROP_FixedDepth,depth=0,X=0,Y=0,ByteA=0,ByteB=0,ByteC=0,ByteD=0)
      Drops(101)=(Type=DROP_FixedDepth,depth=0,X=0,Y=0,ByteA=0,ByteB=0,ByteC=0,ByteD=0)
      Drops(102)=(Type=DROP_FixedDepth,depth=0,X=0,Y=0,ByteA=0,ByteB=0,ByteC=0,ByteD=0)
      Drops(103)=(Type=DROP_FixedDepth,depth=0,X=0,Y=0,ByteA=0,ByteB=0,ByteC=0,ByteD=0)
      Drops(104)=(Type=DROP_FixedDepth,depth=0,X=0,Y=0,ByteA=0,ByteB=0,ByteC=0,ByteD=0)
      Drops(105)=(Type=DROP_FixedDepth,depth=0,X=0,Y=0,ByteA=0,ByteB=0,ByteC=0,ByteD=0)
      Drops(106)=(Type=DROP_FixedDepth,depth=0,X=0,Y=0,ByteA=0,ByteB=0,ByteC=0,ByteD=0)
      Drops(107)=(Type=DROP_FixedDepth,depth=0,X=0,Y=0,ByteA=0,ByteB=0,ByteC=0,ByteD=0)
      Drops(108)=(Type=DROP_FixedDepth,depth=0,X=0,Y=0,ByteA=0,ByteB=0,ByteC=0,ByteD=0)
      Drops(109)=(Type=DROP_FixedDepth,depth=0,X=0,Y=0,ByteA=0,ByteB=0,ByteC=0,ByteD=0)
      Drops(110)=(Type=DROP_FixedDepth,depth=0,X=0,Y=0,ByteA=0,ByteB=0,ByteC=0,ByteD=0)
      Drops(111)=(Type=DROP_FixedDepth,depth=0,X=0,Y=0,ByteA=0,ByteB=0,ByteC=0,ByteD=0)
      Drops(112)=(Type=DROP_FixedDepth,depth=0,X=0,Y=0,ByteA=0,ByteB=0,ByteC=0,ByteD=0)
      Drops(113)=(Type=DROP_FixedDepth,depth=0,X=0,Y=0,ByteA=0,ByteB=0,ByteC=0,ByteD=0)
      Drops(114)=(Type=DROP_FixedDepth,depth=0,X=0,Y=0,ByteA=0,ByteB=0,ByteC=0,ByteD=0)
      Drops(115)=(Type=DROP_FixedDepth,depth=0,X=0,Y=0,ByteA=0,ByteB=0,ByteC=0,ByteD=0)
      Drops(116)=(Type=DROP_FixedDepth,depth=0,X=0,Y=0,ByteA=0,ByteB=0,ByteC=0,ByteD=0)
      Drops(117)=(Type=DROP_FixedDepth,depth=0,X=0,Y=0,ByteA=0,ByteB=0,ByteC=0,ByteD=0)
      Drops(118)=(Type=DROP_FixedDepth,depth=0,X=0,Y=0,ByteA=0,ByteB=0,ByteC=0,ByteD=0)
      Drops(119)=(Type=DROP_FixedDepth,depth=0,X=0,Y=0,ByteA=0,ByteB=0,ByteC=0,ByteD=0)
      Drops(120)=(Type=DROP_FixedDepth,depth=0,X=0,Y=0,ByteA=0,ByteB=0,ByteC=0,ByteD=0)
      Drops(121)=(Type=DROP_FixedDepth,depth=0,X=0,Y=0,ByteA=0,ByteB=0,ByteC=0,ByteD=0)
      Drops(122)=(Type=DROP_FixedDepth,depth=0,X=0,Y=0,ByteA=0,ByteB=0,ByteC=0,ByteD=0)
      Drops(123)=(Type=DROP_FixedDepth,depth=0,X=0,Y=0,ByteA=0,ByteB=0,ByteC=0,ByteD=0)
      Drops(124)=(Type=DROP_FixedDepth,depth=0,X=0,Y=0,ByteA=0,ByteB=0,ByteC=0,ByteD=0)
      Drops(125)=(Type=DROP_FixedDepth,depth=0,X=0,Y=0,ByteA=0,ByteB=0,ByteC=0,ByteD=0)
      Drops(126)=(Type=DROP_FixedDepth,depth=0,X=0,Y=0,ByteA=0,ByteB=0,ByteC=0,ByteD=0)
      Drops(127)=(Type=DROP_FixedDepth,depth=0,X=0,Y=0,ByteA=0,ByteB=0,ByteC=0,ByteD=0)
      Drops(128)=(Type=DROP_FixedDepth,depth=0,X=0,Y=0,ByteA=0,ByteB=0,ByteC=0,ByteD=0)
      Drops(129)=(Type=DROP_FixedDepth,depth=0,X=0,Y=0,ByteA=0,ByteB=0,ByteC=0,ByteD=0)
      Drops(130)=(Type=DROP_FixedDepth,depth=0,X=0,Y=0,ByteA=0,ByteB=0,ByteC=0,ByteD=0)
      Drops(131)=(Type=DROP_FixedDepth,depth=0,X=0,Y=0,ByteA=0,ByteB=0,ByteC=0,ByteD=0)
      Drops(132)=(Type=DROP_FixedDepth,depth=0,X=0,Y=0,ByteA=0,ByteB=0,ByteC=0,ByteD=0)
      Drops(133)=(Type=DROP_FixedDepth,depth=0,X=0,Y=0,ByteA=0,ByteB=0,ByteC=0,ByteD=0)
      Drops(134)=(Type=DROP_FixedDepth,depth=0,X=0,Y=0,ByteA=0,ByteB=0,ByteC=0,ByteD=0)
      Drops(135)=(Type=DROP_FixedDepth,depth=0,X=0,Y=0,ByteA=0,ByteB=0,ByteC=0,ByteD=0)
      Drops(136)=(Type=DROP_FixedDepth,depth=0,X=0,Y=0,ByteA=0,ByteB=0,ByteC=0,ByteD=0)
      Drops(137)=(Type=DROP_FixedDepth,depth=0,X=0,Y=0,ByteA=0,ByteB=0,ByteC=0,ByteD=0)
      Drops(138)=(Type=DROP_FixedDepth,depth=0,X=0,Y=0,ByteA=0,ByteB=0,ByteC=0,ByteD=0)
      Drops(139)=(Type=DROP_FixedDepth,depth=0,X=0,Y=0,ByteA=0,ByteB=0,ByteC=0,ByteD=0)
      Drops(140)=(Type=DROP_FixedDepth,depth=0,X=0,Y=0,ByteA=0,ByteB=0,ByteC=0,ByteD=0)
      Drops(141)=(Type=DROP_FixedDepth,depth=0,X=0,Y=0,ByteA=0,ByteB=0,ByteC=0,ByteD=0)
      Drops(142)=(Type=DROP_FixedDepth,depth=0,X=0,Y=0,ByteA=0,ByteB=0,ByteC=0,ByteD=0)
      Drops(143)=(Type=DROP_FixedDepth,depth=0,X=0,Y=0,ByteA=0,ByteB=0,ByteC=0,ByteD=0)
      Drops(144)=(Type=DROP_FixedDepth,depth=0,X=0,Y=0,ByteA=0,ByteB=0,ByteC=0,ByteD=0)
      Drops(145)=(Type=DROP_FixedDepth,depth=0,X=0,Y=0,ByteA=0,ByteB=0,ByteC=0,ByteD=0)
      Drops(146)=(Type=DROP_FixedDepth,depth=0,X=0,Y=0,ByteA=0,ByteB=0,ByteC=0,ByteD=0)
      Drops(147)=(Type=DROP_FixedDepth,depth=0,X=0,Y=0,ByteA=0,ByteB=0,ByteC=0,ByteD=0)
      Drops(148)=(Type=DROP_FixedDepth,depth=0,X=0,Y=0,ByteA=0,ByteB=0,ByteC=0,ByteD=0)
      Drops(149)=(Type=DROP_FixedDepth,depth=0,X=0,Y=0,ByteA=0,ByteB=0,ByteC=0,ByteD=0)
      Drops(150)=(Type=DROP_FixedDepth,depth=0,X=0,Y=0,ByteA=0,ByteB=0,ByteC=0,ByteD=0)
      Drops(151)=(Type=DROP_FixedDepth,depth=0,X=0,Y=0,ByteA=0,ByteB=0,ByteC=0,ByteD=0)
      Drops(152)=(Type=DROP_FixedDepth,depth=0,X=0,Y=0,ByteA=0,ByteB=0,ByteC=0,ByteD=0)
      Drops(153)=(Type=DROP_FixedDepth,depth=0,X=0,Y=0,ByteA=0,ByteB=0,ByteC=0,ByteD=0)
      Drops(154)=(Type=DROP_FixedDepth,depth=0,X=0,Y=0,ByteA=0,ByteB=0,ByteC=0,ByteD=0)
      Drops(155)=(Type=DROP_FixedDepth,depth=0,X=0,Y=0,ByteA=0,ByteB=0,ByteC=0,ByteD=0)
      Drops(156)=(Type=DROP_FixedDepth,depth=0,X=0,Y=0,ByteA=0,ByteB=0,ByteC=0,ByteD=0)
      Drops(157)=(Type=DROP_FixedDepth,depth=0,X=0,Y=0,ByteA=0,ByteB=0,ByteC=0,ByteD=0)
      Drops(158)=(Type=DROP_FixedDepth,depth=0,X=0,Y=0,ByteA=0,ByteB=0,ByteC=0,ByteD=0)
      Drops(159)=(Type=DROP_FixedDepth,depth=0,X=0,Y=0,ByteA=0,ByteB=0,ByteC=0,ByteD=0)
      Drops(160)=(Type=DROP_FixedDepth,depth=0,X=0,Y=0,ByteA=0,ByteB=0,ByteC=0,ByteD=0)
      Drops(161)=(Type=DROP_FixedDepth,depth=0,X=0,Y=0,ByteA=0,ByteB=0,ByteC=0,ByteD=0)
      Drops(162)=(Type=DROP_FixedDepth,depth=0,X=0,Y=0,ByteA=0,ByteB=0,ByteC=0,ByteD=0)
      Drops(163)=(Type=DROP_FixedDepth,depth=0,X=0,Y=0,ByteA=0,ByteB=0,ByteC=0,ByteD=0)
      Drops(164)=(Type=DROP_FixedDepth,depth=0,X=0,Y=0,ByteA=0,ByteB=0,ByteC=0,ByteD=0)
      Drops(165)=(Type=DROP_FixedDepth,depth=0,X=0,Y=0,ByteA=0,ByteB=0,ByteC=0,ByteD=0)
      Drops(166)=(Type=DROP_FixedDepth,depth=0,X=0,Y=0,ByteA=0,ByteB=0,ByteC=0,ByteD=0)
      Drops(167)=(Type=DROP_FixedDepth,depth=0,X=0,Y=0,ByteA=0,ByteB=0,ByteC=0,ByteD=0)
      Drops(168)=(Type=DROP_FixedDepth,depth=0,X=0,Y=0,ByteA=0,ByteB=0,ByteC=0,ByteD=0)
      Drops(169)=(Type=DROP_FixedDepth,depth=0,X=0,Y=0,ByteA=0,ByteB=0,ByteC=0,ByteD=0)
      Drops(170)=(Type=DROP_FixedDepth,depth=0,X=0,Y=0,ByteA=0,ByteB=0,ByteC=0,ByteD=0)
      Drops(171)=(Type=DROP_FixedDepth,depth=0,X=0,Y=0,ByteA=0,ByteB=0,ByteC=0,ByteD=0)
      Drops(172)=(Type=DROP_FixedDepth,depth=0,X=0,Y=0,ByteA=0,ByteB=0,ByteC=0,ByteD=0)
      Drops(173)=(Type=DROP_FixedDepth,depth=0,X=0,Y=0,ByteA=0,ByteB=0,ByteC=0,ByteD=0)
      Drops(174)=(Type=DROP_FixedDepth,depth=0,X=0,Y=0,ByteA=0,ByteB=0,ByteC=0,ByteD=0)
      Drops(175)=(Type=DROP_FixedDepth,depth=0,X=0,Y=0,ByteA=0,ByteB=0,ByteC=0,ByteD=0)
      Drops(176)=(Type=DROP_FixedDepth,depth=0,X=0,Y=0,ByteA=0,ByteB=0,ByteC=0,ByteD=0)
      Drops(177)=(Type=DROP_FixedDepth,depth=0,X=0,Y=0,ByteA=0,ByteB=0,ByteC=0,ByteD=0)
      Drops(178)=(Type=DROP_FixedDepth,depth=0,X=0,Y=0,ByteA=0,ByteB=0,ByteC=0,ByteD=0)
      Drops(179)=(Type=DROP_FixedDepth,depth=0,X=0,Y=0,ByteA=0,ByteB=0,ByteC=0,ByteD=0)
      Drops(180)=(Type=DROP_FixedDepth,depth=0,X=0,Y=0,ByteA=0,ByteB=0,ByteC=0,ByteD=0)
      Drops(181)=(Type=DROP_FixedDepth,depth=0,X=0,Y=0,ByteA=0,ByteB=0,ByteC=0,ByteD=0)
      Drops(182)=(Type=DROP_FixedDepth,depth=0,X=0,Y=0,ByteA=0,ByteB=0,ByteC=0,ByteD=0)
      Drops(183)=(Type=DROP_FixedDepth,depth=0,X=0,Y=0,ByteA=0,ByteB=0,ByteC=0,ByteD=0)
      Drops(184)=(Type=DROP_FixedDepth,depth=0,X=0,Y=0,ByteA=0,ByteB=0,ByteC=0,ByteD=0)
      Drops(185)=(Type=DROP_FixedDepth,depth=0,X=0,Y=0,ByteA=0,ByteB=0,ByteC=0,ByteD=0)
      Drops(186)=(Type=DROP_FixedDepth,depth=0,X=0,Y=0,ByteA=0,ByteB=0,ByteC=0,ByteD=0)
      Drops(187)=(Type=DROP_FixedDepth,depth=0,X=0,Y=0,ByteA=0,ByteB=0,ByteC=0,ByteD=0)
      Drops(188)=(Type=DROP_FixedDepth,depth=0,X=0,Y=0,ByteA=0,ByteB=0,ByteC=0,ByteD=0)
      Drops(189)=(Type=DROP_FixedDepth,depth=0,X=0,Y=0,ByteA=0,ByteB=0,ByteC=0,ByteD=0)
      Drops(190)=(Type=DROP_FixedDepth,depth=0,X=0,Y=0,ByteA=0,ByteB=0,ByteC=0,ByteD=0)
      Drops(191)=(Type=DROP_FixedDepth,depth=0,X=0,Y=0,ByteA=0,ByteB=0,ByteC=0,ByteD=0)
      Drops(192)=(Type=DROP_FixedDepth,depth=0,X=0,Y=0,ByteA=0,ByteB=0,ByteC=0,ByteD=0)
      Drops(193)=(Type=DROP_FixedDepth,depth=0,X=0,Y=0,ByteA=0,ByteB=0,ByteC=0,ByteD=0)
      Drops(194)=(Type=DROP_FixedDepth,depth=0,X=0,Y=0,ByteA=0,ByteB=0,ByteC=0,ByteD=0)
      Drops(195)=(Type=DROP_FixedDepth,depth=0,X=0,Y=0,ByteA=0,ByteB=0,ByteC=0,ByteD=0)
      Drops(196)=(Type=DROP_FixedDepth,depth=0,X=0,Y=0,ByteA=0,ByteB=0,ByteC=0,ByteD=0)
      Drops(197)=(Type=DROP_FixedDepth,depth=0,X=0,Y=0,ByteA=0,ByteB=0,ByteC=0,ByteD=0)
      Drops(198)=(Type=DROP_FixedDepth,depth=0,X=0,Y=0,ByteA=0,ByteB=0,ByteC=0,ByteD=0)
      Drops(199)=(Type=DROP_FixedDepth,depth=0,X=0,Y=0,ByteA=0,ByteB=0,ByteC=0,ByteD=0)
      Drops(200)=(Type=DROP_FixedDepth,depth=0,X=0,Y=0,ByteA=0,ByteB=0,ByteC=0,ByteD=0)
      Drops(201)=(Type=DROP_FixedDepth,depth=0,X=0,Y=0,ByteA=0,ByteB=0,ByteC=0,ByteD=0)
      Drops(202)=(Type=DROP_FixedDepth,depth=0,X=0,Y=0,ByteA=0,ByteB=0,ByteC=0,ByteD=0)
      Drops(203)=(Type=DROP_FixedDepth,depth=0,X=0,Y=0,ByteA=0,ByteB=0,ByteC=0,ByteD=0)
      Drops(204)=(Type=DROP_FixedDepth,depth=0,X=0,Y=0,ByteA=0,ByteB=0,ByteC=0,ByteD=0)
      Drops(205)=(Type=DROP_FixedDepth,depth=0,X=0,Y=0,ByteA=0,ByteB=0,ByteC=0,ByteD=0)
      Drops(206)=(Type=DROP_FixedDepth,depth=0,X=0,Y=0,ByteA=0,ByteB=0,ByteC=0,ByteD=0)
      Drops(207)=(Type=DROP_FixedDepth,depth=0,X=0,Y=0,ByteA=0,ByteB=0,ByteC=0,ByteD=0)
      Drops(208)=(Type=DROP_FixedDepth,depth=0,X=0,Y=0,ByteA=0,ByteB=0,ByteC=0,ByteD=0)
      Drops(209)=(Type=DROP_FixedDepth,depth=0,X=0,Y=0,ByteA=0,ByteB=0,ByteC=0,ByteD=0)
      Drops(210)=(Type=DROP_FixedDepth,depth=0,X=0,Y=0,ByteA=0,ByteB=0,ByteC=0,ByteD=0)
      Drops(211)=(Type=DROP_FixedDepth,depth=0,X=0,Y=0,ByteA=0,ByteB=0,ByteC=0,ByteD=0)
      Drops(212)=(Type=DROP_FixedDepth,depth=0,X=0,Y=0,ByteA=0,ByteB=0,ByteC=0,ByteD=0)
      Drops(213)=(Type=DROP_FixedDepth,depth=0,X=0,Y=0,ByteA=0,ByteB=0,ByteC=0,ByteD=0)
      Drops(214)=(Type=DROP_FixedDepth,depth=0,X=0,Y=0,ByteA=0,ByteB=0,ByteC=0,ByteD=0)
      Drops(215)=(Type=DROP_FixedDepth,depth=0,X=0,Y=0,ByteA=0,ByteB=0,ByteC=0,ByteD=0)
      Drops(216)=(Type=DROP_FixedDepth,depth=0,X=0,Y=0,ByteA=0,ByteB=0,ByteC=0,ByteD=0)
      Drops(217)=(Type=DROP_FixedDepth,depth=0,X=0,Y=0,ByteA=0,ByteB=0,ByteC=0,ByteD=0)
      Drops(218)=(Type=DROP_FixedDepth,depth=0,X=0,Y=0,ByteA=0,ByteB=0,ByteC=0,ByteD=0)
      Drops(219)=(Type=DROP_FixedDepth,depth=0,X=0,Y=0,ByteA=0,ByteB=0,ByteC=0,ByteD=0)
      Drops(220)=(Type=DROP_FixedDepth,depth=0,X=0,Y=0,ByteA=0,ByteB=0,ByteC=0,ByteD=0)
      Drops(221)=(Type=DROP_FixedDepth,depth=0,X=0,Y=0,ByteA=0,ByteB=0,ByteC=0,ByteD=0)
      Drops(222)=(Type=DROP_FixedDepth,depth=0,X=0,Y=0,ByteA=0,ByteB=0,ByteC=0,ByteD=0)
      Drops(223)=(Type=DROP_FixedDepth,depth=0,X=0,Y=0,ByteA=0,ByteB=0,ByteC=0,ByteD=0)
      Drops(224)=(Type=DROP_FixedDepth,depth=0,X=0,Y=0,ByteA=0,ByteB=0,ByteC=0,ByteD=0)
      Drops(225)=(Type=DROP_FixedDepth,depth=0,X=0,Y=0,ByteA=0,ByteB=0,ByteC=0,ByteD=0)
      Drops(226)=(Type=DROP_FixedDepth,depth=0,X=0,Y=0,ByteA=0,ByteB=0,ByteC=0,ByteD=0)
      Drops(227)=(Type=DROP_FixedDepth,depth=0,X=0,Y=0,ByteA=0,ByteB=0,ByteC=0,ByteD=0)
      Drops(228)=(Type=DROP_FixedDepth,depth=0,X=0,Y=0,ByteA=0,ByteB=0,ByteC=0,ByteD=0)
      Drops(229)=(Type=DROP_FixedDepth,depth=0,X=0,Y=0,ByteA=0,ByteB=0,ByteC=0,ByteD=0)
      Drops(230)=(Type=DROP_FixedDepth,depth=0,X=0,Y=0,ByteA=0,ByteB=0,ByteC=0,ByteD=0)
      Drops(231)=(Type=DROP_FixedDepth,depth=0,X=0,Y=0,ByteA=0,ByteB=0,ByteC=0,ByteD=0)
      Drops(232)=(Type=DROP_FixedDepth,depth=0,X=0,Y=0,ByteA=0,ByteB=0,ByteC=0,ByteD=0)
      Drops(233)=(Type=DROP_FixedDepth,depth=0,X=0,Y=0,ByteA=0,ByteB=0,ByteC=0,ByteD=0)
      Drops(234)=(Type=DROP_FixedDepth,depth=0,X=0,Y=0,ByteA=0,ByteB=0,ByteC=0,ByteD=0)
      Drops(235)=(Type=DROP_FixedDepth,depth=0,X=0,Y=0,ByteA=0,ByteB=0,ByteC=0,ByteD=0)
      Drops(236)=(Type=DROP_FixedDepth,depth=0,X=0,Y=0,ByteA=0,ByteB=0,ByteC=0,ByteD=0)
      Drops(237)=(Type=DROP_FixedDepth,depth=0,X=0,Y=0,ByteA=0,ByteB=0,ByteC=0,ByteD=0)
      Drops(238)=(Type=DROP_FixedDepth,depth=0,X=0,Y=0,ByteA=0,ByteB=0,ByteC=0,ByteD=0)
      Drops(239)=(Type=DROP_FixedDepth,depth=0,X=0,Y=0,ByteA=0,ByteB=0,ByteC=0,ByteD=0)
      Drops(240)=(Type=DROP_FixedDepth,depth=0,X=0,Y=0,ByteA=0,ByteB=0,ByteC=0,ByteD=0)
      Drops(241)=(Type=DROP_FixedDepth,depth=0,X=0,Y=0,ByteA=0,ByteB=0,ByteC=0,ByteD=0)
      Drops(242)=(Type=DROP_FixedDepth,depth=0,X=0,Y=0,ByteA=0,ByteB=0,ByteC=0,ByteD=0)
      Drops(243)=(Type=DROP_FixedDepth,depth=0,X=0,Y=0,ByteA=0,ByteB=0,ByteC=0,ByteD=0)
      Drops(244)=(Type=DROP_FixedDepth,depth=0,X=0,Y=0,ByteA=0,ByteB=0,ByteC=0,ByteD=0)
      Drops(245)=(Type=DROP_FixedDepth,depth=0,X=0,Y=0,ByteA=0,ByteB=0,ByteC=0,ByteD=0)
      Drops(246)=(Type=DROP_FixedDepth,depth=0,X=0,Y=0,ByteA=0,ByteB=0,ByteC=0,ByteD=0)
      Drops(247)=(Type=DROP_FixedDepth,depth=0,X=0,Y=0,ByteA=0,ByteB=0,ByteC=0,ByteD=0)
      Drops(248)=(Type=DROP_FixedDepth,depth=0,X=0,Y=0,ByteA=0,ByteB=0,ByteC=0,ByteD=0)
      Drops(249)=(Type=DROP_FixedDepth,depth=0,X=0,Y=0,ByteA=0,ByteB=0,ByteC=0,ByteD=0)
      Drops(250)=(Type=DROP_FixedDepth,depth=0,X=0,Y=0,ByteA=0,ByteB=0,ByteC=0,ByteD=0)
      Drops(251)=(Type=DROP_FixedDepth,depth=0,X=0,Y=0,ByteA=0,ByteB=0,ByteC=0,ByteD=0)
      Drops(252)=(Type=DROP_FixedDepth,depth=0,X=0,Y=0,ByteA=0,ByteB=0,ByteC=0,ByteD=0)
      Drops(253)=(Type=DROP_FixedDepth,depth=0,X=0,Y=0,ByteA=0,ByteB=0,ByteC=0,ByteD=0)
      Drops(254)=(Type=DROP_FixedDepth,depth=0,X=0,Y=0,ByteA=0,ByteB=0,ByteC=0,ByteD=0)
      Drops(255)=(Type=DROP_FixedDepth,depth=0,X=0,Y=0,ByteA=0,ByteB=0,ByteC=0,ByteD=0)
}
