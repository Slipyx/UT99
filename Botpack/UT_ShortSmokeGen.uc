//=============================================================================
// UT_ShortSmokeGen.
//=============================================================================
class UT_ShortSmokeGen extends Effects;

var() float SmokeDelay;		// pause between drips
var() float SizeVariance;		// how different each drip is 
var() float BasePuffSize;
var() int TotalNumPuffs;
var() float RisingVelocity;
var() class<effects> GenerationType;
var() bool bRepeating;
var int i;

Auto State Active
{
	Simulated function Timer()
	{
		local Effects d;
		
		d = Spawn(GenerationType);
		d.DrawScale = BasePuffSize+FRand()*SizeVariance;
		d.RemoteRole = ROLE_None;	
		i++;
		if (i>TotalNumPuffs && TotalNumPuffs!=0) Destroy();
	}
}

simulated function PostBeginPlay()
{
	SetTimer(SmokeDelay+FRand()*SmokeDelay,True);
	Super.PostBeginPlay();
}

function Trigger( actor Other, pawn EventInstigator )
{
	SetTimer(SmokeDelay+FRand()*SmokeDelay,True);
	i=0;
}

function UnTrigger( actor Other, pawn EventInstigator )
{
	i=0;
	if (TotalNumPuffs==0)
	{
		if ( bRepeating )
			SetTimer(0.0, false);
		else
			Destroy();
	}

}

defaultproperties
{
     SmokeDelay=0.120000
     SizeVariance=1.000000
     BasePuffSize=1.500000
     TotalNumPuffs=10
     RisingVelocity=40.000000
     GenerationType=Class'Botpack.UT_SpriteSmokePuff'
     bHidden=True
     bNetTemporary=False
     RemoteRole=ROLE_None
     Style=STY_Masked
     Texture=None
}
