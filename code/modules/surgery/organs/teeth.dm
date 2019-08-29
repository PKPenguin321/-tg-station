/obj/item/organ/teeth
	name = "an abstract teeth holder"
	desc = "You shouldn't see this; report this on github"
	zone = BODY_ZONE_PRECISE_MOUTH
	slot = ORGAN_SLOT_TEETH
	var/teeth = 32//a healthy average human has 32 teeth

/* TODO:
- individual tooth object
- sprites for individual teeth (could have more than 1 for variety)
- maaaybe make individual teeth stack?
- proc that drops a variable # of teeth objects, overrides dropping the abstract organ
- surgery that puts teeth back in, increments var/teeth by 1 (or by a variable amount?)
- scale eating speed to number of teeth
- heavy damage to the head (or mouth if targetted?) knocks out teeth
- boxing knocks out teeth
- missing most of your teeth replaces "s"s with "th" (mike tyson)
- a necklace you can make out of teeth
- grind teeth for calcium (also make a calcium reagent)
- refactor tooth pill implants
*/

/obj/item/tooth
	name = "tooth"
	desc = "A tooth, probably from somebody's mouth. Yuck."
	force = 1
	throwforce = 1
	attack_verb = list("scraped", "jabbed", "gnawed")
	//icon = TODO

/obj/item/organ/tongue/Remove(mob/living/carbon/M, special = 0)
	..()
	for(var/i=1; i<=teeth; i++)
		new /obj/item/tooth(M.loc)
	qdel(src)

