//=============================================================================
// WayBeacon.
//=============================================================================
class WayBeacon extends Keypoint;

//temporary beacon for serverfind navigation

function PostBeginPlay()
{
	local class<actor> NewClass;

	Super.PostBeginPlay();
	NewClass = class<actor>( DynamicLoadObject( "Unreali.Lamp4", class'Class' ) );
	if( NewClass!=None )
		Mesh = NewClass.Default.Mesh;
}

function touch(actor other)
{
	if (other == owner)
	{
		if ( Owner.IsA('PlayerPawn') )
			PlayerPawn(owner).ShowPath();
		Destroy();
	}
}

defaultproperties
{
      bStatic=False
      bHidden=False
      bOnlyOwnerSee=True
      RemoteRole=ROLE_None
      LifeSpan=6.000000
      DrawType=DT_Mesh
      DrawScale=0.500000
      AmbientGlow=40
      bCollideActors=True
      LightType=LT_Steady
      LightBrightness=125
      LightSaturation=125
}
