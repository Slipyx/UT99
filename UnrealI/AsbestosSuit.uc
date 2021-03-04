//=============================================================================
// AsbestosSuit.
//=============================================================================
class AsbestosSuit extends Suits;

#exec AUDIO IMPORT FILE="..\UnrealShare\Sounds\Pickups\SUIT1.WAV" NAME="SuitSnd" GROUP="Pickups"

#exec MESH IMPORT MESH=AsbSuit ANIVFILE=..\UnrealShare\MODELS\bSuit_a.3D DATAFILE=..\UnrealShare\MODELS\bSuit_d.3D X=0 Y=0 Z=0
#exec MESH ORIGIN MESH=AsbSuit X=0 Y=100 Z=40 YAW=64 ROLL=64
#exec MESH SEQUENCE MESH=AsbSuit SEQ=All STARTFRAME=0  NUMFRAMES=1
#exec TEXTURE IMPORT NAME=AAsbSuit1 FILE=MODELS\bAsbSuit.PCX GROUP="Skins"
#exec MESHMAP SCALE MESHMAP=AsbSuit X=0.04 Y=0.04 Z=0.08
#exec MESHMAP SETTEXTURE MESHMAP=AsbSuit NUM=1 TEXTURE=AAsbSuit1

defaultproperties
{
      PickupMessage="You picked up the Asbestos Suit"
      ProtectionType1="Burned"
      ProtectionType2="Frozen"
      Charge=50
      ArmorAbsorption=50
      bIsAnArmor=True
      AbsorptionPriority=6
      PickupSound=Sound'UnrealShare.Pickups.suitsnd'
      DrawType=DT_Mesh
      Mesh=LodMesh'UnrealShare.Suit'
      CollisionRadius=30.000000
      CollisionHeight=30.000000
}
