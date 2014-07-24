//=============================================================================
// UT_Sparks.
//=============================================================================
class UT_Sparks extends Effects;

#exec MESH IMPORT MESH=SparksM ANIVFILE=..\unrealshare\MODELS\blood2_a.3D DATAFILE=..\unrealshare\MODELS\blood2_d.3D X=0 Y=0 Z=0 ZEROTEX=1
#exec MESH ORIGIN MESH=SparksM X=0 Y=0 Z=0 YAW=128
#exec MESH SEQUENCE MESH=SparksM SEQ=All       STARTFRAME=0   NUMFRAMES=45
#exec MESH SEQUENCE MESH=SparksM SEQ=Spray     STARTFRAME=0   NUMFRAMES=6
#exec MESH SEQUENCE MESH=SparksM SEQ=Still     STARTFRAME=6   NUMFRAMES=1
#exec MESH SEQUENCE MESH=SparksM SEQ=GravSpray STARTFRAME=7   NUMFRAMES=5
#exec MESH SEQUENCE MESH=SparksM SEQ=Stream    STARTFRAME=12  NUMFRAMES=11
#exec MESH SEQUENCE MESH=SparksM SEQ=Trail     STARTFRAME=23  NUMFRAMES=11
#exec MESH SEQUENCE MESH=SparksM SEQ=Burst     STARTFRAME=34  NUMFRAMES=2
#exec MESH SEQUENCE MESH=SparksM SEQ=GravSpray2 STARTFRAME=36 NUMFRAMES=7

#exec MESHMAP SCALE MESHMAP=SparksM X=0.1 Y=0.1 Z=0.2
#exec MESHMAP SETTEXTURE MESHMAP=SparksM NUM=0  TEXTURE=Botpack.Effects.Sparky

simulated function PostBeginPlay()
{
	Super.PostBeginPlay();
	PlayAnim('GravSpray');
}
	
simulated function Landed( vector HitNormal )
{
	Destroy();
}

simulated function HitWall( vector HitNormal, actor Wall )
{
	Destroy();
}

simulated function ZoneChange( ZoneInfo NewZone )
{
	if ( NewZone.bWaterZone )
		Destroy();
}

defaultproperties
{
     Physics=PHYS_Falling
     RemoteRole=ROLE_None
     LifeSpan=1.000000
     AnimSequence=GravSpray
     DrawType=DT_Mesh
     Style=STY_Translucent
     Texture=Texture'Botpack.Effects.Sparky'
     Mesh=LodMesh'Botpack.SparksM'
     DrawScale=0.100000
     bUnlit=True
     bParticles=True
     bCollideWorld=True
}
