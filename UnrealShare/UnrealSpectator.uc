//=============================================================================
// UnrealSpectator.
//=============================================================================
class UnrealSpectator extends Spectator;

function PostBeginPlay()
{
	Super.PostBeginPlay();
	if ( (Level.Game != None) && Level.Game.IsA('Intro') )
		HUDType = Level.Game.HUDType;		
}

exec function Fire( optional float F )
{
	if ( (Role == ROLE_Authority) && (Level.Game == None || !Level.Game.IsA('Intro')) )
		Super.Fire( F );
}

defaultproperties
{
      HUDType=Class'UnrealShare.spectatorhud'
      CollisionRadius=17.000000
}
