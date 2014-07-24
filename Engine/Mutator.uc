//=============================================================================
// Mutator.
// called by the IsRelevant() function of DeathMatchPlus
// by adding new mutators, you can change actors in the level without requiring
// a new game class.  Multiple mutators can be linked together. 
//=============================================================================
class Mutator expands Info
	native;

var Mutator NextMutator;
var Mutator NextDamageMutator;
var Mutator NextMessageMutator;
var Mutator NextHUDMutator;

var bool bHUDMutator;

var class<Weapon> DefaultWeapon;

event PreBeginPlay()
{
	//Don't call Actor PreBeginPlay()
}

simulated event PostRender( canvas Canvas );

function ModifyPlayer(Pawn Other)
{
	// called by GameInfo.RestartPlayer()
	if ( NextMutator != None )
		NextMutator.ModifyPlayer(Other);
}

function bool HandleRestartGame()
{
	if ( NextMutator != None )
		return NextMutator.HandleRestartGame();
	return false;
}

function bool HandleEndGame()
{
	// called by GameInfo.RestartPlayer()
	if ( NextMutator != None )
		return NextMutator.HandleEndGame();
	return false;
}

function bool HandlePickupQuery(Pawn Other, Inventory item, out byte bAllowPickup)
{
	if ( NextMutator != None )
		return NextMutator.HandlePickupQuery(Other, item, bAllowPickup);
	return false;
}

function bool PreventDeath(Pawn Killed, Pawn Killer, name damageType, vector HitLocation)
{
	if ( NextMutator != None )
		return NextMutator.PreventDeath(Killed,Killer, damageType,HitLocation);
	return false;
}

function ModifyLogin(out class<playerpawn> SpawnClass, out string Portal, out string Options)
{
	if ( NextMutator != None )
		NextMutator.ModifyLogin(SpawnClass, Portal, Options);
}

function ScoreKill(Pawn Killer, Pawn Other)
{
	// called by GameInfo.ScoreKill()
	if ( NextMutator != None )
		NextMutator.ScoreKill(Killer, Other);
}

// return what should replace the default weapon
// mutators further down the list override earlier mutators
function Class<Weapon> MutatedDefaultWeapon()
{
	local Class<Weapon> W;

	if ( NextMutator != None )
	{
		W = NextMutator.MutatedDefaultWeapon();
		if ( W == Level.Game.DefaultWeapon )
			W = MyDefaultWeapon();
	}
	else
		W = MyDefaultWeapon();
	return W;
}

function Class<Weapon> MyDefaultWeapon()
{
	if ( DefaultWeapon != None )
		return DefaultWeapon;
	else
		return Level.Game.DefaultWeapon;
}

function AddMutator(Mutator M)
{
	if ( NextMutator == None )
		NextMutator = M;
	else
		NextMutator.AddMutator(M);
}

/* ReplaceWith()
Call this function to replace an actor Other with an actor of aClass.
*/
function bool ReplaceWith(actor Other, string aClassName)
{
	local Actor A;
	local class<Actor> aClass;

	if ( Other.IsA('Inventory') && (Other.Location == vect(0,0,0)) )
		return false;
	aClass = class<Actor>(DynamicLoadObject(aClassName, class'Class'));
	if ( aClass != None )
		A = Spawn(aClass,Other.Owner,Other.tag,Other.Location, Other.Rotation);
	if ( Other.IsA('Inventory') )
	{
		if ( Inventory(Other).MyMarker != None )
		{
			Inventory(Other).MyMarker.markedItem = Inventory(A);
			if ( Inventory(A) != None )
			{
				Inventory(A).MyMarker = Inventory(Other).MyMarker;
				A.SetLocation(A.Location 
					+ (A.CollisionHeight - Other.CollisionHeight) * vect(0,0,1));
			}
			Inventory(Other).MyMarker = None;
		}
		else if ( A.IsA('Inventory') )
		{
			Inventory(A).bHeldItem = true;
			Inventory(A).Respawntime = 0.0;
		}
	}
	if ( A != None )
	{
		A.event = Other.event;
		A.tag = Other.tag;
		return true;
	}
	return false;
}

/* Force game to always keep this actor, even if other mutators want to get rid of it
*/
function bool AlwaysKeep(Actor Other)
{
	if ( NextMutator != None )
		return ( NextMutator.AlwaysKeep(Other) );
	return false;
}

function bool IsRelevant(Actor Other, out byte bSuperRelevant)
{
	local bool bResult;

	// allow mutators to remove actors
	bResult = CheckReplacement(Other, bSuperRelevant);
	if ( bResult && (NextMutator != None) )
		bResult = NextMutator.IsRelevant(Other, bSuperRelevant);

	return bResult;
}

function bool CheckReplacement(Actor Other, out byte bSuperRelevant)
{
	return true;
}

function Mutate(string MutateString, PlayerPawn Sender)
{
	if ( NextMutator != None )
		NextMutator.Mutate(MutateString, Sender);
}

function MutatorTakeDamage( out int ActualDamage, Pawn Victim, Pawn InstigatedBy, out Vector HitLocation, 
						out Vector Momentum, name DamageType)
{
	if ( NextDamageMutator != None )
		NextDamageMutator.MutatorTakeDamage( ActualDamage, Victim, InstigatedBy, HitLocation, Momentum, DamageType );
}

function bool MutatorTeamMessage( Actor Sender, Pawn Receiver, PlayerReplicationInfo PRI, coerce string S, name Type, optional bool bBeep )
{
	if ( NextMessageMutator != None )
		return NextMessageMutator.MutatorTeamMessage( Sender, Receiver, PRI, S, Type, bBeep );
	else
		return true;
}

function bool MutatorBroadcastMessage( Actor Sender, Pawn Receiver, out coerce string Msg, optional bool bBeep, out optional name Type )
{
	if ( NextMessageMutator != None )
		return NextMessageMutator.MutatorBroadcastMessage( Sender, Receiver, Msg, bBeep, Type );
	else
		return true;
}

function bool MutatorBroadcastLocalizedMessage( Actor Sender, Pawn Receiver, out class<LocalMessage> Message, out optional int Switch, out optional PlayerReplicationInfo RelatedPRI_1, out optional PlayerReplicationInfo RelatedPRI_2, out optional Object OptionalObject )
{
	if ( NextMessageMutator != None )
		return NextMessageMutator.MutatorBroadcastLocalizedMessage( Sender, Receiver, Message, Switch, RelatedPRI_1, RelatedPRI_2, OptionalObject );
	else
		return true;
}

// Registers the current mutator on the client to receive PostRender calls.
simulated function RegisterHUDMutator()
{
	local Pawn P;

	ForEach AllActors(class'Pawn', P)
		if ( P.IsA('PlayerPawn') && (PlayerPawn(P).myHUD != None) )
		{
			NextHUDMutator = PlayerPawn(P).myHud.HUDMutator;
			PlayerPawn(P).myHUD.HUDMutator = Self;
			bHUDMutator = True;
		}	
}

defaultproperties
{
}
