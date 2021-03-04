class UWindowHTMLTextRow expands UWindowDynamicTextRow;

var HTMLStyle StartStyle; // style at start of line
var HTMLStyle EndStyle;	  // style at end of line

var string DisplayString;
var string StyleString;

defaultproperties
{
      StartStyle=(BulletLevel=0,LinkDestination="",TextColor=(R=0,G=0,B=0,A=0),BGColor=(R=0,G=0,B=0,A=0),bCenter=False,bLink=False,bUnderline=False,bNoBR=False,bHeading=False,bBold=False,bBlink=False)
      EndStyle=(BulletLevel=0,LinkDestination="",TextColor=(R=0,G=0,B=0,A=0),BGColor=(R=0,G=0,B=0,A=0),bCenter=False,bLink=False,bUnderline=False,bNoBR=False,bHeading=False,bBold=False,bBlink=False)
      DisplayString=""
      StyleString=""
}
