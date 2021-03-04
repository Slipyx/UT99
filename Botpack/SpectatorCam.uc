//=============================================================================
// SpectatorCam.
//=============================================================================
class SpectatorCam extends KeyPoint;

var() bool bSkipView; // spectators skip this camera when flipping through cams
var() float FadeOutTime;	// fade out time if used as EndCam

defaultproperties
{
      bSkipView=False
      FadeOutTime=5.000000
      bClientAnim=True
      bDirectional=True
      DrawType=DT_Mesh
      Texture=Texture'Engine.S_Camera'
      CollisionRadius=20.000000
      CollisionHeight=40.000000
}
