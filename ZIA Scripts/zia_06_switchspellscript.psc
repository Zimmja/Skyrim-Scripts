Scriptname ZIA_06_SwitchSpellScript extends activemagiceffect  

ReferenceAlias Property SwitchAlias Auto

Event OnEffectStart(Actor akTarget, Actor akCaster)
	(SwitchAlias as ZIA_06_SwitchScript).BeginSwitch()
EndEvent