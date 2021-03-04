class MeshActor extends Info;

var UMenuPlayerMeshClient NotifyClient;

function AnimEnd()
{
	NotifyClient.AnimEnd(Self);
}

defaultproperties
{
      NotifyClient=None
      bHidden=False
      bOnlyOwnerSee=True
      bAlwaysTick=True
      Physics=PHYS_Rotating
      RemoteRole=ROLE_None
      DrawType=DT_Mesh
      DrawScale=0.100000
      AmbientGlow=255
      bUnlit=True
      CollisionRadius=0.000000
      CollisionHeight=0.000000
}
