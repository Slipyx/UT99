//=============================================================================
// UdpServerQuery
//
// Version: 1.5.2
//
// This query server is compliant with the GameSpy Uplink Specification.
// The specification is available at http://www.gamespy.com/developer
// and might be of use to progammers who are writing or maintaining
// their own stat gathering/game querying software.
//
// Note: Currently, SendText returns false if successful.
//
// Full documentation on this class is available at http://unreal.epicgames.com/
//
//=============================================================================
class UdpServerQuery extends UdpLink config;

// Game Server Config.
var() name					QueryName;			// Name to set this object's Tag to.
var int					    CurrentQueryNum;	// Query ID Number.
var globalconfig string		GameName;
//crt
var string ReplyData;

var globalconfig int		MinNetVer;

//!! Hack to prevent port swapping
var globalconfig int		OldQueryPortNumber;
var globalconfig bool		bRestartServerOnPortSwap;

var globalconfig bool bTeamInfo; //utpg: respond to \teams\ queries

final function string StrReplace(string str, string replace, string with)
{
	local int i;
	local string Input;
		
	Input = str;
	str = "";
	i = InStr(Input, Replace);
	while(i != -1)
	{	
		str = str$Left(Input, i) $ With;
		Input = Mid(Input, i + Len(Replace));	
		i = InStr(Input, Replace);
	}
	return str$Input;
}

// Initialize.
function PreBeginPlay()
{
	local int boundport;

	// Set the Tag
	Tag = QueryName;

	// Bind the listen socket
	boundport = BindPort(Level.Game.GetServerPort(), true);
	if( boundport == 0 )
	{
		Log("UdpServerQuery: Port failed to bind.");
		return;
	}
	Log("UdpServerQuery(crt): Port "$boundport$" successfully bound.");

	if( bRestartServerOnPortSwap )
	{
		if( OldQueryPortNumber != 0 )
			assert( OldQueryPortNumber == boundport );
		OldQueryPortNumber = boundport;
		SaveConfig();
	}
}

function PostBeginPlay()
{
	local UdpBeacon	Beacon;

	foreach AllActors(class'UdpBeacon', Beacon)
	{
		Beacon.UdpServerQueryPort = Port;
	}
	Super.PostBeginPlay();
}

// Received a query request.
event ReceivedText( IpAddr Addr, string Text )
{
	local string Query;
	local bool QueryRemaining;
	local int  QueryNum, PacketNum;

	// Assign this packet a unique value from 1 to 100
	CurrentQueryNum++;
	if (CurrentQueryNum > 100)
		CurrentQueryNum = 1;
	QueryNum = CurrentQueryNum;

	Query = Text;
	if (Query == "")		// If the string is empty, don't parse it
		QueryRemaining = false;
	else
		QueryRemaining = true;
	//crt
	PacketNum =  0;
	ReplyData = "";
	while (QueryRemaining) {
		Query = ParseQuery(Addr, Query, QueryNum, PacketNum);
		if (Query == "")
			QueryRemaining = false;
		else
			QueryRemaining = true;
	}
}

function bool ParseNextQuery( string Query, out string QueryType, out string QueryValue, out string QueryRest, out int bFinalPacket )
{
	local string TempQuery;
	local int ClosingSlash;

	if (Query == "")
		return false;

	// Query should be:
	//   \[type]\<value>
	if (Left(Query, 1) == "\\")
	{
		// Check to see if closed.
		ClosingSlash = InStr(Right(Query, Len(Query)-1), "\\");
		if (ClosingSlash == 0)
			return false;

		TempQuery = Query;

		// Query looks like:
		//  \[type]\
		QueryType = Right(Query, Len(Query)-1);
		QueryType = Left(QueryType, ClosingSlash);

		QueryRest = Right(Query, Len(Query) - (Len(QueryType) + 2));

		if ((QueryRest == "") || (Len(QueryRest) == 1))
		{
			bFinalPacket = 1;
			return true;
		} else if (Left(QueryRest, 1) == "\\")
			return true;	// \type\\

		// Query looks like:
		//  \type\value
		ClosingSlash = InStr(QueryRest, "\\");
		if (ClosingSlash >= 0)
			QueryValue = Left(QueryRest, ClosingSlash);
		else
			QueryValue = QueryRest;

		QueryRest = Right(Query, Len(Query) - (Len(QueryType) + Len(QueryValue) + 3));
		if (QueryRest == "")
		{
			bFinalPacket = 1;
			return true;
		} else
			return true;
	} else {
		return false;
	}
}

