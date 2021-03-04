//=============================================================================
// MasterCreatureChunk
//=============================================================================
class MasterCreatureChunk extends CreatureChunks;

var PlayerReplicationInfo PlayerRep;

replication
{
	// Things the server should send to the client.
	unreliable if( Role==ROLE_Authority )
		PlayerRep;
}

function SetAsMaster(Actor Other)
{
	Velocity = Other.Velocity;
	CarcassAnim = Other.AnimSequence;
	CarcHeight = Other.CollisionHeight;
}

defaultproperties
{
      PlayerRep=None
      TrailSize=0.500000
      bMasterChunk=True
      CarcHeight=39.000000
}
