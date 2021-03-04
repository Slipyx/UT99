//=============================================================================
// StationaryPawn.
//=============================================================================
class StationaryPawn extends Pawn
	abstract;

function SetTeam(int TeamNum);

simulated function AddVelocity( vector NewVelocity )
{
	Velocity = vect(0,0,0);
}

function bool SameTeamAs(int TeamNum)
{
	return false;
}

defaultproperties
{
      bCanFly=True
      MaxDesiredSpeed=0.000000
      GroundSpeed=0.000000
      WaterSpeed=0.000000
      AccelRate=0.000000
      JumpZ=0.000000
      MaxStepHeight=0.000000
      Visibility=0
      SightRadius=-1000.000000
      HearingThreshold=-1000.000000
      FovAngle=0.000000
      Health=500
      AttitudeToPlayer=ATTITUDE_Ignore
      Intelligence=BRAINS_NONE
      bCanTeleport=False
      bStasis=False
      RemoteRole=ROLE_DumbProxy
      DrawType=DT_Mesh
      RotationRate=(Pitch=0,Yaw=0,Roll=0)
}
