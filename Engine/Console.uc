//=============================================================================
// Console: A player console, associated with a viewport.
// This is a built-in Unreal class and it shouldn't be modified.
//=============================================================================
class Console extends Object
	native
	noexport
	transient;

// Imports.
#exec Texture Import NAME=ConsoleBack File=Textures\Console.pcx
#exec Texture Import File=Textures\Border.pcx

// Internal.
var private const pointer vtblOut;

// Constants.
const MaxBorder=6;
const MaxLines=64;
const MaxHistory=16;
const TextMsgSize=128;

// Variables.
var viewport Viewport;
var int HistoryTop, HistoryBot, HistoryCur;
var string TypedStr, History[16];
var int Scrollback, NumLines, TopLine, TextLines;
var float MsgTime, MsgTickTime;
var string MsgText[64];
var name MsgType[64];
var PlayerReplicationInfo MsgPlayer[64];
var float MsgTick[64];
var int BorderSize;
var int ConsoleLines, BorderLines, BorderPixels;
var float ConsolePos, ConsoleDest;
var float FrameX, FrameY;
var texture ConBackground, Border;
var bool bNoStuff, bTyping;
var bool bNoDrawWorld;

// Timedemo
var bool bTimeDemo;
var bool bStartTimeDemo;
var bool bRestartTimeDemo;
var bool bSaveTimeDemoToFile;
// stijn: OldUnreal paste support. I put this bool here because there's some unused padding here ---
var bool bControlDown;
// --- stijn
var float StartTime;
var float ExtraTime;
var float LastFrameTime;
var float LastSecondStartTime;
var int FrameCount;
var int LastSecondFrameCount;
var float MinFPS;
var float MaxFPS;
var float LastSecFPS;
var Font TimeDemoFont;

var localized string LoadingMessage;
var localized string SavingMessage;
var localized string ConnectingMessage;
var localized string PausedMessage;
var localized string PrecachingMessage;


var localized string FrameRateText;
var localized string AvgText;
var localized string LastSecText;
var localized string MinText;
var localized string MaxText;
var localized string fpsText;
var localized string SecondsText;
var localized string FramesText;

//-----------------------------------------------------------------------------
// Input.

// Input system states.
enum EInputAction
{
	IST_None,    // Not performing special input processing.
	IST_Press,   // Handling a keypress or button press.
	IST_Hold,    // Handling holding a key or button.
	IST_Release, // Handling a key or button release.
	IST_Axis,    // Handling analog axis movement.
};

