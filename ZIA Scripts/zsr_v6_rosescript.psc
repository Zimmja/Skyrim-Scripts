Scriptname ZSR_V6_RoseScript extends Actor  

EffectShader Property SoulTrapTargetActFXS Auto
Sound Property ZSR_DismissSound Auto 
Weapon Property DA14SanguineRose Auto
Message Property ZSR_DismissMessage Auto

Event OnItemRemoved(Form akBaseItem, int aiItemCount, ObjectReference akItemReference, ObjectReference akDestContainer)
	akItemReference.Delete()
EndEvent

Event OnActivate(ObjectReference akTriggerRef)
IF (akTriggerRef == Game.GetPlayer()) && (Game.GetPlayer().GetItemCount(DA14SanguineRose) >= 1)
	Int Choice = ZSR_DismissMessage.Show()
	If Choice == 0
		SoulTrapTargetActFXS.Play(Self, 1)
		ZSR_DismissSound.Play(Self)
		Disable(True)
		Utility.Wait(2)	
		Delete()
	Endif
ENDIF
EndEvent