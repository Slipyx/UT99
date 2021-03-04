//=============================================================================
// SmokeExplo.
//=============================================================================
class SmokeExplo extends AnimSpriteEffect;

#exec TEXTURE IMPORT NAME=SmokeE1 FILE=MODELS\f201.pcx GROUP=Effects
#exec TEXTURE IMPORT NAME=SmokeE2 FILE=MODELS\f202.pcx GROUP=Effects
#exec TEXTURE IMPORT NAME=SmokeE3 FILE=MODELS\f203.pcx GROUP=Effects
#exec TEXTURE IMPORT NAME=SmokeE4 FILE=MODELS\f204.pcx GROUP=Effects
#exec TEXTURE IMPORT NAME=SmokeE5 FILE=MODELS\f205.pcx GROUP=Effects
#exec TEXTURE IMPORT NAME=SmokeE6 FILE=MODELS\f206.pcx GROUP=Effects
#exec TEXTURE IMPORT NAME=SmokeE7 FILE=MODELS\f207.pcx GROUP=Effects
#exec TEXTURE IMPORT NAME=SmokeE8 FILE=MODELS\f208.pcx GROUP=Effects
#exec TEXTURE IMPORT NAME=SmokeE9 FILE=MODELS\f209.pcx GROUP=Effects

defaultproperties
{
      SpriteAnim(0)=Texture'UnrealShare.Effects.SmokeE1'
      SpriteAnim(1)=Texture'UnrealShare.Effects.SmokeE2'
      SpriteAnim(2)=Texture'UnrealShare.Effects.SmokeE3'
      SpriteAnim(3)=Texture'UnrealShare.Effects.SmokeE4'
      SpriteAnim(4)=Texture'UnrealShare.Effects.SmokeE5'
      SpriteAnim(5)=Texture'UnrealShare.Effects.SmokeE6'
      SpriteAnim(6)=Texture'UnrealShare.Effects.SmokeE7'
      SpriteAnim(7)=Texture'UnrealShare.Effects.SmokeE8'
      SpriteAnim(8)=Texture'UnrealShare.Effects.SmokeE9'
      NumFrames=9
      Pause=0.050000
      LifeSpan=1.000000
      DrawScale=0.200000
      LightType=LT_None
      LightBrightness=68
      LightHue=0
      LightSaturation=255
      LightRadius=3
}
