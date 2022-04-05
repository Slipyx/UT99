class TrainingDM extends DeathMatchPlus;

#exec OBJ LOAD FILE=..\Sounds\TutVoiceDM.uax PACKAGE=TutVoiceDM

var string DM[24];

var bool bReadyToSpawn;

var localized string TutMessage[24];
var localized string TutMessage4Parts[5];
var localized string TutMessage6Parts[2];
var localized string TutMessage14Parts[2];
var localized string TutMessage15Parts[2];

var string KeyAlias[255];

var PlayerPawn Trainee;
var rotator LastRotation;
var vector LastLocation;

var int EventTimer, LastEvent, EventIndex, SoundIndex;
var bool bPause;

// Parse options for this game...
event InitGame( string Options, out string Error )
{
	Super.InitGame(Options, Error);

	bRatedGame = True;
	TimeLimit = 0;
	RemainingTime = 0;
	FragLimit = 3;
	bRequireReady = False;
	EventTimer = 3;
}

function InitRatedGame(LadderInventory LadderObj, PlayerPawn LadderPlayer)
{
	Super.InitRatedGame(LadderObj, LadderPlayer);
	
	RemainingBots = 0;
	bRequireReady = False;
}

function PostBeginPlay()
{
	local Barrel B;

	Super.PostBeginPlay();

	foreach AllActors(class'Barrel', B)
	{
		B.bHidden = True;
		B.SetCollision(False, False, False);
	}
}

event playerpawn Login
(
	string Portal,
	string Options,
	out string Error,
	class<playerpawn> SpawnClass
)
{
	local PlayerPawn NewPlayer;
	
	NewPlayer = Super.Login(Portal, Options, Error, SpawnClass);
	NewPlayer.PlayerReplicationInfo.TeamName = "Red";
	NewPlayer.PlayerReplicationInfo.Team = 0;
	NewPlayer.ReducedDamageType = 'All';

	if ( RatedPlayer == None ) RatedPlayer = NewPlayer;
	if ( Trainee == None )     Trainee = NewPlayer;

	return NewPlayer;
}

function TutorialSound( string NewSound )
{
	local sound MySound;

	MySound = sound( DynamicLoadObject(NewSound, class'Sound') );
	EventTimer = GetSoundDuration( MySound ) + 2;
	Trainee.PlaySound( MySound, SLOT_Interface, 2.0, false, 99999);
}

function AddDefaultInventory( pawn PlayerPawn )
{
	local Weapon NewWeapon;

	if (bReadyToSpawn)
	{
		if (!PlayerPawn.PlayerReplicationInfo.bIsABot)
			newWeapon = Spawn(class'ShockRifle');
		else
			newWeapon = Spawn(class'Enforcer');

		if( newWeapon != None )
		{
			newWeapon.BecomeItem();
			newWeapon.bHeldItem = true;
			PlayerPawn.AddInventory(newWeapon);
			newWeapon.Instigator = PlayerPawn;
			newWeapon.GiveAmmo(PlayerPawn);
			newWeapon.SetSwitchPriority(PlayerPawn);
			newWeapon.WeaponSet(PlayerPawn);
			if ( !PlayerPawn.IsA('PlayerPawn') )
				newWeapon.GotoState('Idle');
			PlayerPawn.Weapon.GotoState('DownWeapon');
			PlayerPawn.PendingWeapon = None;
			PlayerPawn.Weapon = newWeapon;
			newWeapon.AmmoType.AmmoAmount = 199;
			newWeapon.AmmoType.MaxAmmo = 199;
		}
	}
}

function LoadKeyBindings(PlayerPawn P)
{
	local int i;
	local string k;

	for (i=0; i<255; i++)
	{
		k = P.ConsoleCommand( "KEYNAME "$i );
		KeyAlias[i] = P.ConsoleCommand( "KEYBINDING "$k );
	}
}

