/obj/item/organ/teeth
	name = "an abstract teeth holder"
	desc = "You shouldn't see this; report this on github"
	zone = BODY_ZONE_PRECISE_MOUTH
	slot = ORGAN_SLOT_TEETH
	var/teeth = 32//a healthy average human has 32 teeth

/* TODO:
x individual tooth object
- sprites for individual teeth (could have more than 1 for variety)
~ maaaybe make individual teeth stack?
x proc that drops a variable # of teeth objects, overrides dropping the abstract organ
- put teeth in carbons at roundstart
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
	if(!special)//run if the teeth organ is surgically removed/dropped, not if species is changed
		loseteeth(teeth)//lose all teeth
	qdel(src)

/obj/item/organ/teeth/proc/loseteeth(amount = 0)
	if(!amount || !teeth)//fail if youre set to remove none/there are none to remove
		return
	var/toothloc = get_turf(src)
	if(owner)
		toothloc = get_turf(owner)
		to_chat(owner, "Your teeth fall out!")//TODO: spans, better message logic
	for(var/i=1; i<=amount; i++)
		new /obj/item/tooth(toothloc)

