//=============================================================================
// NaliPlayer.
//=============================================================================
class NaliPlayer extends UnrealIPlayer;

#exec MESH IMPORT MESH=Nali2 ANIVFILE=MODELS\naliX_a.3D DATAFILE=..\unrealshare\MODELS\nali_d.3D X=0 Y=0 Z=0 ZEROTEX=1
#exec MESH ORIGIN MESH=Nali2 X=00 Y=-130 Z=30 YAW=64 ROLL=-64

#exec MESH SEQUENCE MESH=nali2 SEQ=All      STARTFRAME=0   NUMFRAMES=447
#exec MESH SEQUENCE MESH=nali2 SEQ=Backup   STARTFRAME=0   NUMFRAMES=10  RATE=15
#exec MESH SEQUENCE MESH=nali2 SEQ=Bowing   STARTFRAME=10  NUMFRAMES=20  RATE=15 Group=Ducking
#exec MESH SEQUENCE MESH=nali2 SEQ=Breath   STARTFRAME=30  NUMFRAMES=8   RATE=6  Group=Waiting
#exec MESH SEQUENCE MESH=nali2 SEQ=Cough    STARTFRAME=38  NUMFRAMES=25  RATE=15 Group=Waiting
#exec MESH SEQUENCE MESH=nali2 SEQ=Landed   STARTFRAME=68  NUMFRAMES=1			 Group=Landing
#exec MESH SEQUENCE MESH=nali2 SEQ=Cringe   STARTFRAME=63  NUMFRAMES=15  RATE=15 Group=Ducking
#exec MESH SEQUENCE MESH=nali2 SEQ=Dead     STARTFRAME=78  NUMFRAMES=38  RATE=15
#exec MESH SEQUENCE MESH=nali2 SEQ=DeathEnd STARTFRAME=115 NUMFRAMES=1
#exec MESH SEQUENCE MESH=nali2 SEQ=Dead2    STARTFRAME=116 NUMFRAMES=16  RATE=15
#exec MESH SEQUENCE MESH=nali2 SEQ=DeathEnd2 STARTFRAME=131 NUMFRAMES=1
#exec MESH SEQUENCE MESH=nali2 SEQ=Dead3    STARTFRAME=132 NUMFRAMES=13  RATE=15
#exec MESH SEQUENCE MESH=nali2 SEQ=Dead4    STARTFRAME=145 NUMFRAMES=21  RATE=15
#exec MESH SEQUENCE MESH=nali2 SEQ=Wave     STARTFRAME=166 NUMFRAMES=23  RATE=15 Group=Gesture
#exec MESH SEQUENCE MESH=nali2 SEQ=GetDown  STARTFRAME=189 NUMFRAMES=5   RATE=15
#exec MESH SEQUENCE MESH=nali2 SEQ=GetUp    STARTFRAME=194 NUMFRAMES=8   RATE=15
#exec MESH SEQUENCE MESH=nali2 SEQ=levitate STARTFRAME=202 NUMFRAMES=6  RATE=6
#exec MESH SEQUENCE MESH=nali2 SEQ=Victory1 STARTFRAME=208 NUMFRAMES=8   RATE=6  Group=Gesture
#exec MESH SEQUENCE MESH=nali2 SEQ=spell    STARTFRAME=216 NUMFRAMES=28  RATE=15
#exec MESH SEQUENCE MESH=nali2 SEQ=Sweat    STARTFRAME=244 NUMFRAMES=18  RATE=15 Group=Waiting
#exec MESH SEQUENCE MESH=nali2 SEQ=walk     STARTFRAME=262 NUMFRAMES=20  RATE=15
#exec MESH SEQUENCE MESH=nali2 SEQ=turn     STARTFRAME=262 NUMFRAMES=5   RATE=15
#exec MESH SEQUENCE MESH=nali2 SEQ=GutHit   STARTFRAME=282 NUMFRAMES=1			 Group=TakeHit
#exec MESH SEQUENCE MESH=nali2 SEQ=AimDown  STARTFRAME=283 NUMFRAMES=1			 Group=Waiting
#exec MESH SEQUENCE MESH=nali2 SEQ=AimUp    STARTFRAME=284 NUMFRAMES=1			 Group=Waiting
#exec MESH SEQUENCE MESH=nali2 SEQ=Bow2     STARTFRAME=285 NUMFRAMES=28  RATE=15
#exec MESH SEQUENCE MESH=nali2 SEQ=HeadHit  STARTFRAME=313 NUMFRAMES=1			 Group=TakeHit
#exec MESH SEQUENCE MESH=nali2 SEQ=LeftHit  STARTFRAME=314 NUMFRAMES=1			 Group=TakeHit
#exec MESH SEQUENCE MESH=nali2 SEQ=RightHit STARTFRAME=315 NUMFRAMES=1			 Group=TakeHit
#exec MESH SEQUENCE MESH=nali2 SEQ=Run      STARTFRAME=316 NUMFRAMES=10  RATE=15
#exec MESH SEQUENCE MESH=nali2 SEQ=RunFire  STARTFRAME=326 NUMFRAMES=10  RATE=15
#exec MESH SEQUENCE MESH=nali2 SEQ=StilFire STARTFRAME=336 NUMFRAMES=1			 Group=Waiting
#exec MESH SEQUENCE MESH=nali2 SEQ=WalkFire STARTFRAME=337 NUMFRAMES=20  RATE=15
#exec MESH SEQUENCE MESH=nali2 SEQ=WalkTool STARTFRAME=357 NUMFRAMES=20  RATE=15
#exec MESH SEQUENCE MESH=nali2 SEQ=Drowning STARTFRAME=377 NUMFRAMES=20  RATE=15
#exec MESH SEQUENCE MESH=nali2 SEQ=Duckwalk STARTFRAME=397 NUMFRAMES=20  RATE=15
#exec MESH SEQUENCE MESH=nali2 SEQ=Swim STARTFRAME=417 NUMFRAMES=15  RATE=15
#exec MESH SEQUENCE MESH=nali2 SEQ=Tread STARTFRAME=432 NUMFRAMES=15  RATE=15

