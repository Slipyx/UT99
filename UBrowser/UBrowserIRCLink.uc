class UBrowserIRCLink expands UBrowserBufferedTCPLink;

var IpAddr			ServerIpAddr;

var string			ServerAddress;
var int				ServerPort;

var string			NickName;
var string			UserIdent;
var string			FullName;
var string			DefaultChannel;

var localized string InvalidAddressText;
var localized string ErrorBindingText;
var localized string ResolveFailedText;
var localized string ConnectedText;
var localized string ConnectingToText;
var localized string TimeOutError;
var localized string InviteString;

var UBrowserIRCSystemPage SystemPage; 

var string DisconnectReason;
var string VersionString;

//utpg: user/channel prefix
var string UPop;
var string UPhalfop;
var string UPvoice;
var string UserPrefixes;
var string ChannelPrefixes; // &#
//utpg:  user/channel prefix -- end

function PostBeginPlay()
{
	Super.PostBeginPlay();
	Disable('Tick');
}

function Connect(UBrowserIRCSystemPage InSystemPage, string InServer, string InNickName, string InUserIdent, string InFullName, string InDefaultChannel)
{
	local string Port;

	UPop = "@";
	UPhalfop = "%";
	UPvoice = "+";
	UserPrefixes = UPop$UPhalfop$UPvoice;
	ChannelPrefixes = "&#";

	SystemPage = InSystemPage;
	NickName = InNickName;
	FullName = InFullName;
	UserIdent = InUserIdent;
	DefaultChannel = InDefaultChannel;

	Port = GetPort(InServer);
	if ( Port == "" )
	{
		ServerAddress = InServer;
		ServerPort = 6667;
	}
	else
	{
		ServerAddress = StripPort(InServer);
		ServerPort = int(Port);
	}

	ResetBuffer();
	ServerIpAddr.Port = ServerPort;
	SetTimer(20, False);
	SystemPage.SystemText( ConnectingToText@ServerAddress );
	Resolve( ServerAddress );
}

function string ChopLeft(string Text)
{
	while(Text != "" && InStr(": !", Left(Text, 1)) != -1)
		Text = Mid(Text, 1);
	return Text;
}

function string RemoveNickPrefix(string Nick)
{
	while(Nick != "" && InStr(":"$UserPrefixes, Left(Nick, 1)) != -1) //utpg: FIXME: use prefixes
		Nick = Mid(Nick, 1);
	return Nick;
}

function string Chop(string Text)
{
	while(Text != "" && InStr(": !", Left(Text, 1)) != -1)
		Text = Mid(Text, 1);
	while(Text != "" && InStr(": !", Right(Text, 1)) != -1)
		Text = Left(Text, Len(Text)-1);

	return Text;
}

function Resolved( IpAddr Addr )
{
	// Set the address
	ServerIpAddr.Addr = Addr.Addr;

	// Handle failure.
	if( ServerIpAddr.Addr == 0 )
	{
		if(SystemPage != None)
		{
			SystemPage.SystemText( InvalidAddressText );
			SystemPage.Disconnect();
		}
		return;
	}

	// Display success message.
	Log( "UBrowserIRCLink: Server is "$ServerAddress$":"$ServerIpAddr.Port );

	// Bind the local port.
	if( BindPort() == 0 )
	{
		if(SystemPage != None)
		{
			SystemPage.SystemText( ErrorBindingText );
			SystemPage.Disconnect();
		}
		return;
	}

	Open( ServerIpAddr );
}

event Closed()
{
	if(SystemPage != None)
		SystemPage.Disconnect();
}

// Host resolution failue.
function ResolveFailed()
{
	if(SystemPage != None)
	{
		SystemPage.SystemText(ResolveFailedText);
		SystemPage.Disconnect();
	}
}

event Timer()
{
	if(SystemPage != None)
	{
		SystemPage.SystemText( TimeOutError );
		SystemPage.Disconnect();
	}
	return;
}

event Opened()
{
	SetTimer(0, False);
	if(SystemPage != None)
		SystemPage.SystemText(ConnectedText);
	Enable('Tick');
	GotoState('LoggingIn');
}

function Tick(float DeltaTime)
{
	local string Line;

	DoBufferQueueIO();
	if(ReadBufferedLine(Line))
		ProcessInput(Line);
}

