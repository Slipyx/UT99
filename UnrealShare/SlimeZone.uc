class SlimeZone extends ZoneInfo;

#exec AUDIO IMPORT FILE="Sounds\Generic\GoopE1.WAV" NAME="LavaEx" GROUP="Generic"
#exec AUDIO IMPORT FILE="Sounds\Generic\GoopJ1.WAV" NAME="LavaEn" GROUP="Generic"
//#exec AUDIO IMPORT FILE="Sounds\Generic\uGoop1.WAV" NAME="InGoop" GROUP="Generic"
//    AmbientSound=InGoop

defaultproperties
{
      DamagePerSec=40
      DamageType="Corroded"
      EntrySound=Sound'UnrealShare.Generic.LavaEn'
      ExitSound=Sound'UnrealShare.Generic.LavaEx'
      EntryActor=Class'UnrealShare.GreenSmokePuff'
      ExitActor=Class'UnrealShare.GreenSmokePuff'
      bWaterZone=True
      bPainZone=True
      bDestructive=True
      ViewFlash=(X=-0.117200,Y=-0.117200,Z=-0.117200)
      ViewFog=(X=0.187500,Y=0.281250,Z=0.093750)
}
