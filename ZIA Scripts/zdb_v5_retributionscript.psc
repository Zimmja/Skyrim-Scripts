Scriptname ZDB_V5_RetributionScript extends activemagiceffect  

Weapon Property DA09Dawnbreaker Auto
Weapon Property ZDB_DawnbreakerTwoHanded Auto
Explosion Property ZDB_DawnbreakerPowerExplosion Auto
Keyword Property ImmuneStrongUnrelentingForce Auto
Keyword Property ActorTypeDLC1Boss Auto

Spell Property ZDB_DawnbreakerSpell_StaggerMid Auto
Spell Property ZDB_DawnbreakerSpell_StaggerSmall Auto

MiscObject Property ZDB_DawnbreakerHitMarker Auto

Event OnEffectStart(Actor akTarget, Actor akCaster)
akTarget.PlaceAtMe(ZDB_DawnbreakerPowerExplosion)
akTarget.AddItem(ZDB_DawnbreakerHitMarker)
Int RandomInt = Utility.RandomInt(1,20)
If (RandomInt <= 1) && !(akTarget.HasKeyword(ImmuneStrongUnrelentingForce)) && !(akTarget.HasKeyword(ActorTypeDLC1Boss))
	akCaster.PushActorAway(akTarget, 2) 
Elseif RandomInt <= 8
	akCaster.DoCombatSpellApply(ZDB_DawnbreakerSpell_StaggerMid, akTarget)
Else
	akCaster.DoCombatSpellApply(ZDB_DawnbreakerSpell_StaggerSmall, akTarget)
Endif
EndEvent