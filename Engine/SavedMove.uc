//=============================================================================
// SavedMove is used during network play to buffer recent client moves,
// for use when the server modifies the clients actual position, etc.
// This is a built-in Unreal class and it shouldn't be modified.
//=============================================================================
class SavedMove extends Info;

// also stores info in Acceleration attribute
var SavedMove NextMove;		// Next move in linked list.
var float TimeStamp;		// Time of this move.
var float Delta;			// Distance moved.
var byte MergeCount;		// Additional moves merged into this.
var bool bRun;
var bool bDuck;
var bool bPressedJump;
var bool bFire;
var bool bAltFire;
var bool bForceFire;
var bool bForceAltFire;
var EDodgeDir DodgeMove;	// Dodge info.

// Player attributes after applying this move
var vector SavedLocation;   
var vector SavedVelocity;
var rotator SavedViewRotation;

final function Clear()
{
	TimeStamp = 0;
	Delta = 0;
	DodgeMove = DODGE_None;
	Acceleration = vect(0,0,0);
	MergeCount = 0;
	bFire = false;
	bRun = false;
	bDuck = false;
	bAltFire = false;
	bPressedJump = false;
	bForceFire = false;
	bForceAltFire = false;
}

final function bool CanMergeAccel( vector OtherAccel)
{
	local vector RealAccel;

	// Physics processing limits magnitude of acceleration to AccelRate.
	RealAccel = Acceleration;
	if ( VSize(RealAccel) > PlayerPawn(Owner).AccelRate )
		RealAccel = Normal(RealAccel) * PlayerPawn(Owner).AccelRate;
	if ( VSize(OtherAccel) > PlayerPawn(Owner).AccelRate )
		OtherAccel = Normal(OtherAccel) * PlayerPawn(Owner).AccelRate;

	if ( VSize(RealAccel-OtherAccel) > 1
		&& Normal(RealAccel) dot Normal(OtherAccel) < 0.95 )
	{
		return false;
	}
	return true;
}


final function bool CanBuffer( vector OldAcceleration)
{
	if ( bForceFire || bForceAltFire || bPressedJump
		|| (DodgeMove >= DODGE_Left && DodgeMove <= DODGE_Back)
		|| (MergeCount >= 31)
		|| !CanMergeAccel(OldAcceleration) )
		return false;

	return true;
}

final function bool CanSendRedundantly( vector NewAcceleration)
{
	if ( bPressedJump
	|| (DodgeMove >= DODGE_Left && DodgeMove <= DODGE_Back)
	|| !CanMergeAccel(NewAcceleration) )
		return true;
	
	return false;
}

final function byte CompressFlags()
{
	local int Compressed;
	
	Compressed += int(bRun) * 1;
	Compressed += int(bDuck) * 2;
	Compressed += int(bFire) * 4;
	Compressed += int(bAltFire) * 8;
	Compressed += int(bForceFire) * 16;
	Compressed += int(bForceAltFire) * 32;
	return byte(Compressed);
}

final function int CompressOld()
{
	local int Compressed;
	local vector BuildAccel;

	BuildAccel = 0.05 * Acceleration + vect(0.5, 0.5, 0.5);
	Compressed = (CompressAccel(BuildAccel.X) << 23)
				+ (CompressAccel(BuildAccel.Y) << 15)
				+ (CompressAccel(BuildAccel.Z) << 7);
	Compressed += 64 * int(bRun);
	Compressed += 32 * int(bDuck);
	Compressed += 16 * int(bPressedJump);
	Compressed += DodgeMove;
	
	return Compressed;
}

final function int CompressAccel(int C)
{
	if ( C >= 0 )
		C = Min(C, 127);
	else
		C = Min(abs(C), 127) + 128;
	return C;
}



function string ToString()
{
	return "[STAMP]"@TimeStamp@"[DELTA]"@Delta@"[DODGE]"@DodgeMove@"[LOC]"@SavedLocation@"[VEL]"@SavedVelocity@"("@VSize(SavedVelocity)@")"@"[ACCEL]"@Acceleration@"("@VSize(Acceleration)@")";
}

defaultproperties
{
      NextMove=None
      TimeStamp=0.000000
      Delta=0.000000
      MergeCount=0
      bRun=False
      bDuck=False
      bPressedJump=False
      bFire=False
      bAltFire=False
      bForceFire=False
      bForceAltFire=False
      DodgeMove=DODGE_None
      SavedLocation=(X=0.000000,Y=0.000000,Z=0.000000)
      SavedVelocity=(X=0.000000,Y=0.000000,Z=0.000000)
      SavedViewRotation=(Pitch=0,Yaw=0,Roll=0)
}