function Timer()
{
	Super.Timer();

	if ((EventTimer == 0) || bPause)
		return;

	EventTimer--;
	if (EventTimer == 0)		// Event time is up, perform an event
	{
		if (EventIndex == LastEvent)	// No more events queued.
			return;

		// Call an event function appropriate for this event.
		switch (EventIndex)
		{
			case 0:
				DMTutEvent0();
				break;
			case 1:
				DMTutEvent1();
				break;
			case 2:
				DMTutEvent2();
				break;
			case 3:
				DMTutEvent3();
				break;
			case 4:
				DMTutEvent4();
				break;
			case 5:
				DMTutEvent5();
				break;
			case 6:
				DMTutEvent6();
				break;
			case 7:
				DMTutEvent7();
				break;
			case 8:
				DMTutEvent8();
				break;
			case 9:
				DMTutEvent9();
				break;
			case 10:
				DMTutEvent10();
				break;
			case 11:
				DMTutEvent11();
				break;
			case 12:
				DMTutEvent12();
				break;
			case 13:
				DMTutEvent13();
				break;
			case 14:
				DMTutEvent14();
				break;
			case 15:
				DMTutEvent15();
				break;
			case 16:
				DMTutEvent16();
				break;
			case 17:
				DMTutEvent17();
				break;
			case 18:
				DMTutEvent18();
				break;
			case 19:
				DMTutEvent19();
				break;
			case 20:
				DMTutEvent20();
				break;
			case 21:
				DMTutEvent21();
				break;
			case 22:
				DMTutEvent22();
				break;
			case 23:
				DMTutEvent23();
				break;
		}
		EventIndex++;
	}
}

function DMTutEvent0()
{
	Trainee.ProgressTimeOut = Level.TimeSeconds;
	LoadKeyBindings(Trainee);
	TournamentConsole(Trainee.Player.Console).ShowMessage();
	TutorialSound(DM[0]);
	TournamentConsole(Trainee.Player.Console).AddMessage(TutMessage[0]);
	SoundIndex++;

	Trainee.Health = 100;
}

function DMTutEvent1()
{
	TutorialSound(DM[1]);
	TournamentConsole(Trainee.Player.Console).AddMessage(TutMessage[1]);
	SoundIndex++;
}

function DMTutEvent2()
{
	TutorialSound(DM[2]);
	TournamentConsole(Trainee.Player.Console).AddMessage(TutMessage[2]);
	SoundIndex++;
}

function DMTutEvent3()
{
	TutorialSound(DM[3]);
	TournamentConsole(Trainee.Player.Console).AddMessage(TutMessage[3]);
	SoundIndex++;
}

function DMTutEvent4()
{
	local int i;
	local string Message;
	local string ForwardKey, BackKey, LeftStrafeKey, RightStrafeKey;

	for (i=0; i<255; i++)
	{
		if (KeyAlias[i] ~= "MoveForward")
		{
			if (ForwardKey != "")
				ForwardKey = ForwardKey$","@class'UMenuCustomizeClientWindow'.default.LocalizedKeyName[i];
			else
				ForwardKey = class'UMenuCustomizeClientWindow'.default.LocalizedKeyName[i];
		}
		if (KeyAlias[i] ~= "MoveBackward")
		{
			if (BackKey != "")
				BackKey = BackKey$","@class'UMenuCustomizeClientWindow'.default.LocalizedKeyName[i];
			else
				BackKey = class'UMenuCustomizeClientWindow'.default.LocalizedKeyName[i];
		}
		if (KeyAlias[i] ~= "StrafeLeft")
		{
			if (LeftStrafeKey != "")
				LeftStrafeKey = LeftStrafeKey$","@class'UMenuCustomizeClientWindow'.default.LocalizedKeyName[i];
			else
				LeftStrafeKey = class'UMenuCustomizeClientWindow'.default.LocalizedKeyName[i];
		}
		if (KeyAlias[i] ~= "StrafeRight")
		{
			if (RightStrafeKey != "")
				RightStrafeKey = RightStrafeKey$","@class'UMenuCustomizeClientWindow'.default.LocalizedKeyName[i];
			else
				RightStrafeKey = class'UMenuCustomizeClientWindow'.default.LocalizedKeyName[i];
		}
	}

	TutorialSound(DM[4]);
	Message = TutMessage4Parts[0]@"["$ForwardKey$"]"@TutMessage4Parts[1]@"["$BackKey$"]"@TutMessage4Parts[2]@"["$LeftStrafeKey$"]"@TutMessage4Parts[3]@"["$RightStrafeKey$"]"$TutMessage4Parts[4];
	TournamentConsole(Trainee.Player.Console).AddMessage(Message);
	SoundIndex++;
}

function DMTutEvent5()
{
	TutorialSound(DM[5]);
	TournamentConsole(Trainee.Player.Console).AddMessage(TutMessage[5]);
	SoundIndex++;
}

function DMTutEvent6()
{
	bPause = True;
	GoToState('FreeRunning1');
}

state FreeRunning1
{
	function Tick(float DeltaTime)
	{
		local int i;
		local string Message;
		local string JumpKey;

		Super.Tick(DeltaTime);

		// Test for strafing and goto next state if true.
		if (Trainee.bWasLeft || Trainee.bWasRight)
		{
			for (i=0; i<255; i++)
			{
				if (KeyAlias[i] ~= "Jump")
				{
					if (JumpKey != "")
						JumpKey = JumpKey$","@class'UMenuCustomizeClientWindow'.default.LocalizedKeyName[i];
					else
						JumpKey = class'UMenuCustomizeClientWindow'.default.LocalizedKeyName[i];
				}
			}

			bPause = False;

			TutorialSound(DM[6]);
			Message = TutMessage6Parts[0]@"["$JumpKey$"]"@TutMessage6Parts[1];
			TournamentConsole(Trainee.Player.Console).AddMessage(Message);
			SoundIndex++;

			GotoState('');
		}
	}
}

function DMTutEvent7()
{
	bPause = True;
	GoToState('FreeRunning2');
}

state FreeRunning2
{
	function Tick(float DeltaTime)
	{
		Super.Tick(DeltaTime);

		// Test for jumping.
		if (Trainee.Location.Z != LastLocation.Z)
		{
			bPause = False;

			TutorialSound(DM[7]);
			TournamentConsole(Trainee.Player.Console).AddMessage(TutMessage[7]);
			SoundIndex++;

			GotoState('');
		}
	}

	function BeginState()
	{
		LastLocation = Trainee.Location;
	}
}

function DMTutEvent8()
{
	TutorialSound(DM[8]);
	TournamentConsole(Trainee.Player.Console).AddMessage(TutMessage[8]);
	SoundIndex++;
}

function DMTutEvent9()
{
	TutorialSound(DM[9]);
	TournamentConsole(Trainee.Player.Console).AddMessage(TutMessage[9]);
	SoundIndex++;
}

function DMTutEvent10()
{
	bPause = True;
	GoToState('FreeRunning3');
}

state FreeRunning3
{
	function Tick(float DeltaTime)
	{
		Super.Tick(DeltaTime);

		// Test for mouselook and goto next state if true.
		if (Trainee.Rotation != LastRotation)
		{
			bPause = False;

			TutorialSound(DM[10]);
			TournamentConsole(Trainee.Player.Console).AddMessage(TutMessage[10]);
			SoundIndex++;

			GotoState('');
		}
	}

	function BeginState()
	{
		LastRotation = Trainee.Rotation;
	}
}

function DMTutEvent11()
{
	TutorialSound(DM[11]);
	TournamentConsole(Trainee.Player.Console).AddMessage(TutMessage[11]);
	SoundIndex++;
}

function DMTutEvent12()
{
	TutorialSound(DM[12]);
	TournamentConsole(Trainee.Player.Console).AddMessage(TutMessage[12]);
	SoundIndex++;
}

function DMTutEvent13()
{
	local Mover m;
	foreach AllActors(class'Mover', m)
		m.Trigger(Trainee, Trainee);

	TutorialSound(DM[13]);
	TournamentConsole(Trainee.Player.Console).AddMessage(TutMessage[13]);
	SoundIndex++;
}

function DMTutEvent14()
{
	bPause = True;
	GoToState('FreeRunning4');
}

state FreeRunning4
{
	function Tick(float DeltaTime)
	{
		local int i;
		local string Message;
		local string FireKey;

		Super.Tick(DeltaTime);

		// Test for weapon pickup and move on.
		if (Trainee.Weapon != None)
		{
			for (i=0; i<255; i++)
			{
				if (KeyAlias[i] ~= "Fire")
				{
					if (FireKey != "")
						FireKey = FireKey$","@class'UMenuCustomizeClientWindow'.default.LocalizedKeyName[i];
					else
						FireKey = class'UMenuCustomizeClientWindow'.default.LocalizedKeyName[i];
				}
			}

			bPause = False;

			TutorialSound(DM[14]);
			Message = TutMessage14Parts[0]@"["$FireKey$"]"@TutMessage14Parts[1];
			TournamentConsole(Trainee.Player.Console).AddMessage(Message);
			SoundIndex++;

			GotoState('');
		}
	}
}

function DMTutEvent15()
{
	bPause = True;
	GoToState('FreeRunning5');
}

