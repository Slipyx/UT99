//=============================================================================
// PathPoint.
//=============================================================================
class PathPoint extends Keypoint;

var() int    sequence_Number;		// to order the points
var() float  curveSpeed;			// how fast the object must move at this point (affects shape of path, not really speed)
var() float  speedU;				// speed factor, a value of 1 will travel through the segment in 1 second, 0 stop, 2 in 1/2 second, etc..
var   vector pVelocity;			// calculated internally, the velocity at this point

defaultproperties
{
      sequence_Number=0
      curveSpeed=0.000000
      speedU=0.000000
      pVelocity=(X=0.000000,Y=0.000000,Z=0.000000)
}
