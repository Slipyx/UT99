//=============================================================================
// VoiceBoss.
//=============================================================================
class VoiceBoss extends ChallengeVoicePack;

#exec OBJ LOAD FILE=..\Sounds\BossVoice.uax PACKAGE=BossVoice

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
      NameSound(0)=Sound'BossVoice.(All).Bredleader'
      NameSound(1)=Sound'BossVoice.(All).Bblueleader'
      NameSound(2)=Sound'BossVoice.(All).Bgreenleader'
      NameSound(3)=Sound'BossVoice.(All).Bgoldleader'
      NameTime(0)=0.960000
      NameTime(1)=1.100000
      NameTime(2)=1.020000
      NameTime(3)=0.990000
      AckSound(0)=Sound'BossVoice.(All).Bgotit'
      AckSound(1)=Sound'BossVoice.(All).Broger'
      AckSound(2)=Sound'BossVoice.(All).Bonmyway'
      AckString(0)="Got it"
      AckString(1)="Roger"
      AckString(2)="On my way"
      AckTime(0)=0.780000
      AckTime(1)=0.810000
      AckTime(2)=0.980000
      numAcks=3
      FFireSound(0)=Sound'BossVoice.(All).Bonyourteam'
      FFireSound(1)=Sound'BossVoice.(All).Bsameteam'
      FFireString(0)="I'm on your team!"
      FFireString(1)="Same team!"
      FFireAbbrev(0)="On your team!"
      numFFires=2
      TauntSound(0)=Sound'BossVoice.(All).Bbowdown'
      TauntSound(1)=Sound'BossVoice.(All).Bdiehuman'
      TauntSound(2)=Sound'BossVoice.(All).Beliminated'
      TauntSound(3)=Sound'BossVoice.(All).Byoudie'
      TauntSound(4)=Sound'BossVoice.(All).Buseless'
      TauntSound(5)=Sound'BossVoice.(All).Bfearme'
      TauntSound(6)=Sound'BossVoice.(All).Binferior'
      TauntSound(7)=Sound'BossVoice.(All).Bobsolete'
      TauntSound(8)=Sound'BossVoice.(All).Bomega'
      TauntSound(9)=Sound'BossVoice.(All).Brunhuman'
      TauntSound(10)=Sound'BossVoice.(All).Bstepaside'
      TauntSound(11)=Sound'BossVoice.(All).Bsuperior'
      TauntSound(12)=Sound'BossVoice.(All).Bperfection'
      TauntSound(13)=Sound'BossVoice.(All).Bboom'
      TauntSound(14)=Sound'BossVoice.(All).Bmyhouse'
      TauntSound(15)=Sound'BossVoice.(All).Bnext'
      TauntSound(16)=Sound'BossVoice.(All).Bburnbaby'
      TauntSound(17)=Sound'BossVoice.(All).Bwantsome'
      TauntSound(18)=Sound'BossVoice.(All).Bhadtohurt'
      TauntSound(19)=Sound'BossVoice.(All).Bimonfire'
      TauntString(0)="Bow down!"
      TauntString(1)="Die, human."
      TauntString(2)="Target lifeform eliminated."
      TauntString(3)="You die too easily."
      TauntString(4)="Useless."
      TauntString(5)="Fear me."
      TauntString(6)="You are inferior."
      TauntString(7)="You are obsolete."
      TauntString(8)="I am the alpha and the omega."
      TauntString(9)="Run, human."
      TauntString(10)="Step aside."
      TauntString(11)="I am superior."
      TauntString(12)="Witness my perfection."
      TauntString(13)="Boom!"
      TauntString(14)="My house."
      TauntString(15)="Next."
      TauntString(16)="Burn, baby"
      TauntString(17)="Anyone else want some?"
      TauntString(18)="That had to hurt."
      TauntString(19)="I'm on fire"
      TauntAbbrev(2)="Target lifeform."
      TauntAbbrev(8)="Alpha/Omega"
      numTaunts=20
      OrderSound(0)=Sound'BossVoice.(All).Bdefendthebase'
      OrderSound(1)=Sound'BossVoice.(All).Bholdposit'
      OrderSound(2)=Sound'BossVoice.(All).Bassaultbase'
      OrderSound(3)=Sound'BossVoice.(All).Bcoverme'
      OrderSound(4)=Sound'BossVoice.(All).Bengage'
      OrderSound(10)=Sound'BossVoice.(All).Btaketheirflag'
      OrderSound(11)=Sound'BossVoice.(All).Bsandd'
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
      OtherSound(0)=Sound'BossVoice.(All).Bbaseunc'
      OtherSound(1)=Sound'BossVoice.(All).Bgetourflag'
      OtherSound(2)=Sound'BossVoice.(All).Bgottheflag'
      OtherSound(3)=Sound'BossVoice.(All).Bgotyourback'
      OtherSound(4)=Sound'BossVoice.(All).BImhit'
      OtherSound(5)=Sound'BossVoice.(All).Bmandown'
      OtherSound(6)=Sound'BossVoice.(All).Bunderattack'
      OtherSound(7)=Sound'BossVoice.(All).Byougotpoint'
      OtherSound(8)=Sound'BossVoice.(All).Bgotourflag'
      OtherSound(9)=Sound'BossVoice.(All).Binposition'
      OtherSound(10)=Sound'BossVoice.(All).Bhanginthere'
      OtherSound(11)=Sound'BossVoice.(All).Bconpointsecure'
      OtherSound(12)=Sound'BossVoice.(All).Bflagcarrierher'
      OtherSound(13)=Sound'BossVoice.(All).Bbackup'
      OtherSound(14)=Sound'BossVoice.(All).Bincoming'
      OtherSound(15)=Sound'BossVoice.(All).Bgotyourback'
      OtherSound(16)=Sound'BossVoice.(All).Bobjectivedest'
      otherstring(0)="Base is uncovered!"
      otherstring(1)="Get our flag back!"
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
