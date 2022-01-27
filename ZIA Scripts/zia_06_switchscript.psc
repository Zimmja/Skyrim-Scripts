Scriptname ZIA_06_SwitchScript extends ReferenceAlias  

Actor PlayerActor
Bool Property AutoAdd Auto
Bool ReceiveState
;---------------------------------------------------------------------------------------------
FormList Property ZXX_Switch_VanillaList Auto
FormList Property ZXX_Switch_ModList Auto
FormList Property ZXX_Switch_LocationList Auto
Spell Property ZXX_SwitchSpell Auto
Spell Property SpellToAdd Auto
Perk Property PerkToAdd Auto
;---------------------------------------------------------------------------------------------
; SWITCH MONITORING
;---------------------------------------------------------------------------------------------
Event OnInit()
	PlayerActor = Game.GetPlayer()
	AddInventoryEventFilter(ZXX_Switch_VanillaList)
	AddInventoryEventFilter(ZXX_Switch_ModList)
	If SpellToAdd
		PlayerActor.AddSpell(SpellToAdd, False)
	EndIf
	If PerkToAdd 
		PlayerActor.AddPerk(PerkToAdd)
	EndIf
	If ((PlayerActor.GetItemCount(ZXX_Switch_VanillaList) >= 1) || (PlayerActor.GetItemCount(ZXX_Switch_ModList) >= 1)) ||  (AutoAdd == True)
		GoToState("Received")
	Else
		GoToState("Ready")
	EndIf
EndEvent

STATE Ready
	Event OnItemAdded(Form akBaseItem, Int aeItemCount, ObjectReference akItemReference, ObjectReference akSourceContainer)
		GoToState("Received")
	EndEvent
ENDSTATE

STATE Received
	Event OnBeginState()
		UnRegisterForUpdate()
		ReceiveState = True
		RegisterForSingleUpdate(30)
		If !PlayerActor.HasSpell(ZXX_SwitchSpell)
			PlayerActor.AddSpell(ZXX_SwitchSpell, False)
		EndIf
	EndEvent
	Event OnItemRemoved(Form akBaseItem, Int aeItemCount, ObjectReference akItemReference, ObjectReference akDestContainer)
		UnregisterForUpdate()
		ReceiveState = False
		GoToState("NoPossession")
	EndEvent
ENDSTATE

	Event OnUpdate()
		ReceiveState = False
		GoToState("Possession")
	EndEvent

STATE Possession
	Event OnBeginState()
		LocationCheck(PlayerActor.GetCurrentLocation())
	EndEvent
	Event OnLocationChange(Location akOldLock, Location akNewLock)
		LocationCheck(akNewLock)
	EndEvent
	Event OnItemRemoved(Form akBaseItem, Int aeItemCount, ObjectReference akItemReference, ObjectReference akDestContainer)
		GoToState("NoPossession")
	EndEvent
ENDSTATE

STATE NoPossession
	Event OnBeginState()
		PlayerActor.RemoveSpell(ZXX_SwitchSpell)
	EndEvent
	Event OnItemAdded(Form akBaseItem, Int aeItemCount, ObjectReference akItemReference, ObjectReference akSourceContainer)
		GoToState("Possession")
	EndEvent
ENDSTATE

STATE Switching
ENDSTATE

Function LocationCheck(Location akNewLoc)
	If ZXX_Switch_LocationList.HasForm(akNewLoc)
		PlayerActor.AddSpell(ZXX_SwitchSpell, False)
	ElseIf PlayerActor.HasSpell(ZXX_SwitchSpell)
		PlayerActor.RemoveSpell(ZXX_SwitchSpell)
	EndIf
EndFunction

;---------------------------------------------------------------------------------------------
Message Property ZXX_Switch_ToModMessage Auto
Message Property ZXX_Switch_ToVanMessage Auto
Sound Property MAGFail Auto
Sound Property MAGLightFire Auto
;---------------------------------------------------------------------------------------------
; SWITCHING
;---------------------------------------------------------------------------------------------
Function BeginSwitch()
	If (PlayerActor.GetItemCount(ZXX_Switch_VanillaList) >= 1)
		ChooseSwitch(ZXX_Switch_VanillaList, ZXX_Switch_ModList, ZXX_Switch_ToModMessage, FindListPosition(ZXX_Switch_VanillaList))
	ElseIf (PlayerActor.GetItemCount(ZXX_Switch_ModList) >= 1)
		ChooseSwitch(ZXX_Switch_ModList, ZXX_Switch_VanillaList, ZXX_Switch_ToVanMessage, FindListPosition(ZXX_Switch_ModList))
	EndIf
EndFunction

Function ChooseSwitch(FormList FromList, FormList ToList, Message ChoiceMessage, Int ListPosition)
GoToState("Switching")
	Int ListChoice = ChoiceMessage.Show()
	If ListChoice == 0
		Debug.Notification("Conversion cancelled.")
		MAGFail.Play(PlayerActor)
	ElseIf ListChoice == 1
		If PlayerActor.IsEquipped(FromList.GetAt(ListPosition))
			PlayerActor.EquipItem(ToList.GetAt(ListPosition),False,True)
		Else
			PlayerActor.AddItem(ToList.GetAt(ListPosition),1,True)
		EndIf
		PlayerActor.RemoveItem(FromList.GetAt(ListPosition),1,True,None)
		Debug.Notification("Conversion successful.")
		MAGLightFire.Play(PlayerActor)
	EndIf
If ReceiveState == False
	GoToState("Possession")
Else
	GoToState("Received")
EndIf
EndFunction

Int Function FindListPosition(FormList ArtifactList)
	Int WhileCounter = 0
	Int ArtifactListSize = ArtifactList.GetSize()
	WHILE WhileCounter < ArtifactListSize
		If PlayerActor.GetItemCount(ArtifactList.GetAt(WhileCounter)) == 0
			WhileCounter += 1
		Else
			ArtifactListSize = -1
		EndIf
	ENDWHILE
	Return WhileCounter
EndFunction