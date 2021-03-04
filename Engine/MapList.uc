//=============================================================================
// MapList.
//
// contains a list of maps to cycle through
//
//=============================================================================
class MapList extends Info;

var(Maps) config string Maps[32];
var config int MapNum;

function string GetNextMap()
{
	local string CurrentMap;
	local int i;

	CurrentMap = GetURLMap();
	if ( CurrentMap != "" )
	{
		if ( Right(CurrentMap,4) ~= ".unr" )
			CurrentMap = CurrentMap;
		else
			CurrentMap = CurrentMap$".unr";

		for ( i=0; i<ArrayCount(Maps); i++ )
		{
			if ( CurrentMap ~= Maps[i] )
			{
				MapNum = i;
				break;
			}
		}
	}

	// search vs. w/ or w/out .unr extension

	MapNum++;
	if ( MapNum > ArrayCount(Maps) - 1 )
		MapNum = 0;
	if ( Maps[MapNum] == "" )
		MapNum = 0;

	SaveConfig();
	return Maps[MapNum];
}

defaultproperties
{
      Maps(0)=""
      Maps(1)=""
      Maps(2)=""
      Maps(3)=""
      Maps(4)=""
      Maps(5)=""
      Maps(6)=""
      Maps(7)=""
      Maps(8)=""
      Maps(9)=""
      Maps(10)=""
      Maps(11)=""
      Maps(12)=""
      Maps(13)=""
      Maps(14)=""
      Maps(15)=""
      Maps(16)=""
      Maps(17)=""
      Maps(18)=""
      Maps(19)=""
      Maps(20)=""
      Maps(21)=""
      Maps(22)=""
      Maps(23)=""
      Maps(24)=""
      Maps(25)=""
      Maps(26)=""
      Maps(27)=""
      Maps(28)=""
      Maps(29)=""
      Maps(30)=""
      Maps(31)=""
      MapNum=0
}
