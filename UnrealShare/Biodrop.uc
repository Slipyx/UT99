//=============================================================================
// BioDrop.
//=============================================================================
class BioDrop extends BioGel;

auto state Flying
{
	simulated function HitWall( vector HitNormal, actor Wall )
	{
		SetRotation(rotator(HitNormal));	
		Super.HitWall(HitNormal, Wall);
	}

	function BeginState()
	{
		Velocity = vect(0,0,0);
		LoopAnim('Flying',0.4);
	}
}

state OnSurface
{
	function CheckSurface()
	{
		local float DotProduct;

		DotProduct = SurfaceNormal dot vect(0,0,-1);
		if (DotProduct > -0.5)
			PlayAnim('Slide',0.2);
	}

Begin:
	FinishAnim();
	CheckSurface();
}

defaultproperties
{
      speed=0.000000
      MaxSpeed=900.000000
      Damage=60.000000
      ImpactSound=None
      RemoteRole=ROLE_DumbProxy
      LifeSpan=140.000000
      CollisionRadius=3.000000
      CollisionHeight=3.000000
      bProjTarget=False
      LightRadius=2
      Buoyancy=0.000000
}
