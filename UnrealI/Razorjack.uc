//=============================================================================
// razorjack
//=============================================================================
class RazorJack extends Weapon;

#exec MESH IMPORT MESH=Razor ANIVFILE=MODELS\razor_a.3D DATAFILE=MODELS\razor_d.3D X=0 Y=0 Z=0
#exec MESH ORIGIN MESH=Razor X=0 Y=0 Z=0 YAW=-64 ROLL=-8
#exec MESH SEQUENCE MESH=razor SEQ=All     STARTFRAME=0   NUMFRAMES=100
#exec MESH SEQUENCE MESH=razor SEQ=Select  STARTFRAME=0   NUMFRAMES=30  RATE=24 GROUP=Select
#exec MESH SEQUENCE MESH=razor SEQ=Fire    STARTFRAME=30  NUMFRAMES=10
#exec MESH SEQUENCE MESH=razor SEQ=Load    STARTFRAME=36  NUMFRAMES=4
#exec MESH SEQUENCE MESH=razor SEQ=Idle    STARTFRAME=40  NUMFRAMES=31
#exec MESH SEQUENCE MESH=razor SEQ=AltFire1 STARTFRAME=71  NUMFRAMES=12 RATE=24
#exec MESH SEQUENCE MESH=razor SEQ=AltFire2 STARTFRAME=83  NUMFRAMES=5 RATE=24
#exec MESH SEQUENCE MESH=razor SEQ=AltFire3 STARTFRAME=88  NUMFRAMES=4 RATE=24
#exec MESH SEQUENCE MESH=razor SEQ=Down    STARTFRAME=92  NUMFRAMES=8

#exec TEXTURE IMPORT NAME=JRazor1 FILE=MODELS\razor.PCX GROUP=Skins
#exec MESHMAP SCALE MESHMAP=razor X=0.005 Y=0.005 Z=0.01
#exec MESHMAP SETTEXTURE MESHMAP=razor NUM=1 TEXTURE=Jrazor1

#exec MESH IMPORT MESH=RazPick ANIVFILE=MODELS\rapick_a.3D DATAFILE=MODELS\rapick_d.3D X=0 Y=0 Z=0
#exec MESH ORIGIN MESH=RazPick X=0 Y=0 Z=0 YAW=-64 ROLL=-8
#exec MESH SEQUENCE MESH=RazPick SEQ=All    STARTFRAME=0   NUMFRAMES=1
#exec MESH SEQUENCE MESH=RazPick SEQ=Still  STARTFRAME=0   NUMFRAMES=1
#exec TEXTURE IMPORT NAME=JRazor1 FILE=MODELS\razor.PCX GROUP=Skins
#exec MESHMAP SCALE MESHMAP=RazPick X=0.025 Y=0.025 Z=0.05
#exec MESHMAP SETTEXTURE MESHMAP=RazPick NUM=1 TEXTURE=Jrazor1

#exec MESH IMPORT MESH=Razor3rd ANIVFILE=MODELS\Razor3_a.3D DATAFILE=MODELS\Razor3_d.3D X=0 Y=0 Z=0
#exec MESH ORIGIN MESH=Razor3rd X=0 Y=-180 Z=-95 YAW=-64 ROLL=6
#exec MESH SEQUENCE MESH=Razor3rd SEQ=All  STARTFRAME=0  NUMFRAMES=20
#exec MESH SEQUENCE MESH=Razor3rd SEQ=Still  STARTFRAME=0  NUMFRAMES=1
#exec MESH SEQUENCE MESH=Razor3rd SEQ=Fire  STARTFRAME=1  NUMFRAMES=9
#exec MESH SEQUENCE MESH=Razor3rd SEQ=AltFire2  STARTFRAME=1  NUMFRAMES=9
#exec MESH SEQUENCE MESH=Razor3rd SEQ=Idle  STARTFRAME=10  NUMFRAMES=10
#exec TEXTURE IMPORT NAME=Jrazor1 FILE=MODELS\razor.PCX GROUP="Skins"
#exec MESHMAP SCALE MESHMAP=Razor3rd X=0.035 Y=0.035 Z=0.06
#exec MESHMAP SETTEXTURE MESHMAP=Razor3rd NUM=1 TEXTURE=JRazor1

#exec AUDIO IMPORT FILE="Sounds\Razor\beam.WAV" NAME="beam" GROUP="RazorJack"

