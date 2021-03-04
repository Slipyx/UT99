//=============================================================================
// ChallengeVoicePack.
//=============================================================================
class ChallengeVoicePack extends VoicePack
	abstract;

var() Sound NameSound[4]; // leader names
var() localized float NameTime[4];

var() Sound AckSound[16]; // acknowledgement sounds
var() localized string AckString[16];
var() localized string AckAbbrev[16];
var() localized float AckTime[16];
var() int numAcks;

var() Sound FFireSound[16];
var() localized string FFireString[16];
var() localized string FFireAbbrev[16];
var() int numFFires;

var() Sound TauntSound[32];
var() localized string TauntString[32];
var() localized string TauntAbbrev[32];
var() int numTaunts;
var() byte MatureTaunt[32];
var   name SendType[5];

var localized String LeaderSign[4];

/* Orders (in same order as in Orders Menu 
	0 = Defend, 
	1 = Hold, 
	2 = Attack, 
	3 = Follow, 
	4 = FreeLance
*/
var() Sound OrderSound[16];
var() localized string OrderString[16];
var() localized string OrderAbbrev[16];

var localized string CommaText;

/* Other messages - use passed messageIndex
	0 = Base Undefended
	1 = Get Flag
	2 = Got Flag
	3 = Back up
	4 = Im Hit
	5 = Under Attack
	6 = Man Down
*/
var() Sound OtherSound[32];
var() localized string OtherString[32];
var() localized string OtherAbbrev[32];

var Sound Phrase[8];
var float PhraseTime[8];
var int PhraseNum;
var string DelayedResponse;
var bool bDelayedResponse;
var PlayerReplicationInfo DelayedSender;

function string GetCallSign( PlayerReplicationInfo P )
{
	if ( P == None )
		return "";
	if ( (Level.NetMode == NM_Standalone) && (P.TeamID == 0) )
		return LeaderSign[P.Team];
	else
		return P.PlayerName;
}

function BotInitialize(PlayerReplicationInfo Sender, PlayerReplicationInfo Recipient, name messagetype, byte messageIndex)
{
	local int m;
	local Sound MessageSound;
	local float MessageTime;

	if ( messagetype == 'ACK' )
		SetAckMessage(messageIndex, Recipient, MessageSound, MessageTime);
	else
	{
		SetTimer(0.1, false);
		if ( recipient != None )
		{
			if ( (Level.NetMode == NM_Standalone) && (recipient.TeamID == 0) )
			{
				Phrase[0] = NameSound[recipient.Team];
				PhraseTime[0] = NameTime[recipient.Team];
				m = 1;
			}
			DelayedResponse = GetCallSign(Recipient)$CommaText;
		}	
		else
			m = 0;
		if ( messagetype == 'FRIENDLYFIRE' )
			SetFFireMessage(messageIndex, Recipient, MessageSound, MessageTime);
		else if ( messagetype == 'AUTOTAUNT' ) 
		{
			SetTauntMessage(messageIndex, Recipient, MessageSound, MessageTime);
			if ( Level.NetMode != NM_Standalone )
				DelayedResponse = "";
		}
		else if ( messagetype == 'TAUNT' )
			SetTauntMessage(messageIndex, Recipient, MessageSound, MessageTime);
		else if ( messagetype == 'ORDER' )
			SetOrderMessage(messageIndex, Recipient, MessageSound, MessageTime);
		else // messagetype == Other
			SetOtherMessage(messageIndex, Recipient, MessageSound, MessageTime);

		Phrase[m] = MessageSound;
		PhraseTime[m] = MessageTime;
	}
}

