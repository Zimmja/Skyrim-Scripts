Scriptname ZIA_V5_QuestAdd extends Quest  

Spell Property SpellToAdd Auto
Perk Property PerkToAdd Auto

Event OnInit()
	IF SpellToAdd
		Game.GetPlayer().AddSpell(SpellToAdd, False)
	ENDIF
	IF PerkToAdd 
		Game.GetPlayer().AddPerk(PerkToAdd)
	ENDIF
	Stop()
EndEvent