//=============================================================================
// Effects, the base class of all gratuitous special effects.
//=============================================================================
class Effects extends Actor;

var() sound 	EffectSound1;
var() sound 	EffectSound2;
var() bool bOnlyTriggerable;

defaultproperties
{
     bNetTemporary=True
     DrawType=DT_None
     bGameRelevant=True
     CollisionRadius=0.000000
     CollisionHeight=0.000000
}