function ClientInitialize(PlayerReplicationInfo Sender, PlayerReplicationInfo Recipient, name messagetype, byte messageIndex)
{
	local int m;
	local Sound MessageSound;
	local float MessageTime;

	DelayedSender = Sender;
	bDelayedResponse = true;

	if ( Sender.bIsABot )
	{
		BotInitialize(Sender, Recipient, messagetype, messageIndex);
		return;
	}

	SetTimer(0.1, false);

	if ( messagetype == 'ACK' )
		SetClientAckMessage(messageIndex, Recipient, MessageSound, MessageTime);
	else
	{
		if ( recipient != None )
		{
			if ( (Level.NetMode == NM_Standalone) && (recipient.TeamID == 0) )
			{
				Phrase[0] = NameSound[recipient.Team];
				PhraseTime[0] = NameTime[recipient.Team];
				m = 1;
			}
			DelayedResponse = GetCallSign(Recipient)$CommaText;
		}
		else if ( (messageType == 'OTHER') && (messageIndex == 9) )
		{
			Phrase[0] = NameSound[Sender.Team];
			PhraseTime[0] = NameTime[Sender.Team];
			m = 1;
		}
		else
			m = 0;
		if ( messagetype == 'FRIENDLYFIRE' )
			SetClientFFireMessage(messageIndex, Recipient, MessageSound, MessageTime);
		else if ( messagetype == 'TAUNT' )
			SetClientTauntMessage(messageIndex, Recipient, MessageSound, MessageTime);
		else if ( messagetype == 'AUTOTAUNT' )
		{
			SetClientTauntMessage(messageIndex, Recipient, MessageSound, MessageTime);
			SetTimer(0.8, false);
			if ( Level.NetMode != NM_Standalone )
				DelayedResponse = "";
		}
		else if ( messagetype == 'ORDER' )
			SetClientOrderMessage(messageIndex, Recipient, MessageSound, MessageTime);
		else // messagetype == Other
			SetClientOtherMessage(messageIndex, Recipient, MessageSound, MessageTime);
	}
	Phrase[m] = MessageSound;
	PhraseTime[m] = MessageTime;
}

function SetClientAckMessage(int messageIndex, PlayerReplicationInfo Recipient, out Sound MessageSound, out Float MessageTime)
{
	messageIndex = Clamp(messageIndex, 0, numAcks-1);

	if (Recipient != None)
		DelayedResponse = AckString[messageIndex]$CommaText$GetCallsign(Recipient);
	else
		DelayedResponse = AckString[messageIndex];

	MessageSound = AckSound[messageIndex];
	MessageTime = AckTime[messageIndex];

	if ( (Recipient != None) && (Level.NetMode == NM_Standalone) 
		&& (recipient.TeamID == 0) && PlayerPawn(Owner).GameReplicationInfo.bTeamGame )
	{
		Phrase[1] = NameSound[Recipient.Team];
		PhraseTime[1] = NameTime[Recipient.Team];
	}
}

function SetAckMessage(int messageIndex, PlayerReplicationInfo Recipient, out Sound MessageSound, out Float MessageTime)
{
	DelayedResponse = AckString[messageIndex]$CommaText$GetCallSign(recipient);
	SetTimer(3 + FRand(), false); // wait for initial order to be spoken
	Phrase[0] = AckSound[messageIndex];
	PhraseTime[0] = AckTime[messageIndex];
	if ( (Level.NetMode == NM_Standalone) && (recipient.TeamID == 0) && PlayerPawn(Owner).GameReplicationInfo.bTeamGame )
	{
		Phrase[1] = NameSound[recipient.Team];
		PhraseTime[1] = NameTime[recipient.Team];
	}
}

function SetClientFFireMessage(int messageIndex, PlayerReplicationInfo Recipient, out Sound MessageSound, out Float MessageTime)
{
	messageIndex = Clamp(messageIndex, 0, numFFires-1);

	DelayedResponse = DelayedResponse$FFireString[messageIndex];
	MessageSound = FFireSound[messageIndex];
}

function SetFFireMessage(int messageIndex, PlayerReplicationInfo Recipient, out Sound MessageSound, out Float MessageTime)
{
	DelayedResponse = DelayedResponse$FFireString[messageIndex];
	MessageSound = FFireSound[messageIndex];
}

function SetClientTauntMessage(int messageIndex, PlayerReplicationInfo Recipient, out Sound MessageSound, out Float MessageTime)
{
	messageIndex = Clamp(messageIndex, 0, numTaunts-1);

	// check if need to avoid a mature taunt
	if ( class'TournamentPlayer'.Default.bNoMatureLanguage || class'DeathMatchPlus'.Default.bLowGore )
	{
		while ( MatureTaunt[messageIndex] > 0 )
			messageIndex--;

		if ( messageIndex < 0 )
		{
			SetTimer(0.0, false);
			Destroy();
			return;
		}
	}
	DelayedResponse = DelayedResponse$TauntString[messageIndex];
	MessageSound = TauntSound[messageIndex];
}

