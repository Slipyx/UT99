//=============================================================================
// Decoration.
//=============================================================================
class Decoration extends Actor
	abstract
	native;

// If set, the pyrotechnic or explosion when item is damaged.
var() class<Actor> EffectWhenDestroyed;
var() bool bPushable;
var() bool bOnlyTriggerable;
var bool bSplash;
var bool bBobbing;
var bool bWasCarried;
var() sound PushSound;
var const int	 numLandings; // Used by engine physics.
var() class<inventory> contents;
var() class<inventory> content2;
var() class<inventory> content3;
var() sound EndPushSound;
var bool bPushSoundPlaying;



event PostBeginPlay()
{
	//Make this decoration appear in the skybox on net clients
	if ( (SkyZoneInfo(Region.Zone) != None) && !bHidden && (RemoteRole != ROLE_None) )
	{
		bAlwaysRelevant = true;
		NetPriority *= 0.5;
	}
	//Reduce amount of network ticks on decorations that don't need them
	if ( bStatic && (RemoteRole != ROLE_None) )
	{
		if ( NetUpdateFrequency == 100 )
			NetUpdateFrequency = 5;
		NetPriority *= 0.5;
	}
}


simulated function FollowHolder(Actor Other);

function Drop(vector newVel);

function Landed(vector HitNormall)
{
	if( bWasCarried && !SetLocation(Location) )
	{
		if( Instigator!=None && (VSize(Instigator.Location - Location) < CollisionRadius + Instigator.CollisionRadius) )
			SetLocation(Instigator.Location);
		TakeDamage( 1000, Instigator, Location, Vect(0,0,1)*900,'exploded' );
	}
	bWasCarried = false;
	bBobbing = false;
}

singular function ZoneChange( ZoneInfo NewZone )
{
	local float splashsize;
	local actor splash;

	if ( NewZone.bWaterZone )
	{
		if( bSplash && !Region.Zone.bWaterZone && Mass<=Buoyancy 
			&& ((Abs(Velocity.Z) < 100) || (Mass == 0)) && (FRand() < 0.05) && !PlayerCanSeeMe() )
		{
			bSplash = false;
			SetPhysics(PHYS_None);
		}
		else if( !Region.Zone.bWaterZone && (Velocity.Z < -200) )
		{
			// Else play a splash.
			splashSize = FClamp(0.0001 * Mass * (250 - 0.5 * FMax(-600,Velocity.Z)), 1.0, 3.0 );
			if( NewZone.EntrySound != None )
				PlaySound(NewZone.EntrySound, SLOT_Interact, splashSize);
			if( NewZone.EntryActor != None )
			{
				splash = Spawn(NewZone.EntryActor); 
				if ( splash != None )
					splash.DrawScale = splashSize;
			}
		}
		bSplash = true;
	}
	else if( Region.Zone.bWaterZone && (Buoyancy > Mass) )
	{
		bBobbing = true;
		if( Buoyancy > 1.1 * Mass )
			Buoyancy = 0.95 * Buoyancy; // waterlog
		else if( Buoyancy > 1.03 * Mass )
			Buoyancy = 0.99 * Buoyancy;
	}

	if( NewZone.bPainZone && (NewZone.DamagePerSec > 0) )
		TakeDamage(100, None, location, vect(0,0,0), NewZone.DamageType);
}

function Trigger( actor Other, pawn EventInstigator )
{
	Instigator = EventInstigator;
	TakeDamage( 1000, Instigator, Location, Vect(0,0,1)*900,'exploded' );
}

singular function BaseChange()
{
	local float decorMass, decorMass2;

	decormass= FMax(1, Mass);
	bBobbing = false;
	if( Velocity.Z < -500 )
		TakeDamage( (1-Velocity.Z/30),Instigator,Location,vect(0,0,0) , 'crushed');

	if( (base == None) && (bPushable || IsA('Carcass')) && (Physics == PHYS_None) )
		SetPhysics(PHYS_Falling);
	else if( (Pawn(base) != None) && (Pawn(Base).CarriedDecoration != self) )
	{
		Base.TakeDamage( (1-Velocity.Z/400)* decormass/Base.Mass,Instigator,Location,0.5 * Velocity , 'crushed');
		Velocity.Z = 100;
		if (FRand() < 0.5)
			Velocity.X += 70;
		else
			Velocity.Y += 70;
		SetPhysics(PHYS_Falling);
	}
	else if( Decoration(Base)!=None && Velocity.Z<-500 )
	{
		decorMass2 = FMax(Decoration(Base).Mass, 1);
		Base.TakeDamage((1 - decorMass/decorMass2 * Velocity.Z/30), Instigator, Location, 0.2 * Velocity, 'stomped');
		Velocity.Z = 100;
		if (FRand() < 0.5)
			Velocity.X += 70;
		else
			Velocity.Y += 70;
		SetPhysics(PHYS_Falling);
	}
	else
		instigator = None;
}

