/obj/item/organ/internal/cyberimp/arm
	name = "arm-mounted implant"
	desc = "You shouldn't see this! Adminhelp and report this as an issue on github!"
	zone = "r_arm"
	slot = "r_arm_device"
	icon_state = "implant-toolkit"
	w_class = 3
	actions_types = list(/datum/action/item_action/organ_action/toggle)

	var/list/items_list = list()
	// Used to store a list of all items inside, for multi-item implants.
	// I would use contents, but they shuffle on every activation/deactivation leading to interface inconsistencies.

	var/obj/item/holder = null
	// You can use this var for item path, it would be converted into an item on New()

/obj/item/organ/internal/cyberimp/arm/New()
	..()
	if(ispath(holder))
		holder = new holder(src)

	update_icon()
	slot = zone + "_device"
	items_list = contents.Copy()

/obj/item/organ/internal/cyberimp/arm/update_icon()
	if(zone == "r_arm")
		transform = null
	else // Mirroring the icon
		transform = matrix(-1, 0, 0, 0, 1, 0)

/obj/item/organ/internal/cyberimp/arm/examine(mob/user)
	..()
	user << "<span class='info'>[src] is assembled in the [zone == "r_arm" ? "right" : "left"] arm configuration. You can use a screwdriver to reassemble it.</span>"

/obj/item/organ/internal/cyberimp/arm/attackby(obj/item/weapon/W, mob/user, params)
	..()
	if(istype(W, /obj/item/weapon/screwdriver))
		if(zone == "r_arm")
			zone = "l_arm"
		else
			zone = "r_arm"
		slot = zone + "_device"
		user << "<span class='notice'>You modify [src] to be installed on the [zone == "r_arm" ? "right" : "left"] arm.</span>"
		update_icon()
	else if(istype(W, /obj/item/weapon/card/emag))
		emag_act()

/obj/item/organ/internal/cyberimp/arm/Remove(mob/living/carbon/M, special = 0)
	Retract()
	..()

/obj/item/organ/internal/cyberimp/arm/emag_act()
	return 0

/obj/item/organ/internal/cyberimp/arm/gun/emp_act(severity)
	if(prob(15/severity))
		owner << "<span class='warning'>[src] is hit by EMP!</span>"
		// give the owner an idea about why his implant is glitching
		Retract()
	..()

/obj/item/organ/internal/cyberimp/arm/proc/Retract()
	if(!holder || (holder in src))
		return

	owner.visible_message("<span class='notice'>[owner] retracts [holder] back into \his [zone == "r_arm" ? "right" : "left"] arm.</span>",
		"<span class='notice'>[holder] snaps back into your [zone == "r_arm" ? "right" : "left"] arm.</span>",
		"<span class='italics'>You hear a short mechanical noise.</span>")

	owner.unEquip(holder, 1)
	holder.loc = src
	holder = null
	playsound(get_turf(owner), 'sound/mecha/mechmove03.ogg', 50, 1)

/obj/item/organ/internal/cyberimp/arm/proc/Extend(var/obj/item/item)
	if(!(item in src))
		return

	holder = item

	holder.flags |= NODROP
	holder.unacidable = 1
	holder.slot_flags = null
	holder.w_class = 5
	holder.materials = null

	var/arm_slot = (zone == "r_arm" ? slot_r_hand : slot_l_hand)
	var/obj/item/arm_item = owner.get_item_by_slot(arm_slot)

	if(arm_item)
		if(!owner.unEquip(arm_item))
			owner << "<span class='warning'>Your [arm_item] interferes with [src]!</span>"
			return
		else
			owner << "<span class='notice'>You drop [arm_item] to activate [src]!</span>"

	if(zone == "r_arm" ? !owner.put_in_r_hand(holder) : !owner.put_in_l_hand(holder))
		owner << "<span class='warning'>Your [src] fails to activate!</span>"
		return

	// Activate the hand that now holds our item.
	if(zone == "r_arm" ? owner.hand : !owner.hand)
		owner.swap_hand()

	owner.visible_message("<span class='notice'>[owner] extends [holder] from \his [zone == "r_arm" ? "right" : "left"] arm.</span>",
		"<span class='notice'>You extend [holder] from your [zone == "r_arm" ? "right" : "left"] arm.</span>",
		"<span class='italics'>You hear a short mechanical noise.</span>")
	playsound(get_turf(owner), 'sound/mecha/mechmove03.ogg', 50, 1)

