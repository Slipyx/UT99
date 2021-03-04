//=============================================================================
// TeamInfo.
//=============================================================================
class TeamInfo extends Info;

var string TeamName;
var int Size; //number of players on this team in the level
var float Score;
var int TeamIndex;

replication
{
	// Variables the server should send to the client.
	reliable if( Role==ROLE_Authority )
		TeamName, Size, Score, TeamIndex;
}

defaultproperties
{
      TeamName=""
      Size=0
      Score=0.000000
      TeamIndex=0
      bAlwaysRelevant=True
}