function string ParseQuery( IpAddr Addr, coerce string Query, int QueryNum, out int PacketNum )
{
	local string QueryType, QueryValue, QueryRest, ValidationString;
	local bool Result;
	local int bFinalPacket;
	
	bFinalPacket = 0;
	Result = ParseNextQuery(Query, QueryType, QueryValue, QueryRest, bFinalPacket);
	if( !Result )
		return "";

	//Log("Got  Query: "  $ QueryNum $ "." $ PacketNum $ ":" $ QueryType);

	if( QueryType=="basic" )
	{
		Result = SendQueryPacket(Addr, GetBasic(), QueryNum, PacketNum, bFinalPacket);
	}
	else if( QueryType=="info" )
	{
		Result = SendQueryPacket(Addr, GetInfo(), QueryNum, PacketNum, bFinalPacket);
	}
	else if( QueryType=="rules" )
	{
		Result = SendQueryPacket(Addr, GetRules(), QueryNum, PacketNum, bFinalPacket);
	}
	else if( QueryType=="players" )
	{
		if( Level.Game.NumPlayers > 0 )
			Result = SendPlayers(Addr, QueryNum, PacketNum, bFinalPacket);
		else
			Result = SendQueryPacket(Addr, "", QueryNum, PacketNum, bFinalPacket);
	}
	else if( QueryType=="status" )
	{
		Result = SendQueryPacket(Addr, GetBasic(), QueryNum, PacketNum, 0);
		Result = SendQueryPacket(Addr, GetInfo(), QueryNum, PacketNum, 0);
		if( Level.Game.NumPlayers == 0 )
		{
			Result = SendQueryPacket(Addr, GetRules(), QueryNum, PacketNum, bFinalPacket);
		}
		else
		{
			Result = SendQueryPacket(Addr, GetRules(), QueryNum, PacketNum, 0);
			Result = SendPlayers(Addr, QueryNum, PacketNum, bFinalPacket);
		}
	}
	else if( QueryType=="echo" )
	{
		// Respond to an echo with the same string
		Result = SendQueryPacket(Addr, "\\echo_replay\\"$StrReplace(QueryValue, Chr(10), ""), QueryNum, PacketNum, bFinalPacket);
	}
	else if( QueryType=="secure" )
	{
		ValidationString = "\\validate\\"$Validate(QueryValue, GameName);
		Result = SendQueryPacket(Addr, ValidationString, QueryNum, PacketNum, bFinalPacket);
	}
	else if( QueryType=="level_property" )
	{
		Result = SendQueryPacket(Addr, GetLevelProperty(QueryValue), QueryNum, PacketNum, bFinalPacket);
	}
	else if( QueryType=="game_property" )
	{
			Result = SendQueryPacket(Addr, GetGameProperty(QueryValue), QueryNum, PacketNum, bFinalPacket);
	}
	else if( QueryType=="player_property" )
	{
		Result = SendQueryPacket(Addr, GetPlayerProperty(QueryValue), QueryNum, PacketNum, bFinalPacket);
	}
  //utpg: \teams\ info support -- begin
  else if( QueryType=="teams" )
  {
    if( Level.Game.bTeamGame && bTeamInfo )
    {
      Result = SendTeams(Addr, QueryNum, PacketNum, bFinalPacket);
    }
    else
    {     
      Result = SendQueryPacket(Addr, "", QueryNum, PacketNum, bFinalPacket);
    }
  }
  //utpg: \teams\ info support -- end
	return QueryRest;
}

function bool SendAPacket(IpAddr Addr, int QueryNum, out int PacketNum, int bFinalPacket)
{
	local bool Result;

	ReplyData = ReplyData$"\\queryid\\"$QueryNum$"."$++PacketNum;
	if (bFinalPacket == 1) {
		ReplyData = ReplyData $ "\\final\\";
	}
	Result = SendText(Addr, ReplyData);
	ReplyData = "";
	
	return Result;

}

// SendQueryPacket is a wrapper for SendText that allows for packet numbering.
function bool SendQueryPacket(IpAddr Addr, coerce string SendString, int QueryNum, out int PacketNum, int bFinalPacket)
{
	local bool Result;
	
	//Log("Send Query: "  $ QueryNum $ "." $ PacketNum $ ":" $ bFinalPacket);
	result = true;
	if (len(ReplyData) + len(SendString) > 1000)
		result = SendAPacket(Addr, QueryNum, PacketNum, 0);
	
	ReplyData = ReplyData $ SendString;
	
	if (bFinalPacket == 1)
		result = SendAPacket(Addr, QueryNum, PacketNum, bFinalPacket);
		
	return Result;
}

