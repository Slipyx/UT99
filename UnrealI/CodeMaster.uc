//=============================================================================
// CodeMaster.
//=============================================================================
class CodeMaster extends Info;

// When a set of CodeTriggers are set up along with their corresponding
// ElevatorMovers, the CodeMaster is notified by the CodeTriggers whenever
// something encroaches upon them, and tries to match the order of trigger
// activations to a preset pattern, and if the pattern is matched, the
// main event is called, solving the "puzzle". M

var() int  OrderCode[6];
var() name MoverTags[6];
var() int  NumElements;
var() name MainEvent;

var   int  ActualOrder[6];
var   int  TriggerFlags[6];
var   int  NumTriggered;
var   bool bTriggeredAlready;

function BeginPlay()
{
	local int i;
	
	bTriggeredAlready = false;
	for( i=0; i<NumElements; i++ ) TriggerFlags[i] = 0;
	NumTriggered = 0;
}

function NotifyTriggered( int TriggerCode )
{
	// Don't continue if the main Event has already been successfully called
	if( bTriggeredAlready ) return; 

	// Don't add it to the order list if this trigger has been triggered already
	if( TriggerFlags[ TriggerCode ] == 1 ) return;

	// Set the trigger flag for this code
	//log( "TriggerCode = " $ TriggerCode );
	TriggerFlags[ TriggerCode ] = 1;
	
	// Add this code to the sequence
	if( NumTriggered == NumElements ) NumTriggered = 0;
	ActualOrder[ NumTriggered ] = TriggerCode;
	NumTriggered++;
	
	CheckOrder();
}

function CheckOrder()
{
	local int i;
	local int bR;
	local ElevatorMover EM;
	local Actor tAct;

	// Check if the order given matches what is required to cause the event
	
	bR = 1;
	// First check if all the triggers were activated
	for( i=0; i<NumElements; i++ )
		bR = bR * TriggerFlags[i];
		
	if( bR != 0 )
	{	
		//log("All triggers activated");
		// All the triggers were activated
		// Now check if the order of activation was correct
		for( i=0; i<NumElements; i++ )
		{
			if( OrderCode[i] == ActualOrder[i] )
			{
				if( i == NumElements-1 )
				{
					//log("Successful! Calling Main Event.");
					// successful match				
					// Call the main Event
					if( MainEvent != '' )
						foreach AllActors( class 'Actor', tAct, MainEvent )
							tAct.Trigger( Self, Self.Instigator );

					// deactivate the CodeMaster
					bTriggeredAlready = true;	
					return;
				}
			}
			else break;
		}

		//log("Resetting puzzle");

		// If false then find all ElevatorMovers who have Tags which match
		// this CodeMaster's Event, and Move them to keyframe 0.
		for( i=0; i<NumElements; i++ )
		{
			if( MoverTags[i] != '' )
				foreach AllActors( class 'ElevatorMover', EM, MoverTags[i] )
					EM.MoveKeyframe( 0, EM.MoveTime );
		}

		// Clear the TriggerFlags array, reset the puzzle
		for( i=0; i<NumElements; i++ ) TriggerFlags[i] = 0;
		NumTriggered = 0;
	}
}

defaultproperties
{
      OrderCode(0)=0
      OrderCode(1)=0
      OrderCode(2)=0
      OrderCode(3)=0
      OrderCode(4)=0
      OrderCode(5)=0
      MoverTags(0)="None"
      MoverTags(1)="None"
      MoverTags(2)="None"
      MoverTags(3)="None"
      MoverTags(4)="None"
      MoverTags(5)="None"
      NumElements=0
      MainEvent="None"
      ActualOrder(0)=0
      ActualOrder(1)=0
      ActualOrder(2)=0
      ActualOrder(3)=0
      ActualOrder(4)=0
      ActualOrder(5)=0
      TriggerFlags(0)=0
      TriggerFlags(1)=0
      TriggerFlags(2)=0
      TriggerFlags(3)=0
      TriggerFlags(4)=0
      TriggerFlags(5)=0
      NumTriggered=0
      bTriggeredAlready=False
}
