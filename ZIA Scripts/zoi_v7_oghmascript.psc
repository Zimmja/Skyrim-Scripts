Scriptname ZOI_V7_OghmaScript extends activemagiceffect  

String Property SpellType Auto ; Power, Ability, Modify
Actor PlayerActor

Event OnEffectStart(Actor akTarget, Actor akCaster)
If akTarget == Game.GetPlayer()
	PlayerActor = akTarget
	GoToState(SpellType)
EndIf
EndEvent

;--------------------------------------------------------------------------------------------------------
GlobalVariable Property ZOI_SoulMin Auto
GlobalVariable Property ZOI_SoulPerks Auto
GlobalVariable Property ZOI_SoulMax Auto
GlobalVariable Property ZOI_SoulsUnlocked Auto
EffectShader Property ZOI_EffectShader Auto
ImageSpaceModifier Property ZOI_Imod Auto
Sound Property MAGFail Auto
Sound Property ZOI_SuccessSound Auto
Sound Property NPCDragonFlightRoarDistant01 Auto
Spell Property ZOI_Dragon02_Power Auto
Int RequiredSouls
;--------------------------------------------------------------------------------------------------------
STATE Power
;--------------------------------------------------------------------------------------------------------
Event OnBeginState()
	RequiredSouls = (ZOI_SoulMin.GetValueInt())
	If PlayerActor.GetActorValue("DragonSouls") >= RequiredSouls
		PlayerActor.DamageActorValue("DragonSouls", RequiredSouls)
		AddDragonPerks()
		SuccessEffects()
	Else
		MAGFail.Play(PlayerActor)
		Debug.Notification(FailMessage())
	EndIf
EndEvent
ENDSTATE

Function AddDragonPerks()
	Int RemainingPerks = (ZOI_SoulMax.GetValueInt() - ZOI_SoulsUnlocked.GetValueInt())
	Int RequestedPerks = (ZOI_SoulPerks.GetValueInt())
	Int SoulsToUnlock = UnlockCount(RemainingPerks, RequestedPerks)
	Game.AddPerkPoints(SoulsToUnlock)
	ZOI_SoulsUnlocked.SetValue(ZOI_SoulsUnlocked.GetValueInt()+SoulsToUnlock)
	CheckMaximum()
EndFunction

Function CheckMaximum()
	If (ZOI_SoulMax.GetValue() > 0) 
		If (ZOI_SoulsUnlocked.GetValue() >= ZOI_SoulMax.GetValue())
			PlayerActor.RemoveSpell(ZOI_Dragon02_Power)
			Debug.Notification("You have leaned all you can from Dragon Knowledge.")
		Else
			Debug.Notification(ZOI_SoulsUnlocked.GetValueInt()+"/"+ZOI_SoulMax.GetValueInt()+" perks unlocked.")
		EndIf
	EndIf
EndFunction

Int Function UnlockCount(Int Remaining, Int Requested)
	If (Remaining > Requested)
		return Requested
	Else
		return Remaining
	EndIf
EndFunction

Function SuccessEffects()
	ZOI_EffectShader.Play(PlayerActor,2)
	ZOI_Imod.Apply()
	ZOI_SuccessSound.Play(PlayerActor)
	Game.ShakeCamera(PlayerActor, 0.5, 1)
	Game.ShakeController(0.5, 0.5, 1)
	Utility.Wait(1.25)
	NPCDragonFlightRoarDistant01.Play(PlayerActor)
EndFunction

String Function FailMessage()
	If RequiredSouls == 1
		return "You need a dragon soul to use this power."
	Else
		return "You need "+RequiredSouls+" dragon souls to use this power."
	EndIf
EndFunction

;--------------------------------------------------------------------------------------------------------
Int SkillPoints = 40
Int SkillMax = 8
String[] PlayerSkills
Int[] PlayerSkillsValues
Int[] PlayerSkillsRanks
Message Property ZOI_V7_OghmaPrintMessage01 Auto
Message Property ZOI_V7_OghmaPrintMessage02 Auto
;--------------------------------------------------------------------------------------------------------
STATE Ability
;--------------------------------------------------------------------------------------------------------
Event OnBeginState()
	PlayerActor.AddSpell(ZOI_Dragon02_Power,False)
	PlayerSkills = New String[18]
	PlayerSkills[0] = "OneHanded"
	PlayerSkills[1] = "TwoHanded"
	PlayerSkills[2] = "Marksman"
	PlayerSkills[3] = "Block"
	PlayerSkills[4] = "Smithing"
	PlayerSkills[5] = "HeavyArmor"
	PlayerSkills[6] = "LightArmor"
	PlayerSkills[7] = "Pickpocket"
	PlayerSkills[8] = "Lockpicking"
	PlayerSkills[9] = "Sneak"
	PlayerSkills[10] = "Alchemy"
	PlayerSkills[11] = "Speechcraft"
	PlayerSkills[12] = "Alteration"
	PlayerSkills[13] = "Conjuration"
	PlayerSkills[14] = "Destruction"
	PlayerSkills[15] = "Illusion"
	PlayerSkills[16] = "Restoration"
	PlayerSkills[17] = "Enchanting"

TESTSetConditions()
	DefineSkillValues()