function SendCommandText(string Text)
{
	local int i, j;
	local string Cmd, Temp, Temp2;

	// Process fake commands like /MSG
	if(Left(Text, 4) ~= "MSG ")
		Text = "PRIVMSG "$Mid(Text, 4);
	if(Left(Text, 6) ~= "LEAVE ")
		Text = "PART "$Mid(Text, 6);

	// Add colons for commands: PRIVMSG, QUIT, KILL, KICK, NOTICE
	i = InStr(Text, " ");
	if(i != -1)
	{
		Cmd = Caps(Left(Text, i));
		Text = Cmd$Mid(Text, i);

		switch(Cmd)
		{
		// CMD nick :message
		case "PRIVMSG":
		case "NOTICE":
		case "KILL":
			Temp = ChopLeft(Mid(Text, i+1));
			i = InStr(Temp, " ");
			if(i != -1)
				Text = Cmd@Left(Temp, i)$" :"$ChopLeft(Mid(Temp, i+1));
			break;
		// hack for CTCP
		case "CTCP":
			Temp = ChopLeft(Mid(Text, i+1));
			i = InStr(Temp, " ");
			if(i != -1)
				Text = "PRIVMSG "$Left(Temp, i)$" :"$Chr(1)$ChopLeft(Mid(Temp, i+1))$Chr(1);
			break;
		// CMD #channel nick :message
		case "KICK":
			Temp = ChopLeft(Mid(Text, i+1));
			i = InStr(Temp, " ");
			if(i != -1)
			{
				Temp2 = ChopLeft(Mid(Temp, i+1));
				j = InStr(Temp2, " ");
				if(j != -1)
					Text = Cmd@Left(Temp, i)@Left(Temp2, j)$" :"$ChopLeft(Mid(Temp2, j+1));
			}
			break;
		// CMD :message
		case "QUIT":
			Text = Cmd$" :"$ChopLeft(Mid(Text, i+1));
			break;
		}
	}
	else
		Text = Caps(Text);	

	SendBufferedData(Text$CRLF);
}

function SendChannelText(string Channel, string Text)
{
	SendBufferedData("PRIVMSG "$Channel$" :"$Text$CRLF);
}

function SendChannelAction(string Channel, string Text)
{
	SendBufferedData("PRIVMSG "$Channel$" :"$Chr(1)$"ACTION "$Text$Chr(1)$CRLF);
}

function ProcessInput(string Line)
{
	// Respond to PING
	if(Left(Line, 5) == "PING ")
		SendBufferedData("PONG "$Mid(Line, 5)$CRLF);
}

state LoggingIn
{
	function ProcessInput(string Line)
	{
		local string Temp, Temp2;
    local int i;
		
		Temp = ParseDelimited(Line, " ", 2);

		if(ParseDelimited(Line, " ", 1)== "ERROR")
			SystemPage.SystemText(ChopLeft(ParseDelimited(Line, ":", 2, True)));

		// Handle nick already in use on connect...
		if(Temp == "433")
		{
			SystemPage.SystemText(ChopLeft(ParseDelimited(Line, " ", 3, True)));
		}    
    //utpg: figure out CHANTYPES= and PREFIX=
    else if(Temp == "005")
		{
      SystemPage.SystemText(ChopLeft(ParseDelimited(Line, " ", 3, True)));
			i = 3;
      Temp = ParseDelimited(Line, " ", i);
      while (Temp != "")
      {
        if (Left(Temp, 10) ~= "CHANTYPES=")
        {
          ChannelPrefixes = Mid(Temp, 10);
          SystemPage.SystemText("Supported CHANTYPES: "$ChannelPrefixes); // FIXME: DEBUG: remove before release
        }
        else if (Left(Temp, 7) ~= "PREFIX=")
        {
          //PREFIX=(ov)@+ or PREFIX=(ohv)@%+
          Temp = Mid(Temp, 7);
          if (Left(Temp, 1) == "(")
          {
            Temp2 = Mid(Temp, (InStr(Temp, ")")+1)); // temp = ohv; temp2 = @%+
            Temp = Mid(Temp, 1);
            while (Temp2 != "")
            {
              switch (Caps(Left(Temp, 1)))
              {
                case "O": UPop = Left(Temp2, 1); break;
                case "H": UPhalfop = Left(Temp2, 1); break;
                case "V": UPvoice = Left(Temp2, 1); break;
              }
              Temp = Mid(Temp, 1);
              Temp2 = Mid(Temp2, 1);
            }
            UserPrefixes = UPop$UPhalfop$UPvoice;
            SystemPage.SystemText("Used user PREFIX: "$UserPrefixes); // FIXME: DEBUG: remove before release
          }
        }
        i++;
        Temp = ParseDelimited(Line, " ", i);
      }
		}
    //utpg: figure out CHANTYPES= and PREFIX= -- end
		else if(Int(Temp) > 5) // on 005 we are really logged in
		{
			SystemPage.SystemText(ChopLeft(ParseDelimited(Line, " ", 3, True)));
			GotoState('LoggedIn');
		}
    else {
      SystemPage.SystemText(ChopLeft(ParseDelimited(Line, " ", 3, True)));
    }

		Global.ProcessInput(Line);
	}

	function SendCommandText(string Text)
	{
		Global.SendCommandText(Text);
		if(ParseDelimited(Text, " ", 1) ~= "NICK")
		{
			SystemPage.ChangedNick(NickName, Chop(ParseDelimited(Text, " ", 2)));
		}
	}

Begin:
	SendBufferedData("USER "$UserIdent$" localhost "$ServerAddress$" :"$FullName$CRLF);
	SendBufferedData("NICK "$NickName$CRLF);
}

