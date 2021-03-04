//=============================================================================
// UT_WallHit.
//=============================================================================
class UT_WallHit extends BulletImpact;

var int MaxChips, MaxSparks;
var float ChipOdds;
var rotator RealRotation;

replication
{
	// Things the server should send to the client.
	unreliable if( Role==ROLE_Authority )
		RealRotation;
}

simulated function SpawnSound()
{
	local float decision;

	decision = FRand();
	if ( decision < 0.25 ) 
		PlaySound(sound'ricochet',, 1.5,,1200, 0.5+FRand());		
	else if ( decision < 0.5 )
		PlaySound(sound'Impact1',, 2.5,,1000);
	else if ( decision < 0.75 )
		PlaySound(sound'Impact2',, 2.5,,1000);
}

simulated function SpawnEffects()
{
	local Actor A;
	local int j;
	local int NumSparks;

	SpawnSound();

	NumSparks = rand(MaxSparks);
	if ( !Level.bDropDetail )
		for ( j=0; j<MaxChips; j++ )
			if ( FRand() < ChipOdds ) 
			{
				NumSparks--;
				A = spawn(class'Chip');
				if ( A != None )
					A.RemoteRole = ROLE_None;
			}

	if ( !Level.bHighDetailMode )
		return;

	Spawn(class'Pock');
	if ( Level.bDropDetail )
		return;

	A = Spawn(class'UT_SpriteSmokePuff');
	A.RemoteRole = ROLE_None;
	if ( !Region.Zone.bWaterZone && (NumSparks > 0) ) 
		for (j=0; j<NumSparks; j++) 
			spawn(class'UT_Spark',,,Location + 8 * Vector(Rotation));
}

Auto State StartUp
{
	simulated function Tick(float DeltaTime)
	{
		if ( Instigator != None )
			MakeNoise(0.3);
		if ( Role == ROLE_Authority )
			RealRotation = Rotation;
		else
			SetRotation(RealRotation);
		
		if ( Level.NetMode != NM_DedicatedServer )
			SpawnEffects();
		Disable('Tick');
	}
}

defaultproperties
{
      MaxChips=2
      MaxSparks=3
      ChipOdds=0.200000
      RealRotation=(Pitch=0,Yaw=0,Roll=0)
      bNetOptional=True
      RemoteRole=ROLE_SimulatedProxy
}
