//=============================================================================
// UnrealLoadMenu
//=============================================================================
class UnrealLoadMenu extends UnrealSlotMenu;

var() localized string RestartString;

function bool ProcessSelection()
{
	if ( Selection == 1 )
	{
		GotoState('Restart');
		PlayerOwner.Player.Console.GotoState('EndMenuing');
		return true;
	}
	if ( SlotNames[Selection - 2] ~= "..Empty.." )
		return false;
	GotoState('LoadGame');
	PlayerOwner.Player.Console.GotoState('EndMenuing');
	return true;
}

function DrawMenu(canvas Canvas)
{
	DrawBackGround(Canvas, (Canvas.ClipY < 320));

	DrawTitle(Canvas);
	DrawSlots(Canvas);	
}

function DrawSlots(canvas Canvas)
{
	local int StartX, StartY, Spacing, i;
			
	Spacing = Clamp(0.05 * Canvas.ClipY, 12, 32);
	StartX = Max(20, 0.5 * (Canvas.ClipX - 206));
	StartY = Max(40, 0.5 * (Canvas.ClipY - MenuLength * Spacing-40));
	Canvas.Font = Canvas.MedFont;

	Canvas.SetPos(StartX, StartY);
	Canvas.DrawText(RestartString$Level.Title, False);

	For ( i=1; i<10; i++ )
	{
		Canvas.SetPos(StartX, StartY + i * Spacing );
		Canvas.DrawText(SlotNames[i-1], False);
	}

	// show selection
	Canvas.SetPos( StartX - 20, StartY + Spacing * (Selection - 1));
	Canvas.DrawText("[]", false);	
}

state LoadGame
{
	function MenuProcessInput( byte KeyNum, byte ActionNum )
	{
		if ( (KeyNum == EInputKey.IK_Enter) 
			&& (ActionNum == EInputAction.IST_Release) )
		{
			PlayerOwner.ClientMessage("");
			bExitAllMenus = true;
			if ( Left(SlotNames[Selection - 2], 4) == "Net:" )
				Level.ServerTravel( "?load=" $ (Selection - 2), false);
			else
				PlayerOwner.ClientTravel( "?load=" $ (Selection - 2), TRAVEL_Absolute, false);
		}
	}
}

state Restart
{
	function MenuProcessInput( byte KeyNum, byte ActionNum )
	{
		if ( (KeyNum == EInputKey.IK_Enter) 
			&& (ActionNum == EInputAction.IST_Release) )
			PlayerOwner.RestartLevel();
	}
}

defaultproperties
{
     RestartString="Restart "
     MenuLength=10
     MenuTitle="LOAD GAME"
}
