//=============================================================================
// LadderAS
//=============================================================================
class LadderAS extends Ladder;

// Objective Shots
static function int GetObjectiveCount(int Index, AssaultInfo AI)
{
	AI = AssaultInfo(DynamicLoadObject(Default.MapPrefix$Default.Maps[Index]$".AssaultInfo0", class'AssaultInfo'));
	return AI.NumObjShots;
}

static function texture GetObjectiveShot(int Index, int ShotNum, AssaultInfo AI)
{
	AI = AssaultInfo(DynamicLoadObject(Default.MapPrefix$Default.Maps[Index]$".AssaultInfo0", class'AssaultInfo'));
	return AI.ObjShots[ShotNum];
}

static function string GetObjectiveString(int Index, int StringNum, AssaultInfo AI)
{
	AI = AssaultInfo(DynamicLoadObject(Default.MapPrefix$Default.Maps[Index]$".AssaultInfo0", class'AssaultInfo'));
	return AI.ObjDesc[StringNum];
}

defaultproperties
{
      Matches=7
      bTeamGame=True
      MapPrefix="AS-"
      Maps(0)="Tutorial.unr"
      Maps(1)="Frigate.unr"
      Maps(2)="HiSpeed.unr"
      Maps(3)="Rook.unr"
      Maps(4)="Mazon.unr"
      Maps(5)="OceanFloor.unr"
      Maps(6)="Overlord.unr"
      MapAuthors(0)="Cliff Bleszinski"
      MapAuthors(1)="Shane Caudle"
      MapAuthors(2)="Juan Pancho Eekels"
      MapAuthors(3)="Alan Willard 'Talisman'"
      MapAuthors(4)="Shane Caudle"
      MapAuthors(5)="Juan Pancho Eekels"
      MapAuthors(6)="Dave Ewing"
      MapTitle(0)="AS Tutorial"
      MapTitle(1)="Frigate"
      MapTitle(2)="High Speed"
      MapTitle(3)="Rook"
      MapTitle(4)="Mazon"
      MapTitle(5)="Ocean Floor"
      MapTitle(6)="Overlord"
      MapDescription(0)="Learn the basic rules of Assault in this special training environment. Test your skills against an untrained enemy before entering the tournament proper."
      MapDescription(1)="A somewhat antiquated Earth warship, the restored SS Victory is still seaworthy. A dual security system prevents intruders from activating the guns by only allowing crew members to open the control room portal. However, should the aft boiler be damaged beyond repair the door will auto-release, allowing access to anyone."
      MapDescription(2)="Always looking to entertain the public, LC refitted this 200 mph high speed train for Tournament purposes. This time the combatants will have the added danger of being able to fall off a train. Get your popcorn out people and enjoy the show!"
      MapDescription(3)="This ancient castle, nestled in the highlands of Romania, was purchased by Xan Kriegor as a personal training ground for his opponents, hoping to cull the best of the best to challenge him. The attacking team must open the main gates and escape the castle by breaking free the main winch in the library and throwing the gatehouse lever, while the defending team must prevent their escape."
      MapDescription(4)="Nestled deep within the foothills of the jungle planet Zeus 6 lies Mazon Fortress, a seemingly impregnable stronghold. Deep within the bowels of the base resides an enormous shard of the rare and volatile element Tarydium. The shard is levitating between two enormous electron rods above a pool of superconductive swamp water."
      MapDescription(5)="Oceanfloor Station5, built by universities around the globe for deep sea research, almost ran out of money when LC came to the rescue. Jerl Liandri President LC: 'If we can't ensure education for our children, what will come of this world?'"
      MapDescription(6)="The tournament organizers at Liandri have decided that the recreation of arguably the Earth's most violent war would create the perfect arena of combat. Storming the beaches of Normandy in WWII was chosen in particular because of the overwhelming odds facing each member of the attacking force. Defending this beach, however, will prove to be no less of a daunting task."
      RankedGame(0)=1
      RankedGame(1)=2
      RankedGame(2)=3
      RankedGame(3)=4
      RankedGame(4)=5
      RankedGame(5)=5
      RankedGame(6)=6
      MatchInfo(0)="Botpack.RatedMatchASTUT"
      MatchInfo(1)="Botpack.RatedMatchAS1"
      MatchInfo(2)="Botpack.RatedMatchAS2"
      MatchInfo(3)="Botpack.RatedMatchAS3"
      MatchInfo(4)="Botpack.RatedMatchAS4"
      MatchInfo(5)="Botpack.RatedMatchAS5"
      MatchInfo(6)="Botpack.RatedMatchAS6"
}
