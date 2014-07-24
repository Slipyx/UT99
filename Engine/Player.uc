//=============================================================================
// Player: Corresponds to a real player (a local camera or remote net player).
// This is a built-in Unreal class and it shouldn't be modified.
//=============================================================================
class Player extends Object
	native
	noexport;

//-----------------------------------------------------------------------------
// Player properties.

// Internal.
var native const int vfOut;
var native const int vfExec;

// The actor this player controls.
var transient const playerpawn Actor;
var transient const console Console;

// Window input variables
var transient const bool bWindowsMouseAvailable;
var bool bShowWindowsMouse;
var bool bSuspendPrecaching;
var transient const float WindowsMouseX;
var transient const float WindowsMouseY;
var int CurrentNetSpeed;
var globalconfig int ConfiguredInternetSpeed, ConfiguredLanSpeed;
var byte SelectedCursor;

const IDC_ARROW=0;
const IDC_SIZEALL=1;
const IDC_SIZENESW=2;
const IDC_SIZENS=3;
const IDC_SIZENWSE=4;
const IDC_SIZEWE=5;
const IDC_WAIT=6;

defaultproperties
{
     ConfiguredInternetSpeed=10000
     ConfiguredLanSpeed=20000
}
