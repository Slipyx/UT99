//=============================================================================
// WeaponLight.
//=============================================================================
class WeaponLight extends Light;

#exec TEXTURE IMPORT NAME=WepLightPal FILE=textures\exppal.pcx GROUP=Effects

defaultproperties
{
      bStatic=False
      bNoDelete=False
      bNetTemporary=True
      bNetOptional=True
      RemoteRole=ROLE_SimulatedProxy
      LifeSpan=0.150000
      Skin=Texture'UnrealShare.Effects.WepLightPal'
      bMovable=True
      LightType=LT_TexturePaletteOnce
      LightEffect=LE_NonIncidence
      LightBrightness=250
      LightHue=28
      LightSaturation=32
      LightRadius=6
      bActorShadows=True
}
