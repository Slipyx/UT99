//=============================================================================
// Scout used for path generation.
//=============================================================================
class Scout extends Pawn
	native;

function PreBeginPlay()
{
	Destroy(); //scouts shouldn't exist during play
}

defaultproperties
{
      AccelRate=1.000000
      SightRadius=4100.000000
      CombatStyle=4363467783093056784302080.000000
      CollisionRadius=52.000000
      CollisionHeight=50.000000
      bCollideActors=False
      bCollideWorld=False
      bBlockActors=False
      bBlockPlayers=False
      bProjTarget=False
}
