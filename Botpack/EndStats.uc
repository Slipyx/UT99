class EndStats expands Info
	config(user);

var globalconfig int TotalGames;
var globalconfig int TotalFrags;
var globalconfig int TotalDeaths;
var globalconfig int TotalFlags;

var globalconfig string BestPlayers[3];
var globalconfig int BestFPHs[3];
var globalconfig string BestRecordDate[3];

defaultproperties
{
     TotalGames=10
     TotalFrags=49
     TotalDeaths=49
     BestPlayers(0)="Visse"
     BestPlayers(1)="Tamerlane"
     BestPlayers(2)="Loque"
     BestFPHs(0)=376
     BestFPHs(1)=423
     BestFPHs(2)=706
     BestRecordDate(0)="05/31/2014 20:04:31"
     BestRecordDate(1)="05/31/2014 20:04:31"
     BestRecordDate(2)="05/31/2014 20:04:31"
}
