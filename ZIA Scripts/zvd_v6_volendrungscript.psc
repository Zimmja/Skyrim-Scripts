Scriptname ZVD_V6_VolendrungScript extends activemagiceffect  

String Property EffectArchetype Auto ; Paralysis, Charge
Spell Property DA06VolendrungPerkSpell_ChargeCostRight Auto
Spell Property DA06VolendrungPerkSpell_ChargeCostLeft Auto
Spell Property DA06VolendrungPerkSpell Auto
Weapon Property DA06Volendrung Auto
Weapon Property ZVD_Volendrung1H Auto

Spell ChargeSpell
Float WeapCharge

Event OnEffectStart(Actor akTarget, Actor akCaster)
	If (akCaster.GetEquippedWeapon(True) == ZVD_Volendrung1H)
		ChargeSpell = DA06VolendrungPerkSpell_ChargeCostLeft
		WeapCharge = akCaster.GetActorValue("LeftItemCharge")
	Else
		ChargeSpell = DA06VolendrungPerkSpell_ChargeCostRight
		WeapCharge = akCaster.GetActorValue("RightItemCharge")
	EndIf

	If (EffectArchetype == "Paralysis") && (WeapCharge >= 500)
		akCaster.DoCombatSpellApply(DA06VolendrungPerkSpell, akTarget)
	ElseIf EffectArchetype == "Charge"
		akCaster.DoCombatSpellApply(ChargeSpell, akCaster)
		akCaster.PushActorAway(akTarget, 8)
	EndIf
EndEvent