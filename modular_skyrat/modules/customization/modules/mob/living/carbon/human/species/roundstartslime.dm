/datum/species/jelly
	species_traits = list(MUTCOLORS,EYECOLOR,NOBLOOD,HAIR,FACEHAIR)
	default_mutant_bodyparts = list("tail" = "None", "snout" = "None", "ears" = "None", "taur" = "None", "wings" = "None")
	mutant_bodyparts = list()
	hair_color = "mutcolor"
	hair_alpha = 160 //a notch brighter so it blends better.

/datum/species/jelly/roundstartslime
	name = "Xenobiological Slime Hybrid"
	id = "slimeperson"
	limbs_id = "slime"
	default_color = "00FFFF"
	say_mod = "says"
	coldmod = 3
	heatmod = 1
	burnmod = 1

/datum/action/innate/slime_change
	name = "Alter Form"
	check_flags = AB_CHECK_CONSCIOUS
	button_icon_state = "alter_form"
	icon_icon = 'modular_skyrat/modules/customization/icons/mob/actions/actions_slime.dmi'
	background_icon_state = "bg_alien"
	var/slime_restricted = TRUE

/datum/action/innate/slime_change/admin
	slime_restricted = FALSE

/datum/action/innate/slime_change/Activate()
	var/mob/living/carbon/human/H = owner
	if(slime_restricted && !isjellyperson(H))
		return
	if(slime_restricted)
		H.visible_message("<span class='notice'>[owner] gains a look of \
		concentration while standing perfectly still.\
		 Their body seems to shift and starts getting more goo-like.</span>",
		"<span class='notice'>You focus intently on altering your body while \
		standing perfectly still...</span>")
	change_form()

/datum/action/innate/slime_change/proc/change_form()
	var/mob/living/carbon/human/H = owner
	var/select_alteration = input(H, "Select what part of your form to alter", "Form Alteration", "cancel") in list("Body Colors","Hair Style", "Facial Hair Style", "Markings", "DNA Specifics", "Cancel")
	if(!select_alteration || select_alteration == "Cancel" || QDELETED(H))
		return
	var/datum/dna/DNA = H.dna
	switch(select_alteration)
		if("Body Colors")
			var/color_choice = input(H, "What color would you like to change?", "Form Alteration", "cancel") in list("Primary", "Secondary", "Tertiary", "All", "Cancel")
			if(!color_choice || color_choice == "Cancel" || QDELETED(H))
				return
			var/color_target
			switch(color_choice)
				if("Primary", "All")
					color_target = "mcolor"
				if("Secondary")
					color_target = "mcolor2"
				if("Tertiary")
					color_target = "mcolor3"
			var/new_mutantcolor = input(H, "Choose your character's new [lowertext(color_choice)] color:", "Form Alteration","#"+DNA.features[color_target]) as color|null
			if(!new_mutantcolor)
				return
			var/marking_reset = alert(H, "Would you like to reset your markings to match your new colors?", "", "Yes", "No")
			var/mutantpart_reset = alert(H, "Would you like to reset your mutant body parts(not limbs) to match your new colors?", "", "Yes", "No")
			if(color_choice == "All")
				DNA.features["mcolor"] = sanitize_hexcolor(new_mutantcolor)
				DNA.features["mcolor2"] = sanitize_hexcolor(new_mutantcolor)
				DNA.features["mcolor3"] = sanitize_hexcolor(new_mutantcolor)
			else
				DNA.features[color_target] = sanitize_hexcolor(new_mutantcolor)
			if(marking_reset && marking_reset == "Yes")
				for(var/zone in DNA.body_markings)
					for(var/key in DNA.body_markings[zone])
						var/datum/body_marking/BD = GLOB.body_markings[key]
						if(BD.always_color_customizable)
							continue
						DNA.body_markings[zone][key] = BD.get_default_color(DNA.features, DNA.species)
				H.icon_render_key = "" //Currently the render key doesnt recognize the markings colors
			if(mutantpart_reset && mutantpart_reset == "Yes")
				H.mutant_renderkey = "" //Just in case
				for(var/mutant_key in DNA.species.mutant_bodyparts)
					var/mutant_list = DNA.species.mutant_bodyparts[mutant_key]
					var/datum/sprite_accessory/SP = GLOB.sprite_accessories[mutant_key][mutant_list[MUTANT_INDEX_NAME]]
					mutant_list[MUTANT_INDEX_COLOR_LIST] = SP.get_default_color(DNA.features, DNA.species)

			H.update_body()
			H.update_hair()
		if("Hair Style")
			var/new_style = input(owner, "Select a hair style", "Hair Alterations")  as null|anything in GLOB.hairstyles_list
			if(new_style)
				H.hairstyle = new_style
				H.update_hair()
		if("Facial Hair Style")
			var/new_style = input(H, "Select a facial hair style", "Hair Alterations")  as null|anything in GLOB.facial_hairstyles_list
			if(new_style)
				H.facial_hairstyle = new_style
				H.update_hair()
		if("Markings")
			var/list/candidates = GLOB.body_marking_sets
			var/chosen_name = input(H, "Select which set of markings would you like to change into", "Marking Alterations")  as null|anything in candidates + "Cancel"
			if(!chosen_name || chosen_name == "Cancel")
				return
			var/datum/body_marking_set/BMS = GLOB.body_marking_sets[chosen_name]
			DNA.species.body_markings = assemble_body_markings_from_set(BMS, DNA.features, DNA.species)
			H.icon_render_key = "" //Just in case
			H.update_body()
		if("DNA Specifics")
			var/dna_alteration = input(H, "Select what part of your DNA you'd like to alter", "DNA Alteration", "cancel") in list("Body Size", "Cancel")
			if(!dna_alteration || dna_alteration == "Cancel")
				return
			switch(dna_alteration)
				if("Body Size")
					var/new_body_size = input(H, "Choose your desired sprite size:\n([BODY_SIZE_MIN*100]%-[BODY_SIZE_MAX*100]%), Warning: May make your character look distorted", "Character Preference", DNA.features["body_size"]*100) as num|null
					if(new_body_size)
						new_body_size = clamp(new_body_size * 0.01, BODY_SIZE_MIN, BODY_SIZE_MAX)
						DNA.features["body_size"] = new_body_size
						DNA.update_body_size()
			H.mutant_renderkey = "" //Just in case
			H.update_mutant_bodyparts()