/obj/item/organ/internal/cyberimp/arm/ui_action_click()
	if(crit_fail || (!holder && !contents.len))
		owner << "<span class='warning'>The implant doesn't respond. It seems to be broken...</span>"
		return

	// You can emag the arm-mounted implant by activating it while holding emag in it's hand.
	var/arm_slot = (zone == "r_arm" ? slot_r_hand : slot_l_hand)
	if(istype(owner.get_item_by_slot(arm_slot), /obj/item/weapon/card/emag) && emag_act())
		return

	if(!holder || (holder in src))
		holder = null
		if(contents.len == 1)
			Extend(contents[1])
		else // TODO: make it similar to borg's storage-like module selection
			var/obj/item/choise = input("Activate which item?", "Arm Implant", null, null) as null|anything in items_list
			if(owner && owner == usr && owner.stat != DEAD && (src in owner.internal_organs) && !holder && istype(choise) && (choise in contents))
				// This monster sanity check is a nice example of how bad input() is.
				Extend(choise)
	else
		Retract()


/obj/item/organ/internal/cyberimp/arm/gun/emp_act(severity)
	if(prob(30/severity) && owner && !crit_fail)
		Retract()
		owner.visible_message("<span class='danger'>A loud bang comes from [owner]\'s [zone == "r_arm" ? "right" : "left"] arm!</span>")
		playsound(get_turf(owner), 'sound/weapons/flashbang.ogg', 100, 1)
		owner << "<span class='userdanger'>You feel an explosion erupt inside your [zone == "r_arm" ? "right" : "left"] arm as your implant breaks!</span>"
		owner.adjust_fire_stacks(20)
		owner.IgniteMob()
		owner.adjustFireLoss(25)
		crit_fail = 1
	else // The gun will still discharge anyway.
		..()


/obj/item/organ/internal/cyberimp/arm/gun/laser
	name = "arm-mounted laser implant"
	desc = "A variant of the arm cannon implant that fires lethal laser beams. The cannon emerges from the subject's arm and remains inside when not in use."
	icon_state = "arm_laser"
	origin_tech = "materials=5;combat=5;biotech=4;powerstorage=4;syndicate=5"//this is kinda nutty and i might lower it
	holder = /obj/item/weapon/gun/energy/laser/mounted

/obj/item/organ/internal/cyberimp/arm/gun/laser/l/zone = "l_arm"


/obj/item/organ/internal/cyberimp/arm/gun/taser
	name = "arm-mounted taser implant"
	desc = "A variant of the arm cannon implant that fires electrodes and disabler shots. The cannon emerges from the subject's arm and remains inside when not in use."
	icon_state = "arm_taser"
	origin_tech = "materials=5;combat=5;biotech=4;powerstorage=4"
	holder = /obj/item/weapon/gun/energy/gun/advtaser/mounted

/obj/item/organ/internal/cyberimp/arm/gun/taser/l/zone = "l_arm"


/obj/item/organ/internal/cyberimp/arm/toolset
	name = "integrated toolset implant"
	desc = "A stripped-down version of engineering cyborg toolset, designed to be installed on subject's arm. Contains all neccessary tools."
	origin_tech = "materials=5;engineering=5;biotech=4;powerstorage=3"
	contents = newlist(/obj/item/weapon/screwdriver/cyborg, /obj/item/weapon/wrench/cyborg, /obj/item/weapon/weldingtool/largetank/cyborg,
		/obj/item/weapon/crowbar/cyborg, /obj/item/weapon/wirecutters/cyborg, /obj/item/device/multitool/cyborg)

/obj/item/organ/internal/cyberimp/arm/toolset/l/zone = "l_arm"

/obj/item/organ/internal/cyberimp/arm/toolset/emag_act()
	if(!(locate(/obj/item/weapon/kitchen/knife/combat/cyborg) in items_list))
		usr << "<span class='notice'>You unlock [src]'s integrated knife!</span>"
		items_list += new /obj/item/weapon/kitchen/knife/combat/cyborg(src)
		return 1
	return 0