// Input keys.
enum EInputKey
{
	/*00*/	IK_None			,IK_LeftMouse	,IK_RightMouse	,IK_Cancel		,
	/*04*/	IK_MiddleMouse	,IK_Unknown05	,IK_Unknown06	,IK_Unknown07	,
	/*08*/	IK_Backspace	,IK_Tab         ,IK_Unknown0A	,IK_Unknown0B	,
	/*0C*/	IK_Unknown0C	,IK_Enter	    ,IK_Unknown0E	,IK_Unknown0F	,
	/*10*/	IK_Shift		,IK_Ctrl	    ,IK_Alt			,IK_Pause       ,
	/*14*/	IK_CapsLock		,IK_MouseButton4,IK_MouseButton5,IK_MouseButton6,
	/*18*/	IK_MouseButton7	,IK_MouseButton8,IK_Unknown1A	,IK_Escape		,
	/*1C*/	IK_Unknown1C	,IK_Unknown1D	,IK_Unknown1E	,IK_Unknown1F	,
	/*20*/	IK_Space		,IK_PageUp      ,IK_PageDown    ,IK_End         ,
	/*24*/	IK_Home			,IK_Left        ,IK_Up          ,IK_Right       ,
	/*28*/	IK_Down			,IK_Select      ,IK_Print       ,IK_Execute     ,
	/*2C*/	IK_PrintScrn	,IK_Insert      ,IK_Delete      ,IK_Help		,
	/*30*/	IK_0			,IK_1			,IK_2			,IK_3			,
	/*34*/	IK_4			,IK_5			,IK_6			,IK_7			,
	/*38*/	IK_8			,IK_9			,IK_Unknown3A	,IK_Unknown3B	,
	/*3C*/	IK_Unknown3C	,IK_Unknown3D	,IK_Unknown3E	,IK_Unknown3F	,
	/*40*/	IK_Unknown40	,IK_A			,IK_B			,IK_C			,
	/*44*/	IK_D			,IK_E			,IK_F			,IK_G			,
	/*48*/	IK_H			,IK_I			,IK_J			,IK_K			,
	/*4C*/	IK_L			,IK_M			,IK_N			,IK_O			,
	/*50*/	IK_P			,IK_Q			,IK_R			,IK_S			,
	/*54*/	IK_T			,IK_U			,IK_V			,IK_W			,
	/*58*/	IK_X			,IK_Y			,IK_Z			,IK_Unknown5B	,
	/*5C*/	IK_Unknown5C	,IK_Unknown5D	,IK_Unknown5E	,IK_Unknown5F	,
	/*60*/	IK_NumPad0		,IK_NumPad1     ,IK_NumPad2     ,IK_NumPad3     ,
	/*64*/	IK_NumPad4		,IK_NumPad5     ,IK_NumPad6     ,IK_NumPad7     ,
	/*68*/	IK_NumPad8		,IK_NumPad9     ,IK_GreyStar    ,IK_GreyPlus    ,
	/*6C*/	IK_Separator	,IK_GreyMinus	,IK_NumPadPeriod,IK_GreySlash   ,
	/*70*/	IK_F1			,IK_F2          ,IK_F3          ,IK_F4          ,
	/*74*/	IK_F5			,IK_F6          ,IK_F7          ,IK_F8          ,
	/*78*/	IK_F9           ,IK_F10         ,IK_F11         ,IK_F12         ,
	/*7C*/	IK_F13			,IK_F14         ,IK_F15         ,IK_F16         ,
	/*80*/	IK_F17			,IK_F18         ,IK_F19         ,IK_F20         ,
	/*84*/	IK_F21			,IK_F22         ,IK_F23         ,IK_F24         ,
	/*88*/	IK_Unknown88	,IK_Unknown89	,IK_Unknown8A	,IK_Unknown8B	,
	/*8C*/	IK_Unknown8C	,IK_Unknown8D	,IK_Unknown8E	,IK_Unknown8F	,
	/*90*/	IK_NumLock		,IK_ScrollLock  ,IK_Unknown92	,IK_Unknown93	,
	/*94*/	IK_Unknown94	,IK_Unknown95	,IK_Unknown96	,IK_Unknown97	,
	/*98*/	IK_Unknown98	,IK_Unknown99	,IK_Unknown9A	,IK_Unknown9B	,
	/*9C*/	IK_Unknown9C	,IK_Unknown9D	,IK_Unknown9E	,IK_Unknown9F	,
	/*A0*/	IK_LShift		,IK_RShift      ,IK_LControl    ,IK_RControl    ,
	/*A4*/	IK_UnknownA4	,IK_UnknownA5	,IK_UnknownA6	,IK_UnknownA7	,
	/*A8*/	IK_UnknownA8	,IK_UnknownA9	,IK_UnknownAA	,IK_UnknownAB	,
	/*AC*/	IK_UnknownAC	,IK_UnknownAD	,IK_UnknownAE	,IK_UnknownAF	,
	/*B0*/	IK_UnknownB0	,IK_UnknownB1	,IK_UnknownB2	,IK_UnknownB3	,
	/*B4*/	IK_UnknownB4	,IK_UnknownB5	,IK_UnknownB6	,IK_UnknownB7	,
	/*B8*/	IK_UnknownB8	,IK_UnknownB9	,IK_Semicolon	,IK_Equals		,
	/*BC*/	IK_Comma		,IK_Minus		,IK_Period		,IK_Slash		,
	/*C0*/	IK_Tilde		,IK_UnknownC1	,IK_UnknownC2	,IK_UnknownC3	,
	/*C4*/	IK_UnknownC4	,IK_UnknownC5	,IK_UnknownC6	,IK_UnknownC7	,
	/*C8*/	IK_Joy1	        ,IK_Joy2	    ,IK_Joy3	    ,IK_Joy4	    ,
	/*CC*/	IK_Joy5	        ,IK_Joy6	    ,IK_Joy7	    ,IK_Joy8	    ,
	/*D0*/	IK_Joy9	        ,IK_Joy10	    ,IK_Joy11	    ,IK_Joy12		,
	/*D4*/	IK_Joy13		,IK_Joy14	    ,IK_Joy15	    ,IK_Joy16	    ,
	/*D8*/	IK_UnknownD8	,IK_UnknownD9	,IK_UnknownDA	,IK_LeftBracket	,
	/*DC*/	IK_Backslash	,IK_RightBracket,IK_SingleQuote	,IK_UnknownDF	,
	/*E0*/  IK_JoyX			,IK_JoyY		,IK_JoyZ		,IK_JoyR		,
	/*E4*/	IK_MouseX		,IK_MouseY		,IK_MouseZ		,IK_MouseW		,
	/*E8*/	IK_JoyU			,IK_JoyV		,IK_UnknownEA	,IK_UnknownEB	,
	/*EC*/	IK_MouseWheelUp ,IK_MouseWheelDown,IK_Unknown10E,UK_Unknown10F  ,
	/*F0*/	IK_JoyPovUp     ,IK_JoyPovDown	,IK_JoyPovLeft	,IK_JoyPovRight	,
	/*F4*/	IK_UnknownF4	,IK_UnknownF5	,IK_Attn		,IK_CrSel		,
	/*F8*/	IK_ExSel		,IK_ErEof		,IK_Play		,IK_Zoom		,
	/*FC*/	IK_NoName		,IK_PA1			,IK_OEMClear
};

//-----------------------------------------------------------------------------
// natives.

// Execute a command on this console.
native function bool ConsoleCommand( coerce string S );
native function SaveTimeDemo( string S );

//-----------------------------------------------------------------------------
// Exec functions accessible from the console and key bindings.

// Begin typing a command on the console.
exec function Type()
{
	TypedStr="";
	GotoState( 'Typing' );
}

exec function Talk()
{
	TypedStr="Say ";
	bNoStuff = true;
	GotoState( 'Typing' );
}

exec function TeamTalk()
{
	TypedStr="TeamSay ";
	bNoStuff = true;
	GotoState( 'Typing' );
}

// Size the view up.
exec function ViewUp()
{
	BorderSize = Clamp( BorderSize-1, 0, MaxBorder );
}

// Size the view down.
exec function ViewDown()
{
	BorderSize = Clamp( BorderSize+1, 0, MaxBorder );
}

//-----------------------------------------------------------------------------
// Member Access Functions.

function string GetMsgText( int Index )
{
	return MsgText[Index];
}
function SetMsgText( int Index, string NewMsgText )
{
	MsgText[Index] = NewMsgText;
}

function name GetMsgType(int Index)
{
	return MsgType[Index];
}
function SetMsgType(int Index, name NewMsgType)
{
	MsgType[Index] = NewMsgType;
}