#exec MESH SEQUENCE MESH=nali2 SEQ=fighter STARTFRAME=0   NUMFRAMES=1

#exec TEXTURE IMPORT NAME=JNali1 FILE=..\unrealshare\MODELS\nali.PCX GROUP=Skins 
#exec MESHMAP SCALE MESHMAP=nali2 X=0.069 Y=0.069 Z=0.138
#exec MESHMAP SETTEXTURE MESHMAP=nali2 NUM=0 TEXTURE=Jnali1

#exec MESH NOTIFY MESH=Nali2 SEQ=Dead	TIME=0.46 FUNCTION=LandThump
#exec MESH NOTIFY MESH=Nali2 SEQ=Dead2	TIME=0.64 FUNCTION=LandThump
#exec MESH NOTIFY MESH=Nali2 SEQ=Dead3	TIME=0.84 FUNCTION=LandThump
#exec MESH NOTIFY MESH=Nali2 SEQ=Dead4	TIME=0.51 FUNCTION=LandThump
#exec MESH NOTIFY MESH=Nali2 SEQ=Backup TIME=0.25 FUNCTION=PlayFootStep
#exec MESH NOTIFY MESH=Nali2 SEQ=Backup TIME=0.75 FUNCTION=PlayFootStep
#exec MESH NOTIFY MESH=Nali2 SEQ=Walk   TIME=0.25 FUNCTION=PlayFootStep
#exec MESH NOTIFY MESH=Nali2 SEQ=Walk   TIME=0.75 FUNCTION=PlayFootStep
#exec MESH NOTIFY MESH=Nali2 SEQ=WalkFire TIME=0.25 FUNCTION=PlayFootStep
#exec MESH NOTIFY MESH=Nali2 SEQ=WalkFire TIME=0.75 FUNCTION=PlayFootStep
#exec MESH NOTIFY MESH=Nali2 SEQ=WalkTool TIME=0.25 FUNCTION=PlayFootStep
#exec MESH NOTIFY MESH=Nali2 SEQ=WalkTool TIME=0.75 FUNCTION=PlayFootStep
#exec MESH NOTIFY MESH=Nali2 SEQ=Run	TIME=0.25 FUNCTION=PlayFootStep
#exec MESH NOTIFY MESH=Nali2 SEQ=Run	TIME=0.75 FUNCTION=PlayFootStep
#exec MESH NOTIFY MESH=Nali2 SEQ=RunFire TIME=0.25 FUNCTION=PlayFootStep
#exec MESH NOTIFY MESH=Nali2 SEQ=RunFire TIME=0.75 FUNCTION=PlayFootStep

