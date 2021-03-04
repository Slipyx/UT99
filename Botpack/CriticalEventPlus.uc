class CriticalEventPlus expands LocalMessagePlus;

static function float GetOffset(int Switch, float YL, float ClipY )
{
	return (Default.YPos/768.0) * ClipY;
}

defaultproperties
{
      FontSize=1
      bIsSpecial=True
      bIsUnique=True
      bFadeMessage=True
      bBeep=True
      DrawColor=(R=0,G=128)
      YPos=196.000000
      bCenter=True
}
