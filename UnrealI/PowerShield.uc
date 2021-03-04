//=============================================================================
// PowerShield.
//=============================================================================
class PowerShield extends ShieldBelt;

function Timer()
{
	Charge-=1;
	if (Charge<0) Destroy();
}

defaultproperties
{
      PickupMessage="You got the PowerShield"
      RespawnTime=100.000000
      Charge=200
      CollisionRadius=30.000000
      CollisionHeight=30.000000
}