function SetTauntMessage(int messageIndex, PlayerReplicationInfo Recipient, out Sound MessageSound, out Float MessageTime)
{
	// check if need to avoid a mature taunt
	if ( class'TournamentPlayer'.Default.bNoMatureLanguage || class'DeathMatchPlus'.Default.bLowGore )
	{
		while ( MatureTaunt[messageIndex] > 0 )
			messageIndex--;

		if ( messageIndex < 0 )
		{
			SetTimer(0.0, false);
			Destroy();
			return;
		}
	}
	DelayedResponse = DelayedResponse$TauntString[messageIndex];
	MessageSound = TauntSound[messageIndex];
	SetTimer(1.0, false);
}

function SetClientOrderMessage(int messageIndex, PlayerReplicationInfo Recipient, out Sound MessageSound, out Float MessageTime)
{
	DelayedResponse = DelayedResponse$OrderString[messageIndex];
	MessageSound = OrderSound[messageIndex];
}

function SetOrderMessage(int messageIndex, PlayerReplicationInfo Recipient, out Sound MessageSound, out Float MessageTime)
{
	if ( messageIndex == 2 )
	{
		if ( Level.Game.IsA('CTFGame') )
			messageIndex = 10;
	}
	else if ( messageIndex == 4 )
	{
		if ( FRand() < 0.4 )
			messageIndex = 11;
	}
	DelayedResponse = DelayedResponse$OrderString[messageIndex];
	MessageSound = OrderSound[messageIndex];
}

// for Voice message popup menu - since order names may be replaced for some game types
static function string GetOrderString(int i, string GameType )
{
	if ( i > 9 )
		return ""; //high index order strings are alternates to the base orders 
	if (i == 2)
	{
		if (GameType == "Capture the Flag")
		{
			if ( Default.OrderAbbrev[10] != "" )
				return Default.OrderAbbrev[10];
			else
				return Default.OrderString[10];
		} else if (GameType == "Domination") {
			if ( Default.OrderAbbrev[11] != "" )
				return Default.OrderAbbrev[11];
			else
				return Default.OrderString[11];
		}
	}

	if ( Default.OrderAbbrev[i] != "" )
		return Default.OrderAbbrev[i];

	return Default.OrderString[i];
}

function SetClientOtherMessage(int messageIndex, PlayerReplicationInfo Recipient, out Sound MessageSound, out Float MessageTime)
{
	DelayedResponse = DelayedResponse$OtherString[messageIndex];
	MessageSound = OtherSound[messageIndex];
}

function SetOtherMessage(int messageIndex, PlayerReplicationInfo Recipient, out Sound MessageSound, out Float MessageTime)
{
	DelayedResponse = DelayedResponse$OtherString[messageIndex];
	MessageSound = OtherSound[messageIndex];
}

function Timer()
{
	local name MessageType;
	local float OldPlaySound;

	if ( bDelayedResponse )
	{
		bDelayedResponse = false;
		if ( Owner.IsA('PlayerPawn') )
		{
			if ( PlayerPawn(Owner).GameReplicationInfo.bTeamGame 
				 && (PlayerPawn(Owner).PlayerReplicationInfo.Team == DelayedSender.Team) )
				MessageType = 'TeamSay';
			else
				MessageType = 'Say';
			PlayerPawn(Owner).TeamMessage(DelayedSender, DelayedResponse, MessageType, false);
		}
	}
	if ( Phrase[PhraseNum] != None )
	{
		if ( Owner.IsA('PlayerPawn') && !PlayerPawn(Owner).bNoVoices 
			&& (Level.TimeSeconds - PlayerPawn(Owner).LastPlaySound > 2)  ) 
		{
			OldPlaySound = PlayerPawn(Owner).LastPlaySound;
			PlayerPawn(Owner).ClientPlaySound(Phrase[PhraseNum],, true);
			PlayerPawn(Owner).LastPlaySound = OldPlaySound;
		}
		if ( PhraseTime[PhraseNum] == 0 )
			Destroy();
		else
		{
			SetTimer(PhraseTime[PhraseNum], false);
			PhraseNum++;
		}
	}
	else 
		Destroy();
}

