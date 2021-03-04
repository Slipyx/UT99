//=============================================================================
// BloodBurst.
//=============================================================================
class BloodBurst extends Blood2;

simulated function PostBeginPlay()
{
	Super.PostBeginPlay();
	PlayAnim  ( 'Burst', 0.2 );
	SetRotation( RotRand() );
}

defaultproperties
{
      bOwnerNoSee=True
      DrawScale=0.400000
      AmbientGlow=80
}
