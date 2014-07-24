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
}
