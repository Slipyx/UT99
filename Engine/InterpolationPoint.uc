//=============================================================================
// InterpolationPoint.
//=============================================================================
class InterpolationPoint extends Keypoint
	native;

// Sprite.
#exec Texture Import File=Textures\IntrpPnt.pcx Name=S_Interp Mips=Off Flags=2

// Number in sequence sharing this tag.
var() int    Position;
var() float  RateModifier;
var() float  GameSpeedModifier;
var() float  FovModifier;
var() bool   bEndOfPath;
var() bool   bSkipNextPath;
var() float  ScreenFlashScale;
var() vector ScreenFlashFog;

// Other points in this interpolation path.
var InterpolationPoint Prev, Next;

//
// At start of gameplay, link all matching interpolation points together.
//
function BeginPlay()
{
	Super.BeginPlay();

	// Try to find previous.
	foreach AllActors( class 'InterpolationPoint', Prev, Tag )
		if( Prev.Position == Position-1 )
			break;
	if( Prev != None )
		Prev.Next = Self;

	// Try to find next.
	foreach AllActors( class 'InterpolationPoint', Next, Tag )
		if( Next.Position == Position+1 )
			break;
	if( Next == None )
		foreach AllActors( class 'InterpolationPoint', Next, Tag )
			if( Next.Position == 0 )
				break;
	if( Next != None )
		Next.Prev = Self;
}

//
// Verify that we're linked up.
//
function PostBeginPlay()
{
	Super.PostBeginPlay();
	//log( "Interpolation point" @ Tag @ Position $ ":" );
	//if( Prev != None )
	//	log( "   Prev # " $ Prev.Position );
	//if( Next != None )
	//	log( "   Next # " $ Next.Position );
}

//
// When reach an interpolation point.
//
function InterpolateEnd( actor Other )
{
	if( bEndOfPath )	
	{
		if( Pawn(Other)!=None && Pawn(Other).bIsPlayer )
		{
			Other.bCollideWorld = True;
			Other.bInterpolating = false;
			if ( Pawn(Other).Health > 0 )
			{
				Other.SetCollision(true,true,true);
				Other.SetPhysics(PHYS_Falling);
				Other.AmbientSound = None;
				if ( Other.IsA('PlayerPawn') )
					Other.GotoState('PlayerWalking');
			}
		}
	}
}

defaultproperties
{
      Position=0
      RateModifier=1.000000
      GameSpeedModifier=1.000000
      FovModifier=1.000000
      bEndOfPath=False
      bSkipNextPath=False
      ScreenFlashScale=1.000000
      ScreenFlashFog=(X=0.000000,Y=0.000000,Z=0.000000)
      Prev=None
      Next=None
      bStatic=False
      bDirectional=True
      Texture=Texture'Engine.S_Interp'
}
