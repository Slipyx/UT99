//=============================================================================
// SmallWire.
//=============================================================================
class SmallWire extends Wire;

Auto State Animate
{

Begin:
	if (WireType == E_WireWiggle) LoopAnim('Wiggle',1.0);
	else LoopAnim('Still',FRand()*0.03+0.02);
}

defaultproperties
{
      DrawScale=0.600000
      CollisionRadius=3.000000
      CollisionHeight=40.000000
}
