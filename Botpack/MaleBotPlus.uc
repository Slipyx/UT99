//=============================================================================
// MaleBotPlus.
//=============================================================================
class MaleBotPlus extends HumanBotPlus
	abstract;

function PlayVictoryDance()
{
	local float decision;

	decision = FRand();

	if ( decision < 0.4 )
		PlayAnim('Victory1',0.7, 0.2);
	else if ( decision < 0.7 )
		PlayAnim('Thrust',0.7, 0.2);
	else
		PlayAnim('Taunt1',0.7, 0.2);
}

function PlayDying(name DamageType, vector HitLoc)
{
	BaseEyeHeight = Default.BaseEyeHeight;
	PlayDyingSound();
			
	if ( DamageType == 'Suicided' )
	{
		PlayAnim('Dead8',, 0.1);
		return;
	}

	// check for head hit
	if ( (DamageType == 'Decapitated') && !Level.Game.bVeryLowGore )
	{
		PlayDecap();
		return;
	}

	if ( FRand() < 0.15 )
	{
		PlayAnim('Dead2',,0.1);
		return;
	}

	// check for big hit
	if ( (Velocity.Z > 250) && (FRand() < 0.75) )
	{
		if ( FRand() < 0.5 )
			PlayAnim('Dead1',,0.1);
		else
			PlayAnim('Dead11',, 0.1);
		return;
	}

	// check for repeater death
	if ( (Health > -10) && ((DamageType == 'shot') || (DamageType == 'zapped')) )
	{
		PlayAnim('Dead9',, 0.1);
		return;
	}
		
	if ( (HitLoc.Z - Location.Z > 0.7 * CollisionHeight) && !Level.Game.bVeryLowGore )
	{
		if ( FRand() < 0.5 )
			PlayDecap();
		else
			PlayAnim('Dead7',, 0.1);
		return;
	}
	
	if ( Region.Zone.bWaterZone || (FRand() < 0.5) ) //then hit in front or back
		PlayAnim('Dead3',, 0.1);
	else
		PlayAnim('Dead8',, 0.1);
}

function PlayDecap()
{
	local carcass carc;

	PlayAnim('Dead4',, 0.1);
	if ( Level.NetMode != NM_Client )
	{
		carc = Spawn(class 'UT_HeadMale',,, Location + CollisionHeight * vect(0,0,0.8), Rotation + rot(3000,0,16384) );
		if (carc != None)
		{
			carc.Initfor(self);
			carc.Velocity = Velocity + VSize(Velocity) * VRand();
			carc.Velocity.Z = FMax(carc.Velocity.Z, Velocity.Z);
		}
	}
}

function PlayGutHit(float tweentime)
{
	if ( (AnimSequence == 'GutHit') || (AnimSequence == 'Dead2') )
	{
		if (FRand() < 0.5)
			TweenAnim('LeftHit', tweentime);
		else
			TweenAnim('RightHit', tweentime);
	}
	else if ( FRand() < 0.6 )
		TweenAnim('GutHit', tweentime);
	else
		TweenAnim('Dead8', tweentime);

}

function PlayHeadHit(float tweentime)
{
	if ( (AnimSequence == 'HeadHit') || (AnimSequence == 'Dead7') )
		TweenAnim('GutHit', tweentime);
	else if ( FRand() < 0.6 )
		TweenAnim('HeadHit', tweentime);
	else
		TweenAnim('Dead7', tweentime);
}

function PlayLeftHit(float tweentime)
{
	if ( (AnimSequence == 'LeftHit') || (AnimSequence == 'Dead9') )
		TweenAnim('GutHit', tweentime);
	else if ( FRand() < 0.6 )
		TweenAnim('LeftHit', tweentime);
	else 
		TweenAnim('Dead9', tweentime);
}

function PlayRightHit(float tweentime)
{
	if ( (AnimSequence == 'RightHit') || (AnimSequence == 'Dead1') )
		TweenAnim('GutHit', tweentime);
	else if ( FRand() < 0.6 )
		TweenAnim('RightHit', tweentime);
	else
		TweenAnim('Dead1', tweentime);
}

defaultproperties
{
      CarcassType=Class'Botpack.TMale1Carcass'
      drown=Sound'Botpack.MaleSounds.(All).drownM02'
      breathagain=Sound'Botpack.MaleSounds.(All).gasp02'
      HitSound3=Sound'Botpack.MaleSounds.(All).injurM04'
      HitSound4=Sound'Botpack.MaleSounds.(All).injurH5'
      Deaths(0)=Sound'Botpack.MaleSounds.(All).deathc1'
      Deaths(1)=Sound'Botpack.MaleSounds.(All).deathc51'
      Deaths(2)=Sound'Botpack.MaleSounds.(All).deathc3'
      Deaths(3)=Sound'Botpack.MaleSounds.(All).deathc4'
      Deaths(4)=Sound'Botpack.MaleSounds.(All).deathc53'
      Deaths(5)=Sound'Botpack.MaleSounds.(All).deathc53'
      GaspSound=Sound'Botpack.MaleSounds.(All).hgasp1'
      UWHit1=Sound'Botpack.MaleSounds.(All).UWinjur41'
      UWHit2=Sound'Botpack.MaleSounds.(All).UWinjur42'
      LandGrunt=Sound'Botpack.MaleSounds.(All).land01'
      JumpSound=Sound'Botpack.MaleSounds.(All).jump1'
      VoicePackMetaClass="BotPack.VoiceMale"
      HitSound1=Sound'Botpack.MaleSounds.(All).injurL2'
      HitSound2=Sound'Botpack.MaleSounds.(All).injurL04'
      Die=Sound'Botpack.MaleSounds.(All).deathc1'
}
