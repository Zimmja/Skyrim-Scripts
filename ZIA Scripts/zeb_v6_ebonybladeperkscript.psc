Scriptname ZEB_V6_EbonyBladePerkScript extends Quest  

Quest Property DA08EbonyBladeTracking Auto
GlobalVariable Property ZEB_EbonyBladeKillsGlobal Auto
Perk Property ZEB_EbonyBlade_DamagePerk Auto

Event OnInit()
	Int EbonyBladeKills = (DA08EbonyBladeTracking as DA08EbonyBladeTrackingScript).FriendsKilled
	ZEB_EbonyBladeKillsGlobal.SetValue(EbonyBladeKills)
	If EbonyBladeKills < 10
		Game.GetPlayer().AddPerk(ZEB_EbonyBlade_DamagePerk)
	Endif
	Stop()
EndEvent