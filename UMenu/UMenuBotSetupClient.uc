class UMenuBotSetupClient extends UMenuBotSetupBase;

var BotInfo BotInfo;

function LoadBots()
{
	local class<BotInfo> C;
	local int i;
	local int NumBots;

	C = class<BotInfo>(DynamicLoadObject("UnrealI.BotInfo", class'Class'));
	BotInfo = GetEntryLevel().Spawn(C);

	NumBots = Int(UMenuBotConfigBase(OwnerWindow).NumBotsEdit.GetValue());

	// Add the bots into the combo
	for(i=0;i<NumBots;i++)
		BotCombo.AddItem(BotWord@string(i+1), String(i));	
}

function ResetBots()
{
	local Class<BotInfo> C;
	
	C = BotInfo.Class;
	BotInfo.Destroy();

	C.ResetConfig();
	BotInfo = GetEntryLevel().Spawn(C);

	Initialized = False;
	ConfigureBot = 0;
	BotCombo.SetSelectedIndex(0);
	LoadCurrent();
	UseSelected();
	Initialized = True;
}

function LoadClasses()
{
	local int i;
	local int SortWeight;

	for(i=0;i<BotInfo.NumClasses;i++)
		ClassCombo.AddItem(BotInfo.AvailableDescriptions[i], BotInfo.AvailableClasses[i], SortWeight);
}

function Close(optional bool bByParent)
{
	Super.Close(bByParent);
	BotInfo.SaveConfig();
	BotInfo.Destroy();
	BotInfo = None;
}

function LoadCurrent()
{
	local int i;

	NameEdit.SetValue(BotInfo.GetBotName(ConfigureBot));
	i = TeamCombo.FindItemIndex2(string(BotInfo.BotTeams[ConfigureBot]));
	if(i == -1)
		i = 255;
	TeamCombo.SetSelectedIndex(i);
	ClassCombo.SetSelectedIndex(Max(ClassCombo.FindItemIndex2(BotInfo.GetBotClassName(ConfigureBot), True), 0));
	SkinCombo.SetSelectedIndex(Max(SkinCombo.FindItemIndex2(BotInfo.GetBotSkin(ConfigureBot), True), 0));
	FaceCombo.SetSelectedIndex(0);
}

function NameChanged()
{
	if (Initialized)
	{
		BotInfo.SetBotName(NameEdit.GetValue(), ConfigureBot);
	}
}

function UseSelected()
{
	if (Initialized)
	{
		// store the stuff in the required botinfo
		BotInfo.SetBotClass(ClassCombo.GetValue2(), ConfigureBot);
		BotInfo.SetBotSkin(SkinCombo.GetValue2(), ConfigureBot);
		BotInfo.SetBotTeam(Int(TeamCombo.GetValue2()), ConfigureBot);
	}

	// setup the mesh window appropriately
	MeshWindow.SetMeshString(NewPlayerClass.Default.SelectionMesh);
	MeshWindow.ClearSkins();
	NewPlayerClass.static.SetMultiSkin(MeshWindow.MeshActor, SkinCombo.GetValue2(), FaceCombo.GetValue2(), Int(TeamCombo.GetValue2()));
}

function SaveConfigs()
{
	Super.SaveConfigs();
	if(BotInfo != None)
		BotInfo.SaveConfig();
}

defaultproperties
{
}
