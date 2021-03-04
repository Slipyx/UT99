//=============================================================================
// UT_BlackSmoke.
//=============================================================================
class UT_BlackSmoke extends UT_SpriteSmokePuff;

#exec OBJ LOAD FILE=..\UnrealShare\textures\SmokeBlack.utx PACKAGE=UnrealShare.SmokeBlack

defaultproperties
{
      SSprites(0)=Texture'UnrealShare.SmokeBlack.bs_a00'
      SSprites(1)=Texture'UnrealShare.SmokeBlack.bs2_a00'
      SSprites(2)=Texture'UnrealShare.SmokeBlack.bs3_a00'
      SSprites(3)=None
      RisingRate=70.000000
      NumSets=3
      bHighDetail=True
      Style=STY_Modulated
      Texture=Texture'UnrealShare.SmokeBlack.bs2_a00'
      DrawScale=2.200000
}
