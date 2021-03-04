//=============================================================================
// SmokePuff.
//=============================================================================
class SmokePuff extends Effects;

#exec MESH IMPORT MESH=SmokePuffM ANIVFILE=MODELS\puff_a.3D DATAFILE=MODELS\puff_d.3D X=0 Y=0 Z=0
#exec MESH ORIGIN MESH=SmokePuffM X=0 Y=0 Z=0 YAW=0
#exec MESH SEQUENCE MESH=SmokePuffM SEQ=All     STARTFRAME=0   NUMFRAMES=2
#exec MESH SEQUENCE MESH=SmokePuffM SEQ=Puff    STARTFRAME=0   NUMFRAMES=2
#exec OBJ LOAD FILE=Textures\SmokeEffect1.utx PACKAGE=UNREALSHARE.SEffect1
#exec MESHMAP SCALE MESHMAP=SmokePuffM X=0.03 Y=0.03 Z=0.06
#exec MESHMAP SETTEXTURE MESHMAP=SmokePuffM NUM=1 TEXTURE=UnrealShare.SEffect1.Smoke1


simulated function PostBeginPlay()
{
	Super.PostBeginPlay();
	if ( Level.Netmode != NM_DedicatedServer )
		PlayAnim( 'Puff', 0.3);	
}

simulated function AnimEnd()
{
	Destroy();
}

defaultproperties
{
      bNetOptional=True
      RemoteRole=ROLE_SimulatedProxy
      LifeSpan=3.000000
      DrawType=DT_Mesh
      Mesh=LodMesh'UnrealShare.SmokePuffM'
}
