class TriggeredTexture extends Triggers;

var() Texture	DestinationTexture;
var() Texture	Textures[10];
var() bool		bTriggerOnceOnly;

var int CurrentTexture;

replication
{
	reliable if( Role==ROLE_Authority )
		CurrentTexture;
}

simulated event PostBeginPlay()
{
	Super.PostBeginPlay();
	CurrentTexture = 0;

	if( ScriptedTexture(DestinationTexture) != None )
		ScriptedTexture(DestinationTexture).NotifyActor = Self;
}

simulated event Destroyed()
{
	if( ScriptedTexture(DestinationTexture) != None && ScriptedTexture(DestinationTexture).NotifyActor == Self)
		ScriptedTexture(DestinationTexture).NotifyActor = None;
	
	Super.Destroyed();
}

event Trigger( Actor Other, Pawn EventInstigator )
{
	if( bTriggerOnceOnly && (Textures[CurrentTexture + 1] == None || CurrentTexture == 9) )
		return;

	CurrentTexture++;
	if( Textures[CurrentTexture] == None || CurrentTexture == 10 )
		CurrentTexture = 0;
}

simulated event RenderTexture( ScriptedTexture Tex )
{
	Tex.DrawTile( 0, 0, Tex.USize, Tex.VSize, 0, 0, Textures[CurrentTexture].USize, Textures[CurrentTexture].VSize, Textures[CurrentTexture], False );
}

defaultproperties
{
      DestinationTexture=None
      Textures(0)=None
      Textures(1)=None
      Textures(2)=None
      Textures(3)=None
      Textures(4)=None
      Textures(5)=None
      Textures(6)=None
      Textures(7)=None
      Textures(8)=None
      Textures(9)=None
      bTriggerOnceOnly=False
      CurrentTexture=0
      bNoDelete=True
      bAlwaysRelevant=True
      RemoteRole=ROLE_SimulatedProxy
}
