//=============================================================================
// UdpBeacon: Base class of beacon sender and receiver.
//=============================================================================
class UdpBeacon extends UdpLink
	config
	transient;

var() globalconfig bool       DoBeacon;
var() globalconfig int        ServerBeaconPort;		// Listen port
var() globalconfig int        BeaconPort;			// Reply port
var() globalconfig float      BeaconTimeout;
var() globalconfig string     BeaconProduct;

var int	UdpServerQueryPort;
var int boundport;

function BeginPlay()
{
	local IpAddr Addr;

	boundport = BindPort(ServerBeaconPort, True);
	if ( boundport == 0 )
	{
		log( "UdpBeacon failed to bind a port." );
		return;
	}

	Addr.Addr = BroadcastAddr;
	Addr.Port = BeaconPort;
	BroadcastBeacon(Addr); // Initial notification.
}

function BroadcastBeacon(IpAddr Addr)
{
	local string Port;
	
	Port = GetPort( Level.GetAddressURL() );
	SendText( Addr, BeaconProduct @ Port @ Level.Game.GetBeaconText() );
	//Log( "UdpBeacon: sending reply to "$IpAddrToString(Addr) );
}

function BroadcastBeaconQuery(IpAddr Addr)
{
	SendText( Addr, BeaconProduct @ UdpServerQueryPort );
	//Log( "UdpBeacon: sending query reply to "$IpAddrToString(Addr) );
}

event ReceivedText( IpAddr Addr, string Text )
{
	if( Text == "REPORT" )
		BroadcastBeacon(Addr);

	if( Text == "REPORTQUERY" )
		BroadcastBeaconQuery(Addr);
}

function Destroyed()
{
	Super.Destroyed();
	//Log("ServerBeacon Destroyed");
}

defaultproperties
{
      DoBeacon=True
      ServerBeaconPort=8777
      BeaconPort=9777
      BeaconTimeout=5.000000
      BeaconProduct="ut"
      UdpServerQueryPort=0
      boundport=0
      RemoteRole=ROLE_None
}