function PlayerReplicationInfo GetMsgPlayer(int Index)
{
	return MsgPlayer[Index];
}
function SetMsgPlayer(int Index, PlayerReplicationInfo NewMsgPlayer)
{
	MsgPlayer[Index] = NewMsgPlayer;
}

function float GetMsgTick(int Index)
{
	return MsgTick[Index];
}
function SetMsgTick(int Index, int NewMsgTick)
{
	MsgTick[Index] = NewMsgTick;
}

//-----------------------------------------------------------------------------
// Functions.

// Clear messages.
function ClearMessages()
{
	local int i;

	for (i=0; i<MaxLines; i++)
	{
		MsgText[i] = "";
		MsgType[i] = '';
		MsgPlayer[i] = None;
		MsgTick[i] = 0.0;
	}
	MsgTime = 0.0;
}

// Write to console.
event Message( PlayerReplicationInfo PRI, coerce string Msg, name N )
{
	if( Msg!="" )
	{
		TopLine		     = (TopLine+1) % MaxLines;
		NumLines	     = Min(NumLines+1,MaxLines-1);
		MsgType[TopLine] = N;
		MsgTime		     = 6.0;
		TextLines++;
		MsgText[TopLine] = Msg;
		MsgPlayer[TopLine] = PRI;
		MsgTick[TopLine] = MsgTickTime + MsgTime;
	}
}

event AddString( coerce string Msg )
{
	if( Msg!="" )
	{
		TopLine		     = (TopLine+1) % MaxLines;
		NumLines	     = Min(NumLines+1,MaxLines-1);
		MsgType[TopLine] = 'Event';
		MsgTime		     = 6.0;
		TextLines++;
		MsgText[TopLine] = Msg;
		MsgPlayer[TopLine] = None;
		MsgTick[TopLine] = MsgTickTime + MsgTime;
	}
}

// Called by the engine when a single key is typed.
event bool KeyType( EInputKey Key );

// Called by the engine when a key, mouse, or joystick button is pressed
// or released, or any analog axis movement is processed.
event bool KeyEvent( EInputKey Key, EInputAction Action, FLOAT Delta )
{
	// Ask the HUD to deal with the key event (hook for mod authors).
	if (Viewport.Actor.myHUD != None)
	{
		if (Viewport.Actor.myHUD.ProcessKeyEvent( Key, Action, Delta ))
			return true;
	}

	if( Action!=IST_Press )
	{
		return false;
	}
	else if( Key==IK_Tilde )
	{
		if( ConsoleDest==0.0 )
		{
			ConsoleDest=0.6;
			GotoState('Typing');
		}
		else GotoState('');
		return true;
	}
	else return false;
}

// Called each rendering iteration to update any time-based display.
event Tick( float Delta )
{
	local int I;

	MsgTickTime += Delta;

	// Slide console up or down.
	if( ConsolePos < ConsoleDest )
		ConsolePos = FMin(ConsolePos+Delta,ConsoleDest);
	else if( ConsolePos > ConsoleDest )
		ConsolePos = FMax(ConsolePos-Delta,ConsoleDest);

	// Update status message.
	if( ((MsgTime-=Delta) <= 0.0) && (TextLines > 0) )
		TextLines--;
}

// Called before rendering the world view.
event PreRender( canvas C );

// Called when video settings change (resolution, driver, color depth).
event VideoChange();

event NotifyLevelChange()
{
	bRestartTimeDemo = True;
	ClearMessages();
}

event ConnectFailure( string FailCode, string URL );

function DrawLevelAction( canvas C )
{
	local string BigMessage;

	if ( (Viewport.Actor.Level.Pauser != "") && (Viewport.Actor.Level.LevelAction == LEVACT_None) )
	{
		C.Font = C.MedFont;
		BigMessage = PausedMessage; // Add pauser name?
		PrintActionMessage(C, BigMessage);
		return;
	}
	if ( (Viewport.Actor.Level.LevelAction == LEVACT_None)
		 || Viewport.Actor.bShowMenu )
	{
		BigMessage = "";
		return;
	}
	else if ( Viewport.Actor.Level.LevelAction == LEVACT_Loading )
		BigMessage = LoadingMessage;
	else if ( Viewport.Actor.Level.LevelAction == LEVACT_Saving )
		BigMessage = SavingMessage;
	else if ( Viewport.Actor.Level.LevelAction == LEVACT_Connecting )
		BigMessage = ConnectingMessage;
	else if ( Viewport.Actor.Level.LevelAction == LEVACT_Precaching )
		BigMessage = PrecachingMessage;

	if ( BigMessage != "" )
	{
		C.Style = 1;
		C.Font = C.LargeFont;
		PrintActionMessage(C, BigMessage);
	}
}

function PrintActionMessage( Canvas C, string BigMessage )
{
	local float XL, YL;

	C.bCenter = false;
	C.StrLen( BigMessage, XL, YL );
	C.SetPos(FrameX/2 - XL/2, FrameY/2 - YL/2);
	C.DrawText( BigMessage, false );
}

