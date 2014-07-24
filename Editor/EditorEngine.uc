//=============================================================================
// EditorEngine: The UnrealEd subsystem.
// This is a built-in Unreal class and it shouldn't be modified.
//=============================================================================
class EditorEngine extends Engine
	native
	noexport
	transient;

#exec Texture Import File=Textures\B_MenuDn.pcx Mips=Off
#exec Texture Import File=Textures\B_MenuUp.pcx Mips=Off
#exec Texture Import File=Textures\B_CollOn.pcx Mips=Off
#exec Texture Import File=Textures\B_CollOf.pcx Mips=Off
#exec Texture Import File=Textures\B_PlyrOn.pcx Mips=Off
#exec Texture Import File=Textures\B_PlyrOf.pcx Mips=Off
#exec Texture Import File=Textures\B_LiteOn.pcx Mips=Off
#exec Texture Import File=Textures\B_LiteOf.pcx Mips=Off

#exec Texture Import File=Textures\Bad.pcx
#exec Texture Import File=Textures\Bkgnd.pcx
#exec Texture Import File=Textures\BkgndHi.pcx

// Objects.
var const int         NotifyVtbl;
var const level       Level;
var const model       TempModel;
var const texture     CurrentTexture;
var const class       CurrentClass;
var const transbuffer Trans;
var const textbuffer  Results;
var const int         Pad[8];

// Icons.
var const texture MenuUp, MenuDn;
var const texture CollOn, CollOff;
var const texture PlyrOn, PlyrOff;
var const texture LiteOn, LiteOff;

// Textures.
var const texture Bad, Bkgnd, BkgndHi;

// Toggles.
var const bool bFastRebuild, bBootstrapping;

// Other variables.
var const config int AutoSaveIndex;
var const int AutoSaveCount, Mode, ClickFlags;
var const float MovementSpeed;
var const package PackageContext;
var const vector AddLocation;
var const plane AddPlane;

// Misc.
var const array<Object> Tools;
var const class BrowseClass;

// Grid.
var const int ConstraintsVtbl;
var(Grid) config bool GridEnabled;
var(Grid) config bool SnapVertices;
var(Grid) config bool AffectRegion;
var(Grid) config bool TextureLock;
var(Grid) config bool SelectionLock;
var(Grid) config float SnapDistance;
var(Grid) config vector GridSize;

// Rotation grid.
var(RotationGrid) config bool RotGridEnabled;
var(RotationGrid) config rotator RotGridSize;

// Advanced.
var(Advanced) config float FovAngleDegrees;
var(Advanced) config bool GodMode;
var(Advanced) config bool AutoSave;
var(Advanced) config byte AutosaveTimeMinutes;
var(Advanced) config string GameCommandLine;
var(Advanced) config array<string> EditPackages;

// Color preferences.
var(Colors) config color
	C_WorldBox,
	C_GroundPlane,
	C_GroundHighlight,
	C_BrushWire,
	C_Pivot,
	C_Select,
	C_Current,
	C_AddWire,
	C_SubtractWire,
	C_GreyWire,
	C_BrushVertex,
	C_BrushSnap,
	C_Invalid,
	C_ActorWire,
	C_ActorHiWire,
	C_Black,
	C_White,
	C_Mask,
	C_SemiSolidWire,
	C_NonSolidWire,
	C_WireBackground,
	C_WireGridAxis,
	C_ActorArrow,
	C_ScaleBox,
	C_ScaleBoxHi,
	C_ZoneWire,
	C_Mover,
	C_OrthoBackground;

defaultproperties
{
     MenuUp=Texture'Editor.B_MenuUp'
     MenuDn=Texture'Editor.B_MenuDn'
     CollOn=Texture'Editor.B_CollOn'
     CollOff=Texture'Editor.B_CollOf'
     PlyrOn=Texture'Editor.B_PlyrOn'
     PlyrOff=Texture'Editor.B_PlyrOf'
     LiteOn=Texture'Editor.B_LiteOn'
     Bad=Texture'Editor.Bad'
     Bkgnd=Texture'Editor.Bkgnd'
     BkgndHi=Texture'Editor.BkgndHi'
     AutoSaveIndex=6
     GridEnabled=True
     SnapVertices=True
     SnapDistance=10.000000
     GridSize=(X=16.000000,Y=16.000000,Z=16.000000)
     RotGridEnabled=True
     RotGridSize=(Pitch=1024,Yaw=1024,Roll=1024)
     FovAngleDegrees=90.000000
     GodMode=True
     AutosaveTimeMinutes=5
     GameCommandLine="-log"
     EditPackages=("Core","Engine","Editor","UWindow","Fire","IpDrv","UWeb","UBrowser","UnrealShare","UnrealI","UMenu","IpServer","Botpack","UTServerAdmin","UTMenu","UTBrowser","SlMod")
     C_WorldBox=(B=107)
     C_GroundPlane=(B=63)
     C_GroundHighlight=(B=127)
     C_BrushWire=(R=255,G=63,B=63)
     C_Pivot=(G=255)
     C_Select=(B=127)
     C_AddWire=(R=127,G=127,B=255)
     C_SubtractWire=(R=255,G=192,B=63)
     C_GreyWire=(R=163,G=163,B=163)
     C_Invalid=(R=163,G=163,B=163)
     C_ActorWire=(R=127,G=63)
     C_ActorHiWire=(R=255,G=127)
     C_White=(R=255,G=255,B=255)
     C_SemiSolidWire=(R=127,G=255)
     C_NonSolidWire=(R=63,G=192,B=32)
     C_WireGridAxis=(R=119,G=119,B=119)
     C_ActorArrow=(R=163)
     C_ScaleBox=(R=151,G=67,B=11)
     C_ScaleBoxHi=(R=223,G=149,B=157)
     C_Mover=(R=255,B=255)
     C_OrthoBackground=(R=163,G=163,B=163)
     CacheSizeMegs=6
}
