//=============================================================================
// pock.
//=============================================================================
class Pock expands Scorch;

#exec TEXTURE IMPORT NAME=pock0_t FILE=TEXTURES\DECALS\pock0_t.PCX LODSET=2
#exec TEXTURE IMPORT NAME=pock2_t FILE=TEXTURES\DECALS\pock2_t.PCX LODSET=2
#exec TEXTURE IMPORT NAME=pock4_t FILE=TEXTURES\DECALS\pock4_t.PCX LODSET=2

var() texture PockTex[3];

simulated function PostBeginPlay()
{
	if ( Level.bDropDetail )
		Texture = PockTex[0];
	else
		Texture = PockTex[Rand(3)];

	Super.PostBeginPlay();
}

simulated function AttachToSurface()
{
	bAttached = AttachDecal(100, vect(0,0,1)) != None;
}

defaultproperties
{
      PockTex(0)=Texture'Botpack.pock0_t'
      PockTex(1)=Texture'Botpack.pock2_t'
      PockTex(2)=Texture'Botpack.pock4_t'
      bImportant=False
      MultiDecalLevel=0
      DrawScale=0.190000
}