// Add localization to hardcoded strings!!
// Called after rendering the world view.
event PostRender( canvas C )
{
	local int YStart, YEnd, Y, I, J, Line, iLine;

	if(bNoDrawWorld)
	{
		C.SetPos(0,0);
		C.DrawPattern( Texture'Border', C.ClipX, C.ClipY, 1.0 );
	}

	if( bTimeDemo )
	{
		TimeDemoCalc();
		TimeDemoRender( C );
	}

	// call overridable "level action" rendering code to draw the "big message"
	DrawLevelAction( C );

	// If the console has changed since the previous frame, draw it.
	if ( ConsoleLines > 0 )
	{
		C.SetOrigin(0.0, ConsoleLines - FrameY*0.6);
		C.SetPos(0.0, 0.0);
		C.DrawTile( ConBackground, FrameX, FrameY*0.6, C.CurX, C.CurY, FrameX, FrameY );
	}

	// Draw border.
	if ( BorderLines > 0 || BorderPixels > 0 )
	{
		YStart 	= BorderLines + ConsoleLines;
		YEnd 	= FrameY - BorderLines;
		if ( BorderLines > 0 )
		{
			C.SetOrigin(0.0, 0.0);
			C.SetPos(0.0, 0.0);
			C.DrawPattern( Border, FrameX, BorderLines, 1.0 );
			C.SetPos(0.0, YEnd);
			C.DrawPattern( Border, FrameX, BorderLines, 1.0 );
		}
		if ( BorderPixels > 0 )
		{
			C.SetOrigin(0.0, 0.0);
			C.SetPos(0.0, YStart);
			C.DrawPattern( Border, BorderPixels, YEnd - YStart, 1.0 );
			C.SetPos( FrameX - BorderPixels, YStart );
			C.DrawPattern( Border, BorderPixels, YEnd - YStart, 1.0 );
		}
	}

	// Draw console text.
	C.SetOrigin(0.0, 0.0);
	if ( ConsoleLines > 0 )
		DrawConsoleView( C );
	else
		DrawSingleView( C );
}

simulated function DrawConsoleView( Canvas C )
{
	local int Y, I, Line;
	local float XL, YL;

	// Console is visible; display console view.
	Y = ConsoleLines - 1;
	MsgText[(TopLine + 1 + MaxLines) % MaxLines] = "(>"@TypedStr;
	for ( I = Scrollback; I < (NumLines + 1); I++ )
	{
		// Display all text in the buffer.
		Line = (TopLine + MaxLines*2 - (I-1)) % MaxLines;

		C.Font = C.MedFont;

		if (( MsgType[Line] == 'Say' ) || ( MsgType[Line] == 'TeamSay' ))
			C.StrLen( MsgPlayer[Line].PlayerName$":"@MsgText[Line], XL, YL );
		else
			C.StrLen( MsgText[Line], XL, YL );

		// Half-space blank lines.
		if ( YL == 0 )
			YL = 5;

		Y -= YL;
		if ( (Y + YL) < 0 )
			break;
		C.SetPos(4, Y);
		C.Font = C.MedFont;

		if (( MsgType[Line] == 'Say' ) || ( MsgType[Line] == 'TeamSay' ))
			C.DrawText( MsgPlayer[Line].PlayerName$":"@MsgText[Line], false );
		else
			C.DrawText( MsgText[Line], false );
	}
}

simulated function DrawSingleView( Canvas C )
{
	local string TypingPrompt;
	local int I, J;
	local float XL, YL;
	local string ShortMessages[4];
	local int ExtraSpace;

	// Console is hidden; display single-line view.

	C.SetOrigin(0.0, 0.0);

	// Ask the HUD to deal with messages.
	if ( Viewport.Actor.myHUD != None
		&& Viewport.Actor.myHUD.DisplayMessages(C) )
		return;

	// If the HUD doesn't deal with messages, use the default behavior
	if (!Viewport.Actor.bShowMenu)
	{
		if ( bTyping )
		{
			TypingPrompt = "(>"@TypedStr$"_";
			C.Font = C.MedFont;
			C.StrLen( TypingPrompt, XL, YL );
			C.SetPos( 2, FrameY - ConsoleLines - YL - 1 );
			C.DrawText( TypingPrompt, false );
		}
	}

	if ( TextLines > 0 && (!Viewport.Actor.bShowMenu || Viewport.Actor.bShowScores) )
	{
		J = TopLine;
		I = 0;
		while ((I < 4) && (J >= 0))
		{
			if ((MsgText[J] != "") && (MsgTick[J] > 0.0) && (MsgTick[J] > MsgTickTime) )
			{
				if (MsgType[J] == 'Say')
					ShortMessages[I] = MsgPlayer[J]$":"@MsgText[J];
				else
					ShortMessages[I] = MsgText[J];
				I++;
			}
			else ShortMessages[I] = "";
			J--;
		}

		J = 0;
		C.Font = C.MedFont;
		for ( I = 0; I < 4; I++ )
		{
			if (ShortMessages[3 - I] != "")
			{
				C.SetPos(4, 2 + (10 * J) + (10 * ExtraSpace));
				C.StrLen( ShortMessages[3 - I], XL, YL );
				C.DrawText( ShortMessages[3 - I], false );
				if ( YL == 18.0 )
					ExtraSpace++;
				J++;
			}
		}
	}
}

//-----------------------------------------------------------------------------
// State used while typing a command on the console.

