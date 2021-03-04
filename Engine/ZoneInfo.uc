//=============================================================================
// ZoneInfo, the built-in Unreal class for defining properties
// of zones.  If you place one ZoneInfo actor in a
// zone you have partioned, the ZoneInfo defines the 
// properties of the zone.
// This is a built-in Unreal class and it shouldn't be modified.
//=============================================================================
class ZoneInfo extends Info
	native
	nativereplication;

#exec Texture Import File=Textures\ZoneInfo.pcx Name=S_ZoneInfo Mips=Off Flags=2

//-----------------------------------------------------------------------------
// Zone properties.

var() name   ZoneTag;
var() vector ZoneGravity;
var() vector ZoneVelocity;
var() float  ZoneGroundFriction;
var() float  ZoneFluidFriction;
var() float	 ZoneTerminalVelocity;
var() name   ZonePlayerEvent;
var   int    ZonePlayerCount;
var   int	 NumCarcasses;
var() int	 DamagePerSec;
var() name	 DamageType;
var() localized string DamageString;
var(LocationStrings) localized string ZoneName;
var LocationID LocationID;	
var() int	 MaxCarcasses;
var() sound  EntrySound;	//only if waterzone
var() sound  ExitSound;		// only if waterzone
var() class<actor> EntryActor;	// e.g. a splash (only if water zone)
var() class<actor> ExitActor;	// e.g. a splash (only if water zone)
var skyzoneinfo SkyZone; // Optional sky zone containing this zone's sky.

//-----------------------------------------------------------------------------
// Zone flags.

var()		bool   bWaterZone;   // Zone is water-filled.
var() const bool   bFogZone;     // Zone is fog-filled.
var() const bool   bKillZone;    // Zone instantly kills those who enter.
var()		bool   bNeutralZone; // Players can't take damage in this zone.
var()		bool   bGravityZone; // Use ZoneGravity.
var()		bool   bPainZone;	 // Zone causes pain.
var()		bool   bDestructive; // Destroys carcasses.
var()		bool   bNoInventory;
var()		bool   bMoveProjectiles;	// this velocity zone should impart velocity to projectiles and effects
var()		bool   bBounceVelocity;		// this velocity zone should bounce actors that land in it

//-----------------------------------------------------------------------------
// Zone light.

var(ZoneLight) byte AmbientBrightness, AmbientHue, AmbientSaturation;
var(ZoneLight) color FogColor;
var(ZoneLight) float FogDistance;

var(ZoneLight) const texture EnvironmentMap;
var(ZoneLight) float TexUPanSpeed, TexVPanSpeed;
var(ZoneLight) vector ViewFlash, ViewFog;

//-----------------------------------------------------------------------------
// Reverb.

// Settings.
var(Reverb) bool bReverbZone;
var(Reverb) bool bRaytraceReverb;
var(Reverb) float SpeedOfSound;
var(Reverb) byte MasterGain;
var(Reverb) int  CutoffHz;
var(Reverb) byte Delay[6];
var(Reverb) byte Gain[6];

//-----------------------------------------------------------------------------
// Lens flare.

var(LensFlare) texture LensFlare[12];
var(LensFlare) float LensFlareOffset[12];
var(LensFlare) float LensFlareScale[12];

//-----------------------------------------------------------------------------
// per-Zone mesh LOD lighting control
 
// the number of lights applied to the actor mesh is interpolated between the following
// properties, as a function of the MeshPolyCount for the previous frame.
var() byte MinLightCount; // minimum number of lights to use (when MaxLightingPolyCount is exceeded)
var() byte MaxLightCount; // maximum number of lights to use (when MeshPolyCount drops below MinLightingPolyCount)
var() int MinLightingPolyCount;
var() int MaxLightingPolyCount;
// (NOTE: the default LOD properties (below) have no effect on the mesh lighting behavior)

//=============================================================================
// Network replication.

replication
{
	reliable if( Role==ROLE_Authority )
		ZoneGravity, ZoneVelocity, 
		// ZoneTerminalVelocity,
		// ZoneGroundFriction, ZoneFluidFriction,
		AmbientBrightness, AmbientHue, AmbientSaturation,
		TexUPanSpeed, TexVPanSpeed,
		// ViewFlash, ViewFog, // Not replicated because vectors replicated with elements rounded to integers
		bReverbZone,
		FogColor;
}

//=============================================================================
// Iterator functions.

// Iterate through all actors in this zone.
native(308) final iterator function ZoneActors( class<actor> BaseClass, out actor Actor );

//=============================================================================
simulated function LinkToSkybox()
{
	local skyzoneinfo TempSkyZone;

	// SkyZone.
	foreach AllActors( class 'SkyZoneInfo', TempSkyZone, '' )
		SkyZone = TempSkyZone;
	foreach AllActors( class 'SkyZoneInfo', TempSkyZone, '' )
		if( TempSkyZone.bHighDetail == Level.bHighDetailMode )
			SkyZone = TempSkyZone;
}

//=============================================================================
// Engine notification functions.

simulated function PreBeginPlay()
{
	Super.PreBeginPlay();

	// call overridable function to link this ZoneInfo actor to a skybox
	LinkToSkybox();
}

