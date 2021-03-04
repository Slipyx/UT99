//=============================================================================
// Jumper.
// Creatures will jump on hitting this trigger in direction specified
//=============================================================================
class Kicker extends Triggers;

var() vector KickVelocity;
var() name KickedClasses;
var() bool bKillVelocity;
var() bool bRandomize;

replication
{
	reliable if ( bNetInitial && Role==ROLE_Authority )
		KickVelocity, KickedClasses, bKillVelocity; //bRandomize cannot be properly simulated
}

simulated function Touch( Actor Other )
{
	local Actor A;

	if ( !Other.IsA(KickedClasses) )
		return;

	if ( (Level.NetMode == NM_Client) && !SimulateKick(Other) )
		return;
	
	PendingTouch = Other.PendingTouch;
	Other.PendingTouch = self;
	if( Event != '' )
		foreach AllActors( class 'Actor', A, Event )
			A.Trigger( Other, Other.Instigator );
}

simulated function PostTouch( Actor Other )
{
	local bool bWasFalling;
	local vector Push;
	local float PMag;

	bWasFalling = ( Other.Physics == PHYS_Falling );
	if ( bKillVelocity )
		Push = -1 * Other.Velocity;
	else
		Push.Z = -1 * Other.Velocity.Z;
	if ( bRandomize )
	{
		PMag = VSize(KickVelocity);
		Push += PMag * Normal(KickVelocity + 0.5 * PMag * VRand());
	}
	else
		Push += KickVelocity;
	if ( Other.IsA('Bot') )
	{
		if ( bWasFalling )
			Bot(Other).bJumpOffPawn = true;
		Bot(Other).SetFall();
	}
	Other.SetPhysics(PHYS_Falling);
	Other.Velocity += Push;
}


static function bool SimulateKick( Actor Other)
{
	if ( Other.Role == ROLE_DumbProxy ) //Location is updated by server
		return false;

	if ( (PlayerPawn(Other) != None) && (Other.Role == ROLE_AutonomousProxy) ) //Local Player (Viewport may be detached during DemoPlay!!)
		return Other.bCanTeleport;

	if ( Other.bIsPawn ) //Simulated pawn receive Location updates
		return false;
		
	return Other.Physics != PHYS_None;
}

defaultproperties
{
      KickVelocity=(X=0.000000,Y=0.000000,Z=0.000000)
      KickedClasses="Pawn"
      bKillVelocity=False
      bRandomize=False
      bAlwaysRelevant=True
      RemoteRole=ROLE_SimulatedProxy
      bDirectional=True
}