state Typing
{
	exec function Type()
	{
		TypedStr="";
		gotoState( '' );
	}
	function bool KeyType( EInputKey Key )
	{
		if ( bNoStuff )
		{
			bNoStuff = false;
			return true;
		}
		if( Key>=0x20 && Key<0x100 && Key!=Asc("~") && Key!=Asc("`") )
		{
			TypedStr = TypedStr $ Chr(Key);
			Scrollback=0;
			return true;
		}
	}
	function bool KeyEvent( EInputKey Key, EInputAction Action, FLOAT Delta )
	{
		local string Temp;

		bNoStuff = false;
		// stijn: OldUnreal paste support
		if( Key==IK_Ctrl )
		{
			if ( Action == IST_Press )
				bControlDown = true;
			else if ( Action == IST_Release )
				bControlDown = false;
		}
		if( Key==IK_V && bControlDown && Action == IST_Press )
		{
			TypedStr $= Viewport.Actor.PasteFromClipboard();
        }

		if( Key==IK_Escape )
		{
			if( Scrollback!=0 )
			{
				Scrollback=0;
			}
			else if( TypedStr!="" )
			{
				TypedStr="";
			}
			else
			{
				ConsoleDest=0.0;
				GotoState( '' );
			}
			Scrollback=0;
		}
		else if( global.KeyEvent( Key, Action, Delta ) )
		{
			return true;
		}
		else if( Action != IST_Press )
		{
			return false;
		}
		else if( Key==IK_Enter )
		{
			if( Scrollback!=0 )
			{
				Scrollback=0;
			}
			else
			{
				if( TypedStr!="" )
				{
					// Print to console.
					if( ConsoleLines!=0 )
						Message( None, "(>" @ TypedStr, 'Console' );

					// Update history buffer.
					History[HistoryCur++ % MaxHistory] = TypedStr;
					if( HistoryCur > HistoryBot )
						HistoryBot++;
					if( HistoryCur - HistoryTop >= MaxHistory )
						HistoryTop = HistoryCur - MaxHistory + 1;

					// Make a local copy of the string.
					Temp=TypedStr;
					TypedStr="";
					if( !ConsoleCommand( Temp ) )
						Message( None, Localize("Errors","Exec","Core"), 'Console' );
					Message( None, "", 'Console' );
				}
				if( ConsoleDest==0.0 )
					GotoState('');
				Scrollback=0;
			}
		}
		else if( Key==IK_Up )
		{
			if( HistoryCur > HistoryTop )
			{
				History[HistoryCur % MaxHistory] = TypedStr;
				TypedStr = History[--HistoryCur % MaxHistory];
			}
			Scrollback=0;
		}
		else if( Key==IK_Down )
		{
			History[HistoryCur % MaxHistory] = TypedStr;
			if( HistoryCur < HistoryBot )
				TypedStr = History[++HistoryCur % MaxHistory];
			else
				TypedStr="";
			Scrollback=0;
		}
		else if( Key==IK_PageUp )
		{
			if( ++Scrollback >= MaxLines )
				Scrollback = MaxLines-1;
		}
		else if( Key==IK_PageDown )
		{
			if( --Scrollback < 0 )
				Scrollback = 0;
		}
		else if( Key==IK_Backspace || Key==IK_Left )
		{
			if( Len(TypedStr)>0 )
				TypedStr = Left(TypedStr,Len(TypedStr)-1);
			Scrollback = 0;
		}
		return true;
	}
	function BeginState()
	{
		bTyping = true;
		Viewport.Actor.Typing(bTyping);
	}
	function EndState()
	{
		bTyping = false;
		Viewport.Actor.Typing(bTyping);
		//log("Console leaving Typing");
		ConsoleDest=0.0;
	}
}

//-----------------------------------------------------------------------------
// State used while in a menu.

state Menuing
{
	function bool KeyEvent( EInputKey Key, EInputAction Action, FLOAT Delta )
	{
		if ( Action != IST_Press )
			return false;
		if ( Viewport.Actor.myHUD == None || Viewport.Actor.myHUD.MainMenu == None )
			return false;

		Viewport.Actor.myHUD.MainMenu.MenuProcessInput(Key, Action);
		Scrollback=0;
		return true;
	}
	function BeginState()
	{
		//log("Console entering Menuing");
	}
	function EndState()
	{
		//log("Console leaving Menuing");
	}
}

state EndMenuing
{
	// pass all key events, not just presses
	function bool KeyEvent( EInputKey Key, EInputAction Action, FLOAT Delta )
	{
		if ( Viewport.Actor.myHUD == None || Viewport.Actor.myHUD.MainMenu == None )
			return false;

		Viewport.Actor.myHUD.MainMenu.MenuProcessInput(Key, Action);
		Scrollback=0;
		return true;
	}
}

//-----------------------------------------------------------------------------
// State used while typing in a menu.

state MenuTyping
{
	function bool KeyType( EInputKey Key )
	{
		if( Key>=0x20 && Key<0x100 && Key!=Asc("~") && Key!=Asc("`") && Key!=Asc(" ") )
		{
			TypedStr = TypedStr $ Chr(Key);
			Scrollback=0;
			if ( (Viewport.Actor.myHUD != None) && (Viewport.Actor.myHUD.MainMenu != None) )
				Viewport.Actor.myHUD.MainMenu.ProcessMenuUpdate( TypedStr );
			return true;
		}
	}
	function bool KeyEvent( EInputKey Key, EInputAction Action, FLOAT Delta )
	{
		local Menu PlayerMenu;

		if( Action != IST_Press )
			return false;

		if( Viewport.Actor.myHUD==None || Viewport.Actor.myHUD.MainMenu==None )
			return false;

		PlayerMenu = Viewport.Actor.myHUD.MainMenu;

		if( Key==IK_Escape )
		{
			if( Scrollback!=0 )
				Scrollback = 0;
			else if( TypedStr!="" )
				TypedStr="";
			else
				GotoState( 'Menuing' );
			PlayerMenu.ProcessMenuEscape();
			Scrollback=0;
		}
		else if( Key==IK_Enter )
		{
			if( Scrollback!=0 )
				Scrollback = 0;
			else
			{
				if( TypedStr!="" )
					PlayerMenu.ProcessMenuInput( TypedStr );
				TypedStr="";
				GotoState( 'Menuing' );
				Scrollback = 0;
			}
		}
		else if( Key==IK_Backspace || Key==IK_Left )
		{
			if( Len(TypedStr)>0 )
				TypedStr = Left(TypedStr,Len(TypedStr)-1);
			Scrollback = 0;
			PlayerMenu.ProcessMenuUpdate( TypedStr );
		}
		return true;
	}
	function BeginState()
	{
		log("Console entering MenuTyping");
	}
	function EndState()
	{
		log("Console leaving MenuTyping");
	}
}

