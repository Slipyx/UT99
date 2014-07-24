class NitrogenZone extends ZoneInfo;

//#exec AUDIO IMPORT FILE="Sounds\Generic\uLNitro1.WAV" NAME="InNitro" GROUP="Generic"
//	AmbientSound=InNitro

// When an actor enters this zone.
event ActorEntered( actor Other )
{
	Super.ActorEntered(Other);
	if ( Other.IsA('Pawn') && Pawn(Other).bIsPlayer )
	{
		Pawn(Other).UnderWaterTime = -1.0;
		Pawn(Other).WaterSpeed *= 2;
	}
}

// When an actor leaves this zone.
event ActorLeaving( actor Other )
{
	Super.ActorLeaving(Other);
	if ( Other.IsA('Pawn') && Pawn(Other).bIsPlayer )
	{
		Pawn(Other).UnderWaterTime = Pawn(Other).Default.UnderWaterTime;
		Pawn(Other).WaterSpeed *= 0.5;
	}
}

defaultproperties
{
     DamagePerSec=20
     DamageType=Frozen
     bWaterZone=True
     bPainZone=True
     ViewFog=(X=0.011719,Y=0.039063,Z=0.046875)
}
