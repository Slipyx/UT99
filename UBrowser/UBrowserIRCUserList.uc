class UBrowserIRCUserList expands UWindowListBoxItem;

var string NickName;
var bool bChOp;
var bool bVoice;
var bool bHalfOp; //utpg: halfop support

function int Compare(UWindowList T, UWindowList B)
{
	local UBrowserIRCUserList UT, UB;

	UT = UBrowserIRCUserList(T);
	UB = UBrowserIRCUserList(B);

	if(UT.bChOp && !UB.bChOp)
		return -1;

	if(!UT.bChOp && UB.bChOp)
		return 1;

  //utpg: halfop support
  if(UT.bHalfOp && !UB.bHalfOp)
		return -1;

	if(!UT.bHalfOp && UB.bHalfOp)
		return 1;
  //utpg: halfop support -- end

	if(UT.bVoice && !UB.bVoice)
		return -1;

	if(!UT.bVoice && UB.bVoice)
		return 1;

	if(Caps(UT.NickName) < Caps(UB.NickName))
		return -1;

	return 1;
}

defaultproperties
{
      NickName=""
      bChOp=False
      bVoice=False
      bHalfOp=False
}
