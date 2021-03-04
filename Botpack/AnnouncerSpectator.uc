class AnnouncerSpectator extends MessagingSpectator;

event PreBeginPlay()
{
	Super.PreBeginPlay();
	
	// Hack to make the announcer invisible on the SmartCTF scoreboard
	if (PlayerReplicationInfo != none)
	    PlayerReplicationInfo.StartTime = 0;

	RemovePawn();
}

function ReceiveLocalizedMessage( class<LocalMessage> Message, optional int Switch, optional PlayerReplicationInfo RelatedPRI_1, optional PlayerReplicationInfo RelatedPRI_2, optional Object OptionalObject )
{
}

function ClientMessage( coerce string S, optional name Type, optional bool bBeep )
{
}

function TeamMessage( PlayerReplicationInfo PRI, coerce string S, name Type, optional bool bBeep )
{
}

function ClientVoiceMessage(PlayerReplicationInfo Sender, PlayerReplicationInfo Recipient, name messagetype, byte messageID)
{
}

defaultproperties
{
}
