class BioMark expands Scorch;

#exec TEXTURE IMPORT NAME=biosplat FILE=TEXTURES\DECALS\goo_splat.PCX LODSET=2
#exec TEXTURE IMPORT NAME=biosplat2 FILE=TEXTURES\DECALS\goo_splat2.PCX LODSET=2

simulated function BeginPlay()
{
	if ( !Level.bDropDetail && (FRand() < 0.5) )
		Texture = texture'Botpack.biosplat2';
	Super.BeginPlay();
}

defaultproperties
{
      MultiDecalLevel=2
      Texture=Texture'Botpack.biosplat'
      DrawScale=0.650000
}
