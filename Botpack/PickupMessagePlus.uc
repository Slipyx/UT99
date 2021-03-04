//
// OptionalObject is an Inventory
//
class PickupMessagePlus expands LocalMessagePlus;


static function float GetOffset(int Switch, float YL, float ClipY )
{
	return ClipY - YL - (64.0/768)*ClipY;
}

static function string GetString(
	optional int Switch,
	optional PlayerReplicationInfo RelatedPRI_1, 
	optional PlayerReplicationInfo RelatedPRI_2,
	optional Object OptionalObject
	)
{
	if (OptionalObject != None)
		return Class<Inventory>(OptionalObject).Default.PickupMessage;
}

defaultproperties
{
      FontSize=1
      bIsSpecial=True
      bIsUnique=True
      bFadeMessage=True
      YPos=64.000000
      bCenter=True
}
