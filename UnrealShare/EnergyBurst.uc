//=============================================================================
// EnergyBurst.
//=============================================================================
class EnergyBurst extends AnimSpriteEffect;

#exec AUDIO IMPORT FILE="sounds\flak\expl2.wav" NAME="Explo1" GROUP="General"

#exec TEXTURE IMPORT NAME=ExplosionPal3 FILE=textures\expal2.pcx GROUP=Effects

#exec OBJ LOAD FILE=textures\maine.utx PACKAGE=UnrealShare.Maineffect

defaultproperties
{
      NumFrames=6
      Pause=0.060000
      EffectSound1=Sound'UnrealShare.General.Explo1'
      RemoteRole=ROLE_SimulatedProxy
      LifeSpan=0.500000
      DrawType=DT_SpriteAnimOnce
      Style=STY_Translucent
      Texture=Texture'UnrealShare.MainEffect.E6_A00'
      Skin=Texture'UnrealShare.Effects.ExplosionPal3'
      DrawScale=1.500000
      LightType=LT_TexturePaletteOnce
      LightEffect=LE_NonIncidence
      LightBrightness=255
      LightHue=0
      LightSaturation=255
      LightRadius=8
      bCorona=False
}
