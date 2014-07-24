//=============================================================================
// AnimSpriteEffect.
//=============================================================================
class AnimSpriteEffect extends Effects;

var() texture SpriteAnim[20];
var() int NumFrames;
var() float Pause;
var int i;
var Float AnimTime;

defaultproperties
{
     DrawScale=0.300000
     bUnlit=True
     LightType=LT_Steady
     LightBrightness=199
     LightHue=24
     LightSaturation=115
     LightRadius=20
     bCorona=True
}
