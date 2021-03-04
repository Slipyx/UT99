//=============================================================================
// RenderIterator.
//
// Created by Mark Poesch
//=============================================================================

class RenderIterator expands Object
	native
	noexport;

struct ActorBuffer
{
	var byte Padding[520];
};

struct ActorNode
{
	var ActorBuffer ActorProxy;
	var Actor NextNode;
};

var()			int			MaxItems;
var				int			Index;
var transient	PlayerPawn	Observer;
var transient	Actor		Frame;	// just a generic pointer used for binary compatibility only (FSceneNode*).

defaultproperties
{
      MaxItems=1
      Index=0
}
