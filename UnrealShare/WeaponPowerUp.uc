//=============================================================================
// WeaponPowerUp.
//=============================================================================
class WeaponPowerUp extends Pickup;

#exec MESH IMPORT MESH=WeaponPowerUpMesh ANIVFILE=MODELS\dpower_a.3D DATAFILE=MODELS\dpower_d.3D MLOD=0
#exec MESH ORIGIN MESH=WeaponPowerUpMesh X=0 Y=0 Z=0 YAW=64
#exec MESH SEQUENCE MESH=WeaponPowerUpMesh SEQ=All STARTFRAME=0  NUMFRAMES=20
#exec MESH SEQUENCE MESH=WeaponPowerUpMesh SEQ=AnimEnergy STARTFRAME=0  NUMFRAMES=20
#exec TEXTURE IMPORT NAME=aPower1 FILE=MODELS\dpower.PCX GROUP="Skins"
#exec OBJ LOAD FILE=Textures\fireeffect22.utx PACKAGE=UnrealShare.Effect22
#exec MESHMAP SCALE MESHMAP=WeaponPowerUpMesh X=0.05 Y=0.05 Z=0.10
#exec MESHMAP SETTEXTURE MESHMAP=WeaponPowerUpMesh NUM=1 TEXTURE=aPower1 TLOD=5
#exec MESHMAP SETTEXTURE MESHMAP=WeaponPowerUpMesh NUM=0 TEXTURE=UnrealShare.Effect22.FireEffect22

#exec AUDIO IMPORT FILE="Sounds\dispersion\number1.WAV" NAME="number1" GROUP="Dispersion"
#exec AUDIO IMPORT FILE="Sounds\dispersion\number2.WAV" NAME="number2" GROUP="Dispersion"
#exec AUDIO IMPORT FILE="Sounds\dispersion\number3.WAV" NAME="number3" GROUP="Dispersion"
#exec AUDIO IMPORT FILE="Sounds\dispersion\number4.WAV" NAME="number4" GROUP="Dispersion"

var Sound PowerUpSounds[4];

event float BotDesireability( pawn Bot )
{
	local DispersionPistol D;

	D = DispersionPistol(Bot.FindInventoryType(class'DispersionPistol'));
	if ( (D == None) || (D.PowerLevel >=4) )
		return -1;
	else 
		return Super.BotDesireability(Bot);
}

auto state Pickup
{
	function BeginState()
	{
		BecomePickup();
		LoopAnim('AnimEnergy',0.4);		
	}
  
	function Touch( actor Other )
	{
		local DispersionPistol d;
		local Inventory Copy;

		if ( Pawn(Other)!=None && Pawn(Other).bIsPlayer)
		{
			d = DispersionPistol(Pawn(Other).FindInventoryType(class'DispersionPistol'));
			if ( (d != None) && (d.PowerLevel < 4) )
				ActivateSound = PowerUpSounds[d.PowerLevel];
			Level.Game.PickupQuery(Pawn(Other), Self);
		}
	}

}

defaultproperties
{
     PowerUpSounds(0)=Sound'UnrealShare.Dispersion.number1'
     PowerUpSounds(1)=Sound'UnrealShare.Dispersion.number2'
     PowerUpSounds(2)=Sound'UnrealShare.Dispersion.number3'
     PowerUpSounds(3)=Sound'UnrealShare.Dispersion.number4'
     PickupMessage="You got the Dispersion Pistol Powerup"
     RespawnTime=30.000000
     PickupViewMesh=Mesh'UnrealShare.WeaponPowerUpMesh'
     AnimSequence=AnimEnergy
     Mesh=Mesh'UnrealShare.WeaponPowerUpMesh'
     CollisionRadius=12.000000
}
