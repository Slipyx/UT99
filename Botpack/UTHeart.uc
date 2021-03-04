//=============================================================================
// UTHeart.
//=============================================================================
class UTHeart extends UTPlayerChunks;

auto state Dying
{

Begin:
	LoopAnim('Beat', 0.2);
	Sleep(0.1);
	GotoState('Dead');
}

defaultproperties
{
      Mesh=LodMesh'UnrealShare.PHeartM'
      CollisionRadius=14.000000
      CollisionHeight=3.000000
}
