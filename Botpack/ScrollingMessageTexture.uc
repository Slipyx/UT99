class ScrollingMessageTexture expands ClientScriptedTexture;

var() localized string ScrollingMessage;
var localized string HisMessage, HerMessage;
var() Font Font;
var() color FontColor;
var() bool bCaps;
var() int PixelsPerSecond;
var() int ScrollWidth;
var() float YPos;
var() bool bResetPosOnTextChange;

var string OldText;
var int Position;
var float FloatPosition; // 469 fix
var float LastDrawTime;
var PlayerPawn Player;

/* parameters for ScrollingMessage:

   %p - local player name
   %h - his/her for local player
   %lp - leading player's name
   %lf - leading player's frags
*/

simulated function FindPlayer()
{
	local PlayerPawn P;

	foreach AllActors(class'PlayerPawn', P)
		if(Viewport(P.Player) != None)
			Player = P;
}

simulated event RenderTexture(ScriptedTexture Tex)
{
	local string Text;
	local PlayerReplicationInfo Leading, PRI;
	local int i;

	if(Player == None)
		FindPlayer();

	if(Player == None || Player.PlayerReplicationInfo == None || Player.GameReplicationInfo == None)
		return;

	if(LastDrawTime == 0)
		FloatPosition = Tex.USize;
	else
		FloatPosition -= (Level.TimeSeconds-LastDrawTime) * PixelsPerSecond;

	if(FloatPosition < -ScrollWidth)
		FloatPosition = Tex.USize;

	LastDrawTime = Level.TimeSeconds;

	Text = ScrollingMessage;

	if(Player.bIsFemale)
		Text = Replace(Text, "%h", HerMessage);
	else
		Text = Replace(Text, "%h", HisMessage);
	
	Text = Replace(Text, "%p", Player.PlayerReplicationInfo.PlayerName);
	if(InStr(Text, "%lf") != -1 || InStr(Text, "%lp") != -1)
	{
		// find the leading player
		Leading = None;

		for (i=0; i<32; i++)
		{
			if (Player.GameReplicationInfo.PRIArray[i] != None)
			{
				PRI = Player.GameReplicationInfo.PRIArray[i];
				if ( !PRI.bIsSpectator && (Leading==None || PRI.Score>Leading.Score) )
					Leading = PRI;
			}
		}
		if(Leading == None)
			Leading = Player.PlayerReplicationInfo;
		Text = Replace(Text, "%lp", Leading.PlayerName);
		Text = Replace(Text, "%lf", string(int(Leading.Score)));
	}

	if(bCaps)
		Text = Caps(Text);

	if(Text != OldText && bResetPosOnTextChange)
	{
		FloatPosition = Tex.USize;
		OldText = Text;
	}

	Position = FloatPosition;

	Tex.DrawColoredText( Position, YPos, Text, Font, FontColor );
}

simulated function string Replace(string Text, string Match, string Replacement)
{
	local int i;
	
	i = InStr(Text, Match);	

	if(i != -1)
		return Left(Text, i) $ Replacement $ Replace(Mid(Text, i+Len(Match)), Match, Replacement);
	else
		return Text;
}

defaultproperties
{
      ScrollingMessage=""
      HisMessage="his"
      HerMessage="her"
      Font=None
      FontColor=(R=0,G=0,B=0,A=0)
      bCaps=False
      PixelsPerSecond=0
      ScrollWidth=0
      YPos=0.000000
      bResetPosOnTextChange=True
      OldText=""
      Position=0
      FloatPosition=0.000000
      LastDrawTime=0.000000
      Player=None
}
