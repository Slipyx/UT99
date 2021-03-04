//=============================================================================
// FlakShellAmmo.
//=============================================================================
class FlakShellAmmo extends FlakBox;

#exec MESH IMPORT MESH=FlakShAm ANIVFILE=MODELS\FlakSh_a.3D DATAFILE=MODELS\FlakSh_d.3D X=0 Y=0 Z=0
#exec MESH ORIGIN MESH=FlakShAm X=0 Y=0 Z=0 ROLL=-64
#exec MESH SEQUENCE MESH=FlakShAm SEQ=All   STARTFRAME=0   NUMFRAMES=1
#exec MESH SEQUENCE MESH=FlakShAm SEQ=Still  STARTFRAME=0   NUMFRAMES=1
#exec TEXTURE IMPORT NAME=JFlakShel1 FILE=..\unrealshare\MODELS\FlakShel.PCX
#exec MESHMAP SCALE MESHMAP=FlakShAm X=0.2 Y=0.2 Z=0.4
#exec MESHMAP SETTEXTURE MESHMAP=FlakShAm NUM=1 TEXTURE=JFlakShel1

defaultproperties
{
      AmmoAmount=1
      ParentAmmo=Class'UnrealI.FlakBox'
      PickupMessage="You got a flak shell."
      PickupViewMesh=LodMesh'UnrealI.FlakShAm'
      Mesh=LodMesh'UnrealI.FlakShAm'
      CollisionRadius=10.000000
      CollisionHeight=8.000000
}
