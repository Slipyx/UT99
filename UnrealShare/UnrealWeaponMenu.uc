//=============================================================================
// UnrealWeaponMenu
//=============================================================================
class UnrealWeaponMenu extends UnrealLongMenu;

var int Slot[21];
var bool bInitLength;

function bool ProcessLeft()
{
	local name temp;

	if ( Selection > 1 )
	{
		temp = PlayerOwner.WeaponPriority[Slot[Selection]];
		PlayerOwner.WeaponPriority[Slot[Selection]] = PlayerOwner.WeaponPriority[Slot[Selection - 1]];
		PlayerOwner.WeaponPriority[Slot[Selection - 1]] = temp;
		Selection--;
	}
	else 
		return false;

	return true;
}

function bool ProcessRight()
{
	local name temp;

	if ( Selection < MenuLength )
	{
		temp = PlayerOwner.WeaponPriority[Slot[Selection]];
		PlayerOwner.WeaponPriority[Slot[Selection]] = PlayerOwner.WeaponPriority[Slot[Selection + 1]];
		PlayerOwner.WeaponPriority[Slot[Selection + 1]] = temp;
		Selection++;
	}
	else
		return false;

	return true;
}

function SaveConfigs()
{
	PlayerOwner.SaveConfig();
	PlayerOwner.ServerUpdateWeapons();
}

function DrawMenu(canvas Canvas)
{
	local int StartX, StartY, Spacing, i, j;

	DrawBackGround(Canvas, (Canvas.ClipY < 250));

	// Draw Title
	StartX = Max(16, 0.5 * Canvas.ClipX - 80);
	Canvas.Font = Canvas.LargeFont;
	Canvas.SetPos(StartX, 4 );
	Canvas.DrawText(MenuTitle, False);
		
	// Draw Weapon Priorities
		
	Spacing = Clamp(Canvas.ClipY/20, 10, 32);
	StartX = Max(48, 0.5 * Canvas.ClipX - 64);
	StartY = Max(40, 0.5 * (Canvas.ClipY - MenuLength * Spacing));

	j = 1;
	MenuLength = 0;
	Canvas.Font = Canvas.MedFont;
	for ( i=19; i>=0; i-- )
	{
		if ( PlayerOwner.WeaponPriority[i] != '' )
		{
			SetFontBrightness( Canvas, (Selection==j) );
			MenuLength++;
			Slot[j] = i;
			Canvas.SetPos(StartX, StartY + (j-1) * Spacing );
			j++;
			Canvas.DrawText(PlayerOwner.WeaponPriority[i], false);
			if ( MenuLength > Canvas.ClipY/Spacing - 1 )
				break;
		}
	}
	Canvas.DrawColor = Canvas.Default.DrawColor;
}

defaultproperties
{
      Slot(0)=0
      Slot(1)=0
      Slot(2)=0
      Slot(3)=0
      Slot(4)=0
      Slot(5)=0
      Slot(6)=0
      Slot(7)=0
      Slot(8)=0
      Slot(9)=0
      Slot(10)=0
      Slot(11)=0
      Slot(12)=0
      Slot(13)=0
      Slot(14)=0
      Slot(15)=0
      Slot(16)=0
      Slot(17)=0
      Slot(18)=0
      Slot(19)=0
      Slot(20)=0
      bInitLength=False
      MenuTitle="PRIORITIES"
}
