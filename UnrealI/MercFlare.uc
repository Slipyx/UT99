//=============================================================================
// MercFlare.
//=============================================================================
class MercFlare extends Effects;

#exec TEXTURE IMPORT NAME=RocketFlare FILE=..\UnrealShare\MODELS\rflare.pcx GROUP=Effects

defaultproperties
{
      RemoteRole=ROLE_SimulatedProxy
      LifeSpan=0.100000
      DrawType=DT_Sprite
      Style=STY_Translucent
      Texture=Texture'UnrealI.Effects.RocketFlare'
      DrawScale=0.750000
      bUnlit=True
      LightType=LT_Steady
      LightBrightness=250
      LightHue=28
      LightSaturation=32
      LightRadius=30
      LightPeriod=32
      LightCone=128
      VolumeBrightness=64
      bActorShadows=True
}