// Return a string of basic information.
function string GetBasic() {
	local string ResultSet;

	// The name of this game.
	ResultSet = "\\gamename\\"$GameName;

	// The version of this game.
	ResultSet = ResultSet$"\\gamever\\"$Level.EngineVersion;

	// The most recent network compatible version.
	if( MinNetVer >= Int(Level.MinNetVersion) && 
		MinNetVer <= Int(Level.EngineVersion) )
		ResultSet = ResultSet$"\\minnetver\\"$string(MinNetVer);
	else
		ResultSet = ResultSet$"\\minnetver\\"$Level.MinNetVersion;

	// The regional location of this game.
	ResultSet = ResultSet$"\\location\\"$Level.Game.GameReplicationInfo.Region;
	
	return ResultSet;
}

// Return a string of important system information.
function string GetInfo() {
	local string ResultSet;

	// The server name, i.e.: Bob's Server
	ResultSet = "\\hostname\\"$StrReplace(Level.Game.GameReplicationInfo.ServerName, "\\", "");

	// The short server name
	//ResultSet = ResultSet$"\\shortname\\"$Level.Game.GameReplicationInfo.ShortName;

	// The server port.
	ResultSet = ResultSet$"\\hostport\\"$Level.Game.GetServerPort();

	// (optional) The server IP
	// if (ServerIP != "")
	//	ResultSet = ResultSet$"\\hostip\\"$ServerIP;

	// The map/level title
	ResultSet = ResultSet$"\\maptitle\\"$StrReplace(Level.Title, "\\", "");
	
	// Map name
	ResultSet = ResultSet$"\\mapname\\"$Left(string(Level), InStr(string(Level), "."));

	// The mod or game type
	ResultSet = ResultSet$"\\gametype\\"$GetItemName(string(Level.Game.Class));

	// The number of players
	ResultSet = ResultSet$"\\numplayers\\"$Level.Game.NumPlayers;

	// The maximum number of players
	ResultSet = ResultSet$"\\maxplayers\\"$Level.Game.MaxPlayers;

	// The game mode: openplaying
	ResultSet = ResultSet$"\\gamemode\\openplaying";

	// The version of this game.
	ResultSet = ResultSet$"\\gamever\\"$Level.EngineVersion;

	// The most recent network compatible version.
	if( MinNetVer >= Int(Level.MinNetVersion) && 
		MinNetVer <= Int(Level.EngineVersion) )
		ResultSet = ResultSet$"\\minnetver\\"$string(MinNetVer);
	else
		ResultSet = ResultSet$"\\minnetver\\"$Level.MinNetVersion;

	ResultSet = ResultSet$Level.Game.GetInfo();

	return ResultSet;
}

// Return a string of miscellaneous information.
// Game specific information, user defined data, custom parameters for the command line.
function string GetRules()
{
	local string ResultSet;

	ResultSet = Level.Game.GetRules();

	// Admin's Name
	if( Level.Game.GameReplicationInfo.AdminName != "" )
		ResultSet = ResultSet$"\\AdminName\\"$StrReplace(Level.Game.GameReplicationInfo.AdminName, "\\", "");
	
	// Admin's Email
	if( Level.Game.GameReplicationInfo.AdminEmail != "" )
		ResultSet = ResultSet$"\\AdminEMail\\"$Level.Game.GameReplicationInfo.AdminEmail;

  //utpg: mutators are only added on the first query (bug in GameInfo.uc)
  if(Level.Game.EnabledMutators != "" && (InStr(ResultSet,"mutators") == -1))
    ResultSet = ResultSet $ "\\mutators\\"$Level.Game.EnabledMutators;
	return ResultSet;
}

