//=============================================================================
// MaleTwoBot.
//=============================================================================
class MaleTwoBot extends MaleBot;

#exec AUDIO IMPORT FILE="..\UnrealShare\Sounds\male\jump10.WAV" NAME="MJump2" GROUP="Male"
#exec AUDIO IMPORT FILE="..\UnrealShare\Sounds\male\land10.WAV" NAME="MLand2" GROUP="Male"

function ForceMeshToExist()
{
	Spawn(class'MaleTwo');
}

defaultproperties
{
      CarcassType=Class'UnrealI.MaleTwoCarcass'
      LandGrunt=Sound'UnrealI.Male.MLand2'
      JumpSound=Sound'UnrealI.Male.MJump2'
      Skin=Texture'UnrealShare.Skins.Ash'
      Mesh=LodMesh'UnrealI.Male2'
}
