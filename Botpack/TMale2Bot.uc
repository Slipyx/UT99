//=============================================================================
// TMale2Bot.
//=============================================================================
class TMale2Bot extends MaleBotPlus;

function ForceMeshToExist()
{
	Spawn(class'TMale2');
}

defaultproperties
{
      CarcassType=Class'Botpack.TMale2Carcass'
      LandGrunt=Sound'Botpack.MaleSounds.(All).land10'
      FaceSkin=3
      FixedSkin=2
      TeamSkin2=1
      DefaultSkinName="SoldierSkins.blkt"
      DefaultPackage="SoldierSkins."
      SelectionMesh="Botpack.SelectionMale2"
      MenuName="Male Soldier"
      Mesh=LodMesh'Botpack.Soldier'
}
