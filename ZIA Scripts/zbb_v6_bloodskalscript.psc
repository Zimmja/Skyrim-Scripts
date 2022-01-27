Scriptname ZBB_V6_BloodskalScript extends activemagiceffect  

Int Cost = 27
Quest Property DLC2RR03 Auto
Spell Property LaunchSpell Auto
Spell Property ZBB_BloodskalSpell_DamageChargeSpell Auto

Event OnEffectStart(Actor akTarget, Actor akCaster)
IF PlayerHasCharge(akCaster)
	LaunchSpell.Cast(akTarget)
	If !FreeBlasts()
		ZBB_BloodskalSpell_DamageChargeSpell.Cast(akCaster)
	EndIf
ENDIF
EndEvent

Bool Function PlayerHasCharge(Actor akCaster)
	return (akCaster == Game.GetPlayer()) && ((akCaster.GetActorValue("RightItemCharge") >= Cost) || FreeBlasts())
EndFunction

Bool Function FreeBlasts()
	return DLC2RR03.GetStage() > 20 && DLC2RR03.GetStage() < 50
EndFunction