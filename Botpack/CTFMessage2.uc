class CTFMessage2 expands LocalMessagePlus;

//
// CTF Messages
//
// Switch 0: You have the flag message.
//
// Switch 1: Enemy has the flag message.

var localized string YouHaveFlagString;
var localized string EnemyHasFlagString;
var color RedColor, YellowColor;

static function color GetColor(
	optional int Switch,
	optional PlayerReplicationInfo RelatedPRI_1, 
	optional PlayerReplicationInfo RelatedPRI_2
	)
{
	if (Switch == 0)
		return Default.YellowColor;
	else
		return Default.RedColor;
}

static function float GetOffset(int Switch, float YL, float ClipY )
{
	if (Switch == 0)
		return ClipY - YL*2 - 0.0833*ClipY;
	else
		return ClipY - YL*3 - 0.0833*ClipY;
}

static function string GetString(
	optional int Switch,
	optional PlayerReplicationInfo RelatedPRI_1, 
	optional PlayerReplicationInfo RelatedPRI_2,
	optional Object OptionalObject
	)
{
	local TeamInfo ScorerTeam, FlagTeam;

	switch (Switch)
	{
		// You have the enemy flag.
		case 0:
			return Default.YouHaveFlagString;
			break;

		// The enemy has your flag!
		case 1:
			return Default.EnemyHasFlagString;
			break;
	}
	return "";
}

defaultproperties
{
     YouHaveFlagString="You have the flag, return to base!"
     EnemyHasFlagString="The enemy has your flag, recover it!"
     RedColor=(R=255)
     YellowColor=(R=255,G=255)
     FontSize=1
     bIsSpecial=True
     bIsConsoleMessage=False
     bFadeMessage=True
     Lifetime=1
     DrawColor=(R=0,G=128)
     YPos=196.000000
     bCenter=True
}
