//=============================================================================
// Ammo.
//=============================================================================
class Ammo extends Pickup
	abstract
	native
	nativereplication;

#exec Texture Import File=Textures\Ammo.pcx Name=S_Ammo Mips=Off Flags=2

var() travel int AmmoAmount;
var() travel int MaxAmmo;
var() class<ammo> ParentAmmo;    // Class of ammo to be represented in inventory
var() byte UsedInWeaponSlot[10];
var   ammo  PAmmo;



// Network replication
//
replication
{
	// Things the server should send to the client.
	reliable if( bNetOwner && (Role==ROLE_Authority) )
		AmmoAmount;
}

event float BotDesireability(Pawn Bot)
{
	local Ammo AlreadyHas;

	if ( ParentAmmo != None )
		AlreadyHas = Ammo(Bot.FindInventoryType(ParentAmmo));
	else
		AlreadyHas = Ammo(Bot.FindInventoryType(Class));
	if ( AlreadyHas == None )
		return (0.35 * MaxDesireability);
	if ( AlreadyHas.AmmoAmount == 0 )
		return MaxDesireability;
	if (AlreadyHas.AmmoAmount >= AlreadyHas.MaxAmmo) 
		return -1;

	return ( MaxDesireability * FMin(1, 0.15 * MaxAmmo/AlreadyHas.AmmoAmount) );
}

function bool HandlePickupQuery( Inventory Item )
{
	if ( (class == Item.class) || 
		(ClassIsChildOf(Item.class, class'Ammo') && (class == Ammo(Item).parentammo)) ) 
	{
		if (AmmoAmount==MaxAmmo) return true;
		if (Level.Game.LocalLog != None)
			Level.Game.LocalLog.LogPickup(Item, Pawn(Owner));
		if (Level.Game.WorldLog != None)
			Level.Game.WorldLog.LogPickup(Item, Pawn(Owner));
		if (Item.PickupMessageClass == None)
			Pawn(Owner).ClientMessage( Item.PickupMessage, 'Pickup' );
		else
			Pawn(Owner).ReceiveLocalizedMessage( Item.PickupMessageClass, 0, None, None, Item.Class );
		Item.PlaySound( Item.PickupSound,, 2);
		AddAmmo(Ammo(Item).AmmoAmount);
		Item.SetRespawn();
		return true;				
	}
	if ( Inventory == None )
		return false;

	return Inventory.HandlePickupQuery(Item);
}

// This function is called by an actor that wants to use ammo.  
// Return true if ammo exists 
//
function bool UseAmmo(int AmountNeeded)
{
	if (AmmoAmount < AmountNeeded) return False;   // Can't do it
	AmmoAmount -= AmountNeeded;
	return True;
}

// If we can, add ammo and return true.  
// We we are at max ammo, return false
//
function bool AddAmmo(int AmmoToAdd)
{
	If (AmmoAmount >= MaxAmmo) return false;
	AmmoAmount += AmmoToAdd;
	if (AmmoAmount > MaxAmmo) AmmoAmount = MaxAmmo;
	return true;
}

function inventory SpawnCopy( Pawn Other )
{
	local Inventory Copy;

	if ( parentammo != None )
	{
		Copy = spawn(parentammo,Other,,,rot(0,0,0));
		Copy.Tag           = Tag;
		Copy.Event         = Event;
		Copy.Instigator    = Other;
		Ammo(Copy).AmmoAmount = AmmoAmount;
		Copy.BecomeItem();
		Other.AddInventory( Copy );
		Copy.GotoState('');
		if ( Level.Game.ShouldRespawn(self) )
			GotoState('Sleeping');
		else
			Destroy();
		return Copy;
	}
	Copy = Super.SpawnCopy(Other);
	Ammo(Copy).AmmoAmount = AmmoAmount; 
	return Copy;
}

defaultproperties
{
      AmmoAmount=0
      MaxAmmo=0
      ParentAmmo=None
      UsedInWeaponSlot(0)=0
      UsedInWeaponSlot(1)=0
      UsedInWeaponSlot(2)=0
      UsedInWeaponSlot(3)=0
      UsedInWeaponSlot(4)=0
      UsedInWeaponSlot(5)=0
      UsedInWeaponSlot(6)=0
      UsedInWeaponSlot(7)=0
      UsedInWeaponSlot(8)=0
      UsedInWeaponSlot(9)=0
      PAmmo=None
      PickupMessage="You picked up some ammo."
      RespawnTime=30.000000
      MaxDesireability=0.200000
      Texture=Texture'Engine.S_Ammo'
      bCollideActors=False
}
