//=============================================================================
// HomeBase.
//=============================================================================
class HomeBase extends NavigationPoint;

#exec Texture Import File=Textures\Flag1.pcx Name=S_Flag Mips=Off Flags=2

var() float extent; //how far the base extends from central point (in line of sight)
var	 vector lookdir; //direction to look while stopped

function PreBeginPlay()
{
	lookdir = 200 * vector(Rotation);
	Super.PreBeginPlay();
}

defaultproperties
{
     Extent=700.000000
     Texture=Texture'Engine.S_Flag'
     SoundVolume=128
}
