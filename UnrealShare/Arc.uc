//=============================================================================
// Arc.
//=============================================================================
class Arc extends Projectile;

var() texture SpriteAnim[8];

#exec TEXTURE IMPORT NAME=Arc1 FILE=MODELS\proa1.pcx GROUP=Effects
#exec TEXTURE IMPORT NAME=Arc2 FILE=MODELS\proa2.pcx GROUP=Effects
#exec TEXTURE IMPORT NAME=Arc3 FILE=MODELS\proa3.pcx GROUP=Effects
#exec TEXTURE IMPORT NAME=Arc4 FILE=MODELS\proa4.pcx GROUP=Effects
#exec TEXTURE IMPORT NAME=Arc5 FILE=MODELS\proa5.pcx GROUP=Effects
#exec TEXTURE IMPORT NAME=Arc6 FILE=MODELS\proa6.pcx GROUP=Effects
#exec TEXTURE IMPORT NAME=Arc7 FILE=MODELS\proa7.pcx GROUP=Effects
#exec TEXTURE IMPORT NAME=Arc8 FILE=MODELS\proa8.pcx GROUP=Effects


#exec MESH IMPORT MESH=arcM ANIVFILE=MODELS\cros_s_a.3D DATAFILE=MODELS\cros_s_d.3D X=0 Y=0 Z=0  ZEROTEX=1
#exec MESH ORIGIN MESH=arcM X=0 Y=0 Z=0 YAW=64
#exec MESH SEQUENCE MESH=arcM SEQ=All  STARTFRAME=0  NUMFRAMES=1
#exec MESH SEQUENCE MESH=arcM SEQ=Still  STARTFRAME=0   NUMFRAMES=1
#exec MESHMAP SCALE MESHMAP=arcM X=0.1 Y=0.1 Z=0.2
#exec MESHMAP SETTEXTURE MESHMAP=arcM NUM=0 TEXTURE=Arc1

var int i;
var vector X,Y,Z;

	function PreBeginPlay()
	{
		Super.PreBeginPlay();
		i=0;
		GetAxes(Instigator.ViewRotation,X,Y,Z);	
		Velocity = VSize(Instigator.Velocity)*X + Vector(Rotation) * speed;
	}

	simulated function Tick(float DeltaTime)
	{
		if ( Level.NetMode != NM_DedicatedServer )
			Skin = SpriteAnim[i];
		i++;
		if (i==8) i=0;
	}

	simulated function HitWall( vector HitNormal, actor Wall )
	{
		Destroy();
	}

defaultproperties
{
     SpriteAnim(0)=Texture'UnrealShare.Effects.Arc1'
     SpriteAnim(1)=Texture'UnrealShare.Effects.Arc2'
     SpriteAnim(2)=Texture'UnrealShare.Effects.Arc3'
     SpriteAnim(3)=Texture'UnrealShare.Effects.Arc4'
     SpriteAnim(4)=Texture'UnrealShare.Effects.Arc5'
     SpriteAnim(5)=Texture'UnrealShare.Effects.Arc6'
     SpriteAnim(6)=Texture'UnrealShare.Effects.Arc7'
     SpriteAnim(7)=Texture'UnrealShare.Effects.Arc8'
     Skin=Texture'UnrealShare.Effects.Arc1'
     Mesh=LodMesh'UnrealShare.arcM'
}
