class VictimMessage expands LocalMessagePlus;

var localized string YouWereKilledBy, KilledByTrailer;

static function float GetOffset(int Switch, float YL, float ClipY )
{
	return (Default.YPos/768.0) * ClipY + 2*YL;
}

static function string GetString(
	optional int Switch,
	optional PlayerReplicationInfo RelatedPRI_1, 
	optional PlayerReplicationInfo RelatedPRI_2,
	optional Object OptionalObject 
	)
{
	if (RelatedPRI_1 == None)
		return "";

	if (RelatedPRI_1.PlayerName != "")
		return Default.YouWereKilledBy@RelatedPRI_1.PlayerName$Default.KilledByTrailer;
}

defaultproperties
{
      YouWereKilledBy="You were killed by"
      KilledByTrailer="!"
      FontSize=1
      bIsSpecial=True
      bIsUnique=True
      bFadeMessage=True
      DrawColor=(G=0,B=0)
      YPos=196.000000
      bCenter=True
}
