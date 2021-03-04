//=============================================================================
// CTFReplicationInfo.
//=============================================================================
class CTFReplicationInfo extends TournamentGameReplicationInfo;

var CTFFlag FlagList[4];

replication
{
	reliable if ( Role == ROLE_Authority )
		FlagList;
}

defaultproperties
{
      FlagList(0)=None
      FlagList(1)=None
      FlagList(2)=None
      FlagList(3)=None
}