//-----------------------------------------------------------------------------
// State used while expecting single key input in a menu.

state KeyMenuing
{
	function bool KeyType( EInputKey Key )
	{
		ConsoleDest=0.0;
		if( Viewport.Actor.myHUD!=None && Viewport.Actor.myHUD.MainMenu!=None )
			Viewport.Actor.myHUD.MainMenu.ProcessMenuKey( Key, Chr(Key) );
		Scrollback=0;
		GotoState( 'Menuing' );
		return true;
	}
	function bool KeyEvent( EInputKey Key, EInputAction Action, FLOAT Delta )
	{
		if( Action==IST_Press )
		{
			ConsoleDest=0.0;
			if( Viewport.Actor.myHUD!=None && Viewport.Actor.myHUD.MainMenu!=None )
				Viewport.Actor.myHUD.MainMenu.ProcessMenuKey( Key, mid(string(GetEnum(enum'EInputKey',Key)),3) );
			Scrollback=0;
			GotoState( 'Menuing' );
			return true;
		}
	}
	function BeginState()
	{
		//log( "Console entering KeyMenuing" );
	}
	function EndState()
	{
		//log( "Console leaving KeyMenuing" );
	}
}


//-----------------------------------------------------------------------------
// Timedemo functions

exec function TimeDemo(bool bEnabled, optional bool bSaveToFile)
{
	bSaveTimeDemoToFile = bSaveToFile;
	if(bEnabled)
		StartTimeDemo();
	else
		StopTimeDemo();
}

function StartTimeDemo()
{
	if(bTimeDemo)
		return;
	bTimeDemo = True;
	bStartTimeDemo = True;
}

function StopTimeDemo()
{
	if(!bTimeDemo)
		return;
	bTimeDemo = False;
	PrintTimeDemoResult();
}

function PrintTimeDemoResult()
{
	local LevelInfo Entry;
	local float Avg;
	local float Delta;
	local string AvgString;
	local string Temp;

	Entry = Viewport.Actor.GetEntryLevel();

	Delta = Entry.TimeSeconds - StartTime - ExtraTime;
	if(Delta <= 0)
		Avg = 0;
	else
		Avg = FrameCount / Delta;

	AvgString = string(FrameCount)@FramesText@FormatFloat(delta)@SecondsText@MinText@FormatFloat(MinFPS)@MaxText@FormatFloat(MaxFPS)@AvgText@FormatFloat(Avg)@fpsText$".";
	Viewport.Actor.ClientMessage(AvgString);
	Log(AvgString);
	if(bSaveTimeDemoToFile)
	{
		Temp =
			FormatFloat(Avg) $ " Unreal "$ Viewport.Actor.Level.EngineVersion $ Chr(13) $ Chr(10) $
			FormatFloat(MinFPS) $ " Min"$ Chr(13) $ Chr(10) $
			FormatFloat(MaxFPS) $ " Max"$ Chr(13) $ Chr(10) $
			AvgString;

		SaveTimeDemo(Temp);
	}
}

function TimeDemoCalc()
{
	local LevelInfo Entry;
	local float Delta;
	Entry = Viewport.Actor.GetEntryLevel();

	if( bRestartTimeDemo )
	{
		StopTimeDemo();
		StartTimeDemo();
		bRestartTimeDemo = False;
	}

	if(	bStartTimeDemo )
	{
		bStartTimeDemo = False;
		StartTime = Entry.TimeSeconds;
		ExtraTime =  0;
		LastFrameTime = StartTime;
		LastSecondStartTime = StartTime;
		FrameCount = 0;
		LastSecondFrameCount = 0;
		MinFPS = 0;
		MaxFPS = 0;
		LastSecFPS = 0;
		return;
	}

	Delta = Entry.TimeSeconds - LastFrameTime;

	// If delta time is more than a half of a second, ignore frame entirely (precaching, loading etc)
	if( Delta > 0.5 )
	{
		ExtraTime += Delta;
		LastSecondStartTime = Entry.TimeSeconds;
		LastSecondFrameCount = 0;
		LastFrameTime = Entry.TimeSeconds;
		return;
	}

	FrameCount++;
	LastSecondFrameCount++;

	if( Entry.TimeSeconds - LastSecondStartTime > 1)
	{
		LastSecFPS = LastSecondFrameCount / (Entry.TimeSeconds - LastSecondStartTime);
		if( MinFPS == 0 || LastSecFPS < MinFPS )
			MinFPS = LastSecFPS;
		if( LastSecFPS > MaxFPS )
			MaxFPS = LastSecFPS;
		LastSecondFrameCount = 0;
		LastSecondStartTime = Entry.TimeSeconds;
	}

	LastFrameTime = Entry.TimeSeconds;
}

