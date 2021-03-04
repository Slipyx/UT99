class UTExtraKeyBindings expands Object;

/*
How to use this,

1) subclass UTExtraKeyBindings.
2) put the name of your mod in the SectionName variable
3) put the descriptions of the actions in the LabelList array.
4) put the exec functions to be bound in the AliasNames array.
5) make a PackageName.ini file with the following data in it:

[Public]
Object=(Name=MyPackage.MyKeyBindingsClass,Class=Class,MetaClass=UTMenu.UTExtraKeyBindings)
*/

var string SectionName;
var string LabelList[30];
var string AliasNames[30];

//example:

//defaultproperties
//{
//    SectionName="Capture the Mage"
//	LabelList(0)="Cast Spell"
//	LabelList(1)="Activate Shield"
//  AliasNames(0)="castspell"
//	AliasNames(1)="activateshield"
//}

defaultproperties
{
      SectionName=""
      LabelList(0)=""
      LabelList(1)=""
      LabelList(2)=""
      LabelList(3)=""
      LabelList(4)=""
      LabelList(5)=""
      LabelList(6)=""
      LabelList(7)=""
      LabelList(8)=""
      LabelList(9)=""
      LabelList(10)=""
      LabelList(11)=""
      LabelList(12)=""
      LabelList(13)=""
      LabelList(14)=""
      LabelList(15)=""
      LabelList(16)=""
      LabelList(17)=""
      LabelList(18)=""
      LabelList(19)=""
      LabelList(20)=""
      LabelList(21)=""
      LabelList(22)=""
      LabelList(23)=""
      LabelList(24)=""
      LabelList(25)=""
      LabelList(26)=""
      LabelList(27)=""
      LabelList(28)=""
      LabelList(29)=""
      AliasNames(0)=""
      AliasNames(1)=""
      AliasNames(2)=""
      AliasNames(3)=""
      AliasNames(4)=""
      AliasNames(5)=""
      AliasNames(6)=""
      AliasNames(7)=""
      AliasNames(8)=""
      AliasNames(9)=""
      AliasNames(10)=""
      AliasNames(11)=""
      AliasNames(12)=""
      AliasNames(13)=""
      AliasNames(14)=""
      AliasNames(15)=""
      AliasNames(16)=""
      AliasNames(17)=""
      AliasNames(18)=""
      AliasNames(19)=""
      AliasNames(20)=""
      AliasNames(21)=""
      AliasNames(22)=""
      AliasNames(23)=""
      AliasNames(24)=""
      AliasNames(25)=""
      AliasNames(26)=""
      AliasNames(27)=""
      AliasNames(28)=""
      AliasNames(29)=""
}
