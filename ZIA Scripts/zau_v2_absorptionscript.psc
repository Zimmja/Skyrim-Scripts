Scriptname ZAU_V2_AbsorptionScript extends activemagiceffect

Actor TargetRef
Actor CasterRef

;-------------------------------------------------------------------------------------------------
; START
;-------------------------------------------------------------------------------------------------

Event OnEffectStart(actor akTarget, actor akCaster)
	SetEffectRefs(akTarget, akCaster)
	RegisterForShieldAnimations()
	SetAnimation(False)
EndEvent

Function SetEffectRefs(actor akTarget, actor akCaster)
	TargetRef = akTarget
	CasterRef = akCaster
EndFunction

Function RegisterForShieldAnimations()
	If (CasterRef == Game.GetPlayer())
		RegisterForAnimationEvent(CasterRef, "bashRelease")
	Else
		RegisterForAnimationEvent(CasterRef, "bashExit")
		RegisterForAnimationEvent(CasterRef, "bashStop")
	EndIf
EndFunction

;-------------------------------------------------------------------------------------------------
; RECEIVING HITS
;-------------------------------------------------------------------------------------------------

GlobalVariable Property DLC1ReflectingShieldTimesHitGlobal Auto
GlobalVariable Property DLC1ReflectingShieldCurrentStageGlobal Auto
Sound Property MagWardTestAbsorb Auto

Event OnHit(ObjectReference akAggressor, Form akSource, Projectile akProjectile, bool abPowerAttack, bool abSneakAttack, bool abBashAttack, bool abHitBlocked)
   	If abHitBlocked
		ChargeUnlessMaxed(DLC1ReflectingShieldTimesHitGlobal.GetValueInt())
   	EndIf
EndEvent

Function ChargeUnlessMaxed(Int TotalHits)
	If TotalHits < 15
		DLC1ReflectingShieldTimesHitGlobal.SetValue(TotalHits + 1)
		MagWardTestAbsorb.play(CasterRef)
		SetChargeStage()
	EndIf
EndFunction

Function SetChargeStage()
	SetChargeIfTargetReached(5, 1)
	SetChargeIfTargetReached(10, 2)
	SetChargeIfTargetReached(15, 3)
EndFunction

Function SetChargeIfTargetReached(Int TargetHits, Int SetCharge)
	If (DLC1ReflectingShieldTimesHitGlobal.GetValue() == TargetHits)
		DLC1ReflectingShieldCurrentStageGlobal.SetValue(SetCharge)
	EndIf
	TurnOnAnimationIfHitsReached(TargetHits)
EndFunction

Function TurnOnAnimationIfHitsReached(Int ChargeTarget)
	If DLC1ReflectingShieldTimesHitGlobal.GetValue() == ChargeTarget
		SetAnimation(True)
	EndIf
EndFunction

;-------------------------------------------------------------------------------------------------
; SHIELD ANIMATION
;-------------------------------------------------------------------------------------------------

ImagespaceModifier Property DLC1ReflectingShieldChargeImod Auto
ImagespaceModifier Property DLC1ReflectingShieldBlastImod Auto

Function SetAnimation(Bool ApplyImod)
	ApplyPlayerImod(ApplyImod)
	AnimateByStage(1, 0.75)
	AnimateByStage(2, 0.85)
	AnimateByStage(3, 1)
EndFunction

Function ApplyPlayerImod(Bool ApplyImod)
	If (CasterRef == Game.GetPlayer()) && (ApplyImod == True)
		DLC1ReflectingShieldChargeImod.Apply()
	EndIf
EndFunction

Function AnimateByStage(Int CurrentStage, Float BlendFloat)
	If CurrentStage == DLC1ReflectingShieldCurrentStageGlobal.GetValue()
		CasterRef.SetSubGraphFloatVariable("fDampRate", 1)
		CasterRef.SetSubGraphFloatVariable("fToggleBlend", BlendFloat)
	EndIf
EndFunction

;-------------------------------------------------------------------------------------------------
; BLAST
;-------------------------------------------------------------------------------------------------

Sound Property ZAU_ShieldBlast01 Auto
Sound Property ZAU_ShieldBlast02 Auto
Sound Property ZAU_ShieldBlast03 Auto
Spell Property ZAU_V2_Spell01 Auto
Spell Property ZAU_V2_Spell02 Auto
Spell Property ZAU_V2_Spell03 Auto

Event OnAnimationEvent(ObjectReference akSource, string EventName)
	If (CasterRef == Game.GetPlayer()) && (EventName == "bashRelease") ; Player animations
		AttemptBlast(0.3, 0.6, 1)
	Elseif (EventName == "bashExit") || (EventName == "bashStop") ; NPC animations
		AttemptBlast(0, 0, 0)
	EndIf
EndEvent

Function AttemptBlast(Float ImodSmDur, Float ImodMdDur, Float ImodLgDur)
	Blast(1, ImodSmDur, ZAU_ShieldBlast01, ZAU_V2_Spell01)
	Blast(2, ImodMdDur, ZAU_ShieldBlast02, ZAU_V2_Spell02)
	Blast(3, ImodLgDur, ZAU_ShieldBlast03, ZAU_V2_Spell03)
	TurnOffAnimations()
EndFunction

Function Blast(Int StageCheck, Float ImodDuration, Sound BlastSound, Spell BlastSpell)
	If DLC1ReflectingShieldCurrentStageGlobal.GetValue() == StageCheck
		If ImodDuration > 0
			DLC1ReflectingShieldBlastImod.Apply(ImodDuration)
		EndIf
		BlastSound.Play(CasterRef)
		BlastSpell.Cast(CasterRef)
	EndIf
EndFunction

Function TurnOffAnimations()
	CasterRef.SetSubGraphFloatVariable("fToggleBlend", 0)
	DLC1ReflectingShieldCurrentStageGlobal.SetValue(0)
	DLC1ReflectingShieldTimesHitGlobal.SetValue(0)
EndFunction

;-------------------------------------------------------------------------------------------------
; FINISH
;-------------------------------------------------------------------------------------------------

Event OnEffectFinish(Actor akTarget, Actor akCaster)	
	UnregisterForAnimationEvent(CasterRef, "bashRelease")
	UnregisterForAnimationEvent(CasterRef, "bashExit")
	UnregisterForAnimationEvent(CasterRef, "bashStop")
EndEvent