//=============================================================================
// WaveTexture: Simple phongish water surface.
// This is a built-in Unreal class and it shouldn't be modified.
//=============================================================================

class WaveTexture extends WaterTexture
	native
	noexport;

var(WaterPaint)			byte   BumpMapLight;
var(WaterPaint)			byte   BumpMapAngle;
var(WaterPaint)			byte   PhongRange;
var(WaterPaint)			byte   PhongSize;

defaultproperties
{
}
