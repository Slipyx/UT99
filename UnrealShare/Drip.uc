//=============================================================================
// Drip.
//=============================================================================
class Drip extends DripGenerator;

#exec AUDIO IMPORT FILE="Sounds\General\Drip.WAV" NAME="Drip1" GROUP="General"

var() sound DripSound;

auto state FallingState
{

	function Landed( vector HitNormal )
	{
		HitWall(HitNormal, None);	
	}

	simulated function HitWall (vector HitNormal, actor Wall) 
	{
		PlaySound(DripSound);
		Destroy();
	}
	
	singular function touch(actor Other)
	{
		PlaySound(DripSound);	
		Destroy();
	}

Begin:
	PlayAnim('Dripping',0.3);
}

defaultproperties
{
      DripSound=Sound'UnrealShare.General.Drip1'
      DripPause=0.000000
      DripVariance=0.000000
      DripTexture=None
      bHidden=False
      Physics=PHYS_Falling
      LifeSpan=5.000000
      Skin=Texture'UnrealShare.JMisc1'
      CollisionRadius=0.000000
      CollisionHeight=0.000000
      bCollideWorld=True
}
