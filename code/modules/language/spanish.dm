/datum/language/spanish
	name = "Galactic Uncommon"
	desc = "Rumored to originate from an old Earth language, this language now only exists in the rare, small civilizations outside of Nanotrasen reach."
	speech_verb = "says"
	whisper_verb = "whispers"
	key = "e"//e is for espanol
	flags = TONGUELESS_SPEECH | LANGUAGE_HIDE_ICON_IF_UNDERSTOOD
	default_priority = 100
	space_chance = 70

	icon_state = "spanish"

//Source: http://www.sttmedia.com/syllablefrequency-spanish

/datum/language/spanish/syllables = list(
"ad", "al", "an", "ar", "as", "ci", "co", "de", "do", "el", "en", "er", "es", "ei", "in", "la", "ue", "un",
"lo", "me", "na", "no", "nt", "on", "or", "os", "pa", "qu", "ra", "re", "ro", "se", "st", "ta", "te", "to",
"aci", "ada", "ado", "ant", "ara", "ció", "com", "con", "des", "dos", "ent", "era", "ero", "est", "ido", "ien", "una",
"ier", "ión", "las", "los", "men", "nte", "nto", "par", "per", "por", "que", "res", "sta", "ste", "ten", "tra", "ver")