state LoggedIn
{
	function ProcessInput(string Line)
	{
		local string Temp, Temp2, Temp3;
		local bool bAddModifier;
		local int i;
		local string Command;

		Global.ProcessInput(Line);
		
		Command = ParseDelimited(Line, " ", 2);

		if(ParseDelimited(Line, " ", 1) == "ERROR")
		{
			SystemPage.SystemText(ChopLeft(ParseDelimited(Line, ":", 2, True)));
		}
		else if(Command == "JOIN")
		{
			Temp = ParseDelimited(Line, ":!", 2);
			if(Temp ~= NickName)
				Temp = "";
			SystemPage.JoinedChannel(Chop(ParseDelimited(Line, " ", 3)), Temp);
		}
		else if(Command == "PART")
		{
			Temp = ParseDelimited(Line, ":!", 2);
			if(Temp ~= NickName)
				Temp = "";
			SystemPage.PartedChannel(Chop(ParseDelimited(Line, " ", 3)), Temp);
		}
		else if(Command == "NICK")
		{
			SystemPage.ChangedNick(ParseDelimited(Line, ":!", 2), Chop(ParseDelimited(Line, " ", 3)));
		}
		else if(Command == "QUIT")
		{
			SystemPage.UserQuit(ParseDelimited(Line, ":!", 2), ChopLeft(ParseDelimited(Line, " ", 3, True)));
		}
		else if(Command == "353")	// NAMES
		{
			Temp2 = ParseDelimited(Line, "#", 2);
			Temp2 = ParseDelimited(Temp2, " :", 1);

			Temp = ParseDelimited(Line, ":", 3, True);
			while(Temp != "")
			{
				// Nickname
				Temp3 = ParseDelimited(Temp, " ", 1);

				SystemPage.UserInChannel("#"$Temp2, RemoveNickPrefix(Temp3));

				if(Left(Temp3, 1) == UPop)
					SystemPage.ChangeOp("#"$Temp2, RemoveNickPrefix(Temp3), True);
				else if(Left(Temp3, 1) == UPvoice)
					SystemPage.ChangeVoice("#"$Temp2, RemoveNickPrefix(Temp3), True);
        //utpg: halfop support
        else if(Left(Temp3, 1) == UPhalfop)
					SystemPage.ChangeHalfop("#"$Temp2, RemoveNickPrefix(Temp3), True);
        //utpg: halfop support -- end

        //utpg: FIXME: use prefix + add halfop support

				Temp = ParseDelimited(Temp, " ", 2, True);
			}	
		}
		else if(Command == "333")	// Channel formed info
		{
		}
		else if(Command == "366")	// End of NAMES
		{
		}
		else if(Command == "331")	// RPL_NOTOPIC
		{
		}
		else if(Command == "332")	// RPL_TOPIC
		{
		}
		else if(Command == "341")   // RPL_INVITING
		{
		}
		else if(Command == "301")	// RPL_AWAY
		{
			SystemPage.IsAway(Chop(ParseDelimited(Line, " ", 4)), ChopLeft(ParseDelimited(Line, ":", 3, True)));
		}
		else if(Command == "NOTICE")
		{
			Temp = ParseDelimited(Line, ": ", 2);
			Temp2 = ParseDelimited(Line, ":! ", 2);

			if(InStr(Temp, "!") != -1 && InStr(Temp2, ".") == -1)
			{
				// it's a Nick.
				Temp = ChopLeft(ParseDelimited(Line, " ", 4, True));
				if(Asc(Left(Temp, 1)) == 1 && Asc(Right(Temp, 1)) == 1)
					SystemPage.CTCP("", Temp2, Mid(Temp, 1, Len(Temp) - 2));
				else
					SystemPage.UserNotice(Temp2, Temp);
			}
			else
				SystemPage.SystemText(ChopLeft(ParseDelimited(Line, " ", 4, True)));
		}
		else if(Int(Command)!= 0)
		{
			SystemPage.SystemText(ChopLeft(ParseDelimited(Line, " ", 4, True)));
		}
		else if(Command == "MODE")
		{
			// channel mode
			Temp = Chop(ParseDelimited(Line, " ", 4));
			// channel
			Temp3 = Chop(ParseDelimited(Line, " ", 3));
			i = 5;
			bAddModifier = True;
			while(Temp != "")
			{
				Temp2 = Left(Temp, 1);
				if(Temp2 == "+")
					bAddModifier = True;
				if(Temp2 == "-")
					bAddModifier = False;

				if(Temp2 == UPop)
				{
					SystemPage.ChangeOp(Temp3, Chop(ParseDelimited(Line, " ", i)), bAddModifier);
					i++;
				}
					
				if(Temp2 == UPvoice)
				{
					SystemPage.ChangeVoice(Temp3, Chop(ParseDelimited(Line, " ", i)), bAddModifier);
					i++;
				}

        //utpg: halfop support
        if(Temp2 == UPhalfop)
				{
					SystemPage.ChangeHalfOp(Temp3, Chop(ParseDelimited(Line, " ", i)), bAddModifier);
					i++;
				}
        //utpg: halfop support -- end

				Temp = Mid(Temp, 1);
			}
			 
			SystemPage.ChangeMode(Temp3, ParseDelimited(Line, ":!", 2), ChopLeft(ParseDelimited(Line, " ", 4, True)));

		}
		else if(Command == "KICK")
		{
			// FIXME: handle multiple kicks in a single message
			SystemPage.KickUser(Chop(ParseDelimited(Line, " ", 3)), Chop(ParseDelimited(Line, " ", 4)), ParseDelimited(Line, ":!", 2), ChopLeft(ParseDelimited(Line, ":", 3, True)));
		}
		else if(Command == "INVITE")
		{
			SystemPage.SystemText(ParseDelimited(Line, ":!", 2)@InviteString@ParseDelimited(Line, ":", 3));	
		}
		else if(Command == "PRIVMSG")
		{
			Temp = Chop(ParseDelimited(Line, " ", 3));
			Temp2 = ChopLeft(ParseDelimited(Line, " ", 4, True));

			if(Mid(Temp2, 1, 7) == "ACTION " && Asc(Left(Temp2, 1))==1 && Asc(Right(Temp2, 1))==1)
			{
				Temp2 = Mid(Temp2, 8);
				Temp2 = Left(Temp2, Len(Temp2) - 1);

				if(Temp != "" && InStr("&#@", Left(Temp, 1)) != -1) //utpg: FIXME: use prefix
					SystemPage.ChannelAction(Temp, ParseDelimited(Line, ":!", 2), Temp2);
				else
					SystemPage.PrivateAction(ParseDelimited(Line, ":!", 2), Temp2);
			}
			else
			if(Asc(Left(Temp2, 1))==1 && Asc(Right(Temp2, 1))==1)
			{
				Temp2 = Mid(Temp2, 1, Len(Temp2) - 2);
				
				switch(Temp2)
				{
				case "VERSION":
					SendBufferedData("NOTICE "$ParseDelimited(Line, ":!", 2)$" :"$Chr(1)$"VERSION "$VersionString$Level.EngineVersion$Chr(1)$CRLF);
					SystemPage.CTCP(Temp, ParseDelimited(Line, ":!", 2), Temp2);
					break;
				default:
					SystemPage.CTCP(Temp, ParseDelimited(Line, ":!", 2), Temp2);
					break;
				}
			}
			else
			{
				if(Temp != "" && InStr("&#@", Left(Temp, 1)) != -1)
					SystemPage.ChannelText(Temp, ParseDelimited(Line, ":!", 2), Temp2);
				else
					SystemPage.PrivateText(ParseDelimited(Line, ":!", 2), Temp2);
			}
		}
	}
Begin:
	JoinChannel(DefaultChannel);
}

