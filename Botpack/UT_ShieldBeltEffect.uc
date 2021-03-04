//=============================================================================
// UT_ShieldBeltEffect.
//=============================================================================
class UT_ShieldBeltEffect extends Effects;

var Texture LowDetailTexture;
var int FatnessOffset;

simulated function Destroyed()
{
	if ( bHidden && (Owner != None) )
	{
		if ( Level.NetMode == NM_Client )
		{
			Owner.Texture = Owner.Default.Texture;
			Owner.bMeshEnviromap = Owner.Default.bMeshEnviromap;
		}
		else
			Owner.SetDefaultDisplayProperties();
	}
	Super.Destroyed();
}

simulated function PostBeginPlay()
{
	if ( !Level.bHighDetailMode && ((Level.NetMode == NM_Standalone) || (Level.NetMode == NM_Client)) )
	{
		Timer();
		bHidden = true;
		SetTimer(1.0, true);
	}
}

simulated function Timer()
{
	local int TeamNum;

	bHidden = true;
	if ( Pawn(Owner) == None )
		return;
	if ( Pawn(Owner).PlayerReplicationInfo == None )
		TeamNum = 3;
	else
		TeamNum = Min(3, Pawn(Owner).PlayerReplicationInfo.Team);
	LowDetailTexture = class'UT_Shieldbelt'.Default.TeamTextures[TeamNum];
	if ( Level.NetMode == NM_Client )
	{
		Owner.Texture = LowDetailTexture;
		Owner.bMeshEnviromap = true;
	}
	else
		Owner.SetDisplayProperties(Owner.Style, LowDetailTexture, false, true);
}

simulated function Tick(float DeltaTime)
{
	local int IdealFatness;

	if ( bHidden || (Level.NetMode == NM_DedicatedServer) || (Owner == None) )
	{
		Disable('Tick');
		return;
	}

	if ( Owner != None )
	{
	    IdealFatness = Owner.Fatness; // Convert to int for safety.
		bHidden = Owner.bHidden;
		PrePivot = Owner.PrePivot;
		Mesh = Owner.Mesh;
		DrawScale = Owner.DrawScale;
	}
	IdealFatness += FatnessOffset;

	if ( Fatness > IdealFatness )
		Fatness = Max(IdealFatness, Fatness - 130 * DeltaTime);
	else
		Fatness = Min(IdealFatness, 255);
}

defaultproperties
{
      LowDetailTexture=Texture'UnrealShare.Belt_fx.ShieldBelt.newgold'
      FatnessOffset=29
      bAnimByOwner=True
      bOwnerNoSee=True
      bNetTemporary=False
      bTrailerSameRotation=True
      Physics=PHYS_Trailer
      RemoteRole=ROLE_SimulatedProxy
      DrawType=DT_Mesh
      Style=STY_Translucent
      Texture=FireTexture'UnrealShare.Belt_fx.ShieldBelt.N_Shield'
      ScaleGlow=0.500000
      AmbientGlow=64
      Fatness=157
      bUnlit=True
      bMeshEnviroMap=True
}
