class BoltScorch expands EnergyImpact;

#exec TEXTURE IMPORT NAME=energymark FILE=TEXTURES\DECALS\Shadow_1.PCX LODSET=2

simulated function Timer()
{
	// Check for nearby players, if none then destroy self

	if ( !bAttached )
	{
		Destroy();
		return;
	}

	if ( !bStartedLife )
	{
		RemoteRole = ROLE_None;
		bStartedLife = true;
		if ( Level.bDropDetail )
			SetTimer(3, false);
		else
			SetTimer(4, false);
		return;
	}
	Destroy();
}

defaultproperties
{
      bImportant=False
      MultiDecalLevel=0
      Texture=Texture'Botpack.energymark'
      DrawScale=0.200000
}
