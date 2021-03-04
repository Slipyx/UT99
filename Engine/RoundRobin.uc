//=============================================================================
// RoundRobin: Each time it's triggered, it advances through a list of
// outgoing events.
//=============================================================================
class RoundRobin extends Triggers;

var() name OutEvents[16]; // Events to generate.
var() bool bLoop;         // Whether to loop when get to end.
var int i;                // Internal counter.

//
// When RoundRobin is triggered...
//
function Trigger( actor Other, pawn EventInstigator )
{
	local actor A;
	if( OutEvents[i] != '' )
	{
		foreach AllActors( class 'Actor', A, OutEvents[i] )		
		{
			A.Trigger( Self, EventInstigator );
		}
		if( ++i>=ArrayCount(OutEvents) || OutEvents[i]=='' )
		{
			if( bLoop ) i=0;
			else
				SetCollision(false,false,false);
		}
	}
}

defaultproperties
{
      OutEvents(0)="None"
      OutEvents(1)="None"
      OutEvents(2)="None"
      OutEvents(3)="None"
      OutEvents(4)="None"
      OutEvents(5)="None"
      OutEvents(6)="None"
      OutEvents(7)="None"
      OutEvents(8)="None"
      OutEvents(9)="None"
      OutEvents(10)="None"
      OutEvents(11)="None"
      OutEvents(12)="None"
      OutEvents(13)="None"
      OutEvents(14)="None"
      OutEvents(15)="None"
      bLoop=False
      i=0
}
