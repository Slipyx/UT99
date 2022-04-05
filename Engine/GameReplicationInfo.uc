//=============================================================================
// GameReplicationInfo.
//=============================================================================
class GameReplicationInfo extends ReplicationInfo
	native nativereplication;

var string GameName;						// Assigned by GameInfo.
var string GameClass;						// Assigned by GameInfo.
var bool bTeamGame;							// Assigned by GameInfo.
var bool bClassicDeathMessages;
var bool bStopCountDown;
var int  RemainingTime, ElapsedTime, RemainingMinute;
var float SecondCount;

var int NumPlayers;
var int SumFrags;
var float UpdateTimer;

var() globalconfig string ServerName;		// Name of the server, i.e.: Bob's Server.
var() globalconfig string ShortName;		// Abbreviated name of server, i.e.: B's Serv (stupid example)
var() globalconfig string AdminName;		// Name of the server admin.
var() globalconfig string AdminEmail;		// Email address of the server admin.
var() globalconfig int 		 Region;		// Region of the game server.

var() globalconfig string MOTDLine1;		// Message
var() globalconfig string MOTDLine2;		// Of
var() globalconfig string MOTDLine3;		// The
var() globalconfig string MOTDLine4;		// Day

var string GameEndedComments;				// set by gameinfo when game ends

var PlayerReplicationInfo PRIArray[32];

replication
{
	reliable if ( Role == ROLE_Authority )
		RemainingMinute, bStopCountDown, GameEndedComments,
		NumPlayers;

	reliable if ( bNetInitial && (Role==ROLE_Authority) )
		GameName, GameClass, bTeamGame, ServerName, ShortName, AdminName,
		AdminEmail, Region, MOTDLine1, MOTDLine2,
		MOTDLine3, MOTDLine4,RemainingTime, ElapsedTime;
}

simulated function PostBeginPlay()
{
	if( Level.NetMode == NM_Client )
	{
		// clear variables so we don't display our own values if the server has them left blank
		ServerName = "";
		AdminName = "";
		AdminEmail = "";
		MOTDLine1 = "";
		MOTDLine2 = "";
		MOTDLine3 = "";
		MOTDLine4 = "";
	}

	SecondCount = Level.TimeSeconds;
	SetTimer(0.2, true);
}

simulated function Timer()
{
	local PlayerReplicationInfo PRI;
	local int i, FragAcc;

	if ( Level.NetMode == NM_Client )
	{
		if (Level.TimeSeconds - SecondCount >= Level.TimeDilation)
		{
			ElapsedTime++;
			if ( RemainingMinute != 0 )
			{
				RemainingTime = RemainingMinute;
				RemainingMinute = 0;
			}
			if ( (RemainingTime > 0) && !bStopCountDown )
				RemainingTime--;
			SecondCount += Level.TimeDilation;
		}
	}

	for (i=0; i<32; i++)
		PRIArray[i] = None;
	i=0;
	foreach AllActors(class'PlayerReplicationInfo', PRI)
	{
		if ( i < 32 )
			PRIArray[i++] = PRI;
	}

	// Update various information.
	UpdateTimer = 0;
	for (i=0; i<32; i++)
		if (PRIArray[i] != None)
			FragAcc += PRIArray[i].Score;
	SumFrags = FragAcc;

	if ( Level.Game != None )
		NumPlayers = Level.Game.NumPlayers;
}

defaultproperties
{
      GameName=""
      GameClass=""
      bTeamGame=False
      bClassicDeathMessages=False
      bStopCountDown=True
      RemainingTime=0
      ElapsedTime=0
      RemainingMinute=0
      SecondCount=0.000000
      NumPlayers=0
      SumFrags=0
      UpdateTimer=0.000000
      ServerName="Another UT Server"
      ShortName="UT Server"
      AdminName=""
      AdminEmail=""
      Region=0
      MOTDLine1=""
      MOTDLine2=""
      MOTDLine3=""
      MOTDLine4=""
      GameEndedComments=""
      PRIArray(0)=None
      PRIArray(1)=None
      PRIArray(2)=None
      PRIArray(3)=None
      PRIArray(4)=None
      PRIArray(5)=None
      PRIArray(6)=None
      PRIArray(7)=None
      PRIArray(8)=None
      PRIArray(9)=None
      PRIArray(10)=None
      PRIArray(11)=None
      PRIArray(12)=None
      PRIArray(13)=None
      PRIArray(14)=None
      PRIArray(15)=None
      PRIArray(16)=None
      PRIArray(17)=None
      PRIArray(18)=None
      PRIArray(19)=None
      PRIArray(20)=None
      PRIArray(21)=None
      PRIArray(22)=None
      PRIArray(23)=None
      PRIArray(24)=None
      PRIArray(25)=None
      PRIArray(26)=None
      PRIArray(27)=None
      PRIArray(28)=None
      PRIArray(29)=None
      PRIArray(30)=None
      PRIArray(31)=None
      RemoteRole=ROLE_SimulatedProxy
}
