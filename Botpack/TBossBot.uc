//=============================================================================
// TBossBot.
//=============================================================================
class TBossBot extends MaleBotPlus;

var float RealSkill, RealAccuracy;
var bool bRatedGame;

function ForceMeshToExist()
{
	Spawn(class'TBoss');
}

function MaybeTaunt(Pawn Other)
{
	if ( !bRatedGame )
		Super.MaybeTaunt(Other);
}

function ReSetSkill()
{
	local float ScaledSkill;
	if ( bRatedGame )
	{
		if ( DeathMatchPlus(Level.Game).RatedPlayer.PlayerReplicationInfo.Score > PlayerReplicationInfo.Score + 1 )
		{
			Skill += 1;
			if ( Skill > 3 )
			{
				if ( bNovice )
				{
					bNovice = false;
					Skill = FClamp(Skill - 4, 0, 3);
				}
				else
				{
					Skill = 3;
					Accuracy += 0.3;
				}
			}
		}
		else if ( DeathMatchPlus(Level.Game).RatedPlayer.PlayerReplicationInfo.Score < PlayerReplicationInfo.Score )
		{
			ScaledSkill = Skill;
			if ( !bNovice )
				ScaledSkill += 4;
			if ( ScaledSkill > RealSkill )
			{
				Accuracy = RealAccuracy;
				ScaledSkill = FMax(RealSkill, ScaledSkill - 0.5);
				bNovice = ( ScaledSkill < 4 );
				if ( !bNovice )
					ScaledSkill -= 4;
				Skill = FClamp(ScaledSkill, 0, 3);
			}
		}
	}

	Super.ReSetSkill();
}

function StartMatch()
{
	local int R;

	RealSkill = Skill;
	RealAccuracy = Accuracy;
	if ( !bNovice )
		RealSkill += 4;
	bRatedGame = ( Level.Game.IsA('DeathMatchPlus') && DeathMatchPlus(Level.Game).bRatedGame );
	if ( bRatedGame )
	{
		R = Rand(7) + 6;
		if ( R == 10 )
			R = 8;
		SendGlobalMessage(None, 'TAUNT', R, 5);
	}
}

static function SetMultiSkin(Actor SkinActor, string SkinName, string FaceName, byte TeamNum)
{
	local string MeshName, SkinItem, SkinPackage;

	MeshName = SkinActor.GetItemName(string(SkinActor.Mesh));

	SkinItem = SkinActor.GetItemName(SkinName);
	SkinPackage = Left(SkinName, Len(SkinName) - Len(SkinItem));

	if(SkinPackage == "")
	{
		SkinPackage="BossSkins.";
		SkinName=SkinPackage$SkinName;
	}

	if( TeamNum != 255 )
	{
		if(!SetSkinElement(SkinActor, 0, SkinName$"1T_"$String(TeamNum), ""))
		{
			if(!SetSkinElement(SkinActor, 0, SkinName$"1", ""))
			{
				SetSkinElement(SkinActor, 0, "BossSkins.boss1T_"$String(TeamNum), "BossSkins.boss1");
				SkinName="BossSkins.boss";
			}
		}
		SetSkinElement(SkinActor, 1, SkinName$"2T_"$String(TeamNum), SkinName$"2");
		SetSkinElement(SkinActor, 2, SkinName$"3T_"$String(TeamNum), SkinName$"3");
		SetSkinElement(SkinActor, 3, SkinName$"4T_"$String(TeamNum), SkinName$"4");
	}
	else
	{
		if(!SetSkinElement(SkinActor, 0, SkinName$"1", "BossSkins.boss1"))
			SkinName="BossSkins.boss";

		SetSkinElement(SkinActor, 1, SkinName$"2", "");
		SetSkinElement(SkinActor, 2, SkinName$"3", "");
		SetSkinElement(SkinActor, 3, SkinName$"4", "");
	}

	if( Pawn(SkinActor) != None ) 
		Pawn(SkinActor).PlayerReplicationInfo.TalkTexture = Texture(DynamicLoadObject(SkinName$"5Xan", class'Texture'));
}

defaultproperties
{
      RealSkill=0.000000
      RealAccuracy=0.000000
      bRatedGame=False
      CarcassType=Class'Botpack.TBossCarcass'
      HitSound3=Sound'Botpack.Boss.BInjur3'
      HitSound4=Sound'Botpack.Boss.BInjur4'
      Deaths(0)=Sound'Botpack.Boss.BDeath1'
      Deaths(1)=Sound'Botpack.Boss.BDeath1'
      Deaths(2)=Sound'Botpack.Boss.BDeath3'
      Deaths(3)=Sound'Botpack.Boss.BDeath4'
      Deaths(4)=Sound'Botpack.Boss.BDeath3'
      Deaths(5)=Sound'Botpack.Boss.BDeath4'
      LandGrunt=Sound'Botpack.Boss.Bland01'
      JumpSound=Sound'Botpack.Boss.BJump1'
      DefaultSkinName="BossSkins.Boss"
      StatusDoll=Texture'Botpack.Icons.BossDoll'
      StatusBelt=Texture'Botpack.Icons.BossBelt'
      VoicePackMetaClass="BotPack.VoiceBoss"
      SelectionMesh="Botpack.SelectionBoss"
      HitSound1=Sound'Botpack.Boss.BInjur1'
      HitSound2=Sound'Botpack.Boss.BInjur2'
      Die=Sound'Botpack.Boss.BDeath1'
      MenuName="Boss"
      VoiceType="BotPack.VoiceBotBoss"
      Mesh=LodMesh'Botpack.Boss'
}
