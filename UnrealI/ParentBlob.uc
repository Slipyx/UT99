//=============================================================================
// ParentBlob.
//=============================================================================
class ParentBlob extends FlockMasterPawn;

var bool bEnemyVisible;
var int numBlobs;
var	bloblet blobs[16]; 
var localized string BlobKillMessage;

function setMovementPhysics()
{
	SetPhysics(PHYS_Spider);
}

function string KillMessage(name damageType, pawn Other)
{
	return(Other.PlayerReplicationInfo.PlayerName$BlobKillMessage);
}

function Shrink(bloblet b)
{
	local int i,j;
	
	for (i=0; i<numBlobs; i++ )
		if ( blobs[i] == b )
			break;
	numBlobs--;
	for (j=i;j<numBlobs; j++ )
		blobs[j] = blobs[j+1];
	if (numBlobs == 0)
		Destroy();
	else
		SetRadius();
}

function SetRadius()
{
	local int i;
	local float size;
	
	size = 24 + 1.5 * numBlobs;
	for (i=0; i<numBlobs; i++)
		blobs[i].Orientation = size * vector(rot(0,65536,0) * i/numBlobs);
}
	
function PreSetMovement()
{
	bCanWalk = true;
	bCanSwim = true;
	bCanFly = false;
	MinHitWall = -0.6;
}


function BaseChange()
{
}

function Killed(pawn Killer, pawn Other, name damageType)
{
	local int i;

	if (Other == Enemy)
	{
		for (i=0; i<numBlobs; i++ )
			blobs[i].GotoState('asleep');
		GotoState('stasis');
	}
}

auto state stasis
{
ignores EncroachedBy, EnemyNotVisible;
	
	function SeePlayer(Actor SeenPlayer)
	{
		local bloblet b;
		local pawn aPawn;
		local int i;

		if ( numBlobs == 0)
		{
			aPawn = Level.PawnList;
			while ( aPawn != None )
			{
				b = bloblet(aPawn);
				if ( (b != None) && (b.tag == tag) )
				{
					blobs[numBlobs] = b;
					numBlobs++;
					b.parentBlob = self;
					b.GotoState('Active');
				}
				if (numBlobs < 15)
					aPawn = aPawn.nextPawn;
				else
					aPawn = None;
			}
			SetRadius();
		}
		else
		{
			for (i = 0; i < numBlobs; i++)
			    if (blobs[i] != None)
				     blobs[i].GotoState('Active');
		}
		enemy = Pawn(SeenPlayer);
		bEnemyVisible = true;
		Gotostate('Attacking');
	}

Begin:
	SetPhysics(PHYS_None);
}

state Attacking
{
	function Timer()
	{
		local int i;

		Enemy = None;
		for (i=0; i<numBlobs; i++ )
			blobs[i].GotoState('asleep');
		GotoState('Stasis');
	}

	function Tick(float DeltaTime)
	{
		local int i;
		
		for (i=0; i<numBlobs; i++ )
			if ( blobs[i].MoveTarget == None )
				blobs[i].Destination = Location + blobs[i].Orientation;
	}
	
	function SeePlayer(Actor SeenPlayer)
	{
		Disable('SeePlayer');
		Enable('EnemyNotVisible');
		bEnemyVisible = true;
		SetTimer(0, false);
	}
	
	function EnemyNotVisible()
	{
		Disable('EnemyNotVisible');
		Enable('SeePlayer');
		bEnemyVisible = false;
		SetTimer(35, false);
	}
		
Begin:
	SetPhysics(PHYS_Spider);
	
Chase:
	if (bEnemyVisible)
		MoveToward(Enemy);
	else
		MoveTo(LastSeenPos);

	Sleep(0.1);
	Goto('Chase');
}

defaultproperties
{
      bEnemyVisible=False
      numBlobs=0
      blobs(0)=None
      blobs(1)=None
      blobs(2)=None
      blobs(3)=None
      blobs(4)=None
      blobs(5)=None
      blobs(6)=None
      blobs(7)=None
      blobs(8)=None
      blobs(9)=None
      blobs(10)=None
      blobs(11)=None
      blobs(12)=None
      blobs(13)=None
      blobs(14)=None
      blobs(15)=None
      BlobKillMessage="was corroded by a Blob"
      GroundSpeed=150.000000
      WaterSpeed=150.000000
      AccelRate=800.000000
      JumpZ=-1.000000
      MaxStepHeight=50.000000
      SightRadius=1000.000000
      PeripheralVision=-5.000000
      HearingThreshold=50.000000
      Intelligence=BRAINS_NONE
      bHidden=True
      Tag="blob1"
}
