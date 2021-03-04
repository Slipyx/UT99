//
// Designed for ChallengeHUD
//
class LocalMessagePlus expands LocalMessage;

var color GreenColor, LightGreenColor, CyanColor;

var int FontSize;						// Relative font size.
										// 0: Huge
										// 1: Big
										// 2: Small ...

static function int GetFontSize(int Switch)
{
	return Default.FontSize;
}

static function color GetColor(
	optional int Switch,
	optional PlayerReplicationInfo RelatedPRI_1, 
	optional PlayerReplicationInfo RelatedPRI_2
	)
{
	return Default.DrawColor;
}

static function float GetOffset(int Switch, float YL, float ClipY )
{
	return Default.YPos/768 * ClipY;
}

defaultproperties
{
      GreenColor=(R=0,G=255,B=0,A=0)
      LightGreenColor=(R=0,G=128,B=0,A=0)
      CyanColor=(R=0,G=128,B=255,A=0)
      FontSize=0
      bIsConsoleMessage=True
}