#exec AUDIO IMPORT FILE="..\unrealshare\Sounds\Nali\injur1a.WAV" NAME="injur1n" GROUP="Nali"
#exec AUDIO IMPORT FILE="..\unrealshare\Sounds\Nali\injur2a.WAV" NAME="injur2n" GROUP="Nali"
#exec AUDIO IMPORT FILE="..\unrealshare\Sounds\Nali\contct1a.WAV" NAME="contct1n" GROUP="Nali"
#exec AUDIO IMPORT FILE="..\unrealshare\Sounds\Nali\contct3a.WAV" NAME="contct3n" GROUP="Nali"
#exec AUDIO IMPORT FILE="..\unrealshare\Sounds\Nali\fear1a.WAV" NAME="fear1n" GROUP="Nali"
#exec AUDIO IMPORT FILE="..\unrealshare\Sounds\Nali\breath2na.WAV" NAME="breath1n" GROUP="Nali"
#exec AUDIO IMPORT FILE="..\unrealshare\Sounds\Nali\death1na.WAV" NAME="death1n" GROUP="Nali"
#exec AUDIO IMPORT FILE="..\unrealshare\Sounds\Nali\death2a.WAV" NAME="death2n" GROUP="Nali"
#exec AUDIO IMPORT FILE="..\unrealshare\Sounds\Nali\bowing1a.WAV" NAME="bowing1n" GROUP="Nali"
#exec AUDIO IMPORT FILE="..\unrealshare\Sounds\Nali\cringe2a.WAV" NAME="cringe2n" GROUP="Nali"
#exec AUDIO IMPORT FILE="..\unrealshare\Sounds\Nali\backup2a.WAV" NAME="backup2n" GROUP="Nali"
#exec AUDIO IMPORT FILE="..\unrealshare\Sounds\Nali\cough1na.WAV" NAME="cough1n" GROUP="Nali"
#exec AUDIO IMPORT FILE="..\unrealshare\Sounds\Nali\sweat1na.WAV" NAME="sweat1n" GROUP="Nali"
#exec AUDIO IMPORT FILE="..\unrealshare\Sounds\Nali\levitF1.WAV" NAME="pray1n" GROUP="Nali"
#exec AUDIO IMPORT FILE="..\Unrealshare\Sounds\Cow\walknc.WAV" NAME="walkC" GROUP="Cow"
#exec AUDIO IMPORT FILE="..\unrealshare\Sounds\Generic\teleprt27.WAV" NAME="Teleport1" GROUP="Generic"
		
function PlayTurning()
{
	BaseEyeHeight = Default.BaseEyeHeight;
	PlayAnim('Turn', 0.3, 0.3);
}

function TweenToWalking(float tweentime)
{
	BaseEyeHeight = Default.BaseEyeHeight;
	if (Weapon == None)
		TweenAnim('Walk', tweentime);
	else if ( Weapon.bPointing || (CarriedDecoration != None) ) 
		TweenAnim('WalkFire', tweentime);
	else
		TweenAnim('Walk', tweentime);
}

