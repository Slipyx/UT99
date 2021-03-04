class RatedTeamInfo8 expands RatedTeamInfo;

// Iron Skull
#exec TEXTURE IMPORT NAME=TSkaarj2 FILE=textures\teamsymbols\skaarjteam_b.pcx GROUP="TeamSymbols" MIPS=OFF

static function class<TournamentPlayer> GetMaleClass()
{
	return class<TournamentPlayer>(DynamicLoadObject("MultiMesh.TSkaarj",class'Class'));
}

defaultproperties
{
      TeamName="Iron Skull"
      TeamSymbol=Texture'Botpack.TeamSymbols.TSkaarj2'
      TeamBio="The N.E.G. has long recognized the superiority of the Skaarj warrior as a military fighting machine, as was made clear in the brutal Human-Skaarj wars.  The Skaarj Hybrid is the result of secret military genetic research using both human and Skaarj DNA performed after the capture of a Skaarj scout ship. If proven in Tournament battle, the Hybrids shall become a leading force in ground based ops."
      BotNames(0)="Reaper"
      BotNames(1)="Baetal"
      BotNames(2)="Pharoh"
      BotNames(3)="Skrilax"
      BotNames(4)="Anthrax"
      BotNames(5)="Entropy"
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
      BotSkins(0)="TSkmSkins.MekS"
      BotSkins(1)="TSkmSkins.PitF"
      BotSkins(2)="TSkmSkins.PitF"
      BotSkins(3)="TSkmSkins.PitF"
      BotSkins(4)="TSkmSkins.PitF"
      BotSkins(5)="TSkmSkins.PitF"
      BotFaces(0)="TSkMSkins.Disconnect"
      BotFaces(1)="TSkMSkins.Baetal"
      BotFaces(2)="TSkMSkins.Pharoh"
      BotFaces(3)="TSkMSkins.Skrilax"
      BotFaces(4)="TSkMSkins.Baetal"
      BotFaces(5)="TSkMSkins.Pharoh"
      BotBio(0)="No profile available. Level 9 security clearance required."
      BotBio(1)="No profile available. Level 9 security clearance required."
      BotBio(2)="No profile available. Level 9 security clearance required."
      BotBio(3)="No profile available. Level 9 security clearance required."
      BotBio(4)="No profile available. Level 9 security clearance required."
      BotBio(5)="No profile available. Level 9 security clearance required."
      MaleSkin="TSkmSkins.PitF"
      FemaleSkin="TSkmSkins.PitF"
}
