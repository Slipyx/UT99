//=============================================================================
// Player start location.
//=============================================================================
class PlayerStart extends NavigationPoint 
	native;

#exec Texture Import File=Textures\S_Player.pcx Name=S_Player Mips=Off Flags=2

// Players on different teams are not spawned in areas with the
// same TeamNumber unless there are more teams in the level than
// team numbers.
var() byte TeamNumber;
var() bool bSinglePlayerStart;
var() bool bCoopStart;		
var() bool bEnabled; 

function Trigger( actor Other, pawn EventInstigator )
{
	bEnabled = !bEnabled;
}

function PlayTeleportEffect(actor Incoming, bool bOut)
{
	if ( Level.Game.bDeathMatch && Incoming.IsA('PlayerPawn') )
		PlayerPawn(Incoming).SetFOVAngle(135);
	Level.Game.PlayTeleportEffect(Incoming, bOut, Level.Game.bDeathMatch );
}

defaultproperties
{
      TeamNumber=0
      bSinglePlayerStart=True
      bCoopStart=True
      bEnabled=True
      bDirectional=True
      Texture=Texture'Engine.S_Player'
      SoundVolume=128
      CollisionRadius=18.000000
      CollisionHeight=40.000000
}