function Trigger( actor Other, pawn EventInstigator )
{
	if (DamagePerSec != 0)
		bPainZone = true;
}

// When an actor enters this zone.
event ActorEntered( actor Other )
{
	local actor A;
	local vector AddVelocity;

	if ( bNoInventory && Other.IsA('Inventory') && (Other.Owner == None) )
	{
		Other.LifeSpan = 1.5;
		return;
	}

	if( Pawn(Other)!=None && Pawn(Other).bIsPlayer )
		if( ++ZonePlayerCount==1 && ZonePlayerEvent!='' )
			foreach AllActors( class 'Actor', A, ZonePlayerEvent )
				A.Trigger( Self, Pawn(Other) );

	if ( bMoveProjectiles && (ZoneVelocity != vect(0,0,0)) )
	{
		if ( Other.Physics == PHYS_Projectile )
			Other.Velocity += ZoneVelocity;
		else if ( Other.IsA('Effects') && (Other.Physics == PHYS_None) )
		{
			Other.SetPhysics(PHYS_Projectile);
			Other.Velocity += ZoneVelocity;
		}
	}
}

// When an actor leaves this zone.
event ActorLeaving( actor Other )
{
	local actor A;
	if( Pawn(Other)!=None && Pawn(Other).bIsPlayer )
		if( --ZonePlayerCount==0 && ZonePlayerEvent!='' )
			foreach AllActors( class 'Actor', A, ZonePlayerEvent )
				A.UnTrigger( Self, Pawn(Other) );
}

defaultproperties
{
      ZoneTag="None"
      ZoneGravity=(X=0.000000,Y=0.000000,Z=-950.000000)
      ZoneVelocity=(X=0.000000,Y=0.000000,Z=0.000000)
      ZoneGroundFriction=8.000000
      ZoneFluidFriction=1.200000
      ZoneTerminalVelocity=2500.000000
      ZonePlayerEvent="None"
      ZonePlayerCount=0
      NumCarcasses=0
      DamagePerSec=0
      DamageType="None"
      DamageString=""
      ZoneName=""
      locationid=None
      MaxCarcasses=3
      EntrySound=None
      ExitSound=None
      EntryActor=None
      ExitActor=None
      SkyZone=None
      bWaterZone=False
      bFogZone=False
      bKillZone=False
      bNeutralZone=False
      bGravityZone=False
      bPainZone=False
      bDestructive=False
      bNoInventory=False
      bMoveProjectiles=True
      bBounceVelocity=False
      AmbientBrightness=0
      AmbientHue=0
      AmbientSaturation=255
      FogColor=(R=0,G=0,B=0,A=0)
      FogDistance=0.000000
      EnvironmentMap=None
      TexUPanSpeed=1.000000
      TexVPanSpeed=1.000000
      ViewFlash=(X=0.000000,Y=0.000000,Z=0.000000)
      ViewFog=(X=0.000000,Y=0.000000,Z=0.000000)
      bReverbZone=False
      bRaytraceReverb=False
      SpeedOfSound=8000.000000
      MasterGain=100
      CutoffHz=6000
      Delay(0)=20
      Delay(1)=34
      Delay(2)=0
      Delay(3)=0
      Delay(4)=0
      Delay(5)=0
      Gain(0)=150
      Gain(1)=70
      Gain(2)=0
      Gain(3)=0
      Gain(4)=0
      Gain(5)=0
      LensFlare(0)=None
      LensFlare(1)=None
      LensFlare(2)=None
      LensFlare(3)=None
      LensFlare(4)=None
      LensFlare(5)=None
      LensFlare(6)=None
      LensFlare(7)=None
      LensFlare(8)=None
      LensFlare(9)=None
      LensFlare(10)=None
      LensFlare(11)=None
      LensFlareOffset(0)=0.000000
      LensFlareOffset(1)=0.000000
      LensFlareOffset(2)=0.000000
      LensFlareOffset(3)=0.000000
      LensFlareOffset(4)=0.000000
      LensFlareOffset(5)=0.000000
      LensFlareOffset(6)=0.000000
      LensFlareOffset(7)=0.000000
      LensFlareOffset(8)=0.000000
      LensFlareOffset(9)=0.000000
      LensFlareOffset(10)=0.000000
      LensFlareOffset(11)=0.000000
      LensFlareScale(0)=0.000000
      LensFlareScale(1)=0.000000
      LensFlareScale(2)=0.000000
      LensFlareScale(3)=0.000000
      LensFlareScale(4)=0.000000
      LensFlareScale(5)=0.000000
      LensFlareScale(6)=0.000000
      LensFlareScale(7)=0.000000
      LensFlareScale(8)=0.000000
      LensFlareScale(9)=0.000000
      LensFlareScale(10)=0.000000
      LensFlareScale(11)=0.000000
      MinLightCount=6
      MaxLightCount=6
      MinLightingPolyCount=1000
      MaxLightingPolyCount=5000
      bStatic=True
      bNoDelete=True
      bAlwaysRelevant=True
      Texture=Texture'Engine.S_ZoneInfo'
      NetUpdateFrequency=2.000000
}
