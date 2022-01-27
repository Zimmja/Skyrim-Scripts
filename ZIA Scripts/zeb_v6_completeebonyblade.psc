Scriptname ZEB_V6_CompleteEbonyBlade extends ObjectReference  

GlobalVariable Property ZEB_EbonyBladeKillsGlobal Auto
Perk Property ZEB_EbonyBlade_DamagePerk Auto
Quest Property DA08EbonyBladeTracking  Auto
Quest Property DA08 Auto

; This script has been set up to allow other mods to remotely complete the Ebony Blade.
; Create a quest with a Location Alias on Lost Prospect Mine, and a Reference Alias on Lost Prospect Mine's FavorItemRefType.
; Activate the Reference Alias. This will auto-complete the Ebony Blade tracker quest. 

Event OnActivate(ObjectReference akTriggerRef)
	ZEB_EbonyBladeKillsGlobal.SetValue(10)
	(DA08EbonyBladeTracking as DA08EbonyBladeTrackingScript).FriendsKilled = 10
	Game.GetPlayer().RemovePerk(ZEB_EbonyBlade_DamagePerk)
	If DA08.GetStage() == 60
		DA08.SetStage(80)
	EndIf
EndEvent