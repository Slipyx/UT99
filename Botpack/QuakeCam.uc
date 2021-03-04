//=============================================================================
// QuakeCam.
//=============================================================================
class QuakeCam extends SpectatorCam;

var() float magnitude;

function BecomeViewTarget()
{
	SetTimer(0.5, false);
}

function Timer()
{
	local Pawn P;
	local PlayerPawn V;
	local bool bFound;

	for ( P=Level.PawnList; P!=None; P=P.NextPawn )
	{
		V = PlayerPawn(P);
		if ( (V != None) && (V.Viewtarget == self) )
		{
			bFound = true;
			V.BaseEyeHeight = FMin(V.Default.BaseEyeHeight, V.BaseEyeHeight * (0.5 + FRand()));
			V.ShakeView(1, magnitude, 0.015 * magnitude);
		}
	}

	if ( bFound )
		SetTimer(0.5, false);
}

defaultproperties
{
      magnitude=2000.000000
      bStatic=False
}
