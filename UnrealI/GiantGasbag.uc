//=============================================================================
// GiantGasbag.
//=============================================================================
class GiantGasbag extends Gasbag;

function SpawnBelch()
{
	local Gasbag G;
	local vector X,Y,Z, projStart;
	local actor P;
	 
	GetAxes(Rotation,X,Y,Z);
	projStart = Location + 0.5 * CollisionRadius * X - 0.3 * CollisionHeight * Z;
	if ( (numChildren > 1) || (FRand() > 0.2) )
	{
		P = spawn(RangedProjectile ,self,'',projStart,AdjustAim(ProjectileSpeed, projStart, 400, bLeadTarget, bWarnTarget));
		if ( P != None )
			P.DrawScale *= 2;
	}
	else
	{
		G = spawn(class 'Gasbag' ,,'',projStart + (0.6 * CollisionRadius + class'Gasbag'.Default.CollisionRadius) * X);
		if ( G != None )
		{
			G.ParentBag = self;
			numChildren++;
		}
	}	
}

defaultproperties
{
     PunchDamage=40
     PoundDamage=65
     Health=600
     CombatStyle=0.500000
     DrawScale=3.000000
     CollisionRadius=160.000000
     CollisionHeight=108.000000
}
