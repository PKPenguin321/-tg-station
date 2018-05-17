/obj/machinery/mineral/ore_distro
	name = "ore distribution machine"
	desc = "A machine that can recieve ore from ORMs and distribute sheets to lathes via invisible bluespace beams."
	icon = 'icons/obj/machines/mining_machines.dmi'
	icon_state = "ore_redemption"//needs a unique sprite
	req_access = list(ACCESS_QM)
	circuit = /obj/item/circuitboard/machine/ore_distro

/obj/machinery/mineral/ore_distro/Initialize()
	. = ..()
	AddComponent(/datum/component/material_container, list(MAT_METAL, MAT_GLASS, MAT_SILVER, MAT_GOLD, MAT_DIAMOND, MAT_PLASMA, MAT_URANIUM, MAT_BANANIUM, MAT_TITANIUM, MAT_BLUESPACE),INFINITY, FALSE, list(/obj/item/stack))

