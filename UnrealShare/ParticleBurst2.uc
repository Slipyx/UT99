//=============================================================================
// ParticleBurst2.
//=============================================================================
class ParticleBurst2 extends ParticleBurst;

#exec TEXTURE IMPORT NAME=T_PStar FILE=MODELS\star.pcx GROUP=Effects


auto state Explode
{
	simulated function Tick( float DeltaTime )
	{
		ScaleGlow = (Lifespan/Default.Lifespan);	
	}

	simulated function BeginState()
	{
		PlayAnim('Explo',0.15);
	}
	
	simulated function AnimEnd()
	{
		Destroy();
	}		
}

defaultproperties
{
     bHighDetail=True
     Physics=PHYS_None
     LifeSpan=0.300000
     Texture=Texture'UnrealShare.Effects.T_PStar'
     DrawScale=0.350000
     RotationRate=(Pitch=0,Yaw=0,Roll=0)
}