function PlayerSpeech( int Type, int Index, int Callsign )
{
	local name SendMode;
	local PlayerReplicationInfo Recipient;
	local Pawn P;

	switch (Type)
	{
		case 0:			// Acknowledgements
			SendMode = 'TEAM';		// Only send to team.
			Recipient = None;		// Send to everyone.
			break;
		case 1:			// Friendly Fire
			SendMode = 'TEAM';		// Only send to team.
			Recipient = None;		// Send to everyone.
			break;
		case 2:			// Orders
			SendMode = 'TEAM';		// Only send to team.
			if (Index == 2)
			{
				if (Level.Game.IsA('CTFGame'))
					Index = 10;
				if (Level.Game.IsA('Domination'))
					Index = 11;
			}
			if ( PlayerPawn(Owner).GameReplicationInfo.bTeamGame )
			{
				if ( Callsign == -1 )
					Recipient = None;
				else {
					for ( P=Level.PawnList; P!=None; P=P.NextPawn )
						//if ( P.bIsPlayer && (P.PlayerReplicationInfo.TeamId == Callsign)
						if ( (P.PlayerReplicationInfo.TeamId == Callsign)
							&& (P.PlayerReplicationInfo.Team == PlayerPawn(Owner).PlayerReplicationInfo.Team) )
						{
							Recipient = P.PlayerReplicationInfo;
							break;
						}
				}
			}
			break;
		case 3:			// Taunts
			SendMode = 'GLOBAL';	// Send to all teams.
			Recipient = None;		// Send to everyone.
			break;
		case 4:			// Other
			SendMode = 'TEAM';		// Only send to team.
			Recipient = None;		// Send to everyone.
			break;
	}
	if (!PlayerPawn(Owner).GameReplicationInfo.bTeamGame)
		SendMode = 'GLOBAL';  // Not a team game? Send to everyone.

	Pawn(Owner).SendVoiceMessage( Pawn(Owner).PlayerReplicationInfo, Recipient, SendType[Type], Index, SendMode );
}

static function string GetAckString(int i)
{
	if ( Default.AckAbbrev[i] != "" )
		return Default.AckAbbrev[i];

	return default.AckString[i];
}

static function string GetFFireString(int i)
{
	if ( default.FFireAbbrev[i] != "" )
		return default.FFireAbbrev[i];

	return default.FFireString[i];
}

static function string GetTauntString(int i)
{
	if ( default.TauntAbbrev[i] != "" )
		return default.TauntAbbrev[i];
	
	return default.TauntString[i];
}

static function string GetOtherString(int i)
{
	if ( Default.OtherAbbrev[i] != "" )
		return default.OtherAbbrev[i];
	
	return default.OtherString[i];
}

