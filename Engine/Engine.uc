//=============================================================================
// Engine: The base class of the global application object classes.
// This is a built-in Unreal class and it shouldn't be modified.
//=============================================================================
class Engine extends Subsystem
	native
	noexport
	transient;

// Drivers.
var config class<RenderDevice>   GameRenderDevice;
var(Drivers) config class<AudioSubsystem> AudioDevice;
var(Drivers) config class<Console>        Console;
var(Drivers) config class<NetDriver>      NetworkDevice;
var(Drivers) config class<Language>       Language;

// Variables.
var primitive Cylinder;
var const client Client;
var const renderbase Render;
var const audiosubsystem Audio;
var int TickCycles, GameCycles, ClientCycles;
var(Settings) config int CacheSizeMegs;

// DO NOT PUT ANOTHER BOOL RIGHT NEXT TO "UseSound"! Just take my word for it.
var(Settings) config bool UseSound;
// DO NOT PUT ANOTHER BOOL RIGHT NEXT TO "UseSound"! Just take my word for it.

var(Settings) float CurrentTickRate;

var config int MinClientVersion; //UTPG: configured min client version

// UTPG/OldUnreal MD5
var string                    MD5ErrorMsg;        // UTPG: message to show below "Connection Failed"
var(MD5) config bool          MD5Enable;          // OldUnreal: Enable MD5 checking on the server?
var(MD5) config array<string> MD5Ignore;          // UTPG: Files to exclude from the list of requested checksums
var(MD5) config bool          MD5AutoUpdate;      // OldUnreal: Automatically update the Packages.md5 file?
var(MD5) config string        MD5UpdateURL;       // OldUnreal: Web server to download Packages.md5 updates from
var(MD5) config int           MD5Version;         // OldUnreal: current version of the Packages.md5 file
var(MD5) config int           MD5LastUpdateCheck; // OldUnreal: timestamp of the last update check

defaultproperties
{
      GameRenderDevice=None
      AudioDevice=None
      Console=None
      NetworkDevice=None
      Language=None
      Cylinder=None
      Client=None
      Render=None
      Audio=None
      TickCycles=0
      GameCycles=0
      ClientCycles=0
      CacheSizeMegs=2
      UseSound=True
      CurrentTickRate=0.000000
      MinClientVersion=0
      MD5ErrorMsg=""
      MD5Enable=False
      MD5Ignore=()
      MD5AutoUpdate=True
      MD5UpdateURL=""
      MD5Version=0
      MD5LastUpdateCheck=0
}
