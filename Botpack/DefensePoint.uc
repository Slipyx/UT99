//=============================================================================
// Defensepoint.
//=============================================================================
class DefensePoint extends AmbushPoint;

var() byte team;
var() byte priority;
var() name FortTag;	//optional associated fort (for assault game)

defaultproperties
{
      Team=0
      priority=0
      FortTag="None"
}