state FreeRunning5
{
	function Tick(float DeltaTime)
	{
		local int i;
		local string Message;
		local string FireKey;

		Super.Tick(DeltaTime);

		// Test for weapon fire and move on.
		if (Trainee.bFire != 0)
		{
			for (i=0; i<255; i++)
			{
				if (KeyAlias[i] ~= "AltFire")
				{
					if (FireKey != "")
						FireKey = FireKey$","@class'UMenuCustomizeClientWindow'.default.LocalizedKeyName[i];
					else
						FireKey = class'UMenuCustomizeClientWindow'.default.LocalizedKeyName[i];
				}
			}

			bPause = False;

			TutorialSound(DM[15]);
			Message = TutMessage15Parts[0]@"["$FireKey$"]"@TutMessage15Parts[1];
			TournamentConsole(Trainee.Player.Console).AddMessage(Message);
			SoundIndex++;

			GotoState('');
		}
	}
}

function DMTutEvent16()
{
	bPause = True;
	GoToState('FreeRunning6');
}

state FreeRunning6
{
	function Tick(float DeltaTime)
	{
		local Weapon newWeapon;

		Super.Tick(DeltaTime);

		// Test for weapon altfire and move on.
		if (Trainee.bAltFire != 0)
		{
			bPause = False;

			TutorialSound(DM[16]);
			TournamentConsole(Trainee.Player.Console).AddMessage(TutMessage[16]);
			SoundIndex++;

			// Give player an enforcer.
			newWeapon = Spawn(class'Enforcer');
			if( newWeapon != None )
			{
				newWeapon.BecomeItem();
				newWeapon.bHeldItem = true;
				Trainee.AddInventory(newWeapon);
				newWeapon.Instigator = Trainee;
				newWeapon.GiveAmmo(Trainee);
				newWeapon.GoToState('DownWeapon');
				newWeapon.AmmoType.AmmoAmount = 199;
				newWeapon.AmmoType.MaxAmmo = 199;
			}

			GotoState('');
		}
	}
}

function DMTutEvent17()
{
	bPause = True;
	GoToState('FreeRunning7');
}

state FreeRunning7
{
	function Tick(float DeltaTime)
	{
		local Weapon newWeapon;

		Super.Tick(DeltaTime);

		// Test for switch to enforcer.
		if ((Trainee.Weapon != None) && (Trainee.Weapon.IsA('Enforcer')))
		{
			bPause = False;

			TutorialSound(DM[17]);
			TournamentConsole(Trainee.Player.Console).AddMessage(TutMessage[17]);
			SoundIndex++;

			// Give player an impact hammer.
			newWeapon = Spawn(class'ImpactHammer');
			if( newWeapon != None )
			{
				newWeapon.BecomeItem();
				newWeapon.bHeldItem = true;
				Trainee.AddInventory(newWeapon);
				newWeapon.Instigator = Trainee;
				newWeapon.GiveAmmo(Trainee);
				newWeapon.GoToState('DownWeapon');
			}

			GotoState('');
		}
	}
}

function DMTutEvent18()
{
	bPause = True;
	GoToState('FreeRunning8');
}

state FreeRunning8
{
	function Tick(float DeltaTime)
	{
		Super.Tick(DeltaTime);

		// Test for switch to impact hammer.
		if ((Trainee.Weapon != None) && (Trainee.Weapon.IsA('ImpactHammer')))
		{
			bPause = False;

			TutorialSound(DM[18]);
			TournamentConsole(Trainee.Player.Console).AddMessage(TutMessage[18]);
			SoundIndex++;

			GotoState('');
		}
	}
}

function DMTutEvent19()
{
	bPause = True;
	GoToState('FreeRunning9');
}

state FreeRunning9
{
	function Tick(float DeltaTime)
	{
		Super.Tick(DeltaTime);

		// Test for weapon fire and move on.
		if (Trainee.bFire != 0)
		{
			bPause = False;

			TutorialSound(DM[19]);
			TournamentConsole(Trainee.Player.Console).AddMessage(TutMessage[19]);
			SoundIndex++;

			GotoState('');
		}
	}
}

function DMTutEvent20()
{
	local Barrel B;
	local string NaliClassString;
	local Nali MyNali;

	bNoMonsters = False;
	// Spawn a Nali
	foreach AllActors(class'Barrel', B)
	{
		MyNali = Spawn(class'Nali',,,B.Location + vect(0,0,100));
		MyNali.Health = 1;
		break;
	}
	bPause = True;
	GoToState('ChunkTheNali');
}

state ChunkTheNali
{
	function Tick(float DeltaTime)
	{
		local Nali N;
		local int NaliCount;

		Super.Tick(DeltaTime);

		// Test for chunked Nali and move on.
		foreach AllActors(class'Nali', N)
		{
			NaliCount++;
		}
		if (NaliCount == 0)
		{
			Trainee.PlayerReplicationInfo.Score = 0;
			bPause = False;

			TutorialSound(DM[20]);
			TournamentConsole(Trainee.Player.Console).AddMessage(TutMessage[20]);
			SoundIndex++;

			GotoState('');
		}
	}
}

function DMTutEvent21()
{
	local Barrel B;

	foreach AllActors(class'Barrel', B)
	{
		Spawn(class'EnhancedRespawn', B, , B.Location, B.Rotation);
		B.bHidden = False;
		B.SetCollision(True, True, True);
	}

	TutorialSound(DM[21]);
	TournamentConsole(Trainee.Player.Console).AddMessage(TutMessage[21]);
	SoundIndex++;
}

function DMTutEvent22()
{

	bPause = True;
	GoToState('FreeRunning10');
}

state FreeRunning10
{
	function Tick(float DeltaTime)
	{
		local int i;
		local Barrel B;

		Super.Tick(DeltaTime);

		// Test for barrel destroy and move on.
		foreach AllActors(class'Barrel', B)
			i++;
		if (i==0)
		{
			bPause = False;

			TutorialSound(DM[22]);
			TournamentConsole(Trainee.Player.Console).AddMessage(TutMessage[22]);
			SoundIndex++;

			GotoState('');
		}
	}
}

function DMTutEvent23()
{
	TournamentConsole(Trainee.Player.Console).HideMessage();

	FragLimit = 3;

	bReadyToSpawn = True;
	bRatedGame = True;

	RemainingBots = 1;
}

function bool SuccessfulGame()
{
	local Pawn P;

	for ( P=Level.PawnList; P!=None; P=P.NextPawn )
		if ( P.bIsPlayer && (P != RatedPlayer) )
			if ( P.PlayerReplicationInfo.Score >= RatedPlayer.PlayerReplicationInfo.Score )
				return false;

	return true;
}

function EndGame( string Reason )
{
	Super.EndGame(Reason);

	if (SuccessfulGame())
		TutorialSound(DM[23]);
	else
		Trainee.ClientPlaySound(sound'Announcer.LostMatch', True);

	if (RatedGameLadderObj != None)
	{
		RatedGameLadderObj.PendingChange = 0;
		RatedGameLadderObj.LastMatchType = LadderTypeIndex;
		if (RatedGameLadderObj.DMPosition < 1)
		{
			RatedGameLadderObj.PendingChange = LadderTypeIndex;
			RatedGameLadderObj.PendingRank = 1;
			RatedGameLadderObj.PendingPosition = 1;
		}
	}
	GoToState('ServerTravel');
}

state ServerTravel
{
	function Timer()
	{
		LadderTransition();
	}

	function BeginState()
	{
		SetTimer(9.0, true);
	}
}

