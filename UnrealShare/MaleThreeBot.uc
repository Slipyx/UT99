//=============================================================================
// MaleThreeBot.
//=============================================================================
class MaleThreeBot extends MaleBot;

#exec AUDIO IMPORT FILE="Sounds\male\jump11.WAV" NAME="MJump3" GROUP="Male"
#exec AUDIO IMPORT FILE="Sounds\male\land12.WAV" NAME="MLand3" GROUP="Male"

function ForceMeshToExist()
{
	Spawn(class'MaleThree');
}

defaultproperties
{
      CarcassType=Class'UnrealShare.MaleThreeCarcass'
      LandGrunt=Sound'UnrealShare.Male.MLand3'
      JumpSound=Sound'UnrealShare.Male.MJump3'
      Skin=Texture'UnrealShare.Skins.Dante'
      Mesh=LodMesh'UnrealShare.Male3'
}
