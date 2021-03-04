//=============================================================================
// DExplosion.
//=============================================================================
class DExplosion extends Effects;

#exec TEXTURE IMPORT NAME=ExplosionPal FILE=textures\exppal.pcx GROUP=Effects
#exec OBJ LOAD FILE=textures\deburst.utx PACKAGE=UnrealShare.DBEffect

defaultproperties
{
      RemoteRole=ROLE_SimulatedProxy
      LifeSpan=0.500000
      DrawType=DT_Sprite
      Style=STY_Translucent
      Texture=Texture'UnrealShare.DBEffect.de_A00'
      Skin=Texture'UnrealShare.Effects.ExplosionPal'
      bUnlit=True
      LightType=LT_TexturePaletteOnce
      LightEffect=LE_NonIncidence
      LightRadius=8
}
