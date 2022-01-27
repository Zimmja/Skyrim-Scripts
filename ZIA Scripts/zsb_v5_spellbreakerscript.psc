Scriptname ZSB_V5_SpellbreakerScript extends activemagiceffect  

Keyword Property ZSB_SpellbreakerKeyword Auto 
Spell Property ZSB_Spellbreaker_WardAb Auto
Actor OwnerActor

Event OnEffectStart(Actor akTarget, Actor akCaster)
	RegisterForAnimationEvent(akTarget, "blockStartOut")
	RegisterForAnimationEvent(akTarget, "blockStop")
	OwnerActor = akTarget
EndEvent

Event OnAnimationEvent(ObjectReference akSource, string EventName)
	If (akSource == (OwnerActor as ObjectReference)) && (OwnerActor.WornHasKeyword(ZSB_SpellbreakerKeyword))
		if eventName == "blockStartOut"
			OwnerActor.AddSpell(ZSB_Spellbreaker_WardAb, False)
		elseif eventName == "blockStop"
			OwnerActor.RemoveSpell(ZSB_Spellbreaker_WardAb)
		endif
	Endif
EndEvent

Event OnEffectFinish(Actor akTarget, Actor akCaster)
	OwnerActor.RemoveSpell(ZSB_Spellbreaker_WardAb)
	UnRegisterForAnimationEvent(akTarget, "blockStartOut")
	UnRegisterForAnimationEvent(akTarget, "blockStop")
EndEvent