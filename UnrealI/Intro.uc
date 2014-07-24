//=============================================================================
// Intro.
//=============================================================================
class Intro extends UnrealGameInfo;

var PlayerPawn NewPlayer;

event playerpawn Login
(
	string Portal,
	string Options,
	out string Error,
	class<playerpawn> SpawnClass
)
{
	NewPlayer = Super.Login(Portal, Options, Error, SpawnClass);	
	SetTimer(0.05,False);
	NewPlayer.SetCollisionSize(18,39);
	return NewPlayer;
}

Function Timer()
{
	local Actor A;
	local InterpolationPoint i;	
	
	if ( NewPlayer != None )
	{	
		foreach AllActors( class 'InterpolationPoint', i, 'Path' )
		{
			if( i.Position == 0 )
			{			

				NewPlayer.SetCollision(false,false,false);
				NewPlayer.Target = i;
				NewPlayer.SetPhysics(PHYS_Interpolating);
				NewPlayer.PhysRate = 1.0;
				NewPlayer.PhysAlpha = 0.0;
				NewPlayer.bInterpolating = true;
//				NewPlayer.GotoState('');				
			}
		}
	}


}

defaultproperties
{
     bPauseable=False
     DefaultWeapon=None
     HUDType=Class'UnrealI.IntroNullHud'
}
