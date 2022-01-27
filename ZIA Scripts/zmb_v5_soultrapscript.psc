Scriptname ZMB_V5_SoulTrapScript extends activemagiceffect  

Actor TargetActor
Actor CasterActor

Keyword Property ActorTypeNPC Auto
Sound Property MAGMysticismSoulTrapCapture Auto
ImageSpaceModifier Property SoulTrapTakingImod Auto
EffectShader Property SoulTrapCastActFXS Auto
EffectShader Property SoulTrapTargetActFXS Auto
VisualEffect Property SoulTrapPVFX01 Auto
VisualEffect Property SoulTrapPVFX02 Auto
Weapon Property DA10MaceofMolagBal Auto

Event OnEffectStart(Actor akTarget, Actor akCaster)
	TargetActor = akTarget
	CasterActor = akCaster
EndEvent

Event OnDying(Actor akKiller)
	MAGMysticismSoulTrapCapture.Play(CasterActor)
	SoulTrapTakingImod.Apply()
	SoulTrapPVFX01.Play(TargetActor,4.7,CasterActor)
	SoulTrapPVFX02 .Play(CasterActor,5.9,TargetActor)
	SoulTrapTargetActFXS.Play(TargetActor,2)
	SoulTrapCastActFXS.Play(CasterActor,3)
	IF CasterActor.TrapSoul(TargetActor) == False
		Float ChargeAmount
			If (TargetActor.HasKeyword(ActorTypeNPC)) || (TargetActor.GetLevel() >= 38)	;NPCs and creatures at least level 38 have grand souls
				ChargeAmount = 3000
			ElseIf (TargetActor.GetLevel() >= 28)	;Creatures at least level 28 have greater souls
				ChargeAmount = 2000
			ElseIf (TargetActor.GetLevel() >= 16)	;Creatures at least level 16 have common souls
				ChargeAmount = 1000
			ElseIf (TargetActor.GetLevel() >= 4)		;Creatures at least level 4 have lesser souls
				ChargeAmount = 500
			Else
				ChargeAmount = 250
			EndIf
		If CasterActor.GetEquippedWeapon(False) == DA10MaceofMolagBal
			Float RightChargeAmount = CalculateChargeAmount("RightItemCharge", ChargeAmount)
			CasterActor.ModActorValue("RightItemCharge", RightChargeAmount)
		ElseIf CasterActor.GetEquippedWeapon(True) == DA10MaceofMolagBal
			Float LeftChargeAmount = CalculateChargeAmount("LeftItemCharge", ChargeAmount)
			CasterActor.ModActorValue("LeftItemCharge", LeftChargeAmount)
		EndIf
	ENDIF
EndEvent

Float Function CalculateChargeAmount(String ItemCharge, Float ChargeAmount)
Float Difference = (5000 - (CasterActor.GetActorValue(ItemCharge)))
	If Difference <= ChargeAmount
		Return Difference
	Else
		Return ChargeAmount
	EndIf
EndFunction
