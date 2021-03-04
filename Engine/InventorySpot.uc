//=============================================================================
// InventorySpot.
//=============================================================================
class InventorySpot extends NavigationPoint
	native;

var Inventory markedItem;

defaultproperties
{
      markedItem=None
      bEndPointOnly=True
      bHiddenEd=True
      bCollideWhenPlacing=False
      CollisionRadius=20.000000
      CollisionHeight=40.000000
}
