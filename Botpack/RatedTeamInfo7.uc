class RatedTeamInfo7 expands RatedTeamInfo;

// Red Claw
#exec TEXTURE IMPORT NAME=TSkaarj1 FILE=textures\teamsymbols\skaarjteam_a.pcx GROUP="TeamSymbols" MIPS=OFF

static function class<TournamentPlayer> GetMaleClass()
{
	return class<TournamentPlayer>(DynamicLoadObject("MultiMesh.TSkaarj",class'Class'));
}

defaultproperties
{
      TeamName="Red Claw"
      TeamSymbol=Texture'Botpack.TeamSymbols.TSkaarj1'
      TeamBio="The N.E.G. has long recognized the superiority of the Skaarj warrior as a military fighting machine, as was made clear in the brutal Human-Skaarj wars.  The Skaarj Hybrid is the result of secret military genetic research using both human and Skaarj DNA performed after the capture of a Skaarj scout ship. If proven in Tournament battle, the Hybrids shall become a leading force in ground based ops."
      BotNames(0)="Dominator"
      BotNames(1)="Berserker"
      BotNames(2)="Guardian"
      BotNames(3)="Devastator"
      BotNames(4)="Pestilence"
      BotNames(5)="Plague"
      BotClassifications(0)="Classified: L9"
      BotClassifications(1)="Classified: L9"
      BotClassifications(2)="Classified: L9"
      BotClassifications(3)="Classified: L9"
      BotClassifications(4)="Classified: L9"
      BotClassifications(5)="Classified: L9"
      BotClasses(0)="MultiMesh.TSkaarjBot"
      BotClasses(1)="MultiMesh.TSkaarjBot"
      BotClasses(2)="MultiMesh.TSkaarjBot"
      BotClasses(3)="MultiMesh.TSkaarjBot"
      BotClasses(4)="MultiMesh.TSkaarjBot"
      BotClasses(5)="MultiMesh.TSkaarjBot"
      BotSkins(0)="TskmSkins.Warr"
      BotSkins(1)="TskmSkins.Warr"
      BotSkins(2)="TskmSkins.Warr"
      BotSkins(3)="TskmSkins.Warr"
      BotSkins(4)="TskmSkins.Warr"
      BotSkins(5)="TskmSkins.Warr"
      BotFaces(0)="TSkMSkins.Dominator"
      BotFaces(1)="TSkMSkins.Berserker"
      BotFaces(2)="TSkMSkins.Guardian"
      BotFaces(3)="TSkMSkins.Dominator"
      BotFaces(4)="TSkMSkins.Berserker"
      BotFaces(5)="TSkMSkins.Guardian"
      BotBio(0)="No profile available. Level 9 security clearance required."
      BotBio(1)="No profile available. Level 9 security clearance required."
      BotBio(2)="No profile available. Level 9 security clearance required."
      BotBio(3)="No profile available. Level 9 security clearance required."
      BotBio(4)="No profile available. Level 9 security clearance required."
      BotBio(5)="No profile available. Level 9 security clearance required."
      MaleSkin="TSkmSkins.Warr"
      FemaleSkin="TSkmSkins.Warr"
}
