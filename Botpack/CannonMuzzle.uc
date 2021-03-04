class CannonMuzzle extends Effects;

function PostBeginPlay()
{
		Super.PostBeginPlay();
		LoopAnim('Shoot');
}

defaultproperties
{
      bHidden=True
      bNetTemporary=False
      DrawType=DT_Mesh
      Style=STY_Translucent
      Texture=Texture'Botpack.Skins.Muzzy'
      Mesh=LodMesh'Botpack.MuzzFlash3'
      DrawScale=0.250000
      bUnlit=True
      bParticles=True
}
