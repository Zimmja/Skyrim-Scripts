Scriptname ZTL_BookScript extends ObjectReference

Actor PlayerActor

ReferenceAlias Property ArcanaeumBook Auto
Bool AllowSetPos= True
;=================================
Event OnCellLoad()
	If ArcanaeumBook.GetRef() == Self && AllowSetPos
		AllowSetPos = False
		SetPosition(52.0, 437.0, 81.0)
	EndIf
EndEvent


Event OnRead()
	PlayerActor = Game.GetPlayer()
	CheckThaneWeapons()
	If PlayerHasArtifact() && !PlayerActor.IsInCombat()
		Utility.WaitMenuMode(1.0)
		MakeChoice()
	EndIf
EndEvent

FormList Property ZTL_List_Alts Auto
;=================================
Bool Function PlayerHasArtifact()
	Bool funcBool = PlayerActor.GetItemCount(ZTL_List_Alts) > 0
	return funcBool
EndFunction

Message Property ZTL_Message_Art Auto
;=================================
Function MakeChoice()
	If ZTL_Message_Art.Show() == 0
		BeginCrafting()
	EndIf
EndFunction

Furniture Property ZTL_CraftingBench Auto
;=================================
Function BeginCrafting()
	ObjectReference Crafting = Game.GetPlayer().PlaceAtMe(ZTL_CraftingBench)
	ForceCloseMenu()
	Crafting.Activate(PlayerActor, True)
EndFunction

Function ForceCloseMenu()
	Game.DisablePlayerControls(false, false, false, false, false, true, false)
	Utility.Wait(0.1)
	Game.EnablePlayerControls(false, false, false, false, false, true, false)
EndFunction

;=================================
Function CheckThaneWeapons()
	DefineThaneArrays()
	Int WhileCounter = 8
	WHILE WhileCounter >= 0
		If Thane_Globals[WhileCounter].GetValue() == 0 && (ThaneImp[WhileCounter] + ThaneSons[WhileCounter] > 0)
			PlayerActor.AddItem(Thane_Weapons[WhileCounter], 1, False)
			Thane_Globals[WhileCounter].SetValue(1)
		EndIf
		WhileCounter -= 1
	ENDWHILE
EndFunction

FavorJarlsMakeFriendsScript ThaneScript
;=================================
Function DefineThaneArrays()
	ThaneScript = Game.GetForm(0x00087E24) As FavorJarlsMakeFriendsScript
	DefineThaneWeapons()
	DefineThaneSons()
	DefineThaneImp()
EndFunction

FormList Property ZTL_List_ThaneGlobals Auto
FormList Property ZTL_List_ThaneWeapons Auto
GlobalVariable[] Thane_Globals
Weapon[] Thane_Weapons
;=================================
Function DefineThaneWeapons()
	Thane_Globals = New GlobalVariable[9]
	Thane_Weapons = New Weapon[9]
	Int WhileCounter = 8
	WHILE WhileCounter >= 0
		Thane_Globals[WhileCounter] = (ZTL_List_ThaneGlobals.GetAt(WhileCounter) as GlobalVariable)
		Thane_Weapons[WhileCounter] = (ZTL_List_ThaneWeapons.GetAt(WhileCounter) as Weapon)
		WhileCounter -= 1
	ENDWHILE
EndFunction

Int[] ThaneSons
;=================================
Function DefineThaneSons()
	ThaneSons = New Int[9]
	ThaneSons[0] = ThaneScript.EastmarchSonsGetOutofJail
	ThaneSons[1] = ThaneScript.FalkreathSonsGetOutofJail
	ThaneSons[2] = ThaneScript.HaafingarSonsGetOutofJail
	ThaneSons[3] = ThaneScript.HjaalmarchSonsGetOutofJail
	ThaneSons[4] = ThaneScript.PaleSonsGetOutofJail
	ThaneSons[5] = ThaneScript.ReachSonsGetOutofJail
	ThaneSons[6] = ThaneScript.RiftSonsGetoutofJail
	ThaneSons[7] = ThaneScript.WhiterunSonsGetOutofJail
	ThaneSons[8] = ThaneScript.WinterholdSonsGetOutofJail
EndFunction

Int[] ThaneImp
;=================================
Function DefineThaneImp()
	ThaneImp = New Int[9]
	ThaneImp[0] = ThaneScript.EastmarchImpGetOutofJail
	ThaneImp[1] = ThaneScript.FalkreathImpGetOutofJail
	ThaneImp[2] = ThaneScript.HaafingarImpGetOutofJail
	ThaneImp[3] = ThaneScript.HjaalmarchImpGetOutofJail
	ThaneImp[4] = ThaneScript.PaleImpGetOutofJail
	ThaneImp[5] = ThaneScript.ReachImpGetOutofJail
	ThaneImp[6] = ThaneScript.RiftImpGetoutofJail
	ThaneImp[7] = ThaneScript.WhiterunImpGetOutofJail
	ThaneImp[8] = ThaneScript.WinterholdImpGetOutofJail
EndFunction