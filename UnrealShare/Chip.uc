//=============================================================================
// Chip.
//=============================================================================
class Chip extends Effects;

#exec MESH IMPORT MESH=ChipM ANIVFILE=MODELS\chip_a.3D DATAFILE=MODELS\chip_d.3D X=0 Y=0 Z=0
#exec MESH ORIGIN MESH=ChipM X=0 Y=0 Z=0 YAW=0
#exec MESH SEQUENCE MESH=ChipM SEQ=All       STARTFRAME=0   NUMFRAMES=4
#exec MESH SEQUENCE MESH=ChipM SEQ=Position1 STARTFRAME=0   NUMFRAMES=1
#exec MESH SEQUENCE MESH=ChipM SEQ=Position2 STARTFRAME=1   NUMFRAMES=1
#exec MESH SEQUENCE MESH=ChipM SEQ=Position3 STARTFRAME=2   NUMFRAMES=1
#exec MESH SEQUENCE MESH=ChipM SEQ=Position4 STARTFRAME=3   NUMFRAMES=1
#exec TEXTURE IMPORT NAME=Chip1 FILE=MODELS\chip.PCX GROUP=Skins
#exec MESHMAP SCALE MESHMAP=ChipM X=0.03 Y=0.03 Z=0.06
#exec MESHMAP SETTEXTURE MESHMAP=ChipM NUM=1 TEXTURE=Chip1

var bool bHasBounced;

auto state Flying
{
	simulated function HitWall( vector HitNormal, actor Wall )
	{
		local vector RealHitNormal;
	
		if ( bHasBounced && ((FRand() < 0.85) || (Velocity.Z > -50)) )
			bBounce = false;
		RealHitNormal = HitNormal;
		HitNormal = Normal(HitNormal + 0.4 * VRand());
		if ( (HitNormal Dot RealHitNormal) < 0 )
			HitNormal *= -0.5; 
		Velocity = 0.5 * (Velocity - 2 * HitNormal * (Velocity Dot HitNormal));
		RotationRate.Yaw = 100000 * 2 *FRand() - 100000;
		RotationRate.Pitch = 100000 * 2 *FRand() - 100000;
		RotationRate.Roll = 100000 * 2 *FRand() - 100000;	
		DesiredRotation = RotRand();		
		bHasBounced = True;
	}

	simulated function Landed( vector HitNormal )
	{
		local rotator RandRot;	

		SetPhysics(PHYS_None);
		RandRot = Rotation;
		RandRot.Pitch = 0;
		RandRot.Roll = 0;
		SetRotation(RandRot);
	}

	simulated function BeginState()
	{
		if (FRand()<0.25) PlayAnim('Position1');
		else if (FRand()<0.25) PlayAnim('Position2');
		else if (FRand()<0.25) PlayAnim('Position3');
		else PlayAnim('Position4');	
		Velocity = VRand()*200*FRand()+Vector(Rotation)*250;
		DesiredRotation = RotRand();		
		RotationRate.Yaw = 200000 * 2 *FRand() - 200000;
		RotationRate.Pitch = 200000 * 2 *FRand() - 200000;
		RotationRate.Roll = 200000 * 2 *FRand() - 200000;			
		DrawScale = FRand()*0.4 + 0.3;
	}
}

defaultproperties
{
     bNetOptional=True
     Physics=PHYS_Falling
     RemoteRole=ROLE_SimulatedProxy
     LifeSpan=3.000000
     DrawType=DT_Mesh
     Mesh=LodMesh'UnrealShare.ChipM'
     bUnlit=True
     bCollideWorld=True
     bBounce=True
     bFixedRotationDir=True
}
