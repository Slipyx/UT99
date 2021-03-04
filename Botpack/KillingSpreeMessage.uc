//
// Switch is the note.
// RelatedPRI_1 is the player on the spree.
//
class KillingSpreeMessage expands CriticalEventLowPlus;

var(Messages)	localized string EndSpreeNote, EndSelfSpree, EndFemaleSpree, MultiKillString;
var(Messages)	localized string SpreeNote[10];
var(Messages)	sound SpreeSound[10];
var(Messages)	localized string EndSpreeNoteTrailer;
 
static function string GetString(
	optional int Switch,
	optional PlayerReplicationInfo RelatedPRI_1, 
	optional PlayerReplicationInfo RelatedPRI_2,
	optional Object OptionalObject
	)
{
	if (RelatedPRI_2 == None)
	{
		if (RelatedPRI_1 == None)
			return "";

		if (RelatedPRI_1.PlayerName != "")
			return RelatedPRI_1.PlayerName@Default.SpreeNote[Switch];
	} 
	else 
	{
		if (RelatedPRI_1 == None)
		{
			if (RelatedPRI_2.PlayerName != "")
			{
				if ( RelatedPRI_2.bIsFemale )
					return RelatedPRI_2.PlayerName@Default.EndFemaleSpree;
				else
					return RelatedPRI_2.PlayerName@Default.EndSelfSpree;
			}
		} 
		else 
		{
			return RelatedPRI_1.PlayerName$Default.EndSpreeNote@RelatedPRI_2.PlayerName@Default.EndSpreeNoteTrailer;
		}
	}
	return "";
}

static simulated function ClientReceive( 
	PlayerPawn P,
	optional int Switch,
	optional PlayerReplicationInfo RelatedPRI_1, 
	optional PlayerReplicationInfo RelatedPRI_2,
	optional Object OptionalObject
	)
{
	Super.ClientReceive(P, Switch, RelatedPRI_1, RelatedPRI_2, OptionalObject);

	if (RelatedPRI_2 != None)
		return;

	if (RelatedPRI_1 != P.PlayerReplicationInfo)
	{
		P.PlaySound(sound'SpreeSound',, 4.0);
		return;
	}
	P.ClientPlaySound(Default.SpreeSound[Switch],, true);

}

defaultproperties
{
      EndSpreeNote="'s killing spree was ended by"
      EndSelfSpree="was looking good till he killed himself!"
      EndFemaleSpree="was looking good till she killed herself!"
      MultiKillString=""
      spreenote(0)="is on a killing spree!"
      spreenote(1)="is on a rampage!"
      spreenote(2)="is dominating!"
      spreenote(3)="is unstoppable!"
      spreenote(4)="is Godlike!"
      spreenote(5)=""
      spreenote(6)=""
      spreenote(7)=""
      spreenote(8)=""
      spreenote(9)=""
      SpreeSound(0)=Sound'Announcer.(All).killingspree'
      SpreeSound(1)=Sound'Announcer.(All).rampage'
      SpreeSound(2)=Sound'Announcer.(All).dominating'
      SpreeSound(3)=Sound'Announcer.(All).unstoppable'
      SpreeSound(4)=Sound'Announcer.(All).godlike'
      SpreeSound(5)=None
      SpreeSound(6)=None
      SpreeSound(7)=None
      SpreeSound(8)=None
      SpreeSound(9)=None
      EndSpreeNoteTrailer=""
      bBeep=False
}