TESTPrintSkills()

	Int WhileBreaker = 0
	WHILE (SkillPoints > 0) && (WhileBreaker < 10)
		Int HighSkillVal = GetHighestSkillVal()
		Int SkillsToRaiseCount = GetHighCount(HighSkillVal)

		If SkillsToRaiseCount > 0
			If (SkillsToRaiseCount * SkillMax) <= SkillPoints
				Int LeftOvers = IncrementSkillsOfValue(HighSkillVal, SkillMax)
				SkillPoints -= ((SkillsToRaiseCount * SkillMax) - LeftOvers)
			Else
				Int Slice = Math.Floor(SkillPoints / SkillsToRaiseCount)
				If Slice < 1
					Slice = 1
				EndIf
				IncrementSkillsOfValue(HighSkillVal, Slice)
				SkillPoints -= SkillsToRaiseCount * Slice
			EndIf
			WhileBreaker -= 1
		Else
			WhileBreaker = 10
		EndIf
	ENDWHILE

	Dispel()
EndEvent
ENDSTATE

Function DefineSkillValues()
	PlayerSkillsValues= New Int[18]
	Int WhileCounter = 0
	WHILE WhileCounter <= 17
		PlayerSkillsValues[WhileCounter] = PlayerActor.GetActorValue(PlayerSkills[WhileCounter]) as Int
		WhileCounter += 1
	ENDWHILE
EndFunction

Int Function GetHighestSkillVal()
	Int HighCounter = 0
	Int WhileCounter = 0
	WHILE WhileCounter <= 17
		If (PlayerSkillsValues[WhileCounter] >= HighCounter) && (PlayerSkillsValues[WhileCounter] < 100) && (PlayerSkillsValues[WhileCounter] >= 0)
			HighCounter = PlayerSkillsValues[WhileCounter]
		EndIf
		WhileCounter += 1
	ENDWHILE
	return HighCounter
EndFunction

Int Function GetHighCount(Int HighNumber)
	Int HighCounter = 0
	Int WhileCounter = 0
	WHILE WhileCounter <= 17
		If (PlayerSkillsValues[WhileCounter] == HighNumber)
			HighCounter += 1
		EndIf
		WhileCounter += 1
	ENDWHILE
	return HighCounter
EndFunction

Int Function IncrementSkillsOfValue(Int Value, Int IncVal)
	Int WhileCounter = 0
	Int LeftOvers = 0
	WHILE WhileCounter <= 17
		If (PlayerSkillsValues[WhileCounter] == Value)
			Int LeftOver = IncrementSkill(WhileCounter, IncVal)
			LeftOvers += LeftOver
		EndIf
		WhileCounter += 1
	ENDWHILE
	return LeftOvers
EndFunction

Int Function IncrementSkill(Int SkillIndex, Int IncVal)
	Int ToHundred = 100 - PlayerSkillsValues[SkillIndex]
	If ToHundred < IncVal
		IncVal = ToHundred
	EndIf
	Game.IncrementSkillBy(PlayerSkills[SkillIndex],IncVal)
	PlayerSkillsValues[SkillIndex] = -1
TESTMessage(PlayerSkills[SkillIndex]+" incremented by "+IncVal)
	return SkillMax - IncVal
EndFunction


Bool Testing = false
;--------------------------------------------------------------------------------------------------------
; Ability Tests
;--------------------------------------------------------------------------------------------------------
Function TESTPrintSkills()
If Testing
	ZOI_V7_OghmaPrintMessage01.Show(PlayerSkillsValues[0], PlayerSkillsValues[1], PlayerSkillsValues[2], PlayerSkillsValues[3], PlayerSkillsValues[4], \
		PlayerSkillsValues[5], PlayerSkillsValues[6], PlayerSkillsValues[7], PlayerSkillsValues[8])
	ZOI_V7_OghmaPrintMessage02.Show(PlayerSkillsValues[9], PlayerSkillsValues[10], PlayerSkillsValues[11], PlayerSkillsValues[12], PlayerSkillsValues[13], \
		PlayerSkillsValues[14], PlayerSkillsValues[15], PlayerSkillsValues[16], PlayerSkillsValues[17])
EndIf
EndFunction

Function TESTMessage(String MessageStr)
If Testing
	Debug.MessageBox(MessageStr)
	Utility.Wait(0.1)
EndIf
EndFunction

Function TESTSetConditions()
If Testing
	PlayerActor.SetActorValue("OneHanded", utility.randomInt(0, 100))
	PlayerActor.SetActorValue("TwoHanded", utility.randomInt(0, 100))
	PlayerActor.SetActorValue("Marksman", utility.randomInt(0, 100))
	PlayerActor.SetActorValue("Block", utility.randomInt(0, 100))
	PlayerActor.SetActorValue("Smithing", utility.randomInt(0, 100))
	PlayerActor.SetActorValue("HeavyArmor", utility.randomInt(0, 100))
	PlayerActor.SetActorValue("LightArmor", utility.randomInt(0, 100))
	PlayerActor.SetActorValue("Pickpocket", utility.randomInt(0, 100))
	PlayerActor.SetActorValue("Lockpicking", utility.randomInt(0, 100))
	PlayerActor.SetActorValue("Sneak", utility.randomInt(0, 100))
	PlayerActor.SetActorValue("Alchemy", utility.randomInt(0, 100))
	PlayerActor.SetActorValue("Speechcraft", utility.randomInt(0, 100))
	PlayerActor.SetActorValue("Alteration", utility.randomInt(0, 100))
	PlayerActor.SetActorValue("Conjuration", utility.randomInt(0, 100))
	PlayerActor.SetActorValue("Destruction", utility.randomInt(0, 100))
	PlayerActor.SetActorValue("Illusion", utility.randomInt(0, 100))
	PlayerActor.SetActorValue("Restoration", utility.randomInt(0, 100))
	PlayerActor.SetActorValue("Enchanting", utility.randomInt(0, 100))
EndIf
EndFunction