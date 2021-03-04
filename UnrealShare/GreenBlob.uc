//=============================================================================
// GreenBlob.
//=============================================================================
class GreenBlob extends Effects;

#exec TEXTURE IMPORT NAME=GreenBlob1 FILE=MODELS\Blob1.pcx GROUP=Effects
#exec TEXTURE IMPORT NAME=GreenBlob2 FILE=MODELS\Blob2.pcx GROUP=Effects
#exec TEXTURE IMPORT NAME=GreenBlob3 FILE=MODELS\Blob3.pcx GROUP=Effects
#exec TEXTURE IMPORT NAME=GreenBlob4 FILE=MODELS\Blob4.pcx GROUP=Effects
#exec TEXTURE IMPORT NAME=GreenBlob5 FILE=MODELS\Blob5.pcx GROUP=Effects

var() texture BlobTypes[5];

simulated function Setup(vector WallNormal)
{
	Texture = BlobTypes[Rand(5)];
	Velocity = VRand()*140*FRand()+WallNormal*250;
	DrawScale = FRand()*0.3 + 0.2;
}

auto state Explode
{

	simulated function Landed( vector HitNormal )
	{
		Destroy();
	}

	simulated function HitWall( vector HitNormal, actor Wall )
	{
		Destroy();
	}
}

defaultproperties
{
      BlobTypes(0)=Texture'UnrealShare.Effects.GreenBlob1'
      BlobTypes(1)=Texture'UnrealShare.Effects.GreenBlob2'
      BlobTypes(2)=Texture'UnrealShare.Effects.GreenBlob3'
      BlobTypes(3)=Texture'UnrealShare.Effects.GreenBlob4'
      BlobTypes(4)=Texture'UnrealShare.Effects.GreenBlob5'
      bHighDetail=True
      Physics=PHYS_Falling
      RemoteRole=ROLE_SimulatedProxy
      LifeSpan=7.000000
      DrawType=DT_Sprite
      Style=STY_Translucent
      Texture=Texture'UnrealShare.Effects.GreenBlob1'
      bUnlit=True
      CollisionRadius=4.000000
      CollisionHeight=4.000000
      bCollideWorld=True
      bBounce=True
      NetPriority=2.000000
}
