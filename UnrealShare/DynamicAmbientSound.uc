//=============================================================================
// DynamicAmbientSound.
//=============================================================================
class DynamicAmbientSound extends Keypoint;

var() bool       bInitiallyOn;   	// Initial state
var() sound      Sounds[16];      	// What to play (must be at least one sound)
var() float      playProbability;	// The chance of the sound effect playing
var() float      minReCheckTime;   // Try to restart the sound after (min amount)
var() float      maxReCheckTime;   // Try to restart the sound after (max amount)
var() bool       bDontRepeat;		// Never play two of the same sound in a row
var   bool       soundPlaying;   	// Is it currently playing it?
var   float      rePlayTime;
var   int        numSounds;		// The number of sounds available
var   int        lastSound;		// Which sound was played most recently?

function BeginPlay () 
{
	
	local int i;
	
	// Calculate how many sounds the user specified
	numSounds=6;
	for (i=0; i<16; i++) 
	{
		if (Sounds[i] == None) 
		{
			numSounds=i;
			break;
		}
	}

	lastSound=-1;
	if (bInitiallyOn) 
	{
		// Which sound should be played?
		i = Rand(numSounds);
		PlaySound (Sounds[i]);
		lastSound = i;
	}

	rePlayTime = (maxReCheckTime-minReCheckTime)*FRand() + minReCheckTime;
	SetTimer(rePlayTime, False);
}


function Timer () 
{

	local int i;
	
	if (FRand() <= playProbability) 
	{
	
		// Play the sound
		// Which sound should be played?
		i = Rand(numSounds);
		while( i == lastSound && bDontRepeat && numSounds > 1 )
			i = Rand(numSounds);
		
		PlaySound (Sounds[i]);
		lastSound = i;
	}

	rePlayTime = (maxReCheckTime-minReCheckTime)*FRand() + minReCheckTime;
	SetTimer(rePlayTime, False);
}

defaultproperties
{
      bInitiallyOn=False
      Sounds(0)=None
      Sounds(1)=None
      Sounds(2)=None
      Sounds(3)=None
      Sounds(4)=None
      Sounds(5)=None
      Sounds(6)=None
      Sounds(7)=None
      Sounds(8)=None
      Sounds(9)=None
      Sounds(10)=None
      Sounds(11)=None
      Sounds(12)=None
      Sounds(13)=None
      Sounds(14)=None
      Sounds(15)=None
      playProbability=0.600000
      minReCheckTime=5.000000
      maxReCheckTime=10.000000
      bDontRepeat=False
      soundPlaying=False
      rePlayTime=0.000000
      numSounds=0
      lastSound=0
      bStatic=False
}
