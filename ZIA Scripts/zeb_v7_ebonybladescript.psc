Scriptname ZEB_V7_EbonyBladeScript extends activemagiceffect

GlobalVariable Property ZEB_EbonyBladeKillsGlobal Auto
Quest Property DA08EbonyBladeTracking Auto
Quest Property DA08 Auto
Perk Property ZEB_EbonyBlade_DamagePerk Auto
Scene Property DA08MephalaGrats Auto

Spell Property ZEB_EbonyBlade_BloodOfDeceit Auto
VisualEffect Property ZEB_EbonyBladeBloodVisual Auto
EffectShader Property AbsorbHealthFXS Auto
ImageSpaceModifier Property IllusionDarkMassiveImod Auto
Sound Property MAGCloakIn Auto

Actor TargetActor
Actor CasterActor

Event OnEffectStart(actor akTarget, Actor akCaster)
TargetActor = akTarget
CasterActor = akCaster
EndEvent

Event OnDying(Actor akKiller)
IF (TargetActor.GetRelationshipRank(CasterActor) >= 1)
	PowerUpBlade()
	CastDeceit()
ENDIF
EndEvent

Function PowerUpBlade(Int PowerUp = 2)
	If CasterActor.HasPerk(ZEB_EbonyBlade_DamagePerk)
		Int KillCount = IncrementKillCount(PowerUp)
		MephalaSpeak(KillCount)
		CheckFinished(KillCount)
	Endif
EndFunction

Function CheckFinished(Int KillCount)
	If (KillCount >= 10)
		CasterActor.RemovePerk(ZEB_EbonyBlade_DamagePerk)
		If DA08.GetStage() == 60
			DA08.SetStage(80)
		EndIf
	Endif
EndFunction

Function MephalaSpeak(Int KillCount)
	If (KillCount % 2 == 0)
		DA08MephalaGrats.Start()
	EndIf
EndFunction

Int Function IncrementKillCount(Int IncVal)
	Int NewKillCount = (ZEB_EbonyBladeKillsGlobal.GetValueInt() + IncVal)
	ZEB_EbonyBladeKillsGlobal.SetValue(NewKillCount)
	(DA08EbonyBladeTracking as DA08EbonyBladeTrackingScript).FriendsKilled = NewKillCount
	return NewKillCount
EndFunction

Function CastDeceit()
	ZEB_EbonyBlade_BloodOfDeceit.Cast(CasterActor, CasterActor)
	ZEB_EbonyBladeBloodVisual.Play(CasterActor)
	AbsorbHealthFXS.Play(CasterActor, 1)
	MAGCloakIn.Play(CasterActor)
	IllusionDarkMassiveImod.ApplyCrossfade(1)
	ImageSpaceModifier.RemoveCrossFade(3)
EndFunction