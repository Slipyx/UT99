//=============================================================================
// Fan2.
//=============================================================================
class Fan2 extends Decoration;

#exec MESH IMPORT MESH=Fan2M ANIVFILE=MODELS\fan2_a.3D DATAFILE=MODELS\fan2_d.3D X=0 Y=0 Z=0
#exec MESH ORIGIN MESH=Fan2M X=0 Y=-300 Z=0 YAW=64

#exec MESH SEQUENCE MESH=fan2M SEQ=All    STARTFRAME=0   NUMFRAMES=1
#exec MESH SEQUENCE MESH=fan2M SEQ=Still  STARTFRAME=0   NUMFRAMES=1


#exec TEXTURE IMPORT NAME=JFan21 FILE=MODELS\fan2.PCX GROUP=Skins FLAGS=2

#exec MESHMAP SCALE MESHMAP=Fan2M X=0.1 Y=0.1 Z=0.2
#exec MESHMAP SETTEXTURE MESHMAP=fan2M NUM=1 TEXTURE=Jfan21


auto state active
{
	function TakeDamage( int NDamage, Pawn instigatedBy, Vector hitlocation, 
						Vector momentum, name damageType)
	{
		if (bStatic || bDeleteme)
			return;	
		Instigator = InstigatedBy;
		if ( Instigator != None )
			MakeNoise(1.0);
		skinnedFrag(class'Fragment1',texture'JFan21', Momentum,2.0, 9);
	}

Begin:
}

defaultproperties
{
      bStatic=False
      Physics=PHYS_Rotating
      RemoteRole=ROLE_SimulatedProxy
      DrawType=DT_Mesh
      Mesh=LodMesh'UnrealShare.Fan2M'
      CollisionRadius=44.000000
      CollisionHeight=44.000000
      bCollideActors=True
      bCollideWorld=True
      bProjTarget=True
      bFixedRotationDir=True
      RotationRate=(Roll=20000)
      DesiredRotation=(Roll=1)
}