defaultproperties
{
      DM(0)="TutVoicedm.dm00"
      DM(1)="TutVoicedm.dm01"
      DM(2)="TutVoicedm.dm02"
      DM(3)="TutVoicedm.dm03"
      DM(4)="TutVoicedm.dm04"
      DM(5)="TutVoicedm.dm05"
      DM(6)="TutVoicedm.dm06"
      DM(7)="TutVoicedm.dm07"
      DM(8)="TutVoicedm.dm08"
      DM(9)="TutVoicedm.dm09"
      DM(10)="TutVoicedm.dm10"
      DM(11)="TutVoicedm.dm11"
      DM(12)="TutVoicedm.dm12"
      DM(13)="TutVoicedm.dm13"
      DM(14)="TutVoicedm.dm14"
      DM(15)="TutVoicedm.dm15"
      DM(16)="TutVoicedm.dm16"
      DM(17)="TutVoicedm.dm17"
      DM(18)="TutVoicedm.dm18"
      DM(19)="TutVoicedm.dm19"
      DM(20)="TutVoicedm.dm20"
      DM(21)="TutVoicedm.dm21"
      DM(22)="TutVoicedm.dm22"
      DM(23)="TutVoicedm.dm23"
      bReadyToSpawn=False
      TutMessage(0)="Welcome to Deathmatch combat training. Deathmatch is a sport in which you compete against other gun-wielding players in a fast paced free-for-all. The object is to destroy all of your enemies by any means necessary."
      TutMessage(1)="Every time you take an enemy out you get a point, called a 'frag' in gaming lingo. You can see your frag count on the left side of the screen. At the end of the game the player with the most frags wins the match."
      TutMessage(2)="Remember, if you accidentally blow yourself up or fall into lava you will lose a frag!"
      TutMessage(3)="Let's learn some basics about moving around. A good deathmatch player is always moving, because a moving target is harder to hit than a stationary one."
      TutMessage(4)="The forward key moves you forward while the backward key makes you backpedal. The left key causes you to strafe left, while the right key, you guessed it, strafes right."
      TutMessage(5)="Strafing is extremely important in deathmatch because it allows you to move from side to side without turning and losing sight or aim of your foe. Let's try strafing left and right now."
      TutMessage(6)="Another important element of moving around is jumping. Jumping allows you to reach areas of the map that are too high to walk to normally and to cross dangerous pits. Try pressing the jump button and jump around the map."
      TutMessage(7)="Excellent."
      TutMessage(8)="Now we're going to learn about Mouselooking. Move your mouse around and notice how your view shifts. This is how you look around and turn, known as Mouselook."
      TutMessage(9)="Try turning around several times by moving the mouse left to right to see the lovely battle arena."
      TutMessage(10)="Excellent. You can also look vertically to see what's occuring above and below you. In deathmatch your enemies will be attacking from above and below, so remember to always keep your eyes peeled."
      TutMessage(11)="If you feel like you are looking around too quickly you can easily adjust the sensitivity of the mouse in the OPTIONS menu."
      TutMessage(12)="Let's learn about offense. Remember, the only way to win at deathmatch is to destroy your foes with weaponry that you collect."
      TutMessage(13)="I'm going to open the weapons locker and allow access to some guns, let's pick them up and get ready for some target practice."
      TutMessage(14)="Great, now we're armed. The gun you're carrying is commonly called the 'Shock Rifle'. It, like all the weapons in the Tournament, has two firing modes. Let's try shooting the gun now. Press the fire button to emit a lethal electric beam."
      TutMessage(15)="Very good. The Shock Rifle's primary fire will instantly hit the person you shoot at. In Unreal Tournament, every weapon also has an alternate firing mode. Press the alt fire button to shoot a ball of plasma at your enemy."
      TutMessage(16)="Great! The alt fire on the Shock Rifle is slower moving than the primary fire, but does more damage. Its up to you to decide which attack is right for the situation. Sometimes you might be carrying more than one weapon. I've just put an 'Enforcer' sidearm in your pack. Each weapon has an associated number, as you can see at the bottom of your screen. The Enforcer is weapon number 2. Press 2 and switch to the enforcer. You can switch back to the Shock Rifle by pressing its number."
      TutMessage(17)="Good, now you know how to switch weapons in battle. Every weapon in Unreal Tournament is a projectile weapon except one, the 'Impact Hammer'. Press 1 now to switch to the Impact Hammer."
      TutMessage(18)="The Impact Hammer is a melee, or close combat, weapon. It requires you to be standing very close to the target to do damage. The tradeoff is that a hit will almost always kill your enemy. Press and hold the primary fire button now to charge up the impact hammer."
      TutMessage(19)="Now, run up to the Nali I just spawned. When you get close enough, the Impact Hammer will release blowing him into pieces."
      TutMessage(20)="Look at those gibs fly!  Great job."
      TutMessage(21)="Good job. Now we're going to take out some stationary targets. Shoot all three barrels to proceed."
      TutMessage(22)="Nice shootin' Tex. It's about to get harder. I'm going to release a training human opponent for you to practice on. You'll have to frag him three times to complete the tutorial. Good luck!"
      TutMessage(23)="Congratulations! You have proven yourself to be a worthy Deathmatch player. Now its time to enter the Deathmatch Tournament Ladder."
      TutMessage4Parts(0)="The forward key"
      TutMessage4Parts(1)="moves you forward while the backward key"
      TutMessage4Parts(2)="makes you backpedal. The left key"
      TutMessage4Parts(3)="causes you to strafe left, while the right key"
      TutMessage4Parts(4)=", you guessed it, strafes right."
      TutMessage6Parts(0)="Another important element of moving around is jumping. Jumping allows you to reach areas of the map that are too high to walk to normally and to cross dangerous pits. Try pressing the jump button"
      TutMessage6Parts(1)="and jump around the map."
      TutMessage14Parts(0)="Great, now we're armed. The gun you're carrying is commonly called the 'Shock Rifle'. It, like all the weapons in the Tournament, has two firing modes. Let's try shooting the gun now. Press the fire button"
      TutMessage14Parts(1)="to emit a lethal electric beam."
      TutMessage15Parts(0)="Very good. The Shock Rifle's primary fire will instantly hit the person you shoot at. In Unreal Tournament, every weapon also has an alternate firing mode. Press the alt fire button"
      TutMessage15Parts(1)="to shoot a ball of plasma at your enemy."
      KeyAlias(0)=""
      KeyAlias(1)=""
      KeyAlias(2)=""
      KeyAlias(3)=""
      KeyAlias(4)=""
      KeyAlias(5)=""
      KeyAlias(6)=""
      KeyAlias(7)=""
      KeyAlias(8)=""
      KeyAlias(9)=""
      KeyAlias(10)=""
      KeyAlias(11)=""
      KeyAlias(12)=""
      KeyAlias(13)=""
      KeyAlias(14)=""
      KeyAlias(15)=""
      KeyAlias(16)=""
      KeyAlias(17)=""
      KeyAlias(18)=""
      KeyAlias(19)=""
      KeyAlias(20)=""
      KeyAlias(21)=""
      KeyAlias(22)=""
      KeyAlias(23)=""
      KeyAlias(24)=""
      KeyAlias(25)=""
      KeyAlias(26)=""
      KeyAlias(27)=""
      KeyAlias(28)=""
      KeyAlias(29)=""
      KeyAlias(30)=""
      KeyAlias(31)=""
      KeyAlias(32)=""
      KeyAlias(33)=""
      KeyAlias(34)=""
      KeyAlias(35)=""
      KeyAlias(36)=""
      KeyAlias(37)=""
      KeyAlias(38)=""
      KeyAlias(39)=""
      KeyAlias(40)=""
      KeyAlias(41)=""
      KeyAlias(42)=""
      KeyAlias(43)=""
      KeyAlias(44)=""
      KeyAlias(45)=""
      KeyAlias(46)=""
      KeyAlias(47)=""
      KeyAlias(48)=""
      KeyAlias(49)=""
      KeyAlias(50)=""
      KeyAlias(51)=""
      KeyAlias(52)=""
      KeyAlias(53)=""
      KeyAlias(54)=""
      KeyAlias(55)=""
      KeyAlias(56)=""
      KeyAlias(57)=""
      KeyAlias(58)=""
      KeyAlias(59)=""
      KeyAlias(60)=""
      KeyAlias(61)=""
      KeyAlias(62)=""
      KeyAlias(63)=""
      KeyAlias(64)=""
      KeyAlias(65)=""
      KeyAlias(66)=""
      KeyAlias(67)=""
      KeyAlias(68)=""
      KeyAlias(69)=""
      KeyAlias(70)=""
      KeyAlias(71)=""
      KeyAlias(72)=""
      KeyAlias(73)=""
      KeyAlias(74)=""
      KeyAlias(75)=""
      KeyAlias(76)=""
      KeyAlias(77)=""
      KeyAlias(78)=""
      KeyAlias(79)=""
      KeyAlias(80)=""
      KeyAlias(81)=""
      KeyAlias(82)=""
      KeyAlias(83)=""
      KeyAlias(84)=""
      KeyAlias(85)=""
      KeyAlias(86)=""
      KeyAlias(87)=""
      KeyAlias(88)=""
      KeyAlias(89)=""
      KeyAlias(90)=""
      KeyAlias(91)=""
      KeyAlias(92)=""
      KeyAlias(93)=""
      KeyAlias(94)=""
      KeyAlias(95)=""
      KeyAlias(96)=""
      KeyAlias(97)=""
      KeyAlias(98)=""
      KeyAlias(99)=""
      KeyAlias(100)=""
      KeyAlias(101)=""
      KeyAlias(102)=""
      KeyAlias(103)=""
      KeyAlias(104)=""
      KeyAlias(105)=""
      KeyAlias(106)=""
      KeyAlias(107)=""
      KeyAlias(108)=""
      KeyAlias(109)=""
      KeyAlias(110)=""
      KeyAlias(111)=""
      KeyAlias(112)=""
      KeyAlias(113)=""
      KeyAlias(114)=""
      KeyAlias(115)=""
      KeyAlias(116)=""
      KeyAlias(117)=""
      KeyAlias(118)=""
      KeyAlias(119)=""
      KeyAlias(120)=""
      KeyAlias(121)=""
      KeyAlias(122)=""
      KeyAlias(123)=""
      KeyAlias(124)=""
      KeyAlias(125)=""
      KeyAlias(126)=""
      KeyAlias(127)=""
      KeyAlias(128)=""
      KeyAlias(129)=""
      KeyAlias(130)=""
      KeyAlias(131)=""
      KeyAlias(132)=""
      KeyAlias(133)=""
      KeyAlias(134)=""
      KeyAlias(135)=""
      KeyAlias(136)=""
      KeyAlias(137)=""
      KeyAlias(138)=""
      KeyAlias(139)=""
      KeyAlias(140)=""
      KeyAlias(141)=""
      KeyAlias(142)=""
      KeyAlias(143)=""
      KeyAlias(144)=""
      KeyAlias(145)=""
      KeyAlias(146)=""
      KeyAlias(147)=""
      KeyAlias(148)=""
      KeyAlias(149)=""
      KeyAlias(150)=""
      KeyAlias(151)=""
      KeyAlias(152)=""
      KeyAlias(153)=""
      KeyAlias(154)=""
      KeyAlias(155)=""
      KeyAlias(156)=""
      KeyAlias(157)=""
      KeyAlias(158)=""
      KeyAlias(159)=""
      KeyAlias(160)=""
      KeyAlias(161)=""
      KeyAlias(162)=""
      KeyAlias(163)=""
      KeyAlias(164)=""
      KeyAlias(165)=""
      KeyAlias(166)=""
      KeyAlias(167)=""
      KeyAlias(168)=""
      KeyAlias(169)=""
      KeyAlias(170)=""
      KeyAlias(171)=""
      KeyAlias(172)=""
      KeyAlias(173)=""
      KeyAlias(174)=""
      KeyAlias(175)=""
      KeyAlias(176)=""
      KeyAlias(177)=""
      KeyAlias(178)=""
      KeyAlias(179)=""
      KeyAlias(180)=""
      KeyAlias(181)=""
      KeyAlias(182)=""
      KeyAlias(183)=""
      KeyAlias(184)=""
      KeyAlias(185)=""
      KeyAlias(186)=""
      KeyAlias(187)=""
      KeyAlias(188)=""
      KeyAlias(189)=""
      KeyAlias(190)=""
      KeyAlias(191)=""
      KeyAlias(192)=""
      KeyAlias(193)=""
      KeyAlias(194)=""
      KeyAlias(195)=""
      KeyAlias(196)=""
      KeyAlias(197)=""
      KeyAlias(198)=""
      KeyAlias(199)=""
      KeyAlias(200)=""
      KeyAlias(201)=""
      KeyAlias(202)=""
      KeyAlias(203)=""
      KeyAlias(204)=""
      KeyAlias(205)=""
      KeyAlias(206)=""
      KeyAlias(207)=""
      KeyAlias(208)=""
      KeyAlias(209)=""
      KeyAlias(210)=""
      KeyAlias(211)=""
      KeyAlias(212)=""
      KeyAlias(213)=""
      KeyAlias(214)=""
      KeyAlias(215)=""
      KeyAlias(216)=""
      KeyAlias(217)=""
      KeyAlias(218)=""
      KeyAlias(219)=""
      KeyAlias(220)=""
      KeyAlias(221)=""
      KeyAlias(222)=""
      KeyAlias(223)=""
      KeyAlias(224)=""
      KeyAlias(225)=""
      KeyAlias(226)=""
      KeyAlias(227)=""
      KeyAlias(228)=""
      KeyAlias(229)=""
      KeyAlias(230)=""
      KeyAlias(231)=""
      KeyAlias(232)=""
      KeyAlias(233)=""
      KeyAlias(234)=""
      KeyAlias(235)=""
      KeyAlias(236)=""
      KeyAlias(237)=""
      KeyAlias(238)=""
      KeyAlias(239)=""
      KeyAlias(240)=""
      KeyAlias(241)=""
      KeyAlias(242)=""
      KeyAlias(243)=""
      KeyAlias(244)=""
      KeyAlias(245)=""
      KeyAlias(246)=""
      KeyAlias(247)=""
      KeyAlias(248)=""
      KeyAlias(249)=""
      KeyAlias(250)=""
      KeyAlias(251)=""
      KeyAlias(252)=""
      KeyAlias(253)=""
      KeyAlias(254)=""
      Trainee=None
      lastRotation=(Pitch=0,Yaw=0,Roll=0)
      LastLocation=(X=0.000000,Y=0.000000,Z=0.000000)
      EventTimer=0
      LastEvent=24
      EventIndex=0
      SoundIndex=0
      bPause=False
      SingleWaitingMessage=""
      bTutorialGame=True
      Difficulty=0
      MapPrefix="DM-Tutorial"
      BeaconName="DM-Tutorial"
      GameName="Combat Training: DM"
      bLoggingGame=False
}
