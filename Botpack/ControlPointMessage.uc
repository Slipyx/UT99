//
// OptionalObject is a ControlPoint
//
class ControlPointMessage expands CriticalEventLowPlus;

var() localized String ControlPointStr, ControlledBy, ControlTrailer;

static function string GetString(
	optional int Switch,
	optional PlayerReplicationInfo RelatedPRI_1, 
	optional PlayerReplicationInfo RelatedPRI_2,
	optional Object OptionalObject
	)
{
	if (OptionalObject == None)
		return "";
	return Default.ControlPointStr@"["$ControlPoint(OptionalObject).PointName$"]"@Default.ControlledBy@class'TeamScoreBoard'.Default.TeamName[Switch]$Default.ControlTrailer;
}

defaultproperties
{
     ControlPointStr="Control Point"
     ControlledBy="now controlled by"
}
