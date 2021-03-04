//=============================================================================
// TazerExplosion.
//=============================================================================
class TazerExplosion extends Effects;

#exec MESH IMPORT MESH=TazerExpl ANIVFILE=MODELS\tex_a.3D DATAFILE=MODELS\tex_d.3D X=0 Y=0 Z=0
#exec MESH ORIGIN MESH=TazerExpl X=0 Y=0 Z=0 YAW=0
#exec MESH SEQUENCE MESH=TazerExpl SEQ=All       STARTFRAME=0   NUMFRAMES=6
#exec MESH SEQUENCE MESH=TazerExpl SEQ=Explosion STARTFRAME=0   NUMFRAMES=6
#exec OBJ LOAD FILE=Textures\fireeffect3.utx PACKAGE=UnrealShare.Effect3
#exec MESHMAP SCALE MESHMAP=TazerExpl X=.4 Y=0.4 Z=0.8 YAW=128
#exec MESHMAP SETTEXTURE MESHMAP=TazerExpl NUM=1 TEXTURE=UnrealShare.Effect3.FireEffect3a 

var rotator NormUp;
var() float Damage;
var() float radius;
var() float MomentumTransfer;

simulated function AnimEnd()
{
	Destroy();
}

simulated function PostBeginPlay()
{
	if ( Level.NetMode != NM_DedicatedServer )
	{
		PlayAnim( 'Explosion', 1 );
		PlaySound (EffectSound1);
	}
	MakeNoise(1.0);				
}

defaultproperties
{
      NormUp=(Pitch=0,Yaw=0,Roll=0)
      Damage=40.000000
      Radius=120.000000
      MomentumTransfer=1400.000000
      EffectSound1=Sound'UnrealShare.flak.Explode1'
      RemoteRole=ROLE_SimulatedProxy
      LifeSpan=3.000000
      DrawType=DT_Mesh
      Mesh=LodMesh'UnrealShare.TazerExpl'
      bUnlit=True
}
