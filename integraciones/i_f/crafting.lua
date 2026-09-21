local PREFIX = mcl_eodp.prefix.italian_food

core.register_craft({
    output = PREFIX ..  "dough",
    recipe = {
        {"", "mcl_farming:wheat_item", ""}, 
        {"mcl_farming:wheat_item", "mcl_farming:wheat_item", "mcl_farming:wheat_item"},
        {"", "mcl_farming:wheat_item", ""}, 
    },
})
core.register_craft({
    output = PREFIX ..  "pizza",
    recipe = {
        {"", PREFIX ..  "mozzarella", ""}, 
        {PREFIX ..  "tomato_sauce", PREFIX ..  "tomato_sauce", PREFIX ..  "tomato_sauce"}, 
        {PREFIX ..  "dough", PREFIX ..  "dough", PREFIX ..  "dough"}, 
    },
})
core.register_craft({
    output = PREFIX ..  "lasagna",
    recipe = {
        {PREFIX ..  "dough", PREFIX ..  "dough", PREFIX ..  "dough"}, 
        {PREFIX ..  "tomato_sauce", PREFIX ..  "tomato_sauce", PREFIX ..  "tomato_sauce"}, 
        {PREFIX ..  "dough", PREFIX ..  "dough", PREFIX ..  "dough"}, 
    },
})
core.register_craft({
    output = PREFIX ..  "mushroom_pizza",
    recipe = {
        {"", "mcl_mushrooms:mushroom_brown", ""},   
        {"", PREFIX ..  "pizza", ""}, 
        {"", "", ""}, 
    },
})
core.register_craft({
	output = PREFIX ..  "spaghetti",
	recipe = {
        {"", PREFIX ..  "tomato_sauce", ""}, 
        {"", PREFIX ..  "spaghetti_raw", ""}, 
        {"", "", ""}, 
    },
})
core.register_craft({
	output = PREFIX ..  "bruschetta",
	recipe = {
        {"", PREFIX ..  "tomato", ""}, 
        {"", "mcl_farming:bread", ""}, 
        {"", "", ""}, 
    },
})
core.register_craft({
	output = PREFIX ..  "tomato_sauce_bruschetta",
	recipe = {
        {"", PREFIX ..  "tomato_sauce", ""}, 
        {"", PREFIX ..  "bruschetta", ""}, 
        {"", "", ""}, 
    },
})
core.register_craft({
	output = PREFIX ..  "pesto_bruschetta",
	recipe = {
        {"", PREFIX ..  "pesto_sauce", ""}, 
        {"", PREFIX ..  "bruschetta", ""}, 
        {"", "", ""}, 
    },
})
core.register_craft({
    output = PREFIX ..  "tiramisu",
    recipe = {
        {"mcl_cocoas:cocoa_beans", "mcl_core:sugar", "mcl_cocoas:cocoa_beans"},
		{PREFIX ..  "coffee", "mcl_throwing:egg", PREFIX ..  "coffee"},      
        {"", "", ""},
    },
})

core.register_craft({
    output = PREFIX ..  "gnocco_raw",
    recipe = {
        {"", "mcl_farming:potato_item", ""},
        {"mcl_farming:potato_item", "mcl_farming:potato_item", "mcl_farming:potato_item"},      
        {"", "mcl_farming:potato_item", ""},
    },
})

