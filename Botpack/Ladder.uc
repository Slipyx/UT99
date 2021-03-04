//=============================================================================
// Ladder
// A ladder game ladder.
//=============================================================================
class Ladder extends Info
	abstract
	config(user);

var() int			Matches;						// # of matches in ladder.
var() bool			bTeamGame;						// TeamGame ladder?
var() localized string	    Titles[9];						// Ranking titles.
var() string		MapPrefix;						// Match map prefix.

// 32 Matches
var() string	    Maps[32];						// Match map.
var() string	    MapAuthors[32];					// Map authors.
var() localized string	    MapTitle[32];					// Map title.
var() localized string	    MapDescription[32];				// Map description.
var() int			RankedGame[32];					// Rank to award upon completion.
var() int			GoalTeamScore[32];				// Match goalteamscore.
var() int			FragLimits[32];					// Match fraglimit.
var() int			TimeLimits[32];					// Match timelimit.
var() string		MatchInfo[32];					// BotConfig to use for each game
													// The botconfig has all the info about
													// individual bots in this match
var() int			DemoDisplay[32];				// This match is for demo display only.

var() class<RatedTeamInfo> LadderTeams[32];			// Teams that can be fought in this ladder
var() int			NumTeams;						// Number of LadderTeams

var   globalconfig bool	HasBeatenGame;

static function Class<RatedMatchInfo> GetMatchConfigType(int Index)
{
	return Class<RatedMatchInfo>(DynamicLoadObject(Default.MatchInfo[Index], class'Class'));
}

static function string GetMap( int Index )
{
	return Default.Maps[Index];
}

static function string GetAuthor( int Index )
{
	return Default.MapAuthors[Index];
}

static function string GetMapTitle( int Index )
{
	return Default.MapTitle[Index];
}

static function string GetDesc( int Index )
{
	return Default.MapDescription[Index];
}

static function string GetRank( int Index )
{
	return Default.Titles[Index];
}

static function int GetFragLimit( int Index )
{
	return Default.FragLimits[Index];
}

static function int GetGoalTeamScore( int Index )
{
	return Default.GoalTeamScore[Index];
}

