class TargetShadow expands Decal;

function AttachToSurface()
{
}
			
simulated function Tick(float DeltaTime)
{
	local Actor HitActor;
	local Vector HitNormal,HitLocation;

	if ( Owner == None )
		return;
	if ( Owner.Physics == PHYS_None )
	{
		Destroy();
		return;
	}
	DetachDecal();

	SetLocation(Owner.Location);
	AttachDecal(320);
}

defaultproperties
{
      MultiDecalLevel=0
      Rotation=(Pitch=16384)
      Texture=Texture'Botpack.energymark'
      DrawScale=0.200000
}
