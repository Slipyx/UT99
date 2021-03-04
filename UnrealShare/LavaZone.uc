class LavaZone extends ZoneInfo;

#exec AUDIO IMPORT FILE="Sounds\Generic\GoopE1.WAV" NAME="LavaEx" GROUP="Generic"
#exec AUDIO IMPORT FILE="Sounds\Generic\GoopJ1.WAV" NAME="LavaEn" GROUP="Generic"
//#exec AUDIO IMPORT FILE="Sounds\Generic\uLava1.WAV" NAME="InLava" GROUP="Generic"
//	AmbientSound=InLava

defaultproperties
{
      DamagePerSec=40
      DamageType="Burned"
      EntrySound=Sound'UnrealShare.Generic.LavaEn'
      ExitSound=Sound'UnrealShare.Generic.LavaEx'
      EntryActor=Class'UnrealShare.FlameExplosion'
      ExitActor=Class'UnrealShare.FlameExplosion'
      bWaterZone=True
      bPainZone=True
      bDestructive=True
      bNoInventory=True
      ViewFog=(X=0.585938,Y=0.195313,Z=0.078125)
}
