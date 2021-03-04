//=============================================================================
// GreenBloodSpray.
//=============================================================================
class GreenBloodSpray extends BloodSpray;

simulated function SpawnCloud()
{
	spawn(class'UT_GreenBloodPuff');
}

defaultproperties
{
      Texture=Texture'UnrealShare.Skins.BloodSGrn'
}
