//=============================================================================
// AssertMover.
//=============================================================================
class AssertMover extends Mover;

// A mover which keeps opening as long as the instigator stays within
// the trigger's radius.  If the instigator steps out, the mover will
// stay in it's current position for WaitUnAssertTime time, and then
// close all the way back to the beginning.  If the bTriggerOnceOnly
// variable is true, once it reaches the last keyframe, it will
// stay there forever if bOnceOnlyStopOpen is true, or it will go back
// to the first frame (after waiting for StayOpenTime) and stay there 
// forever if bOnceOnlyStopOpen is false.  If bTriggerOnceOnly is 
// false, when it reaches the last keyframe, after it waits for 
// StayOpenTime, it will return to the first keyframe, and the
// entire process will be repeatable.
// Note: When the last keyframe is reached, Event will be called. M.


var() float OpenTimes [6];
var() float CloseTimes[6];
var() bool  bOnceOnlyStopOpen;
var() float WaitUnAssertTime;

var int LastKeyNum;

function BeginPlay() 
{

	KeyNum = 0;
	Super.BeginPlay();
}


function DoOpen() 
{

	// Open through to the next keyframe.
	//
	bOpening = true;
	bDelaying = false;
	LastKeyNum = KeyNum;
	InterpolateTo (KeyNum+1, OpenTimes[Keynum]);
	PlaySound (OpeningSound);
	AmbientSound = MoveAmbientSound;
}

function DoClose() 
{

	// Close through to the next keyframe.
	//
	bOpening = false;
	bDelaying = false;
	LastKeyNum = KeyNum;
	InterpolateTo (KeyNum-1, CloseTimes[Keynum-1]);
	PlaySound (ClosingSound);
	AmbientSound = MoveAmbientSound;
}

//=======================================================================
// The various states

// When triggered, open, wait, then close.
//
state() AssertTriggerOpenTimed 
{
	function bool HandleDoor(pawn Other)
	{
		return HandleTriggerDoor(Other);
	}

	function Trigger( actor Other, pawn EventInstigator )
	{
		// Keep opening until untriggered
		SavedTrigger = Other;
		Instigator = EventInstigator;
		if ( SavedTrigger != None )
			SavedTrigger.BeginEvent();
		GotoState( 'AssertTriggerOpenTimed', 'Open' );
	}

	function UnTrigger( actor Other, pawn EventInstigator )
	{
		// Start waiting, and close when the waiting time has expired
		// (unless re-triggered within the waiting interval,
		//  when it will keep opening).
		SavedTrigger = Other;
		Instigator = EventInstigator;
		GotoState( 'AssertTriggerOpenTimed', 'WaitClose' );	
	}

	function InterpolateEnd(actor Other) 
	{	
	}

	function BeginState()
	{
		bOpening = false;
	}
		
Open:

	Disable( 'Trigger' );
	if ( DelayTime > 0 )
	{
		bDelaying = true;
		Sleep(DelayTime);
	}
	if( KeyNum+1 >= NumKeys )
	{
		if( bTriggerOnceOnly && bOnceOnlyStopOpen ) GotoState('');

		// Wait in the open position for some time
		Disable( 'UnTrigger' );
		Sleep( StayOpenTime );
		GotoState( 'AssertTriggerOpenTimed', 'CloseFully' );
	}
	DoOpen();
	FinishInterpolation();
	FinishedOpening();

	// Loop forever
	GotoState( 'AssertTriggerOpenTimed', 'Open' );

WaitClose:
	Disable( 'UnTrigger' );
	FinishInterpolation();
	FinishedOpening();
	
	// Wait a little while in this current position, before closing
	Sleep( WaitUnAssertTime );
	
CloseFully:
	DoClose();
	FinishInterpolation();
	FinishedClosing();
	
	if( KeyNum > 0 ) GotoState( 'AssertTriggerOpenTimed', 'CloseFully' );

	if( bTriggerOnceOnly ) GotoState('');

	// Set it back to its initial state
	Enable('Trigger');
	Enable('UnTrigger');	
	Stop;
}

defaultproperties
{
      OpenTimes(0)=0.000000
      OpenTimes(1)=0.000000
      OpenTimes(2)=0.000000
      OpenTimes(3)=0.000000
      OpenTimes(4)=0.000000
      OpenTimes(5)=0.000000
      CloseTimes(0)=0.000000
      CloseTimes(1)=0.000000
      CloseTimes(2)=0.000000
      CloseTimes(3)=0.000000
      CloseTimes(4)=0.000000
      CloseTimes(5)=0.000000
      bOnceOnlyStopOpen=False
      WaitUnAssertTime=0.000000
      LastKeyNum=0
}