function TweenToRunning(float tweentime)
{
	BaseEyeHeight = Default.BaseEyeHeight;
	if (bIsWalking)
		TweenToWalking(0.1);
	else if (Weapon == None)
		PlayAnim('Run', 1, tweentime);
	else if ( Weapon.bPointing ) 
		PlayAnim('RunFire', 1, tweentime);
	else
		PlayAnim('Run', 1, tweentime);
}

function PlayWalking()
{
	BaseEyeHeight = Default.BaseEyeHeight;
	if (Weapon == None)
		LoopAnim('Walk');
	else if ( Weapon.bPointing || (CarriedDecoration != None) ) 
		LoopAnim('WalkFire');
	else
		LoopAnim('Walk');
}

function PlayRunning()
{
	BaseEyeHeight = Default.BaseEyeHeight;
	if (Weapon == None)
		LoopAnim('Run');
	else if ( Weapon.bPointing ) 
		LoopAnim('RunFire');
	else
		LoopAnim('Run');
}

function PlayRising()
{
	BaseEyeHeight = 0.4 * Default.BaseEyeHeight;
	TweenAnim('DuckWalk', 0.7);
}

function PlayFeignDeath()
{
	local float decision;

	BaseEyeHeight = 0;
	PlayAnim('Levitate', 0.3, 1.0);
}

function PlayDying(name DamageType, vector HitLoc)
{
	local vector X,Y,Z, HitVec, HitVec2D;
	local float dotp;

	BaseEyeHeight = Default.BaseEyeHeight;
	PlayDyingSound();
			
	if ( FRand() < 0.15 )
	{
		PlayAnim('Dead',0.7,0.1);
		return;
	}

	// check for big hit
	if ( (Velocity.Z > 250) && (FRand() < 0.7) )
	{
		PlayAnim('Dead4', 0.7, 0.1);
		return;
	}

	// check for head hit
	if ( (DamageType == 'Decapitated') || (HitLoc.Z - Location.Z > 0.6 * CollisionHeight) )
	{
		DamageType = 'Decapitated';
		PlayAnim('Dead3', 0.7, 0.1);
		return;
	}

	GetAxes(Rotation,X,Y,Z);
	HitVec = Normal(HitLoc - Location);
	dotp = HitVec dot Y;
	if (dotp > 0.0)
		PlayAnim('Dead', 0.7, 0.1);
	else
		PlayAnim('Dead2', 0.7, 0.1);
}

//FIXME - add death first frames as alternate takehit anims!!!

function PlayGutHit(float tweentime)
{
	if ( AnimSequence == 'GutHit' )
	{
		if (FRand() < 0.5)
			TweenAnim('LeftHit', tweentime);
		else
			TweenAnim('RightHit', tweentime);
	}
	else
		TweenAnim('GutHit', tweentime);
}

function PlayHeadHit(float tweentime)
{
	if ( AnimSequence == 'HeadHit' )
		TweenAnim('GutHit', tweentime);
	else
		TweenAnim('HeadHit', tweentime);
}

function PlayLeftHit(float tweentime)
{
	if ( AnimSequence == 'LeftHit' )
		TweenAnim('GutHit', tweentime);
	else
		TweenAnim('LeftHit', tweentime);
}

function PlayRightHit(float tweentime)
{
	if ( AnimSequence == 'RightHit' )
		TweenAnim('GutHit', tweentime);
	else
		TweenAnim('RightHit', tweentime);
}
	
