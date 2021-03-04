//=============================================================================
// Ambushpoint.
//=============================================================================
class AmbushPoint extends NavigationPoint;

var vector lookdir; //direction to look while ambushing
//at start, ambushing creatures will pick either their current location, or the location of
//some ambushpoint belonging to their team
var byte survivecount; //used when picking ambushpoint 
var() float SightRadius; // How far bot at this point should look for enemies
var() bool	bSniping;	// bots should snipe from this position

function PreBeginPlay()
{
	lookdir = 2000 * vector(Rotation);

	Super.PreBeginPlay();
}

defaultproperties
{
      lookDir=(X=0.000000,Y=0.000000,Z=0.000000)
      survivecount=0
      SightRadius=5000.000000
      bSniping=False
      bDirectional=True
      SoundVolume=128
}
