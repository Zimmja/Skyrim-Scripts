Scriptname ZBB_V6_PlayerScript extends ReferenceAlias

Actor PlayerActor
GlobalVariable Property ZBB_V6_Global_FirstCharge Auto
Perk Property ZBB_BloodskalPerk Auto
Spell Property ZBB_V6_Spell_CheckHorizontal Auto
Spell Property ZBB_V6_Spell_CheckVertical Auto
Weapon Property DLC2BloodskalBlade Auto

Event OnInit()
	SetupAlias()
	If BloodskalEquipped()
		InitBloodskal()
	EndIf
EndEvent

Event OnObjectEquipped(Form akBaseObject, ObjectReference akReference)
	If akBaseObject == DLC2BloodskalBlade
		InitBloodskal()
	EndIf
EndEvent

Event OnObjectUnequipped(Form akBaseObject, ObjectReference akReference)
	If akBaseObject == DLC2BloodskalBlade
		EndBloodskal()
	EndIf
endEvent

Event OnAnimationEvent(ObjectReference akSource, string EventName)
	If BloodskalEquipped()
		If (eventName == "AttackPowerRight_FXstart") || (eventName == "AttackPowerLeft_FXstart") || (eventName == "AttackPowerBackward_FXstart")
			ZBB_V6_Spell_CheckHorizontal.Cast(PlayerActor)
		ElseIf  (eventName == "AttackPowerStanding_FXstart") || (eventName == "AttackPowerForward_FXstart")
			ZBB_V6_Spell_CheckVertical.Cast(PlayerActor)
		EndIf
	EndIf
EndEvent

Function SetupAlias()
	Utility.Wait(0.1)
	AttemptAddPerk()
	AddInventoryEventFilter(DLC2BloodskalBlade)
	PlayerActor= (Self.GetRef() as Actor)
EndFunction

Function AttemptAddPerk()
	If !PlayerActor.HasPerk(ZBB_BloodskalPerk)
		PlayerActor.AddPerk(ZBB_BloodskalPerk)
	EndIf
EndFunction

Function InitBloodskal()
	RegisterForAnimationEvent(PlayerActor, "AttackPowerStanding_FXstart")
	RegisterForAnimationEvent(PlayerActor, "AttackPowerRight_FXstart")
	RegisterForAnimationEvent(PlayerActor, "AttackPowerLeft_FXstart")
	RegisterForAnimationEvent(PlayerActor, "AttackPowerBackward_FXstart")
	RegisterForAnimationEvent(PlayerActor, "AttackPowerForward_FXstart")
	AttemptChargeBlade()
EndFunction

Function EndBloodskal()
	UnregisterForAnimationEvent(PlayerActor, "AttackPowerStanding_FXstart")
	UnregisterForAnimationEvent(PlayerActor, "AttackPowerRight_FXstart")
	UnregisterForAnimationEvent(PlayerActor, "AttackPowerLeft_FXstart")
	UnregisterForAnimationEvent(PlayerActor, "AttackPowerBackward_FXstart")
	UnregisterForAnimationEvent(PlayerActor, "AttackPowerForward_FXstart")
EndFunction

Function AttemptChargeBlade()
	If ZBB_V6_Global_FirstCharge.GetValue() == 1
		ZBB_V6_Global_FirstCharge.SetValue(0)
		Float BladeCharge = PlayerActor.GetActorValue("RightItemCharge")
		PlayerActor.ModActorValue("RightItemCharge", 3000 - BladeCharge)
	EndIf
EndFunction

Bool Function BloodskalEquipped()
	return  PlayerActor.GetEquippedWeapon() == DLC2BloodskalBlade
EndFunction