Scriptname ZTL_QuestScript extends Quest

FormList Property ZTL_List_CraftAllows Auto
FormList Property ZTL_List_CraftAlts Auto

Book Property ZTL_Book Auto
LeveledItem Property LItemBookClutter Auto

Event OnInit()
	SetAllowedAlternatives()
	Game.GetPlayer().AddItem(ZTL_Book, 1, true)
	LItemBookClutter.AddForm(ZTL_Book, 1, 1)
EndEvent

Function SetAllowedAlternatives()
	Int Countdown = ZTL_List_CraftAllows.GetSize()
	WHILE Countdown >= 0
		Countdown -= 1
		GlobalVariable cdGlobal = ZTL_List_CraftAllows.GetAt(Countdown) as GlobalVariable
		FormList cdList = ZTL_List_CraftAlts.GetAt(Countdown) as FormList
		cdGlobal.SetValue(cdList.GetSize())
	ENDWHILE
EndFunction