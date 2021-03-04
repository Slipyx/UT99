class Decal expands Actor
	native;

// properties
var int MultiDecalLevel;
var float LastRenderedTime;

// native stuff.
var const array<int> SurfList;

simulated native function Texture AttachDecal( float TraceDistance, optional vector DecalDir ); // trace forward and attach this decal to surfaces.
simulated native function DetachDecal(); // detach this decal from all surfaces.

simulated event PostBeginPlay()
{
	AttachToSurface();
}

simulated function AttachToSurface()
{
	if(AttachDecal(100) == None)	// trace 100 units ahead in direction of current rotation
		Destroy();
}

simulated event Destroyed()
{
	DetachDecal();
	Super.Destroyed();
}

event Update(Actor L);

defaultproperties
{
      MultiDecalLevel=4
      LastRenderedTime=0.000000
      SurfList=()
      bHighDetail=True
      bNetTemporary=True
      bNetOptional=True
      RemoteRole=ROLE_None
      DrawType=DT_None
      bUnlit=True
      bGameRelevant=True
      CollisionRadius=0.000000
      CollisionHeight=0.000000
}
