//=============================================================================
// CHSpectator.
//=============================================================================
class CHSpectator extends Spectator;

var Actor OldTarget;

event PostBeginPlay()
{
	Super.PostBeginPlay();
	if ( Level.NetMode != NM_Client )
		HUDType = Level.Game.HUDType;
}

exec function Jump( optional float F )
{
	ViewClass(class'SpectatorCam', true);
	While ( (ViewTarget != None) && ViewTarget.IsA('SpectatorCam') && SpectatorCam(ViewTarget).bSkipView )
		ViewClass(class'SpectatorCam', true);
	if ( ViewTarget.IsA('SpectatorCam') )
		bBehindView = false;
}

exec function Verbose()
{
	if ( Bot(ViewTarget) != None )
		Bot(ViewTarget).bVerbose = true;
}

function FixFOV()
{
	if ( (ViewTarget != None) && !ViewTarget.IsA('SpectatorCam') )
	{
		FOVAngle = 90;
		DesiredFOV = 90;
		DefaultFOV = 90;
	}
	else
	{
		FOVAngle = Default.DefaultFOV;
		DesiredFOV = Default.DefaultFOV;
		DefaultFOV = Default.DefaultFOV;
	}
}

exec function NextWeapon()
{
	OldTarget = ViewTarget;
	Fire();
}

exec function PrevWeapon()
{
	if ( OldTarget != None )
		ViewTarget = OldTarget;
	else if ( (Role == ROLE_Authority) && !Level.Game.IsA('Intro') )
		ViewPlayerNum(-2);
	OldTarget = None;
	if ( ViewTarget == None )
		bBehindView = false;
	else
		bBehindView = bChaseCam;
}


exec function ViewPlayerNum(optional int num)
{
	bChaseCam = true;
	bBehindView = true;
	Super.ViewPlayerNum(num);
	FixFOV();
}

exec function ViewClass( class<actor> aClass, optional bool bQuiet )
{
	Super.ViewClass(aClass, bQuiet);
	FixFOV();
}

exec function ViewSelf()
{
	Super.ViewSelf();
	FixFOV();
}

exec function CheatView( class<actor> aClass )
{
	Super.CheatView(aClass);
	FixFOV();
}

exec function Fire( optional float F )
{
	if ( (Role == ROLE_Authority) && (Level.Game == None || !Level.Game.IsA('Intro')) )
	{
		ViewPlayerNum(-1);
		if ( ViewTarget == None )
			bBehindView = false;
		else
			bBehindView = bChaseCam;
	}
}

defaultproperties
{
     HUDType=Class'Botpack.CHSpectatorHUD'
     FovAngle=110.000000
     CollisionRadius=17.000000
}
