Scriptname ZWT_V5_WuuthradScript extends activemagiceffect  

Activator Property ZWT_AshPile auto
EffectShader Property ShockDisintegrate01FXS auto
FormList Property ZWT_ElfRace auto

Event OnEffectStart(Actor akTarget, Actor akCaster)
If ZWT_ElfRace.HasForm(akTarget.GetRace())
	akTarget.Kill()
	akTarget.SetCriticalStage(akTarget.CritStage_DisintegrateStart)

	ShockDisintegrate01FXS.play(akTarget,4)
	Utility.Wait(1.25)     
	akTarget.AttachAshPile(ZWT_AshPile)
	Utility.Wait(1.65)
	ShockDisintegrate01FXS.Stop(akTarget)

	akTarget.SetAlpha (0.0,True)
	akTarget.SetCriticalStage(akTarget.CritStage_DisintegrateEnd)
Endif
EndEvent
