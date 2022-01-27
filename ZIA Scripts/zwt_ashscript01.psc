Scriptname ZWT_AshScript01 extends ObjectReference  

Event OnLoad()
	RegisterForUpdateGameTime(0.5)
EndEvent

Event OnUpdateGameTime()	
	UnregisterForUpdateGameTime()
	DeleteWhenAble()
EndEvent