//=============================================================================
// SpawnNotify - Actor spawn notification.  
//   NB - This happens on the client AND server for replicated actors.
//=============================================================================
class SpawnNotify expands Actor
	native;

var class<Actor> ActorClass;
var SpawnNotify  Next;

replication
{
	reliable if( Role == ROLE_Authority )
		ActorClass;
}

simulated function PostBeginPlay()
{
	local SpawnNotify N;

	for(N = Level.SpawnNotify; N != None; N = N.Next)
		if(N == Self)
			return;

	Next = Level.SpawnNotify;
	Level.SpawnNotify = Self;
}

simulated event Destroyed()
{
	local SpawnNotify N;
	
	if(Level.SpawnNotify == Self)
	{
		Level.SpawnNotify = Next;
		Next = None;		
	}
	else
	{
		for(N = Level.SpawnNotify; N != None && N.Next != None; N = N.Next)
		{
			if(N.Next == Self)
			{
				N.Next = Next;
				Next = None;
				return;
			}
		}
	}
}

simulated event Actor SpawnNotification(Actor A)
{
	return A;
}

defaultproperties
{
     ActorClass=Class'Engine.Actor'
     bHidden=True
     bAlwaysRelevant=True
     bNetTemporary=True
}
