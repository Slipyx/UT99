// ===================================================================
//  WaterTexture: Simple phongish water surface.
//  This is a built-in Unreal class and it shouldn't be modified.
// ===================================================================

class IceTexture extends FractalTexture
    native
	noexport;


// Ice movement definitions.

enum PanningType
{
    SLIDE_Linear,
	SLIDE_Circular,
	SLIDE_Gestation,
	SLIDE_WavyX,
	SLIDE_WavyY,
};



enum TimingType
{
	TIME_FrameRateSync,
	TIME_RealTimeScroll,
};


// Persistent IceTexture Parameters.

var(IceLayer)		texture		GlassTexture;
var(IceLayer)		texture		SourceTexture;
var(IceLayer)       PanningType PanningStyle;
var(IceLayer)       TimingType  TimeMethod;
var(IceLayer)       byte		HorizPanSpeed;
var(IceLayer)       byte		VertPanSpeed;
var(IceLayer)       byte        Frequency;
var(IceLayer)       byte        Amplitude;

var(IceLayer)       bool		MoveIce;
var                 float       MasterCount;
var                 float		UDisplace;
var                 float		VDisplace;
var                 float       UPosition;
var                 float       VPosition;

// Transient IceTexture Parameters

var	transient		float       TickAccu;
var	transient		int         OldUDisplace;
var	transient		int         OldVDisplace;
var transient       texture     OldGlassTex;
var transient		texture     OldSourceTex;
var transient       pointer		LocalSource;
var transient       int			ForceRefresh;

defaultproperties
{
      GlassTexture=None
      SourceTexture=None
      PanningStyle=SLIDE_Linear
      TimeMethod=TIME_FrameRateSync
      HorizPanSpeed=0
      VertPanSpeed=0
      Frequency=0
      Amplitude=0
      MoveIce=False
      MasterCount=0.000000
      UDisplace=0.000000
      VDisplace=0.000000
      UPosition=0.000000
      VPosition=0.000000
}
