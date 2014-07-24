//=============================================================================
// ForceField.
//=============================================================================
class ForceField extends Pickup;

#exec AUDIO IMPORT FILE="..\UnrealShare\Sounds\Pickups\FFIELDA3.WAV" NAME="FieldSnd" GROUP="Pickups"
#exec AUDIO IMPORT FILE="..\UnrealShare\Sounds\Pickups\FFIELDh2.WAV" NAME="fFieldh2" GROUP="Pickups"

#exec TEXTURE IMPORT NAME=I_ForceField FILE=TEXTURES\HUD\i_force.PCX GROUP="Icons" MIPS=OFF

#exec MESH IMPORT MESH=ForceFieldPick ANIVFILE=MODELS\force2_a.3D DATAFILE=MODELS\force2_d.3D X=0 Y=0 Z=0
#exec MESH ORIGIN MESH=ForceFieldPick X=0 Y=0 Z=0 YAW=64
#exec MESH SEQUENCE MESH=ForceFieldPick SEQ=All STARTFRAME=0  NUMFRAMES=1
#exec TEXTURE IMPORT NAME=aforce1 FILE=MODELS\force2.PCX GROUP="Skins"
#exec OBJ LOAD FILE=..\UnrealShare\Textures\fireeffect27.utx  PACKAGE=UNREALI.Effect27
#exec MESHMAP SCALE MESHMAP=ForceFieldPick X=0.07 Y=0.07 Z=0.14
#exec MESHMAP SETTEXTURE MESHMAP=ForceFieldPick NUM=1 TEXTURE=aforce1
#exec MESHMAP SETTEXTURE MESHMAP=ForceFieldPick NUM=0 TEXTURE=Unreali.Effect27.FireEffect27

var vector X,Y,Z;	
var ForceFieldProj r;
var() localized String M_NoRoom;

state Activated
{
	function BeginState()
	{
		bStasis = false;
		GetAxes(Pawn(Owner).ViewRotation,X,Y,Z);
		r = Spawn(class'ForceFieldProj', Owner, '', Pawn(Owner).Location + 90.0 * X - 0 * Y - 0 * Z );
		if (r == None)
		{
			Owner.PlaySound(DeActivateSound);
			Pawn(Owner).ClientMessage(M_NoRoom);		
			GoToState('DeActivated');
		}
		else
		{
			r.Charge = Charge;
			Pawn(Owner).NextItem();
			if (Pawn(Owner).SelectedItem == Self) Pawn(Owner).SelectedItem=None;	
			Owner.PlaySound(ActivateSound);		
			Pawn(Owner).DeleteInventory(Self);		
		}
	}
}

state DeActivated
{
Begin:
}

defaultproperties
{
     M_NoRoom="No room to activate force field."
     bActivatable=True
     bDisplayableInv=True
     PickupMessage="You picked up the Force Field"
     RespawnTime=20.000000
     PickupViewMesh=LodMesh'UnrealI.ForceFieldPick'
     Charge=130
     PickupSound=Sound'UnrealShare.Pickups.GenPickSnd'
     ActivateSound=Sound'UnrealI.Pickups.FieldSnd'
     DeActivateSound=Sound'UnrealI.Pickups.fFieldh2'
     Icon=Texture'UnrealI.Icons.I_ForceField'
     RemoteRole=ROLE_DumbProxy
     Mesh=LodMesh'UnrealI.ForceFieldPick'
     AmbientGlow=78
     CollisionRadius=8.000000
     CollisionHeight=22.000000
}
