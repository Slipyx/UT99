//=============================================================================
// TMale1Bot.
//=============================================================================
class TMale1Bot extends MaleBotPlus;

function ForceMeshToExist()
{
	Spawn(class'TMale1');
}

defaultproperties
{
      LandGrunt=Sound'UnrealShare.Male.MLand3'
      JumpSound=Sound'Botpack.Male.TMJump3'
      FaceSkin=1
      TeamSkin1=2
      TeamSkin2=3
      DefaultSkinName="CommandoSkins.cmdo"
      DefaultPackage="CommandoSkins."
      SelectionMesh="Botpack.SelectionMale1"
      MenuName="Male Commando"
      VoiceType="BotPack.VoiceMaleOne"
      Mesh=LodMesh'Botpack.Commando'
}
