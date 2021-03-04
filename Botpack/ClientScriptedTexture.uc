class ClientScriptedTexture expands Info;

var() Texture ScriptedTexture;

simulated function BeginPlay()
{
	if(ScriptedTexture != None)
		ScriptedTexture(ScriptedTexture).NotifyActor = Self;
}

simulated function Destroyed()
{
	if(ScriptedTexture != None)
		ScriptedTexture(ScriptedTexture).NotifyActor = None;
}

simulated event RenderTexture(ScriptedTexture Tex)
{
}

defaultproperties
{
      ScriptedTexture=None
      bNoDelete=True
      bAlwaysRelevant=True
      RemoteRole=ROLE_SimulatedProxy
}
