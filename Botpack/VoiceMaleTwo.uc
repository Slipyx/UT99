//=============================================================================
// VoiceMaleTwo.
//=============================================================================
class VoiceMaleTwo extends VoiceMale;

#exec OBJ LOAD FILE=..\Sounds\Male2Voice.uax PACKAGE=Male2Voice

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
	else if ( messageIndex == 5 )
	{
		if ( FRand() < 0.5 )
			messageIndex = 17;
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
      NameSound(0)=Sound'Male2Voice.(All).M2redleader'
      NameSound(1)=Sound'Male2Voice.(All).M2blueleader'
      NameSound(2)=Sound'Male2Voice.(All).M2greenleader'
      NameSound(3)=Sound'Male2Voice.(All).M2goldleader'
      NameTime(0)=0.960000
      NameTime(1)=1.100000
      NameTime(2)=1.020000
      NameTime(3)=0.990000
      AckSound(0)=Sound'Male2Voice.(All).M2gotit'
      AckSound(1)=Sound'Male2Voice.(All).M2roger'
      AckSound(2)=Sound'Male2Voice.(All).M2onmyway'
      AckString(0)="Got it"
      AckString(1)="Roger"
      AckString(2)="On my way"
      AckTime(0)=0.780000
      AckTime(1)=0.810000
      AckTime(2)=0.980000
      numAcks=3
      FFireSound(0)=Sound'Male2Voice.(All).M2sameteam'
      FFireSound(1)=Sound'Male2Voice.(All).M2idiot'
      FFireString(0)="Hey! Same team!"
      FFireString(1)="I'm on your team, you idiot!"
      FFireAbbrev(1)="On your team!"
      numFFires=2
      TauntSound(0)=Sound'Male2Voice.(All).M2eatthat'
      TauntSound(1)=Sound'Male2Voice.(All).M2yalikethat'
      TauntSound(2)=Sound'Male2Voice.(All).M2sucker'
      TauntSound(3)=Sound'Male2Voice.(All).M2boom'
      TauntSound(4)=Sound'Male2Voice.(All).M2burnbaby'
      TauntSound(5)=Sound'Male2Voice.(All).M2yousuck'
      TauntSound(6)=Sound'Male2Voice.(All).M2diebitch'
      TauntSound(7)=Sound'Male2Voice.(All).M2loser'
      TauntSound(8)=Sound'Male2Voice.(All).M2yeehaw'
      TauntSound(9)=Sound'Male2Voice.(All).M2ohyeah'
      TauntSound(10)=Sound'Male2Voice.(All).M2thathadtohurt'
      TauntSound(11)=Sound'Male2Voice.(All).M2dirtbag'
      TauntSound(12)=Sound'Male2Voice.(All).M2myhouse'
      TauntSound(13)=Sound'Male2Voice.(All).M2biteme'
      TauntSound(14)=Sound'Male2Voice.(All).M2OnFire'
      TauntSound(15)=Sound'Male2Voice.(All).M2Useless'
      TauntSound(16)=Sound'Male2Voice.(All).M2laugh'
      TauntSound(17)=Sound'Male2Voice.(All).M2Yoube'
      TauntSound(18)=Sound'Male2Voice.(All).M2next'
      TauntSound(19)=Sound'Male2Voice.(All).M2Medic'
      TauntSound(20)=Sound'Male2Voice.(All).M2seeya'
      TauntSound(21)=Sound'Male2Voice.(All).M2Target'
      TauntSound(22)=Sound'Male2Voice.(All).M2wantsome'
      TauntSound(23)=Sound'Male2Voice.(All).M2gotim'
      TauntSound(24)=Sound'Male2Voice.(All).M2staydown'
      TauntString(0)="Eat that!"
      TauntString(1)="You like that?"
      TauntString(2)="Sucker!"
      TauntString(3)="Boom!"
      TauntString(4)="Burn, baby"
      TauntString(5)="You suck!"
      TauntString(6)="Die, bitch."
      TauntString(7)="Loser."
      TauntString(8)="Yeehaw!"
      TauntString(9)="Oh, yeah!"
      TauntString(10)="That had to hurt."
      TauntString(11)="Dirt bag!"
      TauntString(12)="My house!"
      TauntString(13)="Bite me!"
      TauntString(14)="I'm on fire!"
      TauntString(15)="Useless."
      TauntString(16)="Ha ha ha!"
      TauntString(17)="You be dead!"
      TauntString(18)="Next!"
      TauntString(19)="Medic!"
      TauntString(20)="See ya!"
      TauntString(21)="Target eliminated."
      TauntString(22)="Anyone else want some?"
      TauntString(23)="Got 'im!"
      TauntString(24)="And stay down!"
      TauntAbbrev(22)="Anyone else?"
      numTaunts=25
      MatureTaunt(6)=1
      MatureTaunt(13)=1
      OrderSound(0)=Sound'Male2Voice.(All).M2defend'
      OrderSound(1)=Sound'Male2Voice.(All).M2hold'
      OrderSound(2)=Sound'Male2Voice.(All).M2assault'
      OrderSound(3)=Sound'Male2Voice.(All).M2coverme'
      OrderSound(4)=Sound'Male2Voice.(All).M2engage'
      OrderSound(10)=Sound'Male2Voice.(All).M2takeflag'
      OrderSound(11)=Sound'Male2Voice.(All).M2searchdestroy'
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
      OtherSound(0)=Sound'Male2Voice.(All).M2uncovered'
      OtherSound(1)=Sound'Male2Voice.(All).M2getflagback'
      OtherSound(2)=Sound'Male2Voice.(All).M2igotflag'
      OtherSound(3)=Sound'Male2Voice.(All).M2gotyourback'
      OtherSound(4)=Sound'Male2Voice.(All).M2imhit'
      OtherSound(5)=Sound'Male2Voice.(All).M2mandown'
      OtherSound(6)=Sound'Male2Voice.(All).M2underattack'
      OtherSound(7)=Sound'Male2Voice.(All).M2gotpoint'
      OtherSound(8)=Sound'Male2Voice.(All).M2ourflag'
      OtherSound(9)=Sound'Male2Voice.(All).M2inposition'
      OtherSound(10)=Sound'Male2Voice.(All).M2hangin'
      OtherSound(11)=Sound'Male2Voice.(All).M2pointsecure'
      OtherSound(12)=Sound'Male2Voice.(All).M2enemycarrier'
      OtherSound(13)=Sound'Male2Voice.(All).M2backup'
      OtherSound(14)=Sound'Male2Voice.(All).M2incoming'
      OtherSound(15)=Sound'Male2Voice.(All).M2gotyourback'
      OtherSound(16)=Sound'Male2Voice.(All).M2objectdestroy'
      OtherSound(17)=Sound'Male2Voice.(All).M2Medic'
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
      otherstring(10)="Hang in there."
      otherstring(11)="Control point is secure."
      otherstring(12)="Enemy flag carrier is here."
      otherstring(13)="I need some backup."
      otherstring(14)="Incoming!"
      otherstring(15)="I've got your back."
      otherstring(16)="Objective destroyed."
      otherstring(17)="Medic!"
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
