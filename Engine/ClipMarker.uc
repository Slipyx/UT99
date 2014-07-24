//=============================================================================
// ClipMarker.
//
// These are markers for the brush clip mode.  You place 2 or 3 of these in
// the level and that defines your clipping plane.
//
// These should NOT be manually added to the level.  The editor adds and
// deletes them on it's own.
//
//=============================================================================
class ClipMarker extends Keypoint
	native;

#exec Texture Import File=Textures\S_ClipMarker.pcx Name=S_ClipMarker Mips=Off Flags=2
#exec Texture Import File=Textures\S_ClipMarker1.pcx Name=S_ClipMarker1 Mips=Off Flags=2
#exec Texture Import File=Textures\S_ClipMarker2.pcx Name=S_ClipMarker2 Mips=Off Flags=2
#exec Texture Import File=Textures\S_ClipMarker3.pcx Name=S_ClipMarker3 Mips=Off Flags=2

defaultproperties
{
     bEdShouldSnap=True
     Texture=Texture'Engine.S_ClipMarker'
}