function JoinChannel(string Channel)
{
	if(Left(Channel, 1) == "#")
		SendBufferedData("JOIN "$Channel$CRLF);
}

function PartChannel(string Channel)
{
	if(Left(Channel, 1) == "#")
		SendBufferedData("PART "$Channel$CRLF);
}

function SetNick(string NewNick)
{
	SendBufferedData("NICK "$NewNick$CRLF);
}

function SetAway(string AwayText)
{
	SendBufferedData("AWAY :"$AwayText$CRLF);
}

function DestroyLink()
{
	SystemPage = None;
	if(IsConnected())
	{
		SendText("QUIT :"$DisconnectReason$CRLF);
		Close();
	}
	else
		Destroy();
}

defaultproperties
{
      ServerIPAddr=(Addr=0,Port=0)
      ServerAddress=""
      ServerPort=0
      NickName=""
      UserIdent=""
      FullName=""
      DefaultChannel=""
      InvalidAddressText="Invalid server address, aborting."
      ErrorBindingText="Error binding local port, aborting."
      ResolveFailedText="Failed to resolve server address, aborting."
      ConnectedText="Connected."
      ConnectingToText="Connecting to"
      TimeOutError="Timeout connecting to server."
      InviteString="invites you to join"
      SystemPage=None
      DisconnectReason="Disconnected"
      VersionString="UBrowser IRC Client version "
      UPop=""
      UPhalfop=""
      UPvoice=""
      UserPrefixes=""
      ChannelPrefixes=""
}
