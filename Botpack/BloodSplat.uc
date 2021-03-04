class BloodSplat expands Scorch;

#exec TEXTURE IMPORT NAME=BloodSplat1 FILE=TEXTURES\DECALS\Blood_Splat_1.PCX LODSET=2
#exec TEXTURE IMPORT NAME=BloodSplat2 FILE=TEXTURES\DECALS\Blood_Splat_2.PCX LODSET=2
#exec TEXTURE IMPORT NAME=BloodSplat3 FILE=TEXTURES\DECALS\Blood_Splat_3.PCX LODSET=2
#exec TEXTURE IMPORT NAME=BloodSplat4 FILE=TEXTURES\DECALS\BloodSplat4.PCX LODSET=2
#exec TEXTURE IMPORT NAME=BloodSplat5 FILE=TEXTURES\DECALS\Blood_Splat_5.PCX LODSET=2
#exec TEXTURE IMPORT NAME=BloodSplat6 FILE=TEXTURES\DECALS\BSplat1-S.PCX LODSET=2
#exec TEXTURE IMPORT NAME=BloodSplat7 FILE=TEXTURES\DECALS\BloodSplat1.PCX LODSET=2
#exec TEXTURE IMPORT NAME=BloodSplat8 FILE=TEXTURES\DECALS\Blood_Splat_1.PCX LODSET=2
#exec TEXTURE IMPORT NAME=BloodSplat9 FILE=TEXTURES\DECALS\Spatter1.PCX LODSET=2
#exec TEXTURE IMPORT NAME=BloodSplat10 FILE=TEXTURES\DECALS\BloodSplat2.PCX LODSET=2

var texture Splats[10];

simulated function BeginPlay()
{
	if ( class'GameInfo'.Default.bLowGore || (Level.bDropDetail && (FRand() < 0.35)) )
	{
		destroy();
		return;
	}
	if ( Level.bDropDetail )
		Texture = splats[Rand(5)];
	else
		Texture = splats[Rand(10)];
}

defaultproperties
{
      Splats(0)=Texture'Botpack.BloodSplat1'
      Splats(1)=Texture'Botpack.BloodSplat2'
      Splats(2)=Texture'Botpack.BloodSplat3'
      Splats(3)=Texture'Botpack.BloodSplat4'
      Splats(4)=Texture'Botpack.BloodSplat5'
      Splats(5)=Texture'Botpack.BloodSplat6'
      Splats(6)=Texture'Botpack.BloodSplat7'
      Splats(7)=Texture'Botpack.BloodSplat8'
      Splats(8)=Texture'Botpack.BloodSplat9'
      Splats(9)=Texture'Botpack.BloodSplat10'
      bImportant=False
      MultiDecalLevel=0
      Texture=Texture'Botpack.BloodSplat1'
      DrawScale=0.350000
}
