//=============================================================================
// Sparks.
//=============================================================================
class Sparks extends Effects;

// Spawns off a number of SparkBit elements, which all die out
// within a random amount of time.  MZM
								// Reasonable defaults
var() float    MinBetweenTime;		// 0.4
var() float    MaxBetweenTime;		// 1.0
var() int      MinSpawnedAtOnce;	// 1
var() int      MaxSpawnedAtOnce;	// 3
var() float    MinSpawnSpeed;		// 200
var() float    MaxSpawnSpeed;		// 300
var() float    MinBurnTime;		// 0.4
var() float    MaxBurnTime;		// 1.0
var() float    MinBrightness;		// 0.7	(values can only go from 0.0 -> 1.0)
var() float    MaxBrightness;		// 1.0    "							   "
var() rotator  SpawnCenterDir;
var() int      AngularDeviation;	// approx. 0x2000 -> 8192

var   float    NextSparkTime;
var   int	  NumSpawnedNow;
var   int	  i;

auto state StartState {

	function MoreSparks () {

		local SparkBit TempSparkBit;
		local rotator SpawnDir;

		// Time to generate another SparkBit.
		TempSparkBit = Spawn (class 'SparkBit', , '', Location);

		SpawnDir = SpawnCenterDir;
		SpawnDir.Pitch += -AngularDeviation + Rand(AngularDeviation*2);
		SpawnDir.Yaw   += -AngularDeviation + Rand(AngularDeviation*2);
		TempSparkBit.Velocity = Vector(SpawnDir)*(MinSpawnSpeed + 
		                         FRand()*(MaxSpawnSpeed-MinSpawnSpeed));

		//TempSparkBit.Velocity = Normal(VRand())*(MinSpawnSpeed + 
		//                         FRand()*(MaxSpawnSpeed-MinSpawnSpeed));
		TempSparkBit.BurnTime = MinBurnTime + FRand()*(MaxBurnTime-MinBurnTime);

		// 0=dark  1=bright
		TempSparkBit.InitialBrightness = MinBrightness + 
									   FRand()*(MaxBrightness-MinBrightness);
	}

Begin:

	if (minBetweenTime >= maxBetweenTime) maxBetweenTime=minBetweenTime + 0.1;

Loop:

	//Log ("Making more sparks");
	NumSpawnedNow = Rand(MaxSpawnedAtOnce-MinSpawnedAtOnce+1)+MinSpawnedAtOnce;
	for (i=0; i<NumSpawnedNow; i++)
		MoreSparks();

	NextSparkTime = FRand()*(MaxBetweenTime-MinBetweenTime)+ MinBetweenTime;
	//Log ("Next spark(s) in " $ NextSparkTime);
	Sleep (NextSparkTime);
	goto 'Loop';
}

defaultproperties
{
      MinBetweenTime=0.400000
      MaxBetweenTime=1.000000
      MinSpawnedAtOnce=1
      MaxSpawnedAtOnce=3
      MinSpawnSpeed=200.000000
      MaxSpawnSpeed=300.000000
      MinBurnTime=0.400000
      MaxBurnTime=1.000000
      MinBrightness=0.700000
      MaxBrightness=1.000000
      SpawnCenterDir=(Pitch=0,Yaw=0,Roll=0)
      AngularDeviation=0
      NextSparkTime=0.000000
      NumSpawnedNow=0
      i=0
      bHidden=True
      bNetTemporary=False
      LifeSpan=1000.000000
      DrawType=DT_Mesh
      Mesh=LodMesh'UnrealShare.bolt1'
      LightBrightness=78
      LightHue=96
      LightSaturation=224
      LightRadius=4
}
