//=============================================================================
// InternetInfo: Parent class for Internet connection classes
//=============================================================================
class InternetInfo extends Info
	native
	transient;

function string GetBeaconAddress( int i );
function string GetBeaconText( int i );


// [Higor] v469, these should only be called with the following as address:
// IPv4Addr:port
// [IPv6Addr]:port
// hostname:port
// TODO: Handle port-less IPv6 without brackets
static final function string GetPort( string Address)
{
	local int i;
	
	//Handle IPv6 address
	i = InStr(Address,"[");
	if ( i == 0 )
	{
		i = InStr(Address,"]");
		if ( i > 0 )
			Address = Mid(Address,i+1);
	}

	//Extract port (if present)
	i = InStr(Address,":");
	if ( i < 0 )
		return "";
	return Mid(Address,i+1);
}


static final function string StripPort( string Address)
{
	local int i;
	
	//Handle IPv6 address (removes the brackets)
	i = InStr(Address,"[");
	if ( i == 0 )
	{
		i = InStr(Address,"]");
		if ( i > 0 )
			return Mid(Address,1,i-1);
	}

	//Remove the port (if present)
	i = InStr(Address,":");
	if ( i < 0 )
		return Address;
	return Left(Address,i);
}

defaultproperties
{
}
