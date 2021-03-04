//=============================================================================
// HorseFly.
// Do not add directly.  Rather, add HorseFlySwarms to the world.
//=============================================================================
class HorseFly extends FlockPawn;

#exec MESH IMPORT MESH=Firefly ANIVFILE=MODELS\firefl_a.3D DATAFILE=MODELS\firefl_d.3D  LODSTYLE=2
#exec MESH LODPARAMS MESH=FireFly STRENGTH=0.6 
#exec MESH ORIGIN MESH=Firefly X=0 Y=00 Z=0 YAW=64

#exec MESH SEQUENCE MESH=Firefly SEQ=All    STARTFRAME=0   NUMFRAMES=5
#exec MESH SEQUENCE MESH=Firefly SEQ=Still  STARTFRAME=0   NUMFRAMES=1
#exec MESH SEQUENCE MESH=Firefly SEQ=Flying STARTFRAME=0   NUMFRAMES=4
#exec MESH SEQUENCE MESH=Firefly SEQ=FastFly  STARTFRAME=4   NUMFRAMES=2

#exec TEXTURE IMPORT NAME=JFirefly1 FILE=MODELS\firefly.PCX GROUP=Skins
#exec MESHMAP SCALE MESHMAP=Firefly X=0.006 Y=0.006 Z=0.012
#exec MESHMAP SETTEXTURE MESHMAP=firefly NUM=1 TEXTURE=Jfirefly1

#exec AUDIO IMPORT FILE="Sounds\Flies\buzz3.WAV" NAME="flybuzz" GROUP="Flies"

//-----------------------------------------------------------------------------
// Horsefly variables.

//==============
// Encroachment
function bool EncroachingOn( actor Other )
{
	if ( (Other.Brush != None) || (Brush(Other) != None) )
		return true;
		
	return false;
}

function EncroachedBy( actor Other )
{
}

function PlayTakeHit(float tweentime, vector HitLoc, int damage)
{
}

function Died(pawn Killer, name damageType, vector HitLocation)
{
	GotoState('Dying');
}

auto state meander
{
	ignores seeplayer, enemynotvisible, footzonechange;

	singular function ZoneChange( ZoneInfo NewZone )
	{
		if (NewZone.bWaterZone || NewZone.bPainZone)
		{
			SetLocation(OldLocation);
			Velocity = vect(0,0,0);
			Acceleration = vect(0,0,0);
			MoveTimer = -1.0;
		}
	}

	 		
begin:
	LoopAnim('Flying');
	SetPhysics(PHYS_Flying);
wander:
	if ( Owner == None )
		Destroy();
	if (!LineOfSightTo(Owner))
		SetLocation(Owner.Location);

	MoveTo(Owner.Location + HorseflySwarm(Owner).swarmradius * (VRand() +  vect(0,0,0.3)));
	if ( Owner == None )
		Destroy();
	if ( HorseflySwarm(Owner).bOnlyIfEnemy && (Pawn(Owner).Enemy == None) && (FRand() < 0.1) )
	{
		HorseflySwarm(Owner).swarmsize++;
		Destroy();
	}
	else
		Goto('Wander');
}

State Dying
{
	ignores seeplayer, enemynotvisible, footzonechange;

	function Landed(vector HitNormal)
	{
		SetPhysics(PHYS_None);
	}	

Begin:
	if ( Owner != None )
	{
		HorseflySwarm(Owner).totalflies--;
		if ( HorseflySwarm(Owner).totalflies <= 0 )
			Owner.Destroy();
	}	
	SetPhysics(PHYS_Falling);
	RemoteRole = ROLE_DumbProxy;
	Sleep(15);
	Destroy();
}			

defaultproperties
{
      AirSpeed=200.000000
      Land=None
      AmbientSound=Sound'UnrealShare.flies.flybuzz'
      DrawType=DT_Mesh
      Mesh=LodMesh'UnrealShare.Firefly'
      SoundRadius=7
      SoundVolume=64
      CollisionRadius=0.000000
      CollisionHeight=0.000000
      bCollideActors=False
      bBlockActors=False
      bBlockPlayers=False
      bProjTarget=False
}
