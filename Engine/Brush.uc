//=============================================================================
// The brush class.
// This is a built-in Unreal class and it shouldn't be modified.
//=============================================================================
class Brush extends Actor
	native;

//-----------------------------------------------------------------------------
// Variables.

// CSG operation performed in editor.
var() enum ECsgOper
{
	CSG_Active,			// Active brush.
	CSG_Add,			// Add to world.
	CSG_Subtract,		// Subtract from world.
	CSG_Intersect,		// Form from intersection with world.
	CSG_Deintersect,	// Form from negative intersection with world.
} CsgOper;

// Outdated.
var const object UnusedLightMesh;
var vector  PostPivot;

// Scaling.
var() scale MainScale;
var() scale PostScale;
var scale   TempScale;

// Information.
var() color BrushColor;
var() int	PolyFlags;
var() bool  bColored;

defaultproperties
{
      CsgOper=CSG_Active
      UnusedLightMesh=None
      PostPivot=(X=0.000000,Y=0.000000,Z=0.000000)
      MainScale=(Scale=(X=1.000000,Y=1.000000,Z=1.000000),SheerRate=0.000000,SheerAxis=SHEER_None)
      PostScale=(Scale=(X=1.000000,Y=1.000000,Z=1.000000),SheerRate=0.000000,SheerAxis=SHEER_None)
      TempScale=(Scale=(X=1.000000,Y=1.000000,Z=1.000000),SheerRate=0.000000,SheerAxis=SHEER_None)
      BrushColor=(R=0,G=0,B=0,A=0)
      PolyFlags=0
      bColored=False
      bStatic=True
      bHidden=True
      bNoDelete=True
      bEdShouldSnap=True
      DrawType=DT_Brush
      bFixedRotationDir=True
}
