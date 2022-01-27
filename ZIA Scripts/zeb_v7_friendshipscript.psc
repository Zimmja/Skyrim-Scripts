Scriptname ZEB_V7_FriendshipScript extends activemagiceffect

Int StartingRank

Event OnEffectStart(Actor akTarget, Actor akCaster)
	StartingRank = akTarget.GetRelationshipRank(akCaster) 
	akTarget.SetRelationshipRank(akCaster, 1)
EndEvent

Event OnEffectFinish(Actor akTarget, Actor akCaster)
	;akTarget.SetRelationshipRank(akCaster, StartingRank)
EndEvent