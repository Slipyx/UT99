//=============================================================================
// FlockMasterPawn.
//=============================================================================
class FlockMasterPawn extends Pawn;

//==============
// Encroachment
function bool EncroachingOn( actor Other )
{
	if ( (Other.Brush != None) || (Brush(Other) != None) )
		return true;
		
	return false;
}

event FootZoneChange(ZoneInfo newFootZone)
{
}

function EncroachedBy( actor Other )
{
}

function TakeDamage( int Damage, Pawn instigatedBy, Vector hitlocation, 
						Vector momentum, name damageType)
{
}

function BaseChange()
{
}

defaultproperties
{
      bForceStasis=True
      bCollideActors=False
      bBlockActors=False
      bBlockPlayers=False
      bProjTarget=False
      Mass=5.000000
      Buoyancy=5.000000
}
