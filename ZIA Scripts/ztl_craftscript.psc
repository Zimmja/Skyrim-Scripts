Scriptname ZTL_CraftScript extends ObjectReference  

Event OnLoad()
	Int WhileCounter = 600
	WHILE Game.IsLookingControlsEnabled() && WhileCounter > 0
		WhileCounter -= 1
	ENDWHILE
	WHILE !Game.IsLookingControlsEnabled()
		Utility.Wait(0.1)
	ENDWHILE
	Disable()
	Delete()
EndEvent