function PlayLanded(float impactVel)
	{	
		impactVel = impactVel/JumpZ;
		impactVel = 0.1 * impactVel * impactVel;
		BaseEyeHeight = Default.BaseEyeHeight;

		if ( Role == ROLE_Authority )
		{
			if ( impactVel > 0.17 )
				PlaySound(LandGrunt, SLOT_Talk, FMin(5, 5 * impactVel),false,1200,FRand()*0.4+0.8);
			if ( !FootRegion.Zone.bWaterZone && (impactVel > 0.01) )
				PlaySound(Land, SLOT_Interact, FClamp(4.5 * impactVel,0.5,6), false, 1000, 1.0);
		}

		if ( (GetAnimGroup(AnimSequence) == 'Dodge') && IsAnimating() )
			return;
		if ( (impactVel > 0.06) || (GetAnimGroup(AnimSequence) == 'Jumping') )
			TweenAnim('Landed', 0.12);
		else if ( !IsAnimating() )
		{
			if ( GetAnimGroup(AnimSequence) == 'TakeHit' )
				AnimEnd();
			else
				TweenAnim('Landed', 0.12);
		}
	}
	
function PlayInAir()
{
	BaseEyeHeight =  Default.BaseEyeHeight;
	TweenAnim('RunFire', 0.4);
}

function PlayDuck()
{
	BaseEyeHeight = 0;
	TweenAnim('DuckWalk', 0.25);
}

function PlayCrawling()
{
	BaseEyeHeight = 0;
	LoopAnim('DuckWalk');
}

function TweenToWaiting(float tweentime)
{
	if( IsInState('PlayerSwimming') || Physics==PHYS_Swimming )
	{
		BaseEyeHeight = 0.7 * Default.BaseEyeHeight;
		TweenAnim('Tread', tweentime);
	}
	else
	{
		BaseEyeHeight = Default.BaseEyeHeight;
		TweenAnim('StilFire', tweentime);
	}
}
	
function PlayWaiting()
{
	local name newAnim;

	if( IsInState('PlayerSwimming') || (Physics==PHYS_Swimming) )
	{
		BaseEyeHeight = 0.7 * Default.BaseEyeHeight;
		LoopAnim('Tread');
	}
	else
	{	
		BaseEyeHeight = Default.BaseEyeHeight;
		if ( (Weapon != None) && Weapon.bPointing )
			TweenAnim('StilFire', 0.3);
		else
		{
			if ( FRand() < 0.2 )
				newAnim = 'Cough';
			else if ( FRand() < 0.3 )
				newAnim = 'Sweat';
			else
				newAnim = 'Breath';
			
			if ( AnimSequence == newAnim )
				LoopAnim(newAnim, 0.3 + 0.7 * FRand());
			else
				PlayAnim(newAnim, 0.3 + 0.7 * FRand(), 0.25);
		}
	}
}	

function PlayFiring()
{
	// switch animation sequence mid-stream if needed
	if (AnimSequence == 'Run')
		AnimSequence = 'RunFire';
	else if (AnimSequence == 'Walk')
		AnimSequence = 'WalkFire';
	else if ( (GetAnimGroup(AnimSequence) != 'Attack')
			&& (GetAnimGroup(AnimSequence) != 'MovingAttack') 
			&& (GetAnimGroup(AnimSequence) != 'Dodge')
			&& (AnimSequence != 'Swim') )
		TweenAnim('StilFire', 0.02);
}

function PlayWeaponSwitch(Weapon NewWeapon)
{
}

function PlaySwimming()
{
	BaseEyeHeight = 0.7 * Default.BaseEyeHeight;
	LoopAnim('Swim');
}

function TweenToSwimming(float tweentime)
{
	BaseEyeHeight = 0.7 * Default.BaseEyeHeight;
	TweenAnim('Swim',tweentime);
}

function SwimAnimUpdate(bool bNotForward)
{
	if ( !bAnimTransition && (GetAnimGroup(AnimSequence) != 'Gesture') && (AnimSequence != 'Swim') )
		TweenToSwimming(0.1);
}

function NormallyVisible()
{
	bHidden = false;
	Style = STY_Normal;
	ScaleGlow = 1.0;
}

