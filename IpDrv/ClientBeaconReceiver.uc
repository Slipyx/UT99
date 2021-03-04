//=============================================================================
// ClientBeaconReceiver: Receives LAN beacons from servers.
//=============================================================================
class ClientBeaconReceiver extends UdpBeacon
	transient;

var struct BeaconInfo
{
	var IpAddr      Addr;
	var float       Time;
	var string      Text;
} Beacons[32];

function string GetBeaconAddress( int i )
{
	return IpAddrToString(Beacons[i].Addr);
}

function string GetBeaconText(int i)
{
	return Beacons[i].Text;
}

function BeginPlay()
{
	local IpAddr Addr;

	if( BindPort( BeaconPort, true ) > 0 )
	{
		SetTimer( 1.0, true );
		log( "ClientBeaconReceiver initialized." );
	}
	else
	{
		log( "ClientBeaconReceiver failed: Beacon port in use." );
	}

	Addr.Addr = BroadcastAddr;
	Addr.Port = ServerBeaconPort;

	BroadcastBeacon(Addr);
}

function Destroyed()
{
	log( "ClientBeaconReceiver finished." );
}

function Timer()
{
	local int i, j;
	for( i=0; i<arraycount(Beacons); i++ )
		if
		(	Beacons[i].Addr.Addr!=0
		&&	Level.TimeSeconds-Beacons[i].Time<BeaconTimeout )
			Beacons[j++] = Beacons[i];
	for( j=j; j<arraycount(Beacons); j++ )
		Beacons[j].Addr.Addr=0;
}

function BroadcastBeacon(IpAddr Addr)
{
	SendText( Addr, "REPORT" );	
}

event ReceivedText( IpAddr Addr, string Text )
{
	local int i, n;
	
	n = len(BeaconProduct);
	if( left(Text,n+1) ~= (BeaconProduct$" ") )
	{
		Text = mid(Text,n+1);
		Addr.Port = int(Text);
		for( i=0; i<arraycount(Beacons); i++ )
			if( Beacons[i].Addr==Addr )
				break;
		if( i==arraycount(Beacons) )
			for( i=0; i<arraycount(Beacons); i++ )
				if( Beacons[i].Addr.Addr==0 )
					break;
		if( i==arraycount(Beacons) )
			return;
		Beacons[i].Addr      = Addr;
		Beacons[i].Time      = Level.TimeSeconds;
		Beacons[i].Text      = mid(Text,InStr(Text," ")+1);
	}
}

defaultproperties
{
      Beacons(0)=(Addr=(Addr=0,Port=0),Time=0.000000,Text="")
      Beacons(1)=(Addr=(Addr=0,Port=0),Time=0.000000,Text="")
      Beacons(2)=(Addr=(Addr=0,Port=0),Time=0.000000,Text="")
      Beacons(3)=(Addr=(Addr=0,Port=0),Time=0.000000,Text="")
      Beacons(4)=(Addr=(Addr=0,Port=0),Time=0.000000,Text="")
      Beacons(5)=(Addr=(Addr=0,Port=0),Time=0.000000,Text="")
      Beacons(6)=(Addr=(Addr=0,Port=0),Time=0.000000,Text="")
      Beacons(7)=(Addr=(Addr=0,Port=0),Time=0.000000,Text="")
      Beacons(8)=(Addr=(Addr=0,Port=0),Time=0.000000,Text="")
      Beacons(9)=(Addr=(Addr=0,Port=0),Time=0.000000,Text="")
      Beacons(10)=(Addr=(Addr=0,Port=0),Time=0.000000,Text="")
      Beacons(11)=(Addr=(Addr=0,Port=0),Time=0.000000,Text="")
      Beacons(12)=(Addr=(Addr=0,Port=0),Time=0.000000,Text="")
      Beacons(13)=(Addr=(Addr=0,Port=0),Time=0.000000,Text="")
      Beacons(14)=(Addr=(Addr=0,Port=0),Time=0.000000,Text="")
      Beacons(15)=(Addr=(Addr=0,Port=0),Time=0.000000,Text="")
      Beacons(16)=(Addr=(Addr=0,Port=0),Time=0.000000,Text="")
      Beacons(17)=(Addr=(Addr=0,Port=0),Time=0.000000,Text="")
      Beacons(18)=(Addr=(Addr=0,Port=0),Time=0.000000,Text="")
      Beacons(19)=(Addr=(Addr=0,Port=0),Time=0.000000,Text="")
      Beacons(20)=(Addr=(Addr=0,Port=0),Time=0.000000,Text="")
      Beacons(21)=(Addr=(Addr=0,Port=0),Time=0.000000,Text="")
      Beacons(22)=(Addr=(Addr=0,Port=0),Time=0.000000,Text="")
      Beacons(23)=(Addr=(Addr=0,Port=0),Time=0.000000,Text="")
      Beacons(24)=(Addr=(Addr=0,Port=0),Time=0.000000,Text="")
      Beacons(25)=(Addr=(Addr=0,Port=0),Time=0.000000,Text="")
      Beacons(26)=(Addr=(Addr=0,Port=0),Time=0.000000,Text="")
      Beacons(27)=(Addr=(Addr=0,Port=0),Time=0.000000,Text="")
      Beacons(28)=(Addr=(Addr=0,Port=0),Time=0.000000,Text="")
      Beacons(29)=(Addr=(Addr=0,Port=0),Time=0.000000,Text="")
      Beacons(30)=(Addr=(Addr=0,Port=0),Time=0.000000,Text="")
      Beacons(31)=(Addr=(Addr=0,Port=0),Time=0.000000,Text="")
}
