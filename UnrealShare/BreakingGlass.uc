//=============================================================================
// BreakingGlass.
//=============================================================================
class BreakingGlass extends ExplodingWall;

#exec AUDIO IMPORT FILE="Sounds\general\glass.WAV" NAME="BreakGlass" GROUP="General"

var() float ParticleSize;
var() float Numparticles;

Auto State Exploding
{
	singular function TakeDamage( int NDamage, Pawn instigatedBy, Vector hitlocation,
						Vector momentum, name damageType)
	{
		if ( !bOnlyTriggerable ) 
			Explode(instigatedBy, Momentum);
	}

	function BeginState()
	{
		Super.BeginState();
		NumGlassChunks = NumParticles;
		GlassParticleSize = ParticleSize;
	}
}

defaultproperties
{
      ParticleSize=0.750000
      Numparticles=16.000000
      ExplosionSize=100.000000
      ExplosionDimensions=90.000000
      NumWallChunks=0
      NumWoodChunks=0
      BreakingSound=Sound'UnrealShare.General.BreakGlass'
      CollisionRadius=45.000000
      CollisionHeight=45.000000
}
