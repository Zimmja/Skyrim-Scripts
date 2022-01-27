Scriptname ZSM_V5_MagnusScript extends activemagiceffect  

Race Property MagicAnomalyRace Auto

Event OnEffectStart(Actor akTarget, Actor akCaster)
	If akTarget.GetRace() == MagicAnomalyRace
		akTarget.DamageActorValue("Health", akTarget.GetActorValue("Health")+10)
	Endif
EndEvent