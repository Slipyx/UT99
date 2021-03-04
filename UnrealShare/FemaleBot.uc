//=============================================================================
// FemaleBot.
//=============================================================================
class FemaleBot extends HumanBot
	abstract;

#exec AUDIO IMPORT FILE="Sounds\female\mdrown2.WAV" NAME="mdrown2fem" GROUP="Female"
#exec AUDIO IMPORT FILE="Sounds\female\hgasp3.WAV"  NAME="hgasp3fem"  GROUP="Female"
#exec AUDIO IMPORT FILE="Sounds\female\linjur2.WAV" NAME="linjur1fem" GROUP="Female"
#exec AUDIO IMPORT FILE="Sounds\female\linjur3.WAV" NAME="linjur2fem" GROUP="Female"
#exec AUDIO IMPORT FILE="Sounds\female\linjur4.WAV" NAME="linjur3fem" GROUP="Female"
#exec AUDIO IMPORT FILE="Sounds\female\hinjur4.WAV" NAME="hinjur4fem" GROUP="Female"
#exec AUDIO IMPORT FILE="Sounds\female\death1d.WAV" NAME="death1dfem" GROUP="Female"
#exec AUDIO IMPORT FILE="Sounds\female\death2a.WAV" NAME="death2afem" GROUP="Female"
#exec AUDIO IMPORT FILE="Sounds\female\death3c.WAV" NAME="death3cfem" GROUP="Female"
#exec AUDIO IMPORT FILE="Sounds\female\death4c.WAV" NAME="death4cfem" GROUP="Female"
#exec AUDIO IMPORT FILE="Sounds\female\lland1.WAV"  NAME="lland1fem"  GROUP="Female"
#exec AUDIO IMPORT FILE="Sounds\female\lgasp1.WAV"  NAME="lgasp1fem"  GROUP="Female"
#exec AUDIO IMPORT FILE="Sounds\female\jump1.WAV"  NAME="jump1fem"  GROUP="Female"
#exec AUDIO IMPORT FILE="Sounds\female\UWhit01.WAV" NAME="FUWHit1" GROUP="Female"
#exec AUDIO IMPORT FILE="Sounds\Male\UWinjur42.WAV" NAME="MUWHit2" GROUP="Male"

defaultproperties
{
      CarcassType=Class'UnrealShare.FemaleBody'
      drown=Sound'UnrealShare.Female.mdrown2fem'
      breathagain=Sound'UnrealShare.Female.hgasp3fem'
      HitSound3=Sound'UnrealShare.Female.linjur3fem'
      HitSound4=Sound'UnrealShare.Female.hinjur4fem'
      Die2=Sound'UnrealShare.Female.death3cfem'
      Die3=Sound'UnrealShare.Female.death2afem'
      Die4=Sound'UnrealShare.Female.death4cfem'
      GaspSound=Sound'UnrealShare.Female.lgasp1fem'
      UWHit1=Sound'UnrealShare.Female.FUWHit1'
      UWHit2=Sound'UnrealShare.Male.MUWHit2'
      LandGrunt=Sound'UnrealShare.Female.lland1fem'
      JumpSound=Sound'UnrealShare.Female.jump1fem'
      bIsFemale=True
      HitSound1=Sound'UnrealShare.Female.linjur1fem'
      HitSound2=Sound'UnrealShare.Female.linjur2fem'
      Die=Sound'UnrealShare.Female.death1dfem'
}
