//=============================================================================
// QueenShield.
//=============================================================================
class QueenShield extends Effects;

#exec MESH IMPORT MESH=Spot ANIVFILE=MODELS\spot_a.3D DATAFILE=MODELS\spot_d.3D X=0 Y=0 Z=0
#exec MESH ORIGIN MESH=Spot X=0 Y=0 Z=0 PITCH=-64
#exec MESH SEQUENCE MESH=Spot SEQ=All       STARTFRAME=0   NUMFRAMES=2
#exec MESH SEQUENCE MESH=Spot SEQ=Explo     STARTFRAME=0   NUMFRAMES=2
#exec MESHMAP SCALE MESHMAP=Spot X=0.3 Y=0.3 Z=0.6
#exec OBJ LOAD FILE=textures\stshield.utx PACKAGE=UNREALI.STEffect
#exec MESHMAP SETTEXTURE MESHMAP=Spot NUM=1 TEXTURE=Unreali.STEffect.STShield

#exec TEXTURE IMPORT NAME=ExplosionPal3 FILE=..\UnrealShare\textures\expal2.pcx GROUP=Effects

function touch( Actor Other )
{
	if ( !Other.IsA('Projectile') && (Other != Instigator) )
		Destroy();
}

defaultproperties
{
      bNetTemporary=False
      LifeSpan=5.000000
      DrawType=DT_Mesh
      Skin=Texture'UnrealShare.Effects.ExplosionPal3'
      Mesh=LodMesh'UnrealI.Spot'
      bUnlit=True
      CollisionRadius=80.000000
      CollisionHeight=80.000000
      bCollideActors=True
      bProjTarget=True
      LightType=LT_TexturePaletteOnce
      LightEffect=LE_NonIncidence
}
