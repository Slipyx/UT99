class UTBloodPool expands Scorch;

#exec TEXTURE IMPORT NAME=BloodPool6 FILE=TEXTURES\DECALS\BSplat1-S.PCX LODSET=2
#exec TEXTURE IMPORT NAME=BloodPool7 FILE=TEXTURES\DECALS\BSplat5-S.PCX LODSET=2
#exec TEXTURE IMPORT NAME=BloodPool8 FILE=TEXTURES\DECALS\BSplat2-S.PCX LODSET=2
#exec TEXTURE IMPORT NAME=BloodPool9 FILE=TEXTURES\DECALS\Spatter2.PCX LODSET=2

var texture Splats[5];

simulated function BeginPlay()
{
	if ( class'GameInfo'.Default.bLowGore )
	{
		destroy();
		return;
	}
	
	if ( Level.bDropDetail )
		Texture = splats[2 + Rand(3)];
	else
		Texture = splats[Rand(5)];;
}

defaultproperties
{
      Splats(0)=Texture'Botpack.BloodPool6'
      Splats(1)=Texture'Botpack.BloodPool8'
      Splats(2)=Texture'Botpack.BloodPool9'
      Splats(3)=Texture'Botpack.BloodPool7'
      Splats(4)=Texture'Botpack.BloodSplat4'
      Texture=Texture'Botpack.BloodSplat1'
      DrawScale=0.750000
}