function TimeDemoRender( Canvas C )
{
	local string AText, LText;
	local float W, H;

	C.Font = TimeDemoFont;
	C.DrawColor.R = 255;
	C.DrawColor.G = 255;
	C.DrawColor.B = 255;

	AText = AvgText @ FormatFloat(FrameCount / (Viewport.Actor.GetEntryLevel().TimeSeconds - StartTime - ExtraTime));
	LText = LastSecText @ FormatFloat(LastSecFPS);

	C.TextSize(AText, W, H);
	C.SetPos(C.ClipX - W, 0.3*C.ClipY);
	C.DrawText(AText);
	C.TextSize(LText, W, H);
	C.SetPos(C.ClipX - W, 0.3*C.ClipY+H);
	C.DrawText(LText);
}

final function string FormatFloat( float f)
{
	local string s;
	local int i;
	s = string(f);
	i = InStr(s, ".");
	if(i != -1)
		s = Left(s, i+3);
	return s;
}

defaultproperties
{
      vtblOut=
      Viewport=None
      HistoryTop=0
      HistoryBot=0
      HistoryCur=0
      TypedStr=""
      History(0)=""
      History(1)=""
      History(2)=""
      History(3)=""
      History(4)=""
      History(5)=""
      History(6)=""
      History(7)=""
      History(8)=""
      History(9)=""
      History(10)=""
      History(11)=""
      History(12)=""
      History(13)=""
      History(14)=""
      History(15)=""
      Scrollback=0
      numLines=0
      TopLine=0
      TextLines=0
      MsgTime=0.000000
      MsgTickTime=0.000000
      MsgText(0)=""
      MsgText(1)=""
      MsgText(2)=""
      MsgText(3)=""
      MsgText(4)=""
      MsgText(5)=""
      MsgText(6)=""
      MsgText(7)=""
      MsgText(8)=""
      MsgText(9)=""
      MsgText(10)=""
      MsgText(11)=""
      MsgText(12)=""
      MsgText(13)=""
      MsgText(14)=""
      MsgText(15)=""
      MsgText(16)=""
      MsgText(17)=""
      MsgText(18)=""
      MsgText(19)=""
      MsgText(20)=""
      MsgText(21)=""
      MsgText(22)=""
      MsgText(23)=""
      MsgText(24)=""
      MsgText(25)=""
      MsgText(26)=""
      MsgText(27)=""
      MsgText(28)=""
      MsgText(29)=""
      MsgText(30)=""
      MsgText(31)=""
      MsgText(32)=""
      MsgText(33)=""
      MsgText(34)=""
      MsgText(35)=""
      MsgText(36)=""
      MsgText(37)=""
      MsgText(38)=""
      MsgText(39)=""
      MsgText(40)=""
      MsgText(41)=""
      MsgText(42)=""
      MsgText(43)=""
      MsgText(44)=""
      MsgText(45)=""
      MsgText(46)=""
      MsgText(47)=""
      MsgText(48)=""
      MsgText(49)=""
      MsgText(50)=""
      MsgText(51)=""
      MsgText(52)=""
      MsgText(53)=""
      MsgText(54)=""
      MsgText(55)=""
      MsgText(56)=""
      MsgText(57)=""
      MsgText(58)=""
      MsgText(59)=""
      MsgText(60)=""
      MsgText(61)=""
      MsgText(62)=""
      MsgText(63)=""
      MsgType(0)="None"
      MsgType(1)="None"
      MsgType(2)="None"
      MsgType(3)="None"
      MsgType(4)="None"
      MsgType(5)="None"
      MsgType(6)="None"
      MsgType(7)="None"
      MsgType(8)="None"
      MsgType(9)="None"
      MsgType(10)="None"
      MsgType(11)="None"
      MsgType(12)="None"
      MsgType(13)="None"
      MsgType(14)="None"
      MsgType(15)="None"
      MsgType(16)="None"
      MsgType(17)="None"
      MsgType(18)="None"
      MsgType(19)="None"
      MsgType(20)="None"
      MsgType(21)="None"
      MsgType(22)="None"
      MsgType(23)="None"
      MsgType(24)="None"
      MsgType(25)="None"
      MsgType(26)="None"
      MsgType(27)="None"
      MsgType(28)="None"
      MsgType(29)="None"
      MsgType(30)="None"
      MsgType(31)="None"
      MsgType(32)="None"
      MsgType(33)="None"
      MsgType(34)="None"
      MsgType(35)="None"
      MsgType(36)="None"
      MsgType(37)="None"
      MsgType(38)="None"
      MsgType(39)="None"
      MsgType(40)="None"
      MsgType(41)="None"
      MsgType(42)="None"
      MsgType(43)="None"
      MsgType(44)="None"
      MsgType(45)="None"
      MsgType(46)="None"
      MsgType(47)="None"
      MsgType(48)="None"
      MsgType(49)="None"
      MsgType(50)="None"
      MsgType(51)="None"
      MsgType(52)="None"
      MsgType(53)="None"
      MsgType(54)="None"
      MsgType(55)="None"
      MsgType(56)="None"
      MsgType(57)="None"
      MsgType(58)="None"
      MsgType(59)="None"
      MsgType(60)="None"
      MsgType(61)="None"
      MsgType(62)="None"
      MsgType(63)="None"
      MsgPlayer(0)=None
      MsgPlayer(1)=None
      MsgPlayer(2)=None
      MsgPlayer(3)=None
      MsgPlayer(4)=None
      MsgPlayer(5)=None
      MsgPlayer(6)=None
      MsgPlayer(7)=None
      MsgPlayer(8)=None
      MsgPlayer(9)=None
      MsgPlayer(10)=None
      MsgPlayer(11)=None
      MsgPlayer(12)=None
      MsgPlayer(13)=None
      MsgPlayer(14)=None
      MsgPlayer(15)=None
      MsgPlayer(16)=None
      MsgPlayer(17)=None
      MsgPlayer(18)=None
      MsgPlayer(19)=None
      MsgPlayer(20)=None
      MsgPlayer(21)=None
      MsgPlayer(22)=None
      MsgPlayer(23)=None
      MsgPlayer(24)=None
      MsgPlayer(25)=None
      MsgPlayer(26)=None
      MsgPlayer(27)=None
      MsgPlayer(28)=None
      MsgPlayer(29)=None
      MsgPlayer(30)=None
      MsgPlayer(31)=None
      MsgPlayer(32)=None
      MsgPlayer(33)=None
      MsgPlayer(34)=None
      MsgPlayer(35)=None
      MsgPlayer(36)=None
      MsgPlayer(37)=None
      MsgPlayer(38)=None
      MsgPlayer(39)=None
      MsgPlayer(40)=None
      MsgPlayer(41)=None
      MsgPlayer(42)=None
      MsgPlayer(43)=None
      MsgPlayer(44)=None
      MsgPlayer(45)=None
      MsgPlayer(46)=None
      MsgPlayer(47)=None
      MsgPlayer(48)=None
      MsgPlayer(49)=None
      MsgPlayer(50)=None
      MsgPlayer(51)=None
      MsgPlayer(52)=None
      MsgPlayer(53)=None
      MsgPlayer(54)=None
      MsgPlayer(55)=None
      MsgPlayer(56)=None
      MsgPlayer(57)=None
      MsgPlayer(58)=None
      MsgPlayer(59)=None
      MsgPlayer(60)=None
      MsgPlayer(61)=None
      MsgPlayer(62)=None
      MsgPlayer(63)=None
      MsgTick(0)=0.000000
      MsgTick(1)=0.000000
      MsgTick(2)=0.000000
      MsgTick(3)=0.000000
      MsgTick(4)=0.000000
      MsgTick(5)=0.000000
      MsgTick(6)=0.000000
      MsgTick(7)=0.000000
      MsgTick(8)=0.000000
      MsgTick(9)=0.000000
      MsgTick(10)=0.000000
      MsgTick(11)=0.000000
      MsgTick(12)=0.000000
      MsgTick(13)=0.000000
      MsgTick(14)=0.000000
      MsgTick(15)=0.000000
      MsgTick(16)=0.000000
      MsgTick(17)=0.000000
      MsgTick(18)=0.000000
      MsgTick(19)=0.000000
      MsgTick(20)=0.000000
      MsgTick(21)=0.000000
      MsgTick(22)=0.000000
      MsgTick(23)=0.000000
      MsgTick(24)=0.000000
      MsgTick(25)=0.000000
      MsgTick(26)=0.000000
      MsgTick(27)=0.000000
      MsgTick(28)=0.000000
      MsgTick(29)=0.000000
      MsgTick(30)=0.000000
      MsgTick(31)=0.000000
      MsgTick(32)=0.000000
      MsgTick(33)=0.000000
      MsgTick(34)=0.000000
      MsgTick(35)=0.000000
      MsgTick(36)=0.000000
      MsgTick(37)=0.000000
      MsgTick(38)=0.000000
      MsgTick(39)=0.000000
      MsgTick(40)=0.000000
      MsgTick(41)=0.000000
      MsgTick(42)=0.000000
      MsgTick(43)=0.000000
      MsgTick(44)=0.000000
      MsgTick(45)=0.000000
      MsgTick(46)=0.000000
      MsgTick(47)=0.000000
      MsgTick(48)=0.000000
      MsgTick(49)=0.000000
      MsgTick(50)=0.000000
      MsgTick(51)=0.000000
      MsgTick(52)=0.000000
      MsgTick(53)=0.000000
      MsgTick(54)=0.000000
      MsgTick(55)=0.000000
      MsgTick(56)=0.000000
      MsgTick(57)=0.000000
      MsgTick(58)=0.000000
      MsgTick(59)=0.000000
      MsgTick(60)=0.000000
      MsgTick(61)=0.000000
      MsgTick(62)=0.000000
      MsgTick(63)=0.000000
      BorderSize=0
      ConsoleLines=0
      BorderLines=0
      BorderPixels=0
      ConsolePos=0.000000
      ConsoleDest=0.000000
      FrameX=0.000000
      FrameY=0.000000
      ConBackground=Texture'Engine.ConsoleBack'
      Border=Texture'Engine.Border'
      bNoStuff=False
      bTyping=False
      bNoDrawWorld=False
      bTimeDemo=False
      bStartTimeDemo=False
      bRestartTimeDemo=False
      bSaveTimeDemoToFile=False
      bControlDown=False
      StartTime=0.000000
      ExtraTime=0.000000
      LastFrameTime=0.000000
      LastSecondStartTime=0.000000
      FrameCount=0
      LastSecondFrameCount=0
      MinFPS=0.000000
      MaxFPS=0.000000
      LastSecFPS=0.000000
      TimeDemoFont=Font'Engine.SmallFont'
      LoadingMessage="LOADING"
      SavingMessage="SAVING"
      ConnectingMessage="CONNECTING"
      PausedMessage="PAUSED"
      PrecachingMessage="PRECACHING"
      FrameRateText="Frame Rate"
      AvgText="Avg"
      LastSecText="Last Sec"
      MinText="Min"
      MaxText="Max"
      fpsText="fps"
      SecondsText="seconds."
      FramesText="frames rendered in"
}
