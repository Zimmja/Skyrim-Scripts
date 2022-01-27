Scriptname ZTH_V7_PlayerAliasScript  extends ReferenceAlias  

Quest Property FavorJarlsMakeFriends Auto
Quest Property ZTh_10_V7_ThaneQuest Auto
FormList Property ZTh_10_ThanePerks Auto
FormList Property ZTL_List_ThaneGlobals Auto

ReferenceAlias Property WinterholdWeapon Auto
ReferenceAlias Property EastmarchWeapon Auto
ReferenceAlias Property FalkreathWeapon Auto
ReferenceAlias Property PaleWeapon Auto
ReferenceAlias Property ReachWeapon Auto
ReferenceAlias Property HjaalmarchWeapon Auto
ReferenceAlias Property HaafingarWeapon Auto
ReferenceAlias Property WhiterunWeapon01 Auto
ReferenceAlias Property WhiterunWeapon02 Auto
ReferenceAlias Property RiftWeapon Auto

Weapon Property ZTh_01_Winterhold00 Auto
Weapon Property ZTh_02_Eastmarch00 Auto
Weapon Property ZTh_03_Falkreath00 Auto
Weapon Property ZTh_04_ThePale00 Auto
Weapon Property ZTh_05_TheReach00 Auto
Weapon Property ZTh_06_Hjaalmarch00 Auto
Weapon Property ZTh_07_Haafingar00 Auto
Weapon Property ZTh_08_Whiterun00 Auto
Weapon Property ZTh_09_Rift00 Auto

Weapon OldThaneWeapon
Actor PlayerActor

Event OnInit()
	SetupAlias()
EndEvent

Function SetupAlias()
	CheckShutdown()
	PlayerActor = Game.GetPlayer()
	Int WhileInt = 0
	While WhileInt < ZTh_10_ThanePerks.GetSize()
		PlayerActor.AddPerk(ZTh_10_ThanePerks.GetAt(WhileInt) as Perk)
		WhileInt += 1
	EndWhile
EndFunction

Event OnItemAdded(Form akBaseItem, int aiItemCount, ObjectReference akItemReference, ObjectReference akSourceContainer)
	IF ((akItemReference == WinterholdWeapon.GetRef() as ObjectReference) && !(WinterholdWeapon.GetRef() == None))
 		OldForNew(WinterholdWeapon.GetRef(), ZTh_01_Winterhold00, ZTL_List_ThaneGlobals.GetAt(0) as GlobalVariable)

	ELSEIF ((akItemReference == EastmarchWeapon.GetRef() as ObjectReference) && !(EastmarchWeapon.GetRef() == None))
 		OldForNew(EastmarchWeapon.GetRef(), ZTh_02_Eastmarch00, ZTL_List_ThaneGlobals.GetAt(1) as GlobalVariable)

	ELSEIF ((akItemReference == FalkreathWeapon.GetRef() as ObjectReference) && !(FalkreathWeapon.GetRef() == None))
 		OldForNew(FalkreathWeapon.GetRef(), ZTh_03_Falkreath00, ZTL_List_ThaneGlobals.GetAt(2) as GlobalVariable)

	ELSEIF ((akItemReference == PaleWeapon.GetRef() as ObjectReference) && !(PaleWeapon.GetRef() == None))
 		OldForNew(PaleWeapon.GetRef(), ZTh_04_ThePale00, ZTL_List_ThaneGlobals.GetAt(3) as GlobalVariable)

	ELSEIF ((akItemReference == ReachWeapon.GetRef() as ObjectReference) && !(ReachWeapon.GetRef() == None))
 		OldForNew(ReachWeapon.GetRef(), ZTh_05_TheReach00, ZTL_List_ThaneGlobals.GetAt(4) as GlobalVariable)

	ELSEIF ((akItemReference == HjaalmarchWeapon.GetRef() as ObjectReference) && !(HjaalmarchWeapon.GetRef() == None))
 		OldForNew(HjaalmarchWeapon.GetRef(), ZTh_06_Hjaalmarch00, ZTL_List_ThaneGlobals.GetAt(5) as GlobalVariable)

	ELSEIF ((akItemReference == HaafingarWeapon.GetRef() as ObjectReference) && !(HaafingarWeapon.GetRef() == None))
 		OldForNew(HaafingarWeapon.GetRef(), ZTh_07_Haafingar00, ZTL_List_ThaneGlobals.GetAt(6) as GlobalVariable)

	ELSEIF ((akItemReference == WhiterunWeapon01.GetRef() as ObjectReference) && !(WhiterunWeapon01.GetRef() == None))
 		OldForNew(WhiterunWeapon01.GetRef(), ZTh_08_Whiterun00, ZTL_List_ThaneGlobals.GetAt(7) as GlobalVariable)

	ELSEIF ((akItemReference == WhiterunWeapon02.GetRef() as ObjectReference) && !(WhiterunWeapon02.GetRef() == None))
 		OldForNew(WhiterunWeapon02.GetRef(), ZTh_08_Whiterun00, ZTL_List_ThaneGlobals.GetAt(7) as GlobalVariable)

	ELSEIF ((akItemReference == RiftWeapon.GetRef() as ObjectReference) && !(RiftWeapon.GetRef() == None))
 		OldForNew(RiftWeapon.GetRef(), ZTh_09_Rift00, ZTL_List_ThaneGlobals.GetAt(8) as GlobalVariable)

	ENDIF
EndEvent

Event OnItemRemoved(Form akBaseItem, int aiItemCount, ObjectReference akItemReference, ObjectReference akDestContainer)
	If akDestContainer && (akBaseItem == OldThaneWeapon)
		akDestContainer.RemoveItem(akBaseItem, aiItemCount, True, None)
	EndIf
EndEvent

Function OldForNew(ObjectReference OldWeaponRef, Weapon NewWeapon, GlobalVariable ThaneGlobal)
	If ThaneGlobal.GetValue() == 0
		OldThaneWeapon = OldWeaponRef.GetBaseObject() as Weapon
		PlayerActor.RemoveItem(OldWeaponRef, 1, True)
		PlayerActor.AddItem(NewWeapon)
		ThaneGlobal.SetValue(1)
		CheckShutdown()
	EndIf
EndFunction

Function CheckShutdown()
	If ThaneGlobalSum() >= 9
		Clear()
		ZTh_10_V7_ThaneQuest.Stop()
	EndIf
EndFunction

Int Function ThaneGlobalSum()
	Int WhileInt = 0
	Int GlobalSum = 0
	While WhileInt < ZTL_List_ThaneGlobals.GetSize()
		GlobalSum += (ZTL_List_ThaneGlobals.GetAt(WhileInt) as GlobalVariable).GetValueInt()
		WhileInt += 1
	EndWhile
	return GlobalSum
EndFunction