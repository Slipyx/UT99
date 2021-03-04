//=============================================================================
// FlakCannon.
//=============================================================================
class FlakCannon extends Weapon;

#exec MESH IMPORT MESH=flak ANIVFILE=MODELS\flak_a.3D DATAFILE=MODELS\flak_d.3D X=0 Y=0 Z=0
#exec MESH ORIGIN MESH=flak X=0 Y=0 Z=0 YAW=-64 ROLL=0 PITCH=0
#exec MESH SEQUENCE MESH=Flak SEQ=All     STARTFRAME=0   NUMFRAMES=105
#exec MESH SEQUENCE MESH=Flak SEQ=Select  STARTFRAME=0   NUMFRAMES=30 RATE=45 GROUP=Select
#exec MESH SEQUENCE MESH=Flak SEQ=Loading STARTFRAME=30  NUMFRAMES=15
#exec MESH SEQUENCE MESH=Flak SEQ=Still   STARTFRAME=45   NUMFRAMES=1
#exec MESH SEQUENCE MESH=Flak SEQ=Fire    STARTFRAME=46  NUMFRAMES=10
#exec MESH SEQUENCE MESH=Flak SEQ=AltFire STARTFRAME=56  NUMFRAMES=11 RATE=24
#exec MESH SEQUENCE MESH=Flak SEQ=Eject   STARTFRAME=67  NUMFRAMES=19
#exec MESH SEQUENCE MESH=Flak SEQ=Down2   STARTFRAME=86  NUMFRAMES=15
#exec MESH SEQUENCE MESH=Flak SEQ=Still2  STARTFRAME=101  NUMFRAMES=1
#exec MESH SEQUENCE MESH=Flak SEQ=Sway    STARTFRAME=102  NUMFRAMES=2
#exec MESH SEQUENCE MESH=Flak SEQ=Down    STARTFRAME=104  NUMFRAMES=6
#exec TEXTURE IMPORT NAME=Jflak1 FILE=MODELS\flak.PCX GROUP=Skins
#exec OBJ LOAD FILE=..\UnrealShare\Textures\fireeffect13.utx PACKAGE=UNREALI.Effect13
#exec MESHMAP SCALE MESHMAP=flak  X=0.005 Y=0.005 Z=0.01
#exec MESHMAP SETTEXTURE MESHMAP=flak NUM=1 TEXTURE=Jflak1
#exec MESHMAP SETTEXTURE MESHMAP=flak NUM=0 TEXTURE=Unreali.Effect13.FireEffect13

#exec MESH IMPORT MESH=FlakPick ANIVFILE=MODELS\flakpi_a.3D DATAFILE=MODELS\flakpi_d.3D X=0 Y=0 Z=0
#exec MESH ORIGIN MESH=FlakPick X=0 Y=0 Z=0 YAW=64
#exec MESH SEQUENCE MESH=Flakpick SEQ=All    STARTFRAME=0   NUMFRAMES=1
#exec MESH SEQUENCE MESH=Flakpick SEQ=Still  STARTFRAME=0   NUMFRAMES=1
#exec MESHMAP SCALE MESHMAP=Flakpick X=0.06 Y=0.06 Z=0.12
#exec MESHMAP SETTEXTURE MESHMAP=Flakpick NUM=1 TEXTURE=JFlak1

#exec MESH IMPORT MESH=Flak3rd ANIVFILE=MODELS\flak3_a.3D DATAFILE=MODELS\flak3_d.3D X=0 Y=0 Z=0
#exec MESH ORIGIN MESH=Flak3rd X=-28 Y=-350 Z=-50 YAW=-64 ROLL=9
#exec MESH SEQUENCE MESH=Flak3rd SEQ=All  STARTFRAME=0  NUMFRAMES=10
#exec MESH SEQUENCE MESH=Flak3rd SEQ=Still  STARTFRAME=0  NUMFRAMES=1
#exec MESH SEQUENCE MESH=Flak3rd SEQ=Fire  STARTFRAME=1  NUMFRAMES=9 RATE=40.0
#exec MESH SEQUENCE MESH=Flak3rd SEQ=AltFire  STARTFRAME=1  NUMFRAMES=9 RATE=40.0
#exec TEXTURE IMPORT NAME=JFlak1 FILE=MODELS\flak.PCX GROUP="Skins"
#exec OBJ LOAD FILE=..\UnrealShare\textures\FireEffect18.utx PACKAGE=UNREALSHARE.Effect18
#exec MESHMAP SCALE MESHMAP=Flak3rd X=0.045 Y=0.045 Z=0.09
#exec MESHMAP SETTEXTURE MESHMAP=Flak3rd NUM=1 TEXTURE=JFlak1
#exec MESHMAP SETTEXTURE MESHMAP=Flak3rd NUM=0 TEXTURE=UnrealShare.Effect18.FireEffect18