defaultproperties
{
      Matches=0
      bTeamGame=False
      Titles(0)="Untrained"
      Titles(1)="Contender"
      Titles(2)="Light Weight"
      Titles(3)="Heavy Weight"
      Titles(4)="Warlord"
      Titles(5)="Battle Master"
      Titles(6)="Champion"
      Titles(7)=""
      Titles(8)=""
      MapPrefix=""
      Maps(0)=""
      Maps(1)=""
      Maps(2)=""
      Maps(3)=""
      Maps(4)=""
      Maps(5)=""
      Maps(6)=""
      Maps(7)=""
      Maps(8)=""
      Maps(9)=""
      Maps(10)=""
      Maps(11)=""
      Maps(12)=""
      Maps(13)=""
      Maps(14)=""
      Maps(15)=""
      Maps(16)=""
      Maps(17)=""
      Maps(18)=""
      Maps(19)=""
      Maps(20)=""
      Maps(21)=""
      Maps(22)=""
      Maps(23)=""
      Maps(24)=""
      Maps(25)=""
      Maps(26)=""
      Maps(27)=""
      Maps(28)=""
      Maps(29)=""
      Maps(30)=""
      Maps(31)=""
      MapAuthors(0)=""
      MapAuthors(1)=""
      MapAuthors(2)=""
      MapAuthors(3)=""
      MapAuthors(4)=""
      MapAuthors(5)=""
      MapAuthors(6)=""
      MapAuthors(7)=""
      MapAuthors(8)=""
      MapAuthors(9)=""
      MapAuthors(10)=""
      MapAuthors(11)=""
      MapAuthors(12)=""
      MapAuthors(13)=""
      MapAuthors(14)=""
      MapAuthors(15)=""
      MapAuthors(16)=""
      MapAuthors(17)=""
      MapAuthors(18)=""
      MapAuthors(19)=""
      MapAuthors(20)=""
      MapAuthors(21)=""
      MapAuthors(22)=""
      MapAuthors(23)=""
      MapAuthors(24)=""
      MapAuthors(25)=""
      MapAuthors(26)=""
      MapAuthors(27)=""
      MapAuthors(28)=""
      MapAuthors(29)=""
      MapAuthors(30)=""
      MapAuthors(31)=""
      MapTitle(0)=""
      MapTitle(1)=""
      MapTitle(2)=""
      MapTitle(3)=""
      MapTitle(4)=""
      MapTitle(5)=""
      MapTitle(6)=""
      MapTitle(7)=""
      MapTitle(8)=""
      MapTitle(9)=""
      MapTitle(10)=""
      MapTitle(11)=""
      MapTitle(12)=""
      MapTitle(13)=""
      MapTitle(14)=""
      MapTitle(15)=""
      MapTitle(16)=""
      MapTitle(17)=""
      MapTitle(18)=""
      MapTitle(19)=""
      MapTitle(20)=""
      MapTitle(21)=""
      MapTitle(22)=""
      MapTitle(23)=""
      MapTitle(24)=""
      MapTitle(25)=""
      MapTitle(26)=""
      MapTitle(27)=""
      MapTitle(28)=""
      MapTitle(29)=""
      MapTitle(30)=""
      MapTitle(31)=""
      MapDescription(0)=""
      MapDescription(1)=""
      MapDescription(2)=""
      MapDescription(3)=""
      MapDescription(4)=""
      MapDescription(5)=""
      MapDescription(6)=""
      MapDescription(7)=""
      MapDescription(8)=""
      MapDescription(9)=""
      MapDescription(10)=""
      MapDescription(11)=""
      MapDescription(12)=""
      MapDescription(13)=""
      MapDescription(14)=""
      MapDescription(15)=""
      MapDescription(16)=""
      MapDescription(17)=""
      MapDescription(18)=""
      MapDescription(19)=""
      MapDescription(20)=""
      MapDescription(21)=""
      MapDescription(22)=""
      MapDescription(23)=""
      MapDescription(24)=""
      MapDescription(25)=""
      MapDescription(26)=""
      MapDescription(27)=""
      MapDescription(28)=""
      MapDescription(29)=""
      MapDescription(30)=""
      MapDescription(31)=""
      RankedGame(0)=0
      RankedGame(1)=0
      RankedGame(2)=0
      RankedGame(3)=0
      RankedGame(4)=0
      RankedGame(5)=0
      RankedGame(6)=0
      RankedGame(7)=0
      RankedGame(8)=0
      RankedGame(9)=0
      RankedGame(10)=0
      RankedGame(11)=0
      RankedGame(12)=0
      RankedGame(13)=0
      RankedGame(14)=0
      RankedGame(15)=0
      RankedGame(16)=0
      RankedGame(17)=0
      RankedGame(18)=0
      RankedGame(19)=0
      RankedGame(20)=0
      RankedGame(21)=0
      RankedGame(22)=0
      RankedGame(23)=0
      RankedGame(24)=0
      RankedGame(25)=0
      RankedGame(26)=0
      RankedGame(27)=0
      RankedGame(28)=0
      RankedGame(29)=0
      RankedGame(30)=0
      RankedGame(31)=0
      GoalTeamScore(0)=0
      GoalTeamScore(1)=0
      GoalTeamScore(2)=0
      GoalTeamScore(3)=0
      GoalTeamScore(4)=0
      GoalTeamScore(5)=0
      GoalTeamScore(6)=0
      GoalTeamScore(7)=0
      GoalTeamScore(8)=0
      GoalTeamScore(9)=0
      GoalTeamScore(10)=0
      GoalTeamScore(11)=0
      GoalTeamScore(12)=0
      GoalTeamScore(13)=0
      GoalTeamScore(14)=0
      GoalTeamScore(15)=0
      GoalTeamScore(16)=0
      GoalTeamScore(17)=0
      GoalTeamScore(18)=0
      GoalTeamScore(19)=0
      GoalTeamScore(20)=0
      GoalTeamScore(21)=0
      GoalTeamScore(22)=0
      GoalTeamScore(23)=0
      GoalTeamScore(24)=0
      GoalTeamScore(25)=0
      GoalTeamScore(26)=0
      GoalTeamScore(27)=0
      GoalTeamScore(28)=0
      GoalTeamScore(29)=0
      GoalTeamScore(30)=0
      GoalTeamScore(31)=0
      FragLimits(0)=0
      FragLimits(1)=0
      FragLimits(2)=0
      FragLimits(3)=0
      FragLimits(4)=0
      FragLimits(5)=0
      FragLimits(6)=0
      FragLimits(7)=0
      FragLimits(8)=0
      FragLimits(9)=0
      FragLimits(10)=0
      FragLimits(11)=0
      FragLimits(12)=0
      FragLimits(13)=0
      FragLimits(14)=0
      FragLimits(15)=0
      FragLimits(16)=0
      FragLimits(17)=0
      FragLimits(18)=0
      FragLimits(19)=0
      FragLimits(20)=0
      FragLimits(21)=0
      FragLimits(22)=0
      FragLimits(23)=0
      FragLimits(24)=0
      FragLimits(25)=0
      FragLimits(26)=0
      FragLimits(27)=0
      FragLimits(28)=0
      FragLimits(29)=0
      FragLimits(30)=0
      FragLimits(31)=0
      TimeLimits(0)=0
      TimeLimits(1)=0
      TimeLimits(2)=0
      TimeLimits(3)=0
      TimeLimits(4)=0
      TimeLimits(5)=0
      TimeLimits(6)=0
      TimeLimits(7)=0
      TimeLimits(8)=0
      TimeLimits(9)=0
      TimeLimits(10)=0
      TimeLimits(11)=0
      TimeLimits(12)=0
      TimeLimits(13)=0
      TimeLimits(14)=0
      TimeLimits(15)=0
      TimeLimits(16)=0
      TimeLimits(17)=0
      TimeLimits(18)=0
      TimeLimits(19)=0
      TimeLimits(20)=0
      TimeLimits(21)=0
      TimeLimits(22)=0
      TimeLimits(23)=0
      TimeLimits(24)=0
      TimeLimits(25)=0
      TimeLimits(26)=0
      TimeLimits(27)=0
      TimeLimits(28)=0
      TimeLimits(29)=0
      TimeLimits(30)=0
      TimeLimits(31)=0
      MatchInfo(0)=""
      MatchInfo(1)=""
      MatchInfo(2)=""
      MatchInfo(3)=""
      MatchInfo(4)=""
      MatchInfo(5)=""
      MatchInfo(6)=""
      MatchInfo(7)=""
      MatchInfo(8)=""
      MatchInfo(9)=""
      MatchInfo(10)=""
      MatchInfo(11)=""
      MatchInfo(12)=""
      MatchInfo(13)=""
      MatchInfo(14)=""
      MatchInfo(15)=""
      MatchInfo(16)=""
      MatchInfo(17)=""
      MatchInfo(18)=""
      MatchInfo(19)=""
      MatchInfo(20)=""
      MatchInfo(21)=""
      MatchInfo(22)=""
      MatchInfo(23)=""
      MatchInfo(24)=""
      MatchInfo(25)=""
      MatchInfo(26)=""
      MatchInfo(27)=""
      MatchInfo(28)=""
      MatchInfo(29)=""
      MatchInfo(30)=""
      MatchInfo(31)=""
      DemoDisplay(0)=0
      DemoDisplay(1)=0
      DemoDisplay(2)=0
      DemoDisplay(3)=0
      DemoDisplay(4)=0
      DemoDisplay(5)=0
      DemoDisplay(6)=0
      DemoDisplay(7)=0
      DemoDisplay(8)=0
      DemoDisplay(9)=0
      DemoDisplay(10)=0
      DemoDisplay(11)=0
      DemoDisplay(12)=0
      DemoDisplay(13)=0
      DemoDisplay(14)=0
      DemoDisplay(15)=0
      DemoDisplay(16)=0
      DemoDisplay(17)=0
      DemoDisplay(18)=0
      DemoDisplay(19)=0
      DemoDisplay(20)=0
      DemoDisplay(21)=0
      DemoDisplay(22)=0
      DemoDisplay(23)=0
      DemoDisplay(24)=0
      DemoDisplay(25)=0
      DemoDisplay(26)=0
      DemoDisplay(27)=0
      DemoDisplay(28)=0
      DemoDisplay(29)=0
      DemoDisplay(30)=0
      DemoDisplay(31)=0
      LadderTeams(0)=Class'Botpack.RatedTeamInfo1'
      LadderTeams(1)=Class'Botpack.RatedTeamInfo2'
      LadderTeams(2)=Class'Botpack.RatedTeamInfo3'
      LadderTeams(3)=Class'Botpack.RatedTeamInfo4'
      LadderTeams(4)=Class'Botpack.RatedTeamInfo5'
      LadderTeams(5)=Class'Botpack.RatedTeamInfo6'
      LadderTeams(6)=Class'Botpack.RatedTeamInfoS'
      LadderTeams(7)=Class'Botpack.RatedTeamInfo7'
      LadderTeams(8)=Class'Botpack.RatedTeamInfo8'
      LadderTeams(9)=Class'Botpack.RatedTeamInfoDemo1'
      LadderTeams(10)=Class'Botpack.RatedTeamInfoDemo2'
      LadderTeams(11)=None
      LadderTeams(12)=None
      LadderTeams(13)=None
      LadderTeams(14)=None
      LadderTeams(15)=None
      LadderTeams(16)=None
      LadderTeams(17)=None
      LadderTeams(18)=None
      LadderTeams(19)=None
      LadderTeams(20)=None
      LadderTeams(21)=None
      LadderTeams(22)=None
      LadderTeams(23)=None
      LadderTeams(24)=None
      LadderTeams(25)=None
      LadderTeams(26)=None
      LadderTeams(27)=None
      LadderTeams(28)=None
      LadderTeams(29)=None
      LadderTeams(30)=None
      LadderTeams(31)=None
      NumTeams=7
      HasBeatenGame=False
}