// Return a string of information on a player.
function string GetPlayer( PlayerPawn P, int PlayerNum )
{
	local string ResultSet;
	local string SkinName, FaceName;

	// Name
	ResultSet = "\\player_"$PlayerNum$"\\"$StrReplace(P.PlayerReplicationInfo.PlayerName, "\\", "");

	// Frags
	ResultSet = ResultSet$"\\frags_"$PlayerNum$"\\"$int(P.PlayerReplicationInfo.Score);

	// Ping
	ResultSet = ResultSet$"\\ping_"$PlayerNum$"\\"$P.ConsoleCommand("GETPING");

	// Team
	ResultSet = ResultSet$"\\team_"$PlayerNum$"\\"$P.PlayerReplicationInfo.Team;

	// Class
	ResultSet = ResultSet$"\\mesh_"$PlayerNum$"\\"$P.Menuname;

	// Skin
	if(P.Skin == None)
	{
		P.static.GetMultiSkin(P, SkinName, FaceName);
		ResultSet = ResultSet$"\\skin_"$PlayerNum$"\\"$SkinName;
		ResultSet = ResultSet$"\\face_"$PlayerNum$"\\"$FaceName;
	}
	else
	{
		ResultSet = ResultSet$"\\skin_"$PlayerNum$"\\"$string(P.Skin);
		ResultSet = ResultSet$"\\face_"$PlayerNum$"\\None";
	}
	if( P.PlayerReplicationInfo.bIsABot )
		ResultSet = ResultSet$"\\ngsecret_"$PlayerNum$"\\bot";
	else
	if( P.ReceivedSecretChecksum )
		ResultSet = ResultSet$"\\ngsecret_"$PlayerNum$"\\true";
	else
		ResultSet = ResultSet$"\\ngsecret_"$PlayerNum$"\\false";
	return ResultSet;
}

// Send data for each player
function bool SendPlayers(IpAddr Addr, int QueryNum, out int PacketNum, int bFinalPacket)
{
	local Pawn P;
	local int i;
	local bool Result, SendResult;
	
	Result = false;

  for ( P = Level.PawnList; P != none; P = P.nextPawn)
  {
		if (P.IsA('PlayerPawn') && !P.PlayerReplicationInfo.bIsSpectator)
		{
			if( i==Level.Game.NumPlayers-1 && bFinalPacket==1)
				SendResult = SendQueryPacket(Addr, GetPlayer(PlayerPawn(P), i), QueryNum, PacketNum, 1);
			else
				SendResult = SendQueryPacket(Addr, GetPlayer(PlayerPawn(P), i), QueryNum, PacketNum, 0);
			Result = SendResult || Result;
			i++;
		}
	}

	return Result;
}

// Get an arbitrary property from the level object.
function string GetLevelProperty( string Prop )
{
	local string ResultSet;
	
	ResultSet = "\\"$Prop$"\\"$Level.GetPropertyText(Prop);
	
	return ResultSet;
}

// Get an arbitrary property from the game object.
function string GetGameProperty( string Prop )
{
	local string ResultSet;

	ResultSet = "\\"$Prop$"\\"$Level.Game.GetPropertyText(Prop);
	
	return ResultSet;
}

// Get an arbitrary property from the players.
function string GetPlayerProperty( string Prop )
{
	local string ResultSet;
	local int i;
	local PlayerPawn P;

	foreach AllActors(class'PlayerPawn', P) {
		i++;
		ResultSet = ResultSet$"\\"$Prop$"_"$i$"\\"$P.GetPropertyText(Prop);
	}
	
	return ResultSet;
}

//utpg: team addition -- begin
function string GetTeam( TeamInfo T, int TeamNum )
{
  local string ResultSet;
  // Name
  ResultSet = "\\team_"$TeamNum$"\\"$T.TeamName;
  //score
  ResultSet = ResultSet$"\\score_"$TeamNum$"\\"$T.Score;
  //size
  ResultSet = ResultSet$"\\size_"$TeamNum$"\\"$T.Size;
  return ResultSet;
}

function bool SendTeams(IpAddr Addr, int QueryNum, out int PacketNum, int bFinalPacket)
{
  local int i;
  local bool Result, SendResult;
     
  Result = false;

  for (i = 0; i < 4; i++)
  {
    if( i==3 && bFinalPacket==1)
      SendResult = SendQueryPacket(Addr, GetTeam(TeamGamePlus(Level.Game).Teams[i], i), QueryNum, PacketNum, 1);
    else
      SendResult = SendQueryPacket(Addr, GetTeam(TeamGamePlus(Level.Game).Teams[i], i), QueryNum, PacketNum, 0);
    Result = SendResult || Result;
  }
  return Result;
}
//utpg: team addition -- end

defaultproperties
{
      QueryName="MasterUplink"
      CurrentQueryNum=0
      GameName="ut"
      ReplyData=""
      MinNetVer=0
      OldQueryPortNumber=0
      bRestartServerOnPortSwap=False
      bTeamInfo=False
      RemoteRole=ROLE_None
}