#exec AUDIO IMPORT FILE="..\UnrealShare\Sounds\flak\Explode1.WAV" NAME="Explode1" GROUP="flak"
#exec AUDIO IMPORT FILE="..\UnrealShare\Sounds\flak\hidraul2.WAV" NAME="Hidraul2" GROUP="flak"
#exec AUDIO IMPORT FILE="..\UnrealShare\Sounds\flak\load1.WAV" NAME="load1" GROUP="flak"
#exec AUDIO IMPORT FILE="..\UnrealShare\Sounds\flak\click.WAV" NAME="click" GROUP="flak"
#exec AUDIO IMPORT FILE="..\UnrealShare\Sounds\flak\shot1.WAV" NAME="shot1" GROUP="flak"
#exec AUDIO IMPORT FILE="..\UnrealShare\Sounds\flak\shot2.WAV" NAME="shot2" GROUP="flak"
#exec AUDIO IMPORT FILE="..\UnrealShare\Sounds\flak\barrelm1.WAV" NAME="barrelm1" GROUP="flak"
#exec AUDIO IMPORT FILE="..\UnrealShare\Sounds\flak\pdown.WAV" NAME="pdown" GROUP="flak"
#exec AUDIO IMPORT FILE="..\UnrealShare\Sounds\flak\expl2.WAV" NAME="expl2" GROUP="flak"

//-------------------------------------------------------
// AI related functions

function float RateSelf( out int bUseAltMode )
{
	local float EnemyDist, rating;
	local vector EnemyDir;

	if ( AmmoType.AmmoAmount <=0 )
		return -2;
	if ( Pawn(Owner).Enemy == None )
	{
		bUseAltMode = 0;
		return AIRating;
	}
	EnemyDir = Pawn(Owner).Enemy.Location - Owner.Location;
	EnemyDist = VSize(EnemyDir);
	rating = FClamp(AIRating - (EnemyDist - 450) * 0.001, 0.2, AIRating);
	if ( EnemyDist > 600 )
	{
		if ( EnemyDir.Z < -0.5 * EnemyDist )
		{
			bUseAltMode = 1;
			return (AIRating - 0.3);
		}
		bUseAltMode = 0;
	}
	else if ( (EnemyDist < 300) || (EnemyDir.Z > 30) )
		bUseAltMode = 0;
	else
		bUseAltMode = int( FRand() < 0.65 );
	return rating;
}

// return delta to combat style
function float SuggestAttackStyle()
{
	return 0.4;
}

function float SuggestDefenseStyle()
{
	return -0.3;
}

//-------------------------------------------------------
 
// Fire chunks
function Fire( float Value )
{
	local Vector Start, X,Y,Z;

	//bFireMem = false;
	//bAltFireMem = false;
	if (AmmoType.UseAmmo(1))
	{
		if ( FiringSpeed>0 )
			Pawn(Owner).PlayRecoil(FiringSpeed);	
		CheckVisibility();
		bPointing=True;
		Start = Owner.Location + CalcDrawOffset();
		if ( PlayerPawn(Owner) != None )
		{
			PlayerPawn(Owner).ClientInstantFlash( -0.4, vect(650, 450, 190));
			PlayerPawn(Owner).ShakeView(ShakeTime, ShakeMag, ShakeVert);
		}
		Owner.MakeNoise(2.0 * Pawn(Owner).SoundDampening);
		AdjustedAim = pawn(owner).AdjustAim(AltProjectileSpeed, Start, AimError, True, bWarnTarget);
		GetAxes(AdjustedAim,X,Y,Z);
		Spawn(class'WeaponLight',,'',Start+X*20,rot(0,0,0));		
		Start = Start + FireOffset.X * X + FireOffset.Y * Y + FireOffset.Z * Z;	
		Spawn( class 'MasterChunk',, '', Start, AdjustedAim);
		Spawn( class 'Chunk2',, '', Start - Z, AdjustedAim);
		Spawn( class 'Chunk3',, '', Start + 2 * Y + Z, AdjustedAim);
		Spawn( class 'Chunk4',, '', Start - Y, AdjustedAim);
		Spawn( class 'Chunk1',, '', Start + 2 * Y - Z, AdjustedAim);
		Spawn( class 'Chunk2',, '', Start, AdjustedAim);
		Spawn( class 'Chunk3',, '', Start + Y - Z, AdjustedAim);
		Spawn( class 'Chunk4',, '', Start + 2 * Y + Z, AdjustedAim);
		PlayAnim( 'Fire', 0.9, 0.05);
		Owner.PlaySound(FireSound, SLOT_None,Pawn(Owner).SoundDampening*4.0);	
		GoToState('NormalFire');
	}
}

