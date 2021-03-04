class WaterZone extends ZoneInfo;

#exec AUDIO IMPORT FILE="Sounds\Generic\dsplash.WAV" NAME="DSplash" GROUP="Generic"
#exec AUDIO IMPORT FILE="Sounds\Generic\wtrexit1.WAV" NAME="WtrExit1" GROUP="Generic"

//#exec AUDIO IMPORT FILE="Sounds\Generic\uWater1a.WAV" NAME="InWater" GROUP="Generic"
//	AmbientSound=InWater

defaultproperties
{
      ZoneName="Underwater"
      EntrySound=Sound'UnrealShare.Generic.DSplash'
      ExitSound=Sound'UnrealShare.Generic.WtrExit1'
      EntryActor=Class'UnrealShare.WaterImpact'
      ExitActor=Class'UnrealShare.WaterImpact'
      bWaterZone=True
      ViewFlash=(X=-0.078000,Y=-0.078000,Z=-0.078000)
      ViewFog=(X=0.128900,Y=0.195300,Z=0.175780)
}
