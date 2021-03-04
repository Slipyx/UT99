//=============================================================================
// ExplosionChain.
//=============================================================================
class ExplosionChain extends Effects;


#exec Texture Import File=models\exp001.pcx Name=s_Exp001 Mips=Off Mask=On Flags=2

var() float MomentumTransfer;
var() float Damage;
var() float Size;
var() float Delaytime;

var bool bExploding;

function PreBeginPlay()
{
	Texture=None;
	Super.PreBeginPlay();
}

singular function TakeDamage( int NDamage, Pawn instigatedBy, Vector hitlocation, 
						Vector momentum, name damageType)
{
	if (bOnlyTriggerable && DamageType!='Detonated') Return;
	
	Instigator = InstigatedBy;
	MakeNoise(1.0);
	GoToState('Exploding');
}

function Trigger( actor Other, pawn EventInstigator )
{
	TakeDamage(10, EventInstigator, Location, Vector(Rotation), 'Detonated');
}

//////////////////////////////////////////////////////////////
state Exploding
{
	ignores TakeDamage;

	function Timer()
	{
		local SpriteBallExplosion f;
		
		bExploding = true;
 		HurtRadius(damage, Damage+100, 'Detonated', MomentumTransfer, Location);
 		f = spawn(class'SpriteBallExplosion',,,Location + vect(0,0,1)*16,rot(16384,0,0)); 
 		f.DrawScale = (Damage/100+0.4+FRand()*0.5)*Size;
		Destroy();
	}
	
	function BeginState()
	{
		bExploding = True;
		SetTimer(DelayTime+FRand()*DelayTime*2, False);
	}
}

defaultproperties
{
      MomentumTransfer=100000.000000
      Damage=100.000000
      Size=1.000000
      DelayTime=0.300000
      bExploding=False
      bNetTemporary=False
      RemoteRole=ROLE_SimulatedProxy
      DrawType=DT_Sprite
      Texture=Texture'UnrealShare.s_Exp001'
      DrawScale=0.400000
      bCollideActors=True
      bCollideWorld=True
      bProjTarget=True
}