defaultproperties
{
      NameSound(0)=None
      NameSound(1)=None
      NameSound(2)=None
      NameSound(3)=None
      NameTime(0)=0.000000
      NameTime(1)=0.000000
      NameTime(2)=0.000000
      NameTime(3)=0.000000
      AckSound(0)=None
      AckSound(1)=None
      AckSound(2)=None
      AckSound(3)=None
      AckSound(4)=None
      AckSound(5)=None
      AckSound(6)=None
      AckSound(7)=None
      AckSound(8)=None
      AckSound(9)=None
      AckSound(10)=None
      AckSound(11)=None
      AckSound(12)=None
      AckSound(13)=None
      AckSound(14)=None
      AckSound(15)=None
      AckString(0)=""
      AckString(1)=""
      AckString(2)=""
      AckString(3)=""
      AckString(4)=""
      AckString(5)=""
      AckString(6)=""
      AckString(7)=""
      AckString(8)=""
      AckString(9)=""
      AckString(10)=""
      AckString(11)=""
      AckString(12)=""
      AckString(13)=""
      AckString(14)=""
      AckString(15)=""
      AckAbbrev(0)=""
      AckAbbrev(1)=""
      AckAbbrev(2)=""
      AckAbbrev(3)=""
      AckAbbrev(4)=""
      AckAbbrev(5)=""
      AckAbbrev(6)=""
      AckAbbrev(7)=""
      AckAbbrev(8)=""
      AckAbbrev(9)=""
      AckAbbrev(10)=""
      AckAbbrev(11)=""
      AckAbbrev(12)=""
      AckAbbrev(13)=""
      AckAbbrev(14)=""
      AckAbbrev(15)=""
      AckTime(0)=0.000000
      AckTime(1)=0.000000
      AckTime(2)=0.000000
      AckTime(3)=0.000000
      AckTime(4)=0.000000
      AckTime(5)=0.000000
      AckTime(6)=0.000000
      AckTime(7)=0.000000
      AckTime(8)=0.000000
      AckTime(9)=0.000000
      AckTime(10)=0.000000
      AckTime(11)=0.000000
      AckTime(12)=0.000000
      AckTime(13)=0.000000
      AckTime(14)=0.000000
      AckTime(15)=0.000000
      numAcks=0
      FFireSound(0)=None
      FFireSound(1)=None
      FFireSound(2)=None
      FFireSound(3)=None
      FFireSound(4)=None
      FFireSound(5)=None
      FFireSound(6)=None
      FFireSound(7)=None
      FFireSound(8)=None
      FFireSound(9)=None
      FFireSound(10)=None
      FFireSound(11)=None
      FFireSound(12)=None
      FFireSound(13)=None
      FFireSound(14)=None
      FFireSound(15)=None
      FFireString(0)=""
      FFireString(1)=""
      FFireString(2)=""
      FFireString(3)=""
      FFireString(4)=""
      FFireString(5)=""
      FFireString(6)=""
      FFireString(7)=""
      FFireString(8)=""
      FFireString(9)=""
      FFireString(10)=""
      FFireString(11)=""
      FFireString(12)=""
      FFireString(13)=""
      FFireString(14)=""
      FFireString(15)=""
      FFireAbbrev(0)=""
      FFireAbbrev(1)=""
      FFireAbbrev(2)=""
      FFireAbbrev(3)=""
      FFireAbbrev(4)=""
      FFireAbbrev(5)=""
      FFireAbbrev(6)=""
      FFireAbbrev(7)=""
      FFireAbbrev(8)=""
      FFireAbbrev(9)=""
      FFireAbbrev(10)=""
      FFireAbbrev(11)=""
      FFireAbbrev(12)=""
      FFireAbbrev(13)=""
      FFireAbbrev(14)=""
      FFireAbbrev(15)=""
      numFFires=0
      TauntSound(0)=None
      TauntSound(1)=None
      TauntSound(2)=None
      TauntSound(3)=None
      TauntSound(4)=None
      TauntSound(5)=None
      TauntSound(6)=None
      TauntSound(7)=None
      TauntSound(8)=None
      TauntSound(9)=None
      TauntSound(10)=None
      TauntSound(11)=None
      TauntSound(12)=None
      TauntSound(13)=None
      TauntSound(14)=None
      TauntSound(15)=None
      TauntSound(16)=None
      TauntSound(17)=None
      TauntSound(18)=None
      TauntSound(19)=None
      TauntSound(20)=None
      TauntSound(21)=None
      TauntSound(22)=None
      TauntSound(23)=None
      TauntSound(24)=None
      TauntSound(25)=None
      TauntSound(26)=None
      TauntSound(27)=None
      TauntSound(28)=None
      TauntSound(29)=None
      TauntSound(30)=None
      TauntSound(31)=None
      TauntString(0)=""
      TauntString(1)=""
      TauntString(2)=""
      TauntString(3)=""
      TauntString(4)=""
      TauntString(5)=""
      TauntString(6)=""
      TauntString(7)=""
      TauntString(8)=""
      TauntString(9)=""
      TauntString(10)=""
      TauntString(11)=""
      TauntString(12)=""
      TauntString(13)=""
      TauntString(14)=""
      TauntString(15)=""
      TauntString(16)=""
      TauntString(17)=""
      TauntString(18)=""
      TauntString(19)=""
      TauntString(20)=""
      TauntString(21)=""
      TauntString(22)=""
      TauntString(23)=""
      TauntString(24)=""
      TauntString(25)=""
      TauntString(26)=""
      TauntString(27)=""
      TauntString(28)=""
      TauntString(29)=""
      TauntString(30)=""
      TauntString(31)=""
      TauntAbbrev(0)=""
      TauntAbbrev(1)=""
      TauntAbbrev(2)=""
      TauntAbbrev(3)=""
      TauntAbbrev(4)=""
      TauntAbbrev(5)=""
      TauntAbbrev(6)=""
      TauntAbbrev(7)=""
      TauntAbbrev(8)=""
      TauntAbbrev(9)=""
      TauntAbbrev(10)=""
      TauntAbbrev(11)=""
      TauntAbbrev(12)=""
      TauntAbbrev(13)=""
      TauntAbbrev(14)=""
      TauntAbbrev(15)=""
      TauntAbbrev(16)=""
      TauntAbbrev(17)=""
      TauntAbbrev(18)=""
      TauntAbbrev(19)=""
      TauntAbbrev(20)=""
      TauntAbbrev(21)=""
      TauntAbbrev(22)=""
      TauntAbbrev(23)=""
      TauntAbbrev(24)=""
      TauntAbbrev(25)=""
      TauntAbbrev(26)=""
      TauntAbbrev(27)=""
      TauntAbbrev(28)=""
      TauntAbbrev(29)=""
      TauntAbbrev(30)=""
      TauntAbbrev(31)=""
      numTaunts=0
      MatureTaunt(0)=0
      MatureTaunt(1)=0
      MatureTaunt(2)=0
      MatureTaunt(3)=0
      MatureTaunt(4)=0
      MatureTaunt(5)=0
      MatureTaunt(6)=0
      MatureTaunt(7)=0
      MatureTaunt(8)=0
      MatureTaunt(9)=0
      MatureTaunt(10)=0
      MatureTaunt(11)=0
      MatureTaunt(12)=0
      MatureTaunt(13)=0
      MatureTaunt(14)=0
      MatureTaunt(15)=0
      MatureTaunt(16)=0
      MatureTaunt(17)=0
      MatureTaunt(18)=0
      MatureTaunt(19)=0
      MatureTaunt(20)=0
      MatureTaunt(21)=0
      MatureTaunt(22)=0
      MatureTaunt(23)=0
      MatureTaunt(24)=0
      MatureTaunt(25)=0
      MatureTaunt(26)=0
      MatureTaunt(27)=0
      MatureTaunt(28)=0
      MatureTaunt(29)=0
      MatureTaunt(30)=0
      MatureTaunt(31)=0
      SendType(0)="ACK"
      SendType(1)="FRIENDLYFIRE"
      SendType(2)="ORDER"
      SendType(3)="Taunt"
      SendType(4)="Other"
      LeaderSign(0)="Red Leader"
      LeaderSign(1)="Blue Leader"
      LeaderSign(2)="Green Leader"
      LeaderSign(3)="Gold Leader"
      OrderSound(0)=None
      OrderSound(1)=None
      OrderSound(2)=None
      OrderSound(3)=None
      OrderSound(4)=None
      OrderSound(5)=None
      OrderSound(6)=None
      OrderSound(7)=None
      OrderSound(8)=None
      OrderSound(9)=None
      OrderSound(10)=None
      OrderSound(11)=None
      OrderSound(12)=None
      OrderSound(13)=None
      OrderSound(14)=None
      OrderSound(15)=None
      OrderString(0)=""
      OrderString(1)=""
      OrderString(2)=""
      OrderString(3)=""
      OrderString(4)=""
      OrderString(5)=""
      OrderString(6)=""
      OrderString(7)=""
      OrderString(8)=""
      OrderString(9)=""
      OrderString(10)=""
      OrderString(11)=""
      OrderString(12)=""
      OrderString(13)=""
      OrderString(14)=""
      OrderString(15)=""
      OrderAbbrev(0)=""
      OrderAbbrev(1)=""
      OrderAbbrev(2)=""
      OrderAbbrev(3)=""
      OrderAbbrev(4)=""
      OrderAbbrev(5)=""
      OrderAbbrev(6)=""
      OrderAbbrev(7)=""
      OrderAbbrev(8)=""
      OrderAbbrev(9)=""
      OrderAbbrev(10)=""
      OrderAbbrev(11)=""
      OrderAbbrev(12)=""
      OrderAbbrev(13)=""
      OrderAbbrev(14)=""
      OrderAbbrev(15)=""
      CommaText=", "
      OtherSound(0)=None
      OtherSound(1)=None
      OtherSound(2)=None
      OtherSound(3)=None
      OtherSound(4)=None
      OtherSound(5)=None
      OtherSound(6)=None
      OtherSound(7)=None
      OtherSound(8)=None
      OtherSound(9)=None
      OtherSound(10)=None
      OtherSound(11)=None
      OtherSound(12)=None
      OtherSound(13)=None
      OtherSound(14)=None
      OtherSound(15)=None
      OtherSound(16)=None
      OtherSound(17)=None
      OtherSound(18)=None
      OtherSound(19)=None
      OtherSound(20)=None
      OtherSound(21)=None
      OtherSound(22)=None
      OtherSound(23)=None
      OtherSound(24)=None
      OtherSound(25)=None
      OtherSound(26)=None
      OtherSound(27)=None
      OtherSound(28)=None
      OtherSound(29)=None
      OtherSound(30)=None
      OtherSound(31)=None
      otherstring(0)=""
      otherstring(1)=""
      otherstring(2)=""
      otherstring(3)=""
      otherstring(4)=""
      otherstring(5)=""
      otherstring(6)=""
      otherstring(7)=""
      otherstring(8)=""
      otherstring(9)=""
      otherstring(10)=""
      otherstring(11)=""
      otherstring(12)=""
      otherstring(13)=""
      otherstring(14)=""
      otherstring(15)=""
      otherstring(16)=""
      otherstring(17)=""
      otherstring(18)=""
      otherstring(19)=""
      otherstring(20)=""
      otherstring(21)=""
      otherstring(22)=""
      otherstring(23)=""
      otherstring(24)=""
      otherstring(25)=""
      otherstring(26)=""
      otherstring(27)=""
      otherstring(28)=""
      otherstring(29)=""
      otherstring(30)=""
      otherstring(31)=""
      OtherAbbrev(0)=""
      OtherAbbrev(1)=""
      OtherAbbrev(2)=""
      OtherAbbrev(3)=""
      OtherAbbrev(4)=""
      OtherAbbrev(5)=""
      OtherAbbrev(6)=""
      OtherAbbrev(7)=""
      OtherAbbrev(8)=""
      OtherAbbrev(9)=""
      OtherAbbrev(10)=""
      OtherAbbrev(11)=""
      OtherAbbrev(12)=""
      OtherAbbrev(13)=""
      OtherAbbrev(14)=""
      OtherAbbrev(15)=""
      OtherAbbrev(16)=""
      OtherAbbrev(17)=""
      OtherAbbrev(18)=""
      OtherAbbrev(19)=""
      OtherAbbrev(20)=""
      OtherAbbrev(21)=""
      OtherAbbrev(22)=""
      OtherAbbrev(23)=""
      OtherAbbrev(24)=""
      OtherAbbrev(25)=""
      OtherAbbrev(26)=""
      OtherAbbrev(27)=""
      OtherAbbrev(28)=""
      OtherAbbrev(29)=""
      OtherAbbrev(30)=""
      OtherAbbrev(31)=""
      phrase(0)=None
      phrase(1)=None
      phrase(2)=None
      phrase(3)=None
      phrase(4)=None
      phrase(5)=None
      phrase(6)=None
      phrase(7)=None
      PhraseTime(0)=0.000000
      PhraseTime(1)=0.000000
      PhraseTime(2)=0.000000
      PhraseTime(3)=0.000000
      PhraseTime(4)=0.000000
      PhraseTime(5)=0.000000
      PhraseTime(6)=0.000000
      PhraseTime(7)=0.000000
      PhraseNum=0
      DelayedResponse=""
      bDelayedResponse=False
      DelayedSender=None
}
