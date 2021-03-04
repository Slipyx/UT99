//=============================================================================
// carFlash.
//=============================================================================
class CarFlash extends Effects;

simulated function PostBeginPlay()
{
	LoopAnim('Shoot', 0.7);
}
	

defaultproperties
{
      bNetTemporary=False
      RemoteRole=ROLE_SimulatedProxy
      AnimSequence="Shoot"
      DrawType=DT_Mesh
      Style=STY_Translucent
      Texture=Texture'Botpack.Skins.Muzzy'
      Mesh=LodMesh'Botpack.MuzzFlash3'
      DrawScale=0.100000
      bUnlit=True
      bParticles=True
      LightBrightness=255
      LightHue=39
      LightSaturation=204
      LightRadius=7
}
