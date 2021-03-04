//=============================================================================
// MortarShell.
//=============================================================================
class MortarShell extends UTFlakShell;

var() int BlastRadius;

function Explode(vector HitLocation, vector HitNormal)
{
	local vector start;
	local FlameExplosion F;

	HurtRadius(damage, BlastRadius, 'mortared', MomentumTransfer, HitLocation);	
	start = Location + 10 * HitNormal;
	F = Spawn( class'FlameExplosion',,,Start);
	if ( Level.NetMode != NM_DedicatedServer )
		Spawn(class'Botpack.BlastMark',self,,Location, rotator(HitNormal));
	if ( F != None )
		F.DrawScale *= 2.5;
	Destroy();
}

defaultproperties
{
      BlastRadius=150
      MomentumTransfer=150000
}
