//=============================================================================
// VoiceFemaleOne.
//=============================================================================
class VoiceFemaleOne extends VoiceFemale;

#exec OBJ LOAD FILE=..\Sounds\Female1Voice.uax PACKAGE=Female1Voice

function SetOtherMessage(int messageIndex, PlayerReplicationInfo Recipient, out Sound MessageSound, out Float MessageTime)
{
	if ( messageIndex == 3 )
	{
		if ( FRand() < 0.4 )
			messageIndex = 7;
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
      NameSound(0)=Sound'Female1Voice.(All).F1redleader'
      NameSound(1)=Sound'Female1Voice.(All).F1blueleader'
      NameSound(2)=Sound'Female1Voice.(All).F1greenleader'
      NameSound(3)=Sound'Female1Voice.(All).F1goldleader'
      NameTime(0)=0.890000
      NameTime(1)=0.940000
      NameTime(2)=0.810000
      NameTime(3)=0.930000
      AckSound(0)=Sound'Female1Voice.(All).F1gotit'
      AckSound(1)=Sound'Female1Voice.(All).F1roger'
      AckSound(2)=Sound'Female1Voice.(All).F1onmyway'
      AckString(0)="Got it"
      AckString(1)="Roger that"
      AckString(2)="On my way"
      AckTime(0)=0.520000
      AckTime(1)=0.750000
      AckTime(2)=0.930000
      numAcks=3
      FFireSound(0)=Sound'Female1Voice.(All).F1sameteam'
      FFireSound(1)=Sound'Female1Voice.(All).F1idiot'
      FFireString(0)="Same team!"
      FFireString(1)="I'm on your team, idiot!"
      FFireAbbrev(1)="On your team!"
      numFFires=2
      TauntSound(0)=Sound'Female1Voice.(All).F1eatthat'
      TauntSound(1)=Sound'Female1Voice.(All).F1sucker'
      TauntSound(2)=Sound'Female1Voice.(All).F1gotim'
      TauntSound(3)=Sound'Female1Voice.(All).F1hadtohurt'
      TauntSound(4)=Sound'Female1Voice.(All).F1wantsome'
      TauntSound(5)=Sound'Female1Voice.(All).F1boom'
      TauntSound(6)=Sound'Female1Voice.(All).F1burnbaby'
      TauntSound(7)=Sound'Female1Voice.(All).F1diebitch'
      TauntSound(8)=Sound'Female1Voice.(All).F1yousuck'
      TauntSound(9)=Sound'Female1Voice.(All).F1likethat'
      TauntSound(10)=Sound'Female1Voice.(All).F1yeehaw'
      TauntSound(11)=Sound'Female1Voice.(All).F1loser'
      TauntSound(12)=Sound'Female1Voice.(All).F1ohyeah'
      TauntSound(13)=Sound'Female1Voice.(All).F1tag'
      TauntSound(14)=Sound'Female1Voice.(All).F1sitdown'
      TauntSound(15)=Sound'Female1Voice.(All).F1slaughter'
      TauntSound(16)=Sound'Female1Voice.(All).F1sorry'
      TauntSound(17)=Sound'Female1Voice.(All).F1squeel'
      TauntSound(18)=Sound'Female1Voice.(All).F1staydown'
      TauntSound(19)=Sound'Female1Voice.(All).F1sucker'
      TauntSound(20)=Sound'Female1Voice.(All).F1toasted'
      TauntSound(21)=Sound'Female1Voice.(All).F1letsrock'
      TauntString(0)="Eat that!"
      TauntString(1)="Sucker!"
      TauntString(2)="Got him!"
      TauntString(3)="That had to hurt!"
      TauntString(4)="Anyone else want some?"
      TauntString(5)="Boom!"
      TauntString(6)="Burn, baby!"
      TauntString(7)="Die, bitch."
      TauntString(8)="You suck!"
      TauntString(9)="You like that?"
      TauntString(10)="Yeehaw!"
      TauntString(11)="Loser!"
      TauntString(12)="Oh yeah!"
      TauntString(13)="Tag, you're it!"
      TauntString(14)="Sit down!"
      TauntString(15)="I just slaughtered that guy!"
      TauntString(16)="I'm sorry, did I blow your head apart?"
      TauntString(17)="Squeal boy, squeal!"
      TauntString(18)="And stay down."
      TauntString(19)="Sucker!"
      TauntString(20)="Toasted!"
      TauntString(21)="Lets rock!"
      TauntAbbrev(3)="Had to hurt!"
      TauntAbbrev(4)="Anyone else?"
      TauntAbbrev(15)="Slaughtered him."
      TauntAbbrev(16)="I'm sorry."
      numTaunts=22
      MatureTaunt(7)=1
      OrderSound(0)=Sound'Female1Voice.(All).F1defend'
      OrderSound(1)=Sound'Female1Voice.(All).F1hold'
      OrderSound(2)=Sound'Female1Voice.(All).F1assault'
      OrderSound(3)=Sound'Female1Voice.(All).F1cover'
      OrderSound(4)=Sound'Female1Voice.(All).F1engage'
      OrderSound(10)=Sound'Female1Voice.(All).F1takeflag'
      OrderSound(11)=Sound'Female1Voice.(All).F1destroy'
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
      OtherSound(0)=Sound'Female1Voice.(All).F1baseunc'
      OtherSound(1)=Sound'Female1Voice.(All).F1getflag'
      OtherSound(2)=Sound'Female1Voice.(All).F1gotflag'
      OtherSound(3)=Sound'Female1Voice.(All).F1gotyourb'
      OtherSound(4)=Sound'Female1Voice.(All).F1imhit'
      OtherSound(5)=Sound'Female1Voice.(All).F1mandown'
      OtherSound(6)=Sound'Female1Voice.(All).F1underatt'
      OtherSound(7)=Sound'Female1Voice.(All).F1yougotpoint'
      OtherSound(8)=Sound'Female1Voice.(All).F1gotourflag'
      OtherSound(9)=Sound'Female1Voice.(All).F1inposition'
      OtherSound(10)=Sound'Female1Voice.(All).F1hanginthere'
      OtherSound(11)=Sound'Female1Voice.(All).F1pointsecure'
      OtherSound(12)=Sound'Female1Voice.(All).F1enemyhere'
      OtherSound(13)=Sound'Female1Voice.(All).F1backup'
      OtherSound(14)=Sound'Female1Voice.(All).F1incoming'
      OtherSound(15)=Sound'Female1Voice.(All).F1gotyourb'
      OtherSound(16)=Sound'Female1Voice.(All).F1objectivedest'
      otherstring(0)="Base is uncovered!"
      otherstring(1)="Somebody get our flag back!"
      otherstring(2)="I've got the flag."
      otherstring(3)="I've got your back."
      otherstring(4)="I'm hit! I'm hit!"
      otherstring(5)="Man down!"
      otherstring(6)="I'm under heavy attack!"
      otherstring(7)="You got point."
      otherstring(8)="I've got our flag."
      otherstring(9)="I'm in position."
      otherstring(10)="Hang in there."
      otherstring(11)="Control point is secure."
      otherstring(12)="Enemy flag carrier is here."
      otherstring(13)="I need some backup."
      otherstring(14)="Incoming!"
      otherstring(15)="I've got your back."
      otherstring(16)="Objective destroyed."
      OtherAbbrev(1)="Get our flag!"
      OtherAbbrev(2)="Got the flag."
      OtherAbbrev(3)="Got your back."
      OtherAbbrev(6)="Under attack!"
      OtherAbbrev(8)="Got our flag."
      OtherAbbrev(9)="In position."
      OtherAbbrev(11)="Point is secure."
      OtherAbbrev(12)="Enemy carrier here."
      OtherAbbrev(15)="Got your back."
}
