Scriptname ZSM_V6_PlayerScript extends ReferenceAlias

Actor PlayerActor
Spell Property ZSM_MagnusAb Auto
Weapon Property MG07StaffofMagnus Auto

Event OnInit()
	SetupAlias()
	If StaffEquipped()
		InitStaff()
	EndIf
EndEvent

Event OnObjectEquipped(Form akBaseObject, ObjectReference akReference)
	If akBaseObject == MG07StaffofMagnus
		InitStaff()
	EndIf
EndEvent

Event OnObjectUnequipped(Form akBaseObject, ObjectReference akReference)
	If akBaseObject == MG07StaffofMagnus
		EndStaff()
	EndIf
endEvent

Function SetupAlias()
	Utility.Wait(0.1)
	AddInventoryEventFilter(MG07StaffofMagnus)
	PlayerActor= (Self.GetRef() as Actor)
EndFunction

Function InitStaff()
	PlayerActor.AddSpell(ZSM_MagnusAb, False)
EndFunction

Function EndStaff()
	PlayerActor.RemoveSpell(ZSM_MagnusAb)
EndFunction

Bool Function StaffEquipped()
	return  PlayerActor.GetEquippedWeapon(false) == MG07StaffofMagnus || PlayerActor.GetEquippedWeapon(true) == MG07StaffofMagnus
EndFunction
