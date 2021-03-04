class KillerMessagePlus expands LocalMessagePlus;

var localized string YouKilled;
var localized string ScoreString;
var localized string YouKilledTrailer;


static function float GetOffset(int Switch, float YL, float ClipY )
{
	return (Default.YPos/768.0) * ClipY - YL;
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
	if (RelatedPRI_2 == None)
		return "";

	if (RelatedPRI_2.PlayerName != "")
		return Default.YouKilled@RelatedPRI_2.PlayerName@Default.YouKilledTrailer;
}

defaultproperties
{
      YouKilled="You killed"
      ScoreString="Your Score:"
      YouKilledTrailer=""
      FontSize=1
      bIsSpecial=True
      bIsUnique=True
      bFadeMessage=True
      DrawColor=(R=0,G=128)
      YPos=196.000000
      bCenter=True
}
