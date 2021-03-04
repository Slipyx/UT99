//=============================================================================
// MortarSpawner.
//=============================================================================
class MortarSpawner extends Effects;

var() int	ShellDamage;
var() int	ShellMomentumTransfer;
var() int	ShellBlastRadius;
var() int   RateOfFire;
var() float ShellSpeed;
var() int	Deviation;
var() bool	bDeviate;
var() sound FireSound;

function BeginPlay()
{
	SetTimer(RateOfFire, True);
}

function Timer()
{
	LaunchShell();
	PlaySound(FireSound, SLOT_None, 4.0);	
}

function LaunchShell()
{
	local rotator NewRot;
	local MortarShell shell;

	if (bDeviate)
	{
		NewRot.Pitch = Rotation.Pitch + (Deviation/2) - (Deviation * FRand());
		NewRot.Roll  = Rotation.Roll  + (Deviation/2) - (Deviation * FRand());
		NewRot.Yaw   = Rotation.Yaw   + (Deviation/2) - (Deviation * FRand());
	}
	else
		NewRot = Rotation;
	shell = Spawn(class'MortarShell',,, Location+Vector(Rotation)*20, NewRot);
	
	shell.speed = ShellSpeed;
	shell.damage = ShellDamage;
	shell.momentumtransfer = ShellMomentumTransfer;
	shell.blastradius = ShellBlastRadius;
}

defaultproperties
{
      ShellDamage=70
      ShellMomentumTransfer=150000
      ShellBlastRadius=400
      RateOfFire=5
      ShellSpeed=1000.000000
      Deviation=4096
      bDeviate=True
      FireSound=Sound'UnrealShare.flak.Explode1'
      bHidden=True
      bNetTemporary=False
      bDirectional=True
      DrawType=DT_Sprite
}
