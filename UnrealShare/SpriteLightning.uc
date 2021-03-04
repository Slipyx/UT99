//=============================================================================
// SpriteLightning.
//=============================================================================
class SpriteLightning extends AnimSpriteEffect;

#exec OBJ LOAD FILE=Textures\fireeffect17.utx PACKAGE=UnrealShare.Effect17

#exec AUDIO IMPORT FILE="Sounds\general\thundr2.WAV" NAME="Lightning" GROUP="General"

var rotator NormUp;
var() float Damage;
var() float radius;
var() float MomentumTransfer;

simulated function PostBeginPlay()
{
	AnimTime=0.0;	
	PlaySound (EffectSound1);
	MakeNoise(1.0);	
	Super.PostBeginPlay();
}

defaultproperties
{
      NormUp=(Pitch=0,Yaw=0,Roll=0)
      Damage=40.000000
      Radius=120.000000
      MomentumTransfer=1400.000000
      EffectSound1=Sound'UnrealShare.General.Lightning'
      RemoteRole=ROLE_SimulatedProxy
      LifeSpan=1.000000
      Skin=FireTexture'UnrealShare.Effect17.fireeffect17'
      DrawScale=0.200000
      LightEffect=LE_NonIncidence
      LightBrightness=255
      LightHue=151
      LightRadius=8
}
