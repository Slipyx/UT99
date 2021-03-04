//=============================================================================
// ExplodingWall.
//=============================================================================
class ExplodingWall extends Effects;

#exec Texture Import File=models\exp001.pcx  Name=s_Exp Mips=Off Flags=2

var() float ExplosionSize;
var() float ExplosionDimensions;
var() float WallParticleSize;
var() float WoodParticleSize;
var() float GlassParticleSize;
var() int NumWallChunks;
var() int NumWoodChunks;
var() int NumGlassChunks;
var() texture WallTexture;
var() texture WoodTexture;
var() texture GlassTexture;
var() int Health;
var() name ActivatedBy[5];
var() sound BreakingSound;
var() bool bTranslucentGlass;
var() bool bUnlitGlass;

function PreBeginPlay()
{
	DrawType = DT_None;
	Super.PreBeginPlay();
}

Auto State Exploding
{
	singular function Trigger( actor Other, pawn EventInstigator )
	{
		Explode(EventInstigator, Vector(Rotation));
	}

	singular function TakeDamage( int NDamage, Pawn instigatedBy, Vector hitlocation,
						Vector momentum, name damageType)
	{
		local int i;
		local bool bAbort;	

		if ( bOnlyTriggerable )
			return;
		
		if ( DamageType != 'All' )
		{
			bAbort = true;
			for ( i=0; i<5; i++ )	 
				if (DamageType==ActivatedBy[i]) bAbort=False;
			if ( bAbort )
				return;
		}
		Health -= NDamage;
		if ( Health <= 0 )
			Explode(instigatedBy, Momentum);
	}

	function Explode( pawn EventInstigator, vector Momentum)
	{
		local int i;
		local Fragment s;
		local actor A;

		if( Event != '' )
			foreach AllActors( class 'Actor', A, Event )
				A.Trigger( Instigator, Instigator );

		Instigator = EventInstigator;
		if ( Instigator != None )
			MakeNoise(1.0);
		
		PlaySound(BreakingSound, SLOT_None,2.0);
	
		for (i=0 ; i<NumWallChunks ; i++) 
		{
			s = Spawn( class 'WallFragments',,,Location+ExplosionDimensions*VRand());
			if ( s != None )
			{
				s.CalcVelocity(vect(0,0,0),ExplosionSize);
				s.DrawScale = WallParticleSize;
				s.Skin = WallTexture;
			}
		}
		for (i=0 ; i<NumWoodChunks ; i++) 
		{
			s = Spawn( class 'WoodFragments',,,Location+ExplosionDimensions*VRand());
			if ( s != None )
			{
				s.CalcVelocity(vect(0,0,0),ExplosionSize);
				s.DrawScale = WoodParticleSize;
				s.Skin = WoodTexture;
			}
		}
		for (i=0 ; i<NumGlassChunks ; i++) 
		{
			s = Spawn( class 'GlassFragments', Owner,,Location+ExplosionDimensions*VRand());
			if ( s != None )
			{
				s.CalcVelocity(Momentum, ExplosionSize);
				s.DrawScale = GlassParticleSize;
				s.Skin = GlassTexture;
				s.bUnlit = bUnlitGlass;
				if (bTranslucentGlass) s.Style = STY_Translucent;
			}
		}
		Destroy();
	}
}

defaultproperties
{
      ExplosionSize=200.000000
      ExplosionDimensions=120.000000
      WallParticleSize=1.000000
      WoodParticleSize=1.000000
      GlassParticleSize=1.000000
      NumWallChunks=10
      NumWoodChunks=3
      NumGlassChunks=0
      WallTexture=None
      WoodTexture=None
      GlassTexture=None
      Health=0
      ActivatedBy(0)="exploded"
      ActivatedBy(1)="None"
      ActivatedBy(2)="None"
      ActivatedBy(3)="None"
      ActivatedBy(4)="None"
      BreakingSound=None
      bTranslucentGlass=False
      bUnlitGlass=False
      bNetTemporary=False
      RemoteRole=ROLE_SimulatedProxy
      DrawType=DT_Sprite
      Texture=Texture'UnrealShare.s_Exp'
      DrawScale=0.300000
      CollisionRadius=32.000000
      CollisionHeight=32.000000
      bCollideActors=True
      bCollideWorld=True
      bProjTarget=True
}
