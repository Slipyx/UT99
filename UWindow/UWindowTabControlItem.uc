class UWindowTabControlItem extends UWindowList;

var string					Caption;
var string					HelpText;

var UWindowTabControl		Owner;
var float					TabTop;
var float					TabLeft;
var float					TabWidth;
var float					TabHeight;

var int						RowNumber;
var bool					bFlash;

function SetCaption(string NewCaption)
{
	Caption=NewCaption;
}

function RightClickTab()
{
}

defaultproperties
{
      Caption=""
      HelpText=""
      Owner=None
      TabTop=0.000000
      TabLeft=0.000000
      TabWidth=0.000000
      TabHeight=0.000000
      RowNumber=0
      bFlash=False
}
