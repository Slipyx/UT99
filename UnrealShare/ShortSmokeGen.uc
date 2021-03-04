//=============================================================================
// ShortSmokeGen.
//=============================================================================
class ShortSmokeGen extends SmokeGenerator;

Auto State Active
{
	Simulated function Timer()
	{
		local Effects d;
		
		d = Spawn(GenerationType);
		d.DrawScale = BasePuffSize+FRand()*SizeVariance;
		d.RemoteRole = ROLE_None;	
		if (SpriteSmokePuff(d)!=None) SpriteSmokePuff(d).RisingRate = RisingVelocity;	
		i++;
		if (i>TotalNumPuffs && TotalNumPuffs!=0) Destroy();
	}
}

simulated function PostBeginPlay()
{
	SetTimer(SmokeDelay+FRand()*SmokeDelay,True);
	Super.PostBeginPlay();
}

defaultproperties
{
      SmokeDelay=0.120000
      BasePuffSize=1.500000
      TotalNumPuffs=10
      RisingVelocity=40.000000
      RemoteRole=ROLE_SimulatedProxy
}
