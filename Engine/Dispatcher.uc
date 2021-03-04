//=============================================================================
// Dispatcher: receives one trigger (corresponding to its name) as input, 
// then triggers a set of specifid events with optional delays.
//=============================================================================
class Dispatcher extends Triggers;

#exec Texture Import File=Textures\Dispatch.pcx Name=S_Dispatcher Mips=Off Flags=2

//-----------------------------------------------------------------------------
// Dispatcher variables.

var() name  OutEvents[8]; // Events to generate.
var() float OutDelays[8]; // Relative delays before generating events.
var int i;                // Internal counter.

//=============================================================================
// Dispatcher logic.

//
// When dispatcher is triggered...
//
function Trigger( actor Other, pawn EventInstigator )
{
	Instigator = EventInstigator;
	gotostate('Dispatch');
}

//
// Dispatch events.
//
state Dispatch
{
Begin:
	disable('Trigger');
	for( i=0; i<ArrayCount(OutEvents); i++ )
	{
		if( OutEvents[i] != '' )
		{
			Sleep( OutDelays[i] );
			foreach AllActors( class 'Actor', Target, OutEvents[i] )
				Target.Trigger( Self, Instigator );
		}
	}
	enable('Trigger');
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
      OutDelays(0)=0.000000
      OutDelays(1)=0.000000
      OutDelays(2)=0.000000
      OutDelays(3)=0.000000
      OutDelays(4)=0.000000
      OutDelays(5)=0.000000
      OutDelays(6)=0.000000
      OutDelays(7)=0.000000
      i=0
      Texture=Texture'Engine.S_Dispatcher'
}
