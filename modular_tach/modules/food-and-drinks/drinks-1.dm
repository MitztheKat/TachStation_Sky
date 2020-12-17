/datum/reagent/consumable/milkshake
	name = "Milkshake"
	description = "Milkshake! makes you crave a truck burger 'n' heap of fries."
	color = "#DFDFDF"
	taste_description = "sweet and sugary milk"
	glass_icon_state = "milkshake"
	glass_name = "Milkshake"
	glass_desc = "Milkshake! makes you crave a truck burger 'n' heap of fries."
	
/datum/chemical_reaction/milkshake
	name = "Milkshake"
	id = "milkshake"
	results = list(/datum/reagent/consumable/milkshake = 15)
	required_reagents = list(/datum/reagent/consumable/milk = 5, /datum/reagent/consumable/ice = 5, /datum/reagent/consumable/cream = 5)
	
	
/datum/reagent/consumable/shirley_temple
	name = "Shirley Temple"
	description = "Space-up, Grenadine, and Orange Juice."
	color = "#FFE48C"
	taste_description = "Sweet tonic cherries"
	glass_icon_state = "shirleytempleglass"
	glass_name = "Shirley Temple"
	glass_desc = "Reminds you of the days restaurants served this to kids..."
	
/datum/chemical_reaction/shirleytemple
	name = "Shirley Temple"
	id = "shirleytemple"
	results = list(/datum/reagent/consumable/shirleytemple = 5)
	required_reagents = list(/datum/reagent/consumable/space_up = 2, /datum/reagent/consumable/orangejuice = 2, /datum/reagent/consumable/grenadine = 1)
	