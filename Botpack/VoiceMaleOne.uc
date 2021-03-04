//=============================================================================
// VoiceMaleOne.
//=============================================================================
class VoiceMaleOne extends VoiceMale;

#exec OBJ LOAD FILE=..\Sounds\Male1Voice.uax PACKAGE=Male1Voice

function SetOtherMessage(int messageIndex, PlayerReplicationInfo Recipient, out Sound MessageSound, out Float MessageTime)
{
	if ( messageIndex == 3 )
	{
		if ( FRand() < 0.3 )
			messageIndex = 7;
		else if ( FRand() < 0.5 )
			messageIndex = 15;
	}
	else if ( messageIndex == 4 )
	{
		if ( FRand() < 0.3 )
			messageIndex = 6;
		else if ( FRand() < 0.5 )
			messageIndex = 13;
	}
	else if ( messageIndex == 10 )
	{
		SetTimer(3 + FRand(), false); // wait for initial request to be spoken
		if ( FRand() < 0.5 )
		{
			DelayedResponse = AckString[2]$CommaText$GetCallSign(recipient);
			Phrase[0] = AckSound[2];
			PhraseTime[0] = AckTime[2];
			if ( (Level.NetMode == NM_Standalone) && (recipient.TeamID == 0) )
			{
				Phrase[1] = NameSound[recipient.Team];
				PhraseTime[1] = NameTime[recipient.Team];
			}
			return;
		}
	}
	Super.SetOtherMessage(messageIndex, Recipient, MessageSound, MessageTime);
}

defaultproperties
{
      NameSound(0)=Sound'Male1Voice.(All).M1redleader'
      NameSound(1)=Sound'Male1Voice.(All).M1blueleader'
      NameSound(2)=Sound'Male1Voice.(All).M1greenleader'
      NameSound(3)=Sound'Male1Voice.(All).M1goldleader'
      NameTime(0)=0.960000
      NameTime(1)=1.100000
      NameTime(2)=1.020000
      NameTime(3)=0.990000
      AckSound(0)=Sound'Male1Voice.(All).M1gotit'
      AckSound(1)=Sound'Male1Voice.(All).M1roger'
      AckSound(2)=Sound'Male1Voice.(All).M1onmyway'
      AckSound(3)=Sound'Male1Voice.(All).M1imonit'
      AckString(0)="Got it"
      AckString(1)="Roger"
      AckString(2)="On my way"
      AckString(3)="I'm on it."
      AckTime(0)=0.780000
      AckTime(1)=0.810000
      AckTime(2)=0.980000
      AckTime(3)=0.980000
      numAcks=4
      FFireSound(0)=Sound'Male1Voice.(All).M1sameteam'
      FFireSound(1)=Sound'Male1Voice.(All).M1idiot'
      FFireString(0)="Hey! Same team!"
      FFireString(1)="I'm on your team, you idiot!"
      FFireAbbrev(1)="On your team!"
      numFFires=2
      TauntSound(0)=Sound'Male1Voice.(All).M1eatthat'
      TauntSound(1)=Sound'Male1Voice.(All).M1likethat'
      TauntSound(2)=Sound'Male1Voice.(All).M1yeahbitch'
      TauntSound(3)=Sound'Male1Voice.(All).M1boom'
      TauntSound(4)=Sound'Male1Voice.(All).M1burnbaby'
      TauntSound(5)=Sound'Male1Voice.(All).M1letsrock'
      TauntSound(6)=Sound'Male1Voice.(All).M1diebitch'
      TauntSound(7)=Sound'Male1Voice.(All).M1loser'
      TauntSound(8)=Sound'Male1Voice.(All).M1nailedem'
      TauntSound(9)=Sound'Male1Voice.(All).M1nasty'
      TauntSound(10)=Sound'Male1Voice.(All).M1nice'
      TauntSound(11)=Sound'Male1Voice.(All).M1ohyeah'
      TauntSound(12)=Sound'Male1Voice.(All).M1slaughter'
      TauntSound(13)=Sound'Male1Voice.(All).M1sucker'
      TauntSound(14)=Sound'Male1Voice.(All).M1yeehaw'
      TauntSound(15)=Sound'Male1Voice.(All).M1yousuck'
      TauntString(0)="Eat that!"
      TauntString(1)="You like that?"
      TauntString(2)="Yeah, bitch!"
      TauntString(3)="Boom!"
      TauntString(4)="Burn, baby"
      TauntString(5)="Lets Rock!"
      TauntString(6)="Die, bitch."
      TauntString(7)="Loser."
      TauntString(8)="Nailed 'im."
      TauntString(9)="That was nasty."
      TauntString(10)="Nice."
      TauntString(11)="Oh, yeah!"
      TauntString(12)="I just slaughtered that guy."
      TauntString(13)="Sucker!"
      TauntString(14)="Yeehaw!"
      TauntString(15)="You suck!"
      TauntAbbrev(12)="Slaughtered him."
      numTaunts=16
      MatureTaunt(2)=1
      MatureTaunt(6)=1
      OrderSound(0)=Sound'Male1Voice.(All).M1defend'
      OrderSound(1)=Sound'Male1Voice.(All).M1hold'
      OrderSound(2)=Sound'Male1Voice.(All).M1assault'
      OrderSound(3)=Sound'Male1Voice.(All).M1coverme'
      OrderSound(4)=Sound'Male1Voice.(All).M1engage'
      OrderSound(10)=Sound'Male1Voice.(All).M1takeflag'
      OrderSound(11)=Sound'Male1Voice.(All).M1searchdestroy'
      OrderString(0)="Defend the base."
      OrderString(1)="Hold this position."
      OrderString(2)="Assault the base."
      OrderString(3)="Cover me."
      OrderString(4)="Engage according to operational parameters."
      OrderString(10)="Take their flag."
      OrderString(11)="Search and destroy."
      OrderAbbrev(0)="Defend"
      OrderAbbrev(2)="Attack"
      OrderAbbrev(4)="Freelance."
      OtherSound(0)=Sound'Male1Voice.(All).M1uncovered'
      OtherSound(1)=Sound'Male1Voice.(All).M1getflagback'
      OtherSound(2)=Sound'Male1Voice.(All).M1igotflag'
      OtherSound(3)=Sound'Male1Voice.(All).M1gotyourback'
      OtherSound(4)=Sound'Male1Voice.(All).M1imhit'
      OtherSound(6)=Sound'Male1Voice.(All).M1underattack'
      OtherSound(7)=Sound'Male1Voice.(All).M1yougotpoint'
      OtherSound(8)=Sound'Male1Voice.(All).M1igotflag'
      OtherSound(9)=Sound'Male1Voice.(All).M1inposition'
      OtherSound(10)=Sound'Male1Voice.(All).M1onmyway'
      OtherSound(11)=Sound'Male1Voice.(All).M1pointsecure'
      OtherSound(12)=Sound'Male1Voice.(All).M1enemycarrier'
      OtherSound(13)=Sound'Male1Voice.(All).M1backup'
      OtherSound(14)=Sound'Male1Voice.(All).M1takedown'
      OtherSound(15)=Sound'Male1Voice.(All).M1gotyoucovered'
      OtherSound(16)=Sound'Male1Voice.(All).M1objectdestroy'
      otherstring(0)="Base is uncovered!"
      otherstring(1)="Somebody get our flag back!"
      otherstring(2)="I've got the flag."
      otherstring(3)="I've got your back."
      otherstring(4)="I'm hit!"
      otherstring(5)="Man down!"
      otherstring(6)="I'm under heavy attack!"
      otherstring(7)="You got point."
      otherstring(8)="I've got our flag."
      otherstring(9)="I'm in position."
      otherstring(10)="On my way."
      otherstring(11)="Control point is secure."
      otherstring(12)="Enemy flag carrier is here."
      otherstring(13)="I need some backup."
      otherstring(14)="Take them down."
      otherstring(15)="I've got you covered."
      otherstring(16)="Objective destroyed."
      OtherAbbrev(1)="Get our flag!"
      OtherAbbrev(2)="Got the flag."
      OtherAbbrev(3)="Got your back."
      OtherAbbrev(6)="Under attack!"
      OtherAbbrev(8)="Got our flag."
      OtherAbbrev(9)="In position."
      OtherAbbrev(11)="Point is secure."
      OtherAbbrev(12)="Enemy carrier here."
      OtherAbbrev(15)="Got you covered."
}
