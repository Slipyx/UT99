//=============================================================================
// BarrelSludge.
//=============================================================================
class BarrelSludge extends BioGel;

function Timer()
{
	local GreenGelPuff f;
	local int j;

	if ( (Mover(Base) != None) && Mover(Base).bDamageTriggered )
		Base.TakeDamage( Damage, instigator, Location, MomentumTransfer * Normal(Velocity), '');
	
	HurtRadius(damage * Drawscale, 60, 'burned', MomentumTransfer * Drawscale, Location);
	f = spawn(class'GreenGelPuff',,,Location + SurfaceNormal*8); 
	f.DrawScale = DrawScale*2.0;
	PlaySound (MiscSound,,3.0*DrawScale);
	f.numBlobs = numBio;
	if ( numBio > 0 )
		f.SurfaceNormal = SurfaceNormal;	
	Destroy();	
}


auto state Flying
{
	singular function TakeDamage( int NDamage, Pawn instigatedBy, Vector hitlocation, 
						vector momentum, name damageType )
	{
		if ( damageType != 'burned' )	GoToState('Exploding');
	}


	function Touch( actor Other )
	{ 
		if( Other != Owner && BarrelSludge(Other)==None )
			GoToState( 'Exploding' ); 
	}

	function HitWall (vector HitNormal, actor Wall)
	{
		local rotator RandRot;

		RandRot = rotator(HitNormal);
		RandRot.Roll += 32768;
		SetRotation(RandRot);
		Super.HitWall(HitNormal, Wall);	
	}

	function BeginState()
	{
		DrawScale = FRand()*0.4+0.3;
		Velocity = VRand() * (50.0*FRand()+80);
		Velocity.z += 250;
		RandSpin(100000);
		LoopAnim('Flying',0.4);
	}
}

defaultproperties
{
     speed=200.000000
     MaxSpeed=1000.000000
     Damage=20.000000
     MomentumTransfer=15000
     RemoteRole=ROLE_DumbProxy
     LifeSpan=140.000000
     DrawScale=2.000000
     CollisionHeight=3.000000
     Buoyancy=0.000000
}
