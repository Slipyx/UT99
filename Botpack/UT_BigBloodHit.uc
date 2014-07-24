//=============================================================================
// BigBloodHit.
//=============================================================================
class UT_BigBloodHit extends UT_BloodHit;

simulated function SpawnCloud()
{
	local Actor A;

	if ( Level.bDropDetail || !Level.bHighDetailMode )
		return;
	if ( bGreenBlood )
		A= spawn(class'UT_GreenBloodPuff');
	else
		A = spawn(class'UT_BigBloodPuff');
	A.RemoteRole = ROLE_None;
}

defaultproperties
{
}
