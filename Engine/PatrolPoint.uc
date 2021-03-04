//=============================================================================
// PatrolPoint.
//=============================================================================
class PatrolPoint extends NavigationPoint;

#exec Texture Import File=Textures\Pathnode.pcx Name=S_Patrol Mips=Off Flags=2

var() name Nextpatrol; //next point to go to
var() float pausetime; //how long to pause here
var	 vector lookdir; //direction to look while stopped
var() name PatrolAnim;
var() sound PatrolSound;
var() byte numAnims;
var int	AnimCount;
var PatrolPoint NextPatrolPoint;


function PreBeginPlay()
{
	if (pausetime > 0.0)
		lookdir = 200 * vector(Rotation);

	//find the patrol point with the tag specified by Nextpatrol
	foreach AllActors(class 'PatrolPoint', NextPatrolPoint, Nextpatrol)
		break; 
	
	Super.PreBeginPlay();
}

defaultproperties
{
      Nextpatrol="None"
      pausetime=0.000000
      lookDir=(X=0.000000,Y=0.000000,Z=0.000000)
      PatrolAnim="None"
      PatrolSound=None
      numAnims=0
      AnimCount=0
      NextPatrolPoint=None
      bDirectional=True
      Texture=Texture'Engine.S_Patrol'
      SoundVolume=128
}