state FeigningDeath
{
ignores SeePlayer, HearNoise, Bump, Fire, AltFire;
	
	event PlayerTick( float DeltaTime )
	{
		Super.PlayerTick(DeltaTime);

		if ( (Role == ROLE_Authority) && !IsAnimating() && !bHidden )
		{
			Style = STY_Translucent;
			ScaleGlow -= DeltaTime;
			if ( ScaleGlow < 0.3 )
				bHidden = true;
		}
	}

	function PlayTakeHit(float tweentime, vector HitLoc, int Damage)
	{
		NormallyVisible();
		Global.PlayTakeHit(tweentime, HitLoc, Damage);
	}
	
	function PlayDying(name DamageType, vector HitLocation)
	{
		NormallyVisible();
		Global.PlayDying(DamageType, HitLocation);
	}

	function Landed(vector HitNormal)
	{
		NormallyVisible();
		Super.Landed(HitNormal);
	}

	function EndState()
	{
		Super.EndState();
		if ( (Role == ROLE_Authority) && !bHidden && (Style == STY_Translucent) )
			NormallyVisible();
	}
}

state PlayerSwimming
{
ignores SeePlayer, HearNoise, Bump;

	function BeginState()
	{
		Super.BeginState();
		NormallyVisible();
	}
}

state PlayerWalking
{
ignores SeePlayer, HearNoise, Bump;

	exec function Fire( optional float F )
	{
		NormallyVisible();
		Super.Fire(F);
	}

	function TakeDamage( int Damage, Pawn instigatedBy, Vector hitlocation, 
							Vector momentum, name damageType)
	{
		NormallyVisible();
		Super.TakeDamage(Damage, instigatedBy, hitlocation, momentum, damageType);
	}

	function ProcessMove(float DeltaTime, vector NewAccel, eDodgeDir DodgeMove, rotator DeltaRot)	
	{
		Super.ProcessMove(DeltaTime, NewAccel, DodgeMove, DeltaRot);
		if ( (Role == ROLE_Authority) && (Style == STY_Translucent) )
		{
			ScaleGlow = VSize(Velocity)/GroundSpeed;
			bHidden = (ScaleGlow < 0.35);
		}
	}
	
	function EndState()
	{
		NormallyVisible();
		Super.EndState();
	}
}

defaultproperties
{
      drown=Sound'UnrealShare.Male.MDrown1'
      breathagain=Sound'UnrealShare.Male.MGasp1'
      Footstep1=Sound'UnrealShare.Cow.walkC'
      Footstep2=Sound'UnrealShare.Cow.walkC'
      Footstep3=Sound'UnrealShare.Cow.walkC'
      HitSound3=Sound'UnrealShare.Nali.injur1n'
      HitSound4=Sound'UnrealShare.Nali.injur2n'
      Die2=Sound'UnrealShare.Nali.death2n'
      Die3=Sound'UnrealShare.Nali.death2n'
      Die4=Sound'UnrealShare.Nali.death2n'
      GaspSound=Sound'UnrealShare.Male.MGasp2'
      UWHit1=Sound'UnrealShare.Male.MUWHit1'
      UWHit2=Sound'UnrealShare.Male.MUWHit2'
      LandGrunt=Sound'UnrealShare.Male.lland01'
      CarcassType=Class'UnrealShare.NaliCarcass'
      JumpSound=Sound'UnrealShare.Male.MJump1'
      bSinglePlayer=False
      GroundSpeed=320.000000
      JumpZ=360.000000
      BaseEyeHeight=32.000000
      EyeHeight=32.000000
      Health=80
      HitSound1=Sound'UnrealShare.Nali.fear1n'
      HitSound2=Sound'UnrealShare.Nali.cringe2n'
      Die=Sound'UnrealShare.Nali.death1n'
      MenuName="Nali"
      Skin=Texture'UnrealShare.Skins.JNali1'
      Mesh=LodMesh'UnrealI.Nali2'
      CollisionRadius=24.000000
      CollisionHeight=48.000000
      Buoyancy=98.000000
}
