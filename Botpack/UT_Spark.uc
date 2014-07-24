//=============================================================================
// ut_spark.
//=============================================================================
class UT_Spark extends Effects;

#exec TEXTURE IMPORT NAME=Sparky FILE=MODELS\spark.pcx GROUP=Effects


function PostBeginPlay()
{
	Velocity = (Vector(Rotation) + VRand()) * 200 * FRand();
}

auto state Explode
{
	simulated function ZoneChange( ZoneInfo NewZone )
	{
		if ( NewZone.bWaterZone )
			Destroy();
	}

	simulated function Landed( vector HitNormal )
	{
		Destroy();
	}

	simulated function HitWall( vector HitNormal, actor Wall )
	{
		Destroy();
	}
}

defaultproperties
{
     Physics=PHYS_Falling
     RemoteRole=ROLE_None
     LifeSpan=1.000000
     DrawType=DT_Sprite
     Style=STY_Translucent
     Texture=Texture'Botpack.Effects.Sparky'
     DrawScale=0.100000
     bUnlit=True
     bCollideWorld=True
     bBounce=True
     NetPriority=2.000000
}
