//=============================================================================
// FortStandard.
//=============================================================================
class FortStandard extends StationaryPawn;

#exec AUDIO IMPORT FILE="Sounds\Domination\teleprt28.WAV" NAME="ControlSound" GROUP="Domination"
#exec AUDIO IMPORT FILE="Sounds\Domination\uLNitro1.WAV" NAME="WarningSound" GROUP="Domination"

var() bool bSelfDisplayed;
var() bool bTriggerOnly;
var() bool bFlashing;
var() bool bSayDestroyed;
var() bool bForceRadius;
var() bool bFinalFort;

var() byte DefensePriority;
var() int DefenseTime;		// how long defenders must defend base (in minutes)
var Pawn Defender;
var float LastHelpMessage;
var() name NearestPathNodeTag;
var() name	FallBackFort;		// Fort to fallback to if this one is destroyed;
var() float ChargeDist;
var NavigationPoint NearestPath;
var() name EndCamTag;
var() localized string FortName;
var() localized string DestroyedMessage;
 
var() name DamageEvent[8];
var() float DamageEventThreshold[8];
var	  int DamagePointer;
var	  float TotalDamage;

function PostBeginPlay()
{
	local NavigationPoint N;

	if ( !Level.Game.IsA('Assault') )
	{
		Destroy();
		return;
	}

	if ( bTriggerOnly )
		bProjTarget = false;

	if ( NearestPathNodeTag != '' )
		for ( N=Level.NavigationPointList; N!=None; N=N.NextNavigationPoint )
			if ( N.Tag == NearestPathNodeTag )
			{
				NearestPath = N;
				break;
			}

	Super.PostBeginPlay();
	if (!bSelfDisplayed )
		DrawType = DT_None;
	LoopAnim('Wave', 0.5);
}

function String GetHumanName()
{
	return FortName;
}

function Destroyed()
{
	Super.Destroyed();
	if ( Level.Game.IsA('Assault') )
		Assault(Level.Game).RemoveFort(self, instigator);
}

function Touch( Actor Other )
{
	if ( bTriggerOnly && Other.bIsPawn && Pawn(Other).bIsPlayer 
		&& (Pawn(Other).PlayerReplicationInfo.Team != Assault(Level.Game).Defender.TeamIndex) )
		DestroyFort(Pawn(Other));
}

function Trigger( actor Other, pawn EventInstigator )
{
	if ( EventInstigator.bIsPlayer 
		&& (EventInstigator.PlayerReplicationInfo.Team != Assault(Level.Game).Defender.TeamIndex) )
		DestroyFort(EventInstigator);
}

function DestroyFort(pawn InstigatedBy)
{
	local Actor A;

	SetTimer(0.0, false);
	Health = Default.Health;
	AmbientSound = None;
	if ( FallBackFort != '' )
		Assault(Level.Game).FallBackTo(FallBackFort, DefensePriority);
		
	if ( Event != '' )
		ForEach AllActors(class'Actor', A, Event)
			A.Trigger( self, instigatedBy );
	instigator = instigatedBy;
	Destroy();
}

function TakeDamage( int Damage, Pawn instigatedBy, Vector hitlocation, 
						Vector momentum, name damageType)
{
	local Pawn P;
	local Actor A;

	if ( bTriggerOnly || (instigatedBy == None)
		 || (instigatedBy.bIsPlayer && (instigatedBy.PlayerReplicationInfo.Team == Assault(Level.Game).Defender.TeamIndex)) )
		return;
	Health -= Damage;
	if ( (Defender != None) && (Defender.Health > 0)
		&& (Level.TimeSeconds - LastHelpMessage > 15)
		&& (VSize(Location - Defender.Location) < 1000)
		&& Defender.LineOfSightTo(self) )
	{
		if ( Defender.IsA('Bot') )
			Bot(Defender).SendTeamMessage(None, 'OTHER', 13, 15);
		LastHelpMessage = Level.TimeSeconds;
	}
	if ( Health < 0 )
		DestroyFort(instigatedBy);
	else
	{	
		TotalDamage += Damage;
		if ( (DamageEvent[DamagePointer] != '') && (TotalDamage >= DamageEventThreshold[DamagePointer]) )
		{
			ForEach AllActors(class'Actor', A, DamageEvent[DamagePointer] )
				A.Trigger(self, instigatedBy);
			DamagePointer++;
		}	
		AmbientSound = sound'WarningSound'; 
		if ( bFlashing && ((TimerRate == 0) || (TimerRate - TimerCounter > 0.01 * Health)) )
			SetTimer(FClamp(0.006 * Health,0.2,1.5), true);
	}
}

function Timer()
{
	if ( !bFlashing || (LightType == LT_Steady) )
		LightType = LT_None;
	else
	{
		LightType = LT_Steady;
		PlaySound(sound'ControlSound');
	}
}

defaultproperties
{
      bSelfDisplayed=True
      bTriggerOnly=False
      bFlashing=True
      bSayDestroyed=True
      bForceRadius=False
      bFinalFort=False
      DefensePriority=0
      DefenseTime=10
      Defender=None
      LastHelpMessage=0.000000
      NearestPathNodeTag="None"
      FallBackFort="None"
      ChargeDist=1000.000000
      NearestPath=None
      EndCamTag="None"
      FortName="Assault Target"
      DestroyedMessage="was destroyed!"
      DamageEvent(0)="None"
      DamageEvent(1)="None"
      DamageEvent(2)="None"
      DamageEvent(3)="None"
      DamageEvent(4)="None"
      DamageEvent(5)="None"
      DamageEvent(6)="None"
      DamageEvent(7)="None"
      DamageEventThreshold(0)=0.000000
      DamageEventThreshold(1)=0.000000
      DamageEventThreshold(2)=0.000000
      DamageEventThreshold(3)=0.000000
      DamageEventThreshold(4)=0.000000
      DamageEventThreshold(5)=0.000000
      DamageEventThreshold(6)=0.000000
      DamageEventThreshold(7)=0.000000
      DamagePointer=0
      TotalDamage=0.000000
      Health=100
      bAlwaysRelevant=True
      Skin=Texture'UnrealI.Skins.JFlag11'
      Mesh=LodMesh'UnrealI.Flag1M'
      bUnlit=True
      SoundRadius=255
      SoundVolume=255
      bBlockActors=False
      bBlockPlayers=False
      LightEffect=LE_NonIncidence
      LightBrightness=255
      LightHue=170
      LightSaturation=96
      LightRadius=12
}
