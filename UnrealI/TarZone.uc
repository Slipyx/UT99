class TarZone extends ZoneInfo;

#exec AUDIO IMPORT FILE="..\UnrealShare\Sounds\Generic\GoopE1.WAV" NAME="LavaEx" GROUP="Generic"
#exec AUDIO IMPORT FILE="..\UnrealShare\Sounds\Generic\GoopJ1.WAV" NAME="LavaEn" GROUP="Generic"
//#exec AUDIO IMPORT FILE="Sounds\Generic\uGoop1.WAV" NAME="InGoop" GROUP="Generic"
//	 AmbientSound=InGoop

// When an actor enters this zone.
event ActorEntered( actor Other )
{
	Super.ActorEntered(Other);
	if ( Other.IsA('Pawn') && Pawn(Other).bIsPlayer )
		Pawn(Other).WaterSpeed *= 0.1;
}

// When an actor leaves this zone.
event ActorLeaving( actor Other )
{
	Super.ActorLeaving(Other);
	if ( Other.IsA('Pawn') && Pawn(Other).bIsPlayer )
		Pawn(Other).WaterSpeed *= 10;
}

defaultproperties
{
      ZoneFluidFriction=4.000000
      ZoneTerminalVelocity=250.000000
      EntrySound=Sound'UnrealShare.Generic.LavaEn'
      ExitSound=Sound'UnrealShare.Generic.LavaEx'
      bWaterZone=True
      ViewFlash=(X=-0.390000,Y=-0.390000,Z=-0.390000)
      ViewFog=(X=0.312500,Y=0.312500,Z=0.234375)
}
