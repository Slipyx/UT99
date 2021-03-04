//=============================================================================
// BabyCow.
// Don't add to world directly.  Rather, set bHasBaby of an adult cow.
//=============================================================================
class BabyCow extends Cow;

var Cow mom;

function PlayRunning()
{
	LoopAnim('Run', -1.5/GroundSpeed,,0.3);
}

function PlayWalking()
{
	LoopAnim('Walk', -2.0/GroundSpeed,,0.3);
}

function FollowMom()
{
	Disable('AnimEnd');
	GotoState('Grazing', 'Wander');
}
				

state Grazing
{
	
	function TakeDamage( int Damage, Pawn instigatedBy, Vector hitlocation, 
						Vector momentum, name damageType)
	{
		Global.TakeDamage(Damage, instigatedBy, hitlocation, momentum, damageType);
		if ( Mom != None && Enemy != None)
			Mom.Help(self);
		if ( health <= 0 || bDeleteme)
			return;
		if ( NextState == 'TakeHit' )
		{
			NextState = 'Attacking';
			NextLabel = 'Begin';
			GotoState('TakeHit');
		}
		else
			GotoState('Attacking');
	}

	function Bump(actor Other)
	{
		if ( (Pawn(Other)!= None) && (Cow(Other) == None) && (MoveTimer < 0) )
			GotoState('Grazing', 'Wander');	
		else if ( (Normal(Destination - Location) Dot Normal(Other.Location - Location)) > 0.8 )
			MoveTimer = -1.0;
		Disable('Bump');
	}
	
	function PickDestination()
	{
		if ( Mom == None )
		{
			Super.PickDestination();
			return;
		}
		if ( !LineOfSightTo(mom) )
		{
			MoveTarget = FindPathToward(mom);
			if ( MoveTarget != None )
			{
				Destination = MoveTarget.Location;
				return;
			}
		}		
		if (ScaryGuy != None)
			Destination = mom.Destination - 2 * mom.CollisionRadius * Normal(ScaryGuy.Location - mom.Destination);
		else
			Destination = mom.Destination;
	}

Begin:
	//log(class$" Grazing");

Wander:
	Acceleration = vect(0,0,0);
	WaitForLanding();
	if (!bForage)
		Goto('Graze');
	PickDestination();
	TweenToWalking(0.2);
	FinishAnim();
	PlayWalking();
	
Moving:
	Enable('Bump');
	MoveTo(Destination, 0.4);

Graze:
	Enable('AnimEnd');
	Acceleration = vect(0,0,0);
	NextAnim = '';
	TweenToPatrolStop(0.2);
	Sleep(4);
	Disable('AnimEnd');
	FinishAnim();
	Goto('Wander');

ContinueWander:
	FinishAnim();
	PlayWalking();
	Goto('Wander');

Turn:
	PlayTurning();
	if (Mom!=None)
	    TurnToward(Mom);
	else
	{
	    SetTurn();
		TurnTo(Destination);
	}
	Goto('Graze');

Pausing:
	Acceleration = vect(0,0,0);
	if ( NearWall(2 * CollisionRadius + 50) )
	{
		PlayTurning();
		TurnTo(Focus);
	}
	Enable('AnimEnd');
	NextAnim = '';
	TweenToPatrolStop(0.2);
	Sleep(1.0);
	Disable('AnimEnd');
	FinishAnim();
	Goto('Moving');

AdjustFromWall:
	if ( !IsAnimating() )
		PlayWalking();
	StrafeTo(Destination, Focus);
	Destination = Focus;
	Goto('Moving');
}

defaultproperties
{
      mom=None
      Health=40
      DrawScale=0.500000
      CollisionRadius=24.000000
      CollisionHeight=16.000000
      Mass=70.000000
}