function AltFire( float Value )
{
	local Vector Start, X,Y,Z;

	//bFireMem = false;
	//bAltFireMem = false;
	if (AmmoType.UseAmmo(1))
	{
		if ( FiringSpeed>0 )
			Pawn(Owner).PlayRecoil(FiringSpeed);	
		CheckVisibility();
		Owner.PlaySound(Misc1Sound, SLOT_None, 0.6*Pawn(Owner).SoundDampening);
		Owner.PlaySound(AltFireSound, SLOT_None,Pawn(Owner).SoundDampening*4.0);
		PlayAnim('AltFire', 1.3, 0.05);
		bPointing=True;
		Owner.MakeNoise(Pawn(Owner).SoundDampening);
		GetAxes(Pawn(owner).ViewRotation,X,Y,Z);
		Start = Owner.Location + CalcDrawOffset();
		Spawn(class'WeaponLight',,'',Start+X*20,rot(0,0,0));		
		Start = Start + FireOffset.X * X + FireOffset.Y * Y + FireOffset.Z * Z; 
		AdjustedAim = pawn(owner).AdjustToss(AltProjectileSpeed, Start, AimError, True, bAltWarnTarget);	//TIM - syntax fixme
		Spawn(class'FlakShell',,, Start,AdjustedAim);	
		if ( PlayerPawn(Owner) != None )
		{
			PlayerPawn(Owner).ClientInstantFlash( -0.4, vect(650, 450, 190));
			PlayerPawn(Owner).ShakeView(ShakeTime, ShakeMag, ShakeVert);
		}
		GoToState('AltFiring');
	}	
}

////////////////////////////////////////////////////////////
state AltFiring
{
Begin:
	FinishAnim();
	Owner.PlaySound(CockingSound, SLOT_None,0.5*Pawn(Owner).SoundDampening);	
	PlayAnim('Loading',0.65, 0.05);
	FinishAnim();
	Finish();
}

/////////////////////////////////////////////////////////////
state NormalFire
{
Begin:
	FinishAnim();
	PlayAnim('Eject',1.5, 0.05);
	Owner.PlaySound(Misc3Sound, SLOT_None,0.6*Pawn(Owner).SoundDampening);	
	FinishAnim();
	PlayAnim('Loading',1.4, 0.05);
	Owner.PlaySound(CockingSound, SLOT_None,0.5*Pawn(Owner).SoundDampening);		
	FinishAnim();
	Finish();	
}

///////////////////////////////////////////////////////////
function TweenDown()
{
	if ( GetAnimGroup(AnimSequence) == 'Select' )
		TweenAnim( AnimSequence, AnimFrame * 0.4 );
	else
	{
		if (AmmoType.AmmoAmount<=0)	PlayAnim('Down2',1.0, 0.05);
		else PlayAnim('Down',1.0, 0.05);
	}
}


function PlayIdleAnim()
{
//	if (VSize(Pawn(Owner).Velocity)>20 && AnimSequence=='Still') 
//		LoopAnim('Still',0.1);
//	else if (VSize(Pawn(Owner).Velocity)<20 && AnimSequence!='Still') 
		LoopAnim('Sway',0.01,0.3);
}

function PlayPostSelect()
{
	PlayAnim('Loading', 1.3, 0.05);
	Owner.PlaySound(Misc2Sound, SLOT_None,1.3*Pawn(Owner).SoundDampening);	
}

defaultproperties
{
      AmmoName=Class'UnrealI.FlakBox'
      PickupAmmoCount=10
      bWarnTarget=True
      bAltWarnTarget=True
      bSplashDamage=True
      FireOffset=(X=10.000000,Y=-12.000000,Z=-15.000000)
      ProjectileClass=Class'UnrealI.MasterChunk'
      AltProjectileClass=Class'UnrealI.FlakShell'
      shakemag=350.000000
      shaketime=0.150000
      shakevert=8.500000
      AIRating=0.800000
      FireSound=Sound'UnrealShare.flak.shot1'
      AltFireSound=Sound'UnrealShare.flak.Explode1'
      CockingSound=Sound'UnrealI.flak.load1'
      SelectSound=Sound'UnrealI.flak.pdown'
      Misc2Sound=Sound'UnrealI.flak.Hidraul2'
      Misc3Sound=Sound'UnrealShare.flak.Click'
      DeathMessage="%o was ripped to shreds by %k's %w."
      AutoSwitchPriority=6
      InventoryGroup=6
      PickupMessage="You got the Flak Cannon"
      ItemName="Flak Cannon"
      PlayerViewOffset=(X=2.100000,Y=-1.500000,Z=-1.250000)
      PlayerViewMesh=LodMesh'UnrealI.flak'
      PlayerViewScale=1.200000
      PickupViewMesh=LodMesh'UnrealI.FlakPick'
      ThirdPersonMesh=LodMesh'UnrealI.Flak3rd'
      PickupSound=Sound'UnrealShare.Pickups.WeaponPickup'
      Mesh=LodMesh'UnrealI.FlakPick'
      bNoSmooth=False
      CollisionRadius=27.000000
      CollisionHeight=23.000000
      LightBrightness=228
      LightHue=30
      LightSaturation=71
      LightRadius=14
}
