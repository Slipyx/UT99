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
      SpriteAnim(0)=None
      SpriteAnim(1)=None
      SpriteAnim(2)=None
      SpriteAnim(3)=None
      SpriteAnim(4)=None
      SpriteAnim(5)=None
      SpriteAnim(6)=None
      SpriteAnim(7)=None
      SpriteAnim(8)=None
      SpriteAnim(9)=None
      SpriteAnim(10)=None
      SpriteAnim(11)=None
      SpriteAnim(12)=None
      SpriteAnim(13)=None
      SpriteAnim(14)=None
      SpriteAnim(15)=None
      SpriteAnim(16)=None
      SpriteAnim(17)=None
      SpriteAnim(18)=None
      SpriteAnim(19)=None
      NumFrames=0
      Pause=0.000000
      i=0
      AnimTime=0.000000
      DrawScale=0.300000
      bUnlit=True
      LightType=LT_Steady
      LightBrightness=199
      LightHue=24
      LightSaturation=115
      LightRadius=20
      bCorona=True
}
