//=============================================================================
// HorseFlySwarm.
//=============================================================================
class HorseFlySwarm extends FlockMasterPawn;

var()	byte	swarmsize; //number of horseflies in swarm
var		byte	totalflies;
var()   bool	bOnlyIfEnemy;
var()	float	swarmradius;
	
function PreBeginPlay()
{
	totalflies = swarmsize;
	Super.PreBeginPlay();
}

singular function ZoneChange( ZoneInfo NewZone )
{
	if (NewZone.bWaterZone /* || NewZone.bPainZone */)
	{
		SetLocation(OldLocation);
		Velocity = vect(0,0,0);
		Acceleration = vect(0,0,0);
		MoveTimer = -1.0;
		Enemy = None;
	}
}

function SpawnFlies()
{
	while (swarmsize > 0)
	{
		swarmsize--;
		spawn(class 'horsefly',self,'', Location + VRand() * CollisionRadius);
	}
}

auto state stasis
{
ignores EncroachedBy;
	
	function SeePlayer(Actor SeenPlayer)
	{
		enemy = Pawn(SeenPlayer);
		SpawnFlies();
		Gotostate('wandering');
	}

Begin:
	SetPhysics(PHYS_None);
}		

state wandering
{
ignores EncroachedBy;

	function SeePlayer(Actor SeenPlayer)
	{
		local actor newfly;
		Enemy = Pawn(SeenPlayer);
		SpawnFlies();
		Disable('SeePlayer');
		Enable('EnemyNotVisible');
	}

	function EnemyNotVisible()
	{
		Enemy = None;
		Disable('EnemyNotVisible');
	}
	
Begin:
	SetPhysics(PHYS_Flying);

Wander:
	if (Enemy == None)
		Enable('SeePlayer');
		
	if ( (Enemy != None) && !Enemy.Region.Zone.bWaterZone  && !Enemy.Region.Zone.bPainZone )
	{
		MoveToward(Enemy);
		sleep(2 * FRand());
	}	
	else
	{
		Destination = Location + VRand() * 1000;
		Destination.Z = 0.5 * (Destination.Z + Location.Z);
		MoveTo(Destination);
	}
	Goto('Wander');
}

defaultproperties
{
      swarmsize=20
      totalflies=0
      bOnlyIfEnemy=True
      swarmradius=120.000000
      GroundSpeed=200.000000
      AirSpeed=200.000000
      JumpZ=-1.000000
      SightRadius=2000.000000
      PeripheralVision=-5.000000
      bHidden=True
}