function Destroyed()
{
	local Actor dropped, A;
	local class<Actor> tempClass;

	if( (Pawn(Base) != None) && (Pawn(Base).CarriedDecoration == self) )
		Pawn(Base).DropDecoration();
	if( (Contents!=None) && !Level.bStartup )
	{
		tempClass = Contents;
		if (Content2!=None && FRand()<0.3) tempClass = Content2;
		if (Content3!=None && FRand()<0.3) tempClass = Content3;
		if ( tempClass != None )
			dropped = Spawn(tempClass);
		if ( dropped != None )
		{
			dropped.RemoteRole = ROLE_DumbProxy;
			dropped.SetPhysics(PHYS_Falling);
			dropped.bCollideWorld = true;
			if ( Inventory(dropped) != None )
				Inventory(dropped).GotoState('Pickup', 'Dropped');
		}
	}	

	if( Event != '' )
		foreach AllActors( class 'Actor', A, Event )
			A.Trigger( Self, None );

	if ( bPushSoundPlaying )
		PlaySound( EndPushSound, SLOT_Misc,0.0);
			
	Super.Destroyed();
}

simulated function skinnedFrag( class<fragment> FragType, texture FragSkin, vector Momentum, float DSize, int NumFrags) 
{
	local int i;
	local actor A, Toucher;
	local Fragment s;

	if ( bOnlyTriggerable )
		return; 

	if ( Event != '' )
		ForEach AllActors( class 'Actor', A, Event )
			A.Trigger( Toucher, pawn(Toucher) );

	if ( !Region.Zone.bDestructive && (FragType != None) )
		for ( i=0 ; i<NumFrags ; i++ ) 
		{
			s = Spawn( FragType, Owner);
			if ( s != None )
			{
				s.CalcVelocity(Momentum/100,0);
				s.Skin = FragSkin;
				s.DrawScale = DSize*0.5+0.7*DSize*FRand();
			}
		}

	Destroy();
}

simulated function Frag( class<fragment> FragType, vector Momentum, float DSize, int NumFrags) 
{
	local int i;
	local actor A, Toucher;
	local Fragment s;

	if ( bOnlyTriggerable )
		return; 

	if ( Event != '' )
		ForEach AllActors( class 'Actor', A, Event )
			A.Trigger( Toucher, pawn(Toucher) );

	if ( !Region.Zone.bDestructive && (FragType != None) )
		for ( i=0 ; i<NumFrags ; i++ ) 
		{
			s = Spawn( FragType, Owner);
			if ( s != None )
			{
				s.CalcVelocity(Momentum,0);
				s.DrawScale = DSize*0.5+0.7*DSize*FRand();
			}
		}
	Destroy();
}

function Timer()
{
	PlaySound( EndPushSound, SLOT_Misc, 0.0);
	bPushSoundPlaying = False;
}

function Bump( actor Other )
{
	local float speed, oldZ;
	if( bPushable && (Pawn(Other)!=None) && (Other.Mass > 40) )
	{
		bBobbing = false;
		oldZ = Velocity.Z;
		speed = VSize(Other.Velocity);
		Velocity = Other.Velocity * FMin(120.0, 20 + speed)/speed;
		if ( Physics == PHYS_None ) {
			Velocity.Z = 25;
			if (!bPushSoundPlaying) PlaySound(PushSound, SLOT_Misc,0.25);
			bPushSoundPlaying = True;			
		}
		else
			Velocity.Z = oldZ;
		SetPhysics(PHYS_Falling);
		SetTimer(0.3,False);
		Instigator = Pawn(Other);
	}
}

defaultproperties
{
      EffectWhenDestroyed=None
      bPushable=False
      bOnlyTriggerable=False
      bSplash=False
      bBobbing=False
      bWasCarried=False
      PushSound=None
      numLandings=0
      contents=None
      content2=None
      content3=None
      EndPushSound=None
      bPushSoundPlaying=False
      bStatic=True
      bStasis=True
      Texture=None
      Mass=0.000000
}