core.register_craft({
    output = PREFIX ..  "tomato_sauce",
    recipe = {
        {"",PREFIX ..  "tomato", ""},
        {"", "mcl_potions:glass_bottle", ""},      
        {"", "", ""},
    },
})
core.register_craft({
    output = PREFIX ..  "pesto_sauce",
    recipe = {
        {"",PREFIX ..  "basil", ""},
        {"", "mcl_potions:glass_bottle", ""},      
        {"", "", ""},
    },
})
core.register_craft({
    output = PREFIX ..  "sunflowerolio",
    recipe = {
        {"","mcl_flowers:sunflower", ""}, 
        {"", "mcl_potions:glass_bottle", ""},     
        {"", "", ""},
    },
})
core.register_craft({
    output = PREFIX ..  "olive_oil",
    recipe = {
        {"",PREFIX ..  "olive", ""}, 
        {"", "mcl_potions:glass_bottle", ""},     
        {"", "", ""},
    },
})
core.register_craft({
    output = PREFIX ..  "coffee",
    recipe = {
        {"",PREFIX ..  "coffee_roasted_bean", ""},
        {"", "mcl_potions:glass_bottle", ""},      
        {"", "", ""},
    },
})
core.register_craft({
    output = PREFIX ..  "sugar_coffee",
    recipe = {
        {"","mcl_core:sugar", ""},
        {"", PREFIX ..  "coffee", ""},      
        {"", "", ""},
    },
})
core.register_craft({
	type = "cooking",
	output = PREFIX ..  "mozzarella",                                 
	recipe = "mcl_mobitems:milk_bucket",
	replacements = {
		{"mcl_mobitems:milk_bucket", "mcl_buckets:bucket_empty"},
	},
})
core.register_craft({
	type = "cooking",
	output = PREFIX ..  "sheep_cheese",                                
	recipe = PREFIX ..  "sheep_milk_bucket",
	replacements = {
		{"mcl_mobitems:milk_bucket", "mcl_buckets:bucket_empty"},
	},
})
core.register_craft({
	type = "cooking",
	output = PREFIX ..  "coffee_roasted_bean",                                
	recipe = PREFIX ..  "coffee_bean",
})
core.register_craft({
    output = PREFIX ..  "ice_cream",
    recipe = {
        {"mcl_core:sugar","mcl_core:ice", "mcl_core:sugar"},
        {"", "mcl_cocoas:cocoa_beans", ""},      
        {"", PREFIX ..  "cone", ""},
    },
})
core.register_craft({
    output = PREFIX ..  "cone",
    recipe = {
        {"","mcl_core:sugar", ""},
        {"", "mcl_mobitems:milk_bucket", ""},      
        {"", "mcl_throwing:egg", ""},
    },
})
core.register_craft({
    output = PREFIX ..  "pandoro",
    recipe = {
        {"","mcl_core:sugar", ""},
        {"", PREFIX ..  "dough", ""},     
        {"", "mcl_throwing:egg", ""},
    },
})
core.register_craft({
    output = PREFIX ..  "panettone",
    recipe = {
        {"","mcl_cocoas:cocoa_beans", ""},
        {"", PREFIX ..  "dough", ""},    
        {"", "mcl_throwing:egg", ""},
    },
})
core.register_craft({
    output = PREFIX ..  "raviolo_raw",
    recipe = {
        {PREFIX ..  "dough", PREFIX ..  "dough", PREFIX ..  "dough"}, 
        {PREFIX ..  "dough", "mcl_mobitems:beef", PREFIX ..  "dough"},
        {PREFIX ..  "dough", PREFIX ..  "dough", PREFIX ..  "dough"}, 
    },
})
core.register_craft({
    output = PREFIX ..  "cannoli",
    recipe = {
        {"","mcl_cocoas:cocoa_beans", ""},
        {"", PREFIX ..  "dough", ""},
        {"", "mcl_throwing:egg", ""},
    },
})
core.register_craft({
    output = PREFIX ..  "diamond_tomato",
    recipe = {
        {"mcl_core:diamondblock","mcl_core:diamondblock", "mcl_core:diamondblock"},
        {"mcl_core:diamondblock", PREFIX ..  "tomato", "mcl_core:diamondblock"},
        {"mcl_core:diamondblock", "mcl_core:diamondblock", "mcl_core:diamondblock"},
    },
})
core.register_craft({
    output = PREFIX ..  "diamond_basil",
    recipe = {
        {"mcl_core:diamondblock","mcl_core:diamondblock", "mcl_core:diamondblock"},
        {"mcl_core:diamondblock", PREFIX ..  "basil", "mcl_core:diamondblock"},
        {"mcl_core:diamondblock", "mcl_core:diamondblock", "mcl_core:diamondblock"},
    },
})

-- non-food items
core.register_craft({
    output = PREFIX ..  "rolling_pin",
    recipe = {
        {"", "mcl_core:stick", ""},
        {"", "mcl_core:stick", ""},
        {"", "mcl_core:stick", ""},
    },
})
core.register_craft({
    output = PREFIX ..  "iron_rolling_pin",
    recipe = {
        {"", "mcl_core:iron_nugget", ""},
        {"", "mcl_core:iron_ingot", ""},
        {"", "mcl_core:iron_nugget", ""},
    },
})
core.register_craft({
    output = PREFIX ..  "pizza_cutter_wheel",
    recipe = {
        {"mcl_core:iron_ingot", "", ""},
        {"", "mcl_core:stick", ""},
        {"", "", "mcl_core:stick"},
    },
})
core.register_craft({
    output = PREFIX ..  "coffee_sack",
    recipe = {
        {"", "mcl_mobitems:string", ""},
        {PREFIX ..  "coffee_roasted_bean", PREFIX ..  "coffee_roasted_bean", PREFIX ..  "coffee_roasted_bean"},
        {PREFIX ..  "coffee_roasted_bean", PREFIX ..  "coffee_roasted_bean", PREFIX ..  "coffee_roasted_bean"},
    }
})

--olive wood stuff
core.register_craft({
	output = PREFIX ..  "olivewood 4",
	recipe = {{PREFIX ..  "olivetree"}},
})

core.register_craft({
	output = PREFIX ..  "olivewood 4",
	recipe = {{PREFIX ..  "stripped_olivetree"}},
})

core.register_craft({
	output = PREFIX ..  "olivewood 3",
	recipe = {{PREFIX ..  "olivetree_bark"}},
})

core.register_craft({
	output = PREFIX ..  "olivewood 3",
	recipe = {{PREFIX ..  "stripped_olivetree_bark"}},
})

core.register_craft({
	output = "mcl_stairs:slab_olivewood 6",
	recipe = {
		{PREFIX ..  "olivewood", PREFIX ..  "olivewood", PREFIX ..  "olivewood"},
	}
})

core.register_craft({
	output = "mcl_stairs:stair_olivewood 4",
	recipe = {
		{PREFIX ..  "olivewood", "", ""},
		{PREFIX ..  "olivewood", PREFIX ..  "olivewood", ""},
		{PREFIX ..  "olivewood", PREFIX ..  "olivewood", PREFIX ..  "olivewood"},
	}
})

core.register_craft({
    output = PREFIX ..  "diamond_tomato",
    recipe = {
        {"mcl_core:diamondblock","mcl_core:diamondblock", "mcl_core:diamondblock"},
        {"mcl_core:diamondblock", PREFIX ..  "tomato", "mcl_core:diamondblock"},
        {"mcl_core:diamondblock", "mcl_core:diamondblock", "mcl_core:diamondblock"},
    },
})
core.register_craft({
    output = PREFIX ..  "diamond_basil",
    recipe = {
        {"mcl_core:diamondblock","mcl_core:diamondblock", "mcl_core:diamondblock"},
        {"mcl_core:diamondblock", PREFIX ..  "basil", "mcl_core:diamondblock"},
        {"mcl_core:diamondblock", "mcl_core:diamondblock", "mcl_core:diamondblock"},
    },
})