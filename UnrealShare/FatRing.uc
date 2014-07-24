//=============================================================================
// FatRing.
//=============================================================================
class FatRing extends Effects;

#exec MESH IMPORT MESH=FatRingM ANIVFILE=MODELS\Ring_a.3D DATAFILE=MODELS\Ring_d.3D  LODSTYLE=8
#exec MESH ORIGIN MESH=FatRingM X=0 Y=0 Z=0 PITCH=64
#exec MESH SEQUENCE MESH=FatRingM SEQ=All      STARTFRAME=0   NUMFRAMES=16
#exec MESH SEQUENCE MESH=FatRingM SEQ=Explosion STARTFRAME=0   NUMFRAMES=11
#exec MESH SEQUENCE MESH=FatRingM SEQ=SmallExp  STARTFRAME=11  NUMFRAMES=5
#exec OBJ LOAD FILE=Textures\fireeffect5.utx PACKAGE=UnrealShare.Effect5
#exec MESHMAP SCALE MESHMAP=FatRingM X=0.5 Y=0.5 Z=1.0 
#exec MESHMAP SETTEXTURE MESHMAP=FatRingM NUM=1 TEXTURE=UnrealShare.Effect5.FireEffect5

#exec AUDIO IMPORT FILE="Sounds\general\Explo4a.WAV" NAME="FatRingSound" GROUP="General"

simulated function Timer()
{
	if (LightBrightness>60) LightBrightness-=60;
}


simulated function PostBeginPlay()
{
	Super.PostBeginPlay();

	if ( Level.NetMode != NM_DedicatedServer )
	{
		SetTimer(0.1,True);
		PlayAnim  ( 'Explosion', 1 );
		PlaySound (EffectSound1,,3.0);	
	}
	MakeNoise ( 1.0 );
}

simulated function AnimEnd()
{
	Destroy();
}

defaultproperties
{
     EffectSound1=Sound'UnrealShare.General.FatRingSound'
     RemoteRole=ROLE_SimulatedProxy
     LifeSpan=4.000000
     DrawType=DT_Mesh
     Mesh=LodMesh'UnrealShare.FatRingM'
     AmbientGlow=97
     LightType=LT_Steady
     LightBrightness=255
     LightHue=25
     LightSaturation=53
     LightRadius=19
}