function Projectile ProjectileFire(class<projectile> ProjClass, float ProjSpeed, bool bWarn)
{
	local Vector Start, X,Y,Z;

	if ( PlayerPawn(Owner) != None )
		PlayerPawn(Owner).ClientInstantFlash( -0.4, vect(500, 0, 650));
	Owner.MakeNoise(Pawn(Owner).SoundDampening);
	GetAxes(Pawn(owner).ViewRotation,X,Y,Z);
	Start = Owner.Location + CalcDrawOffset() + FireOffset.X * X + FireOffset.Z * Z; 
	AdjustedAim = pawn(owner).AdjustAim(ProjSpeed, Start, AimError, True, bWarn);	
	return Spawn(ProjClass,,, Start,AdjustedAim);	
}

function PlayFiring()
{
	PlayAnim( 'Fire', 0.7,0.05 );
}

function PlayAltFiring()
{
	PlayAnim('AltFire1', 0.9,0.05);
}

function AltFire( float Value )
{
	if (AmmoType.UseAmmo(1))
	{
		if ( Owner.bHidden )
			CheckVisibility();
		bPointing=True;
		PlayAltFiring();
		GotoState('AltFiring');
	}
}
	
///////////////////////////////////////////////////////////
state AltFiring
{
	function Projectile ProjectileFire(class<projectile> ProjClass, float ProjSpeed, bool bWarn)
	{
		local Vector Start, X,Y,Z;		

		Owner.MakeNoise(Pawn(Owner).SoundDampening);
		GetAxes(Pawn(owner).ViewRotation,X,Y,Z);
		Start = Owner.Location + CalcDrawOffset() + FireOffset.X * X + FireOffset.Y * Y + FireOffset.Z * Z; 
		AdjustedAim = pawn(owner).AdjustAim(ProjSpeed, Start, AimError, True, bWarn);	
		AdjustedAim.Roll += 12768;		
		return RazorBlade(Spawn(ProjClass,,, Start,AdjustedAim));
	}

Begin:
	FinishAnim();
Repeater:
	ProjectileFire(AltProjectileClass,AltProjectileSpeed,bAltWarnTarget);
	PlayAnim('AltFire2', 0.4,0.05);
	FinishAnim();
	if ( PlayerPawn(Owner) == None )
	{
		if ( (AmmoType != None) && (AmmoType.AmmoAmount<=0) )
		{
			Pawn(Owner).StopFiring();
			Pawn(Owner).SwitchToBestWeapon();
			if ( bChangeWeapon )
				GotoState('DownWeapon');
		}
		else if ( (Pawn(Owner).bAltFire == 0) || (FRand() > AltRefireRate) )
		{
			Pawn(Owner).StopFiring();
			GotoState('Idle');
		}
	}
	if ( (Pawn(Owner).bAltFire!=0) 
		&& (Pawn(Owner).Weapon==Self) && AmmoType.UseAmmo(1))
	{
		goto 'Repeater';
	}	
	PlayAnim('AltFire3', 0.9,0.05);
	FinishAnim();
	PlayAnim('Load',0.2,0.05);	
	FinishAnim();	
	if ( Pawn(Owner).bFire!=0 && Pawn(Owner).Weapon==Self) 
		Global.Fire(0);
	else 
		GotoState('Idle');
}

///////////////////////////////////////////////////////////
function PlayIdleAnim()
{
	LoopAnim('Idle', 0.4);
}

defaultproperties
{
      AmmoName=Class'UnrealI.RazorAmmo'
      PickupAmmoCount=15
      FireOffset=(X=16.000000,Z=-15.000000)
      ProjectileClass=Class'UnrealI.RazorBlade'
      AltProjectileClass=Class'UnrealI.RazorBladeAlt'
      shakemag=120.000000
      AIRating=0.500000
      RefireRate=0.830000
      AltRefireRate=0.830000
      SelectSound=Sound'UnrealI.Razorjack.beam'
      DeathMessage="%k took a bloody chunk out of %o with the %w."
      AutoSwitchPriority=7
      InventoryGroup=7
      PickupMessage="You got the RazorJack"
      ItemName="Razorjack"
      PlayerViewOffset=(X=2.000000,Z=-0.900000)
      PlayerViewMesh=LodMesh'UnrealI.Razor'
      BobDamping=0.970000
      PickupViewMesh=LodMesh'UnrealI.RazPick'
      ThirdPersonMesh=LodMesh'UnrealI.Razor3rd'
      PickupSound=Sound'UnrealShare.Pickups.WeaponPickup'
      Mesh=LodMesh'UnrealI.RazPick'
      bNoSmooth=False
      CollisionRadius=28.000000
      CollisionHeight=7.000000
      Mass=17.000000
}
