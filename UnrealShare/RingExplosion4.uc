//=============================================================================
// RingExplosion4.
//=============================================================================
class RingExplosion4 extends RingExplosion;


var vector MoveAmount;
var int NumPuffs;
var int numwaits;

replication
{
	// Things the server should send to the client.
	unreliable if( Role==ROLE_Authority )
		MoveAmount, NumPuffs;
}

simulated function Tick( float DeltaTime )
{
	if ( Level.NetMode != NM_DedicatedServer )
	{
		ScaleGlow = (Lifespan/Default.Lifespan)*1.2;
		AmbientGlow = ScaleGlow * 210;
	}
}


simulated function PostBeginPlay()
{
	if ( Level.NetMode != NM_DedicatedServer )
	{
		PlayAnim  ( 'Explosion', 0.1 );
		SetTimer(0.06, false);
	}
}

simulated function Timer()
{
	local RingExplosion4 r;

	//log(self$" timer "$Level.TimeSeconds$" role "$Role$" Location "$Location$" rot "$Rotation$" numpuffs "$numpuffs);

	//log("self lifespan "$lifespan);
	
	if (NumPuffs>0)
	{
		r = Spawn(class'RingExplosion4',,,Location+MoveAmount);
		r.RemoteRole = ROLE_None;
		r.NumPuffs = NumPuffs -1;
		r.MoveAmount = MoveAmount;
	}
}

defaultproperties
{
      MoveAmount=(X=0.000000,Y=0.000000,Z=0.000000)
      NumPuffs=0
      numwaits=0
      LifeSpan=0.400000
      DrawScale=0.200000
}
