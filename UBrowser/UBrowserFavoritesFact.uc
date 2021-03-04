class UBrowserFavoritesFact extends UBrowserServerListFactory;

var config int FavoriteCount;
var config string Favorites[100];

/* eg Favorites[0]=Host Name\10.0.0.1\7778\True */


function string ParseOption(string Input, int Pos)
{
	local int i;

	while(True)
	{
		if(Pos == 0)
		{
			i = InStr(Input, "\\");
			if(i != -1)
				Input = Left(Input, i);
			return Input;
		}

		i = InStr(Input, "\\");
		if(i == -1)
			return "";

		Input = Mid(Input, i+1);
		Pos--;
	}
}

function Query(optional bool bBySuperset, optional bool bInitial)
{
	local int i;
	local UBrowserServerList L;

	Super.Query(bBySuperset, bInitial);

	for(i=0;i<FavoriteCount;i++)
	{
		L = FoundServer(ParseOption(Favorites[i], 1), Int(ParseOption(Favorites[i], 2)), "", "Unreal", ParseOption(Favorites[i], 0));
		L.bKeepDescription = ParseOption(Favorites[i], 3) ~= (string(True));
	}

	QueryFinished(True);
}

function SaveFavorites()
{
	local UBrowserServerList I;

	FavoriteCount = 0;
	for(I = UBrowserServerList(PingedList.Next); i!=None; I = UBrowserServerList(I.Next))
	{
		if(FavoriteCount == 100)
			break;
		Favorites[FavoriteCount] = I.HostName$"\\"$I.IP$"\\"$string(I.QueryPort)$"\\"$string(I.bKeepDescription);

		FavoriteCount++;
	}

	for(I = UBrowserServerList(UnPingedList.Next); i!=None; I = UBrowserServerList(I.Next))
	{
		if(FavoriteCount == 100)
			break;
		Favorites[FavoriteCount] = I.HostName$"\\"$I.IP$"\\"$string(I.QueryPort)$"\\"$string(I.bKeepDescription);

		FavoriteCount++;
	}

	if(FavoriteCount < 100)
		Favorites[FavoriteCount] = "";

	SaveConfig();
}

defaultproperties
{
      FavoriteCount=0
      Favorites(0)=""
      Favorites(1)=""
      Favorites(2)=""
      Favorites(3)=""
      Favorites(4)=""
      Favorites(5)=""
      Favorites(6)=""
      Favorites(7)=""
      Favorites(8)=""
      Favorites(9)=""
      Favorites(10)=""
      Favorites(11)=""
      Favorites(12)=""
      Favorites(13)=""
      Favorites(14)=""
      Favorites(15)=""
      Favorites(16)=""
      Favorites(17)=""
      Favorites(18)=""
      Favorites(19)=""
      Favorites(20)=""
      Favorites(21)=""
      Favorites(22)=""
      Favorites(23)=""
      Favorites(24)=""
      Favorites(25)=""
      Favorites(26)=""
      Favorites(27)=""
      Favorites(28)=""
      Favorites(29)=""
      Favorites(30)=""
      Favorites(31)=""
      Favorites(32)=""
      Favorites(33)=""
      Favorites(34)=""
      Favorites(35)=""
      Favorites(36)=""
      Favorites(37)=""
      Favorites(38)=""
      Favorites(39)=""
      Favorites(40)=""
      Favorites(41)=""
      Favorites(42)=""
      Favorites(43)=""
      Favorites(44)=""
      Favorites(45)=""
      Favorites(46)=""
      Favorites(47)=""
      Favorites(48)=""
      Favorites(49)=""
      Favorites(50)=""
      Favorites(51)=""
      Favorites(52)=""
      Favorites(53)=""
      Favorites(54)=""
      Favorites(55)=""
      Favorites(56)=""
      Favorites(57)=""
      Favorites(58)=""
      Favorites(59)=""
      Favorites(60)=""
      Favorites(61)=""
      Favorites(62)=""
      Favorites(63)=""
      Favorites(64)=""
      Favorites(65)=""
      Favorites(66)=""
      Favorites(67)=""
      Favorites(68)=""
      Favorites(69)=""
      Favorites(70)=""
      Favorites(71)=""
      Favorites(72)=""
      Favorites(73)=""
      Favorites(74)=""
      Favorites(75)=""
      Favorites(76)=""
      Favorites(77)=""
      Favorites(78)=""
      Favorites(79)=""
      Favorites(80)=""
      Favorites(81)=""
      Favorites(82)=""
      Favorites(83)=""
      Favorites(84)=""
      Favorites(85)=""
      Favorites(86)=""
      Favorites(87)=""
      Favorites(88)=""
      Favorites(89)=""
      Favorites(90)=""
      Favorites(91)=""
      Favorites(92)=""
      Favorites(93)=""
      Favorites(94)=""
      Favorites(95)=""
      Favorites(96)=""
      Favorites(97)=""
      Favorites(98)=""
      Favorites(99)=""
}
