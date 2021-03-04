//=============================================================================
// TMaleBody.
//=============================================================================
class TMaleBody extends UTHumanCarcass
	abstract;

var float LastHit;
var bool bJerking;
var name Jerks[4];

replication
{
	// Things the server should send to the client.
	unreliable if( Role==ROLE_Authority )
		LastHit, bJerking;
}

function TakeDamage( int Damage, Pawn InstigatedBy, Vector Hitlocation, 
						Vector Momentum, name DamageType)
{	
	local bool bRiddled;
	
	if ( bJerking || (AnimSequence == 'Dead9') )
	{
		bJerking = true;
		if ( Damage < 23 )
			LastHit = Level.TimeSeconds;
		else 
			bJerking = false;
	}
	Super.TakeDamage(Damage, InstigatedBy, HitLocation, Momentum, DamageType);

	if ( bJerking )
	{
		CumulativeDamage = 50;
		Velocity.Z = FMax(Velocity.Z, 40);
		if ( InstigatedBy == None )
		{
			bJerking = false;
			PlayAnim('Dead9B', 1.1, 0.1);
		}
	}
	if ( bJerking && (VSize(InstigatedBy.Location - Location) < 150)
		&& (InstigatedBy.Acceleration != vect(0,0,0))
		&& ((Normal(InstigatedBy.Velocity) Dot Normal(Location - InstigatedBy.Location)) > 0.7) )
	{
		bJerking = false;
		PlayAnim('Dead9B', 1.1, 0.1);
	}
}

function AnimEnd()
{
	local name NewAnim;

	if ( AnimSequence == 'Dead9' )
		bJerking = true;

	if ( !bJerking )
		Super.AnimEnd();
	else if ( (Level.TimeSeconds - LastHit < 0.2) && (FRand() > 0.02) )
	{
		NewAnim = Jerks[Rand(4)];
		if ( NewAnim == AnimSequence )
		{
			if ( NewAnim == Jerks[0] )
				NewAnim = Jerks[1];
			else
				NewAnim = Jerks[0];
		}
		TweenAnim(NewAnim, 0.15);
	}
	else
	{
		bJerking = false;
		PlayAnim('Dead9B', 1.1, 0.1);
	}
}

function SpawnHead()
{
	local carcass carc;

	carc = Spawn(class'UT_HeadMale');
	if ( carc != None )
	{
		carc.RemoteRole = ROLE_SimulatedProxy;
		carc.Initfor(self);
	}
}

defaultproperties
{
      LastHit=0.000000
      bJerking=False
      Jerks(0)="GutHit"
      Jerks(1)="HeadHit"
      Jerks(2)="LeftHit"
      Jerks(3)="RightHit"
      MasterReplacement=Class'Botpack.TMaleMasterChunk'
      AnimSequence="Dead1"
      bBlockActors=True
      bBlockPlayers=True
      Mass=100.000000
}
