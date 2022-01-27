Scriptname ZTH_V7_EnchScript extends activemagiceffect  

String Property EffectArchetype Auto ; Falkreath, Rift, Reach, ReachCaster

; Falkreath
Spell Property ZTh_03_Falkreath01_StaggerKnock Auto
Spell Property ZTh_03_Falkreath01_StaggerMajor Auto
Spell Property ZTh_03_Falkreath01_StaggerMinor Auto

;Rift
Spell Property ZTh_09_Rift02_InvisSpell Auto

; Reach and ReachCaster
Spell Property ZTh_05_TheReach02_V7_Spell01 Auto
Spell Property ZTh_05_TheReach02_V7_Spell02 Auto
Spell Property ZTh_05_TheReach02_V7_Spell03 Auto
Actor CasterActor
Actor TargetActor

Event OnEffectStart(Actor akTarget, Actor akCaster)
	CasterActor = akCaster
	TargetActor = akTarget
	If EffectArchetype == "Falkreath"
		FalkreathStart()
	ElseIf EffectArchetype == "Reach"
		ReachStart()
	EndIf
EndEvent

Event OnDying(Actor akKiller)
	If CasterActor == akKiller && EffectArchetype == "Rift"
		CasterActor.DoCombatSpellApply(ZTh_09_Rift02_InvisSpell, CasterActor)
	EndIf
EndEvent

Event OnObjectEquipped(Form akBaseObject, ObjectReference akReference)
	If (EffectArchetype == "ReachCaster")
		ReachFinish()
	EndIf
endEvent

Event OnObjectUnEquipped(Form akBaseObject, ObjectReference akReference)
	If (EffectArchetype == "ReachCaster")
		ReachFinish()
	EndIf
endEvent

Event OnEffectFinish(Actor akTarget, Actor akCaster)
	If EffectArchetype == "Reach"
		ReachFinish()
	EndIf
EndEvent

Function FalkreathStart()
	If (TargetActor.GetDistance(CasterActor) > 2100)
		MomentumHit(Utility.RandomInt(1,100), ZTh_03_Falkreath01_StaggerKnock, ZTh_03_Falkreath01_StaggerMajor, 10, CasterActor, TargetActor)
	ElseIf (TargetActor.GetDistance(CasterActor) <= 2100) && (TargetActor.GetDistance(CasterActor) > 900)
		MomentumHit(Utility.RandomInt(1,100), ZTh_03_Falkreath01_StaggerMajor, None, 5, CasterActor, TargetActor)
	ElseIf (TargetActor.GetDistance(CasterActor) <= 900) && (TargetActor.GetDistance(CasterActor) > 300)
		MomentumHit(Utility.RandomInt(1,100), ZTh_03_Falkreath01_StaggerMinor, None, 0, CasterActor, TargetActor)
	EndIf
EndFunction

Function MomentumHit(Int RandomChance, Spell SuccessSpell, Spell FailureSpell, Int HealthDamage, Actor akCaster, Actor akTarget)
	akTarget.DamageActorValue("Health", HealthDamage)
	If RandomChance > 50 && !akTarget.IsDead()
		akCaster.DoCombatSpellApply(SuccessSpell, akTarget)
	ElseIf FailureSpell
		akCaster.DoCombatSpellApply(FailureSpell, akTarget)		
	EndIf
EndFunction

Function ReachStart()
	RemoveSpells()
	Utility.Wait(0.2)
	ApplyBonus(CasterActor.GetActorValue("WeaponSpeedMult"))
EndFunction

Function ReachFinish()
	RemoveSpells()
EndFunction

Function RemoveSpells()
	CasterActor.DispelSpell(ZTh_05_TheReach02_V7_Spell01)
	CasterActor.DispelSpell(ZTh_05_TheReach02_V7_Spell02)
	CasterActor.DispelSpell(ZTh_05_TheReach02_V7_Spell03)
EndFunction

Function ApplyBonus(Float CasterAV)
	If CasterAV == 0
		ZTh_05_TheReach02_V7_Spell01.Cast(CasterActor)
	ElseIf CasterAV <= 1.25 && CasterAV >= 1
		ZTh_05_TheReach02_V7_Spell02.Cast(CasterActor)
	ElseIf CasterAV <= 1.35 && CasterAV >= 1
		ZTh_05_TheReach02_V7_Spell03.Cast(CasterActor)
	EndIf
EndFunction