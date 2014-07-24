//=============================================================================
// DeadChairMale.
//=============================================================================
class DeadChairMale extends MaleBodyTwo;

#exec AUDIO IMPORT FILE="Sounds\Male\deathc4.WAV" NAME="MDeath4" GROUP="Male"

var bool	bChairSlump;
var sound   Scream;

function PostBeginPlay()
{
	Super.PostBeginPlay();
	bChairSlump = ( (AnimSequence == 'Chair1a') || (AnimSequence == 'Chair2a') );
}

function Trigger( actor Other, pawn EventInstigator )
{
	if ( bChairSlump )
		PlaySlump();
}
		
function Touch(Actor Other)
{
	if ( !bChairSlump )
	{
		Disable('Touch');
		Return;
	}
	if ( Other.IsA('Pawn') || Other.IsA('Projectile') )
	{
		PlaySlump();
		Disable('Touch');
	}
}

function TakeDamage( int Damage, Pawn InstigatedBy, Vector Hitlocation, 
						Vector Momentum, name DamageType)
{
	if ( bChairSlump )
		PlaySlump();
	else
		Super.TakeDamage(Damage, InstigatedBy, HitLocation, Momentum, DamageType);
}

function PlaySlump()
{
	Playsound(Scream);
	Playsound(Scream);
	Playsound(Scream);
	bChairSlump = false;
	PlayAnim(AnimSequence);
}

defaultproperties
{
     Scream=Sound'UnrealShare.Male.MDeath4'
     AnimSequence=Chair1a
     PrePivot=(Z=0.000000)
     CollisionRadius=22.000000
     CollisionHeight=22.000000
}