//FISTROCKET

/obj/item/organ/internal/cyberimp/fistrocket
	name = "fist rocket implant"
	desc = "A badass implant that lets you fire your fist off of your arm."
	zone = "r_arm"
	slot = "r_arm_device"
	icon_state = "implant-toolkit"//placeholder
	w_class = 3
	actions_types = list(/datum/action/item_action/organ_action)
	var/hasfist = 1

/obj/item/organ/internal/cyberimp/fistrocket/ui_action_click()
	var/mob/living/carbon/H = owner
	if(H.incapacitated())
		H << "<span class='warning'>You can't do that while you're incapacitated.</span>"
		return
	if(!hasfist)
		H << "<span class='warning'>You don't have a fist to shoot off!</span>"
		return
	H.visible_message("<span class='danger'>[H] shoots his fist off of \his arm!</span>", "<b><i>Your fist shoots off of your arm!</i></b>")
	var/obj/item/weapon/rocketfist/fist = new(get_turf(H))
//	var/atom/throw_target = get_edge_target_turf(H, get_dir(src, get_step_away(H, src)))
	var/atom/throw_target = get_edge_target_turf(H, H.dir)
	fist.throw_at_fast(throw_target, 7, 3, spin=0)
	var/obj/item/rocketstump/stump = new(H)
	H.put_in_hands(stump)
	hasfist = 0


/obj/item/weapon/rocketfist
	name = "rocket fist"
	desc = "A metal fist with a thruster on the back."
	icon_state = "rocketfist"//placeholder
	item_state = "bomb"//placeholder
	flags =  CONDUCT
	w_class = 3
	force = 5
	var/thrusters = 1//controls whether or not the throw impact will have the full effect. turns off after the first throw

/obj/item/weapon/rocketfist/throw_impact(atom/hit_atom)
	..()
	if(thrusters && iscarbon(hit_atom))
		thrusters = 0
		var/mob/living/carbon/C = hit_atom
		C.visible_message("<span class='danger'>[C] is knocked down by [src]!</span>", "<span class='userdanger'>[src] violently crashes into you!</span>")
		C.Weaken(3)
		var/armor_block = C.run_armor_check(null, "melee")
		C.apply_damage(40, BRUTE, null, armor_block)
		//when sprites are acquired this part will line will set their icon to remove the flames, signifying the thrusters are out
	else if(thrusters && !iscarbon(hit_atom))
		thrusters = 0
		return

/obj/item/rocketstump
	name = "stump"
	desc = "Without your metal fist, you are left with nothing but an unusable stump."
	icon = 'icons/obj/weapons.dmi'
	icon_state = "stump"//placeholder
	item_state = "bomb"//placeholder
	flags = NODROP | ABSTRACT
	slot_flags = null
	w_class = 5

/obj/item/rocketstump/attackby(obj/item/I, mob/user, params)
	if(istype(I, /obj/item/weapon/rocketfist))
		user << "<span class='notice'>You begin reattaching [I] to your stump...</span>"
		playsound(get_turf(user), 'sound/items/Screwdriver.ogg', 50, 1)
		if(do_after(user, 20, target = src))
			user << "<span class='notice'>You finish reattaching [I].</span>"
			for(var/obj/item/organ/internal/cyberimp/fistrocket/implant in user)//i feel like this isn't the best way to do this
				implant.hasfist = 1
			qdel(I)
			qdel(src)
	else if(istype(I, /obj/item/stack/sheet/metal))
		var/obj/item/stack/sheet/metal/M = I
		if(M.amount < 5)
			user << "<span class='warning'>You need at least five metal sheets to make a new fist!</span>"
			return
		user << "<span class='notice'>You begin making a new fist for your stump...</span>"
		if(do_after(user, 50, target = src))
			M.use(5)
			user << "<span class='notice'>You make a new fist for your stump.</span>"
			for(var/obj/item/organ/internal/cyberimp/fistrocket/implant in user)
				implant.hasfist = 1
			qdel(src)
