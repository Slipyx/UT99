//=============================================================================
// SuperHealth.
//=============================================================================
class SuperHealth extends Health;

#exec MESH IMPORT MESH=SuperHealthMesh ANIVFILE=MODELS\sheal_a.3D DATAFILE=MODELS\sheal_d.3D LODSTYLE=8
#exec MESH LODPARAMS MESH=SuperHealthMesh STRENGTH=0.6
#exec  MESH ORIGIN MESH=SuperHealthMesh X=0 Y=0 Z=0 ROLL=128
#exec  MESH SEQUENCE MESH=SuperHealthMesh SEQ=All    STARTFRAME=0  NUMFRAMES=1
#exec  TEXTURE IMPORT NAME=Jshealth1 FILE=MODELS\shealth.PCX GROUP="Skins" 
#exec OBJ LOAD FILE=Textures\WaterEffect1.utx  PACKAGE=UnrealShare.WEffect1
#exec  MESHMAP SCALE MESHMAP=SuperHealthMesh X=0.04 Y=0.04 Z=0.08
#exec  MESHMAP SETTEXTURE MESHMAP=SuperHealthMesh NUM=1 TEXTURE=Jshealth1
#exec  MESHMAP SETTEXTURE MESHMAP=SuperHealthMesh NUM=0 TEXTURE=UnrealShare.WEffect1.WaterEffect1

function PlayPickupMessage(Pawn Other)
{
	Other.ClientMessage(PickupMessage, 'Pickup');
}

defaultproperties
{
     HealingAmount=100
     bSuperHeal=True
     PickupMessage="You picked up the Super Health Pack"
     RespawnTime=100.000000
     PickupViewMesh=LodMesh'UnrealShare.SuperHealthMesh'
     MaxDesireability=1.000000
     Texture=None
     Mesh=LodMesh'UnrealShare.SuperHealthMesh'
     CollisionRadius=16.000000
     CollisionHeight=19.500000
}
