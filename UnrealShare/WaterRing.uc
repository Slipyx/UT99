//=============================================================================
// WaterRing.
//=============================================================================
class WaterRing extends RingExplosion;

#exec OBJ LOAD FILE=Textures\fireeffect56.utx  PACKAGE=UnrealShare.Effect56

simulated function SpawnEffects()
{
}

defaultproperties
{
      bNetOptional=True
      Skin=FireTexture'UnrealShare.Effect56.fireeffect56'
}
