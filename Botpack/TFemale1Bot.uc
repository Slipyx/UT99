//=============================================================================
// TFemale1Bot.
//=============================================================================
class TFemale1Bot extends FemaleBotPlus;

function ForceMeshToExist()
{
	Spawn(class'TFemale1');
}

defaultproperties
{
      FaceSkin=3
      TeamSkin2=1
      DefaultSkinName="FCommandoSkins.cmdo"
      DefaultPackage="FCommandoSkins."
      SelectionMesh="Botpack.SelectionFemale1"
      MenuName="Female Commando"
      VoiceType="BotPack.VoiceFemaleOne"
      Mesh=LodMesh'Botpack.FCommando'
}
