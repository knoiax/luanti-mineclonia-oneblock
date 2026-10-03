local PREFIX = mcl_eodp.prefix.de_papi
local IF_PREFIX = mcl_eodp.prefix.italian_food

-- RECETA DE CRAFTEO DE LIMONADA
core.register_craft({
    output = PREFIX .. "lemonade 4",
    recipe = {
        {PREFIX .. "lemon_fruit", PREFIX .. "lemon_fruit", PREFIX .. "lemon_fruit"},
        {"mcl_potions:water", "mcl_core:ice", "mcl_core:sugar"},
        {"mcl_potions:glass_bottle", "mcl_potions:glass_bottle", "mcl_potions:glass_bottle"},
    },
})

-- RECETA DE CRAFTEO DE MOZZARELLA
core.register_craft({
	output = IF_PREFIX .. "mozzarella",                                 
	recipe = {
		{"mcl_mobitems:milk_bucket", PREFIX .. "lemon_fruit"},
		{"",""},
	},
	replacements = {
		{"mcl_mobitems:milk_bucket", "mcl_buckets:bucket_empty"},
	},
})

-- RECETA DE CRAFTEO DE QUESO DE OVEJA
core.register_craft({
	output = IF_PREFIX .. "sheep_cheese",                                
	recipe = {
		{IF_PREFIX .. "sheep_milk_bucket", PREFIX .. "lemon_fruit"},
		{"",""},
	},
	replacements = {
		{IF_PREFIX .. "sheep_milk_bucket", "mcl_buckets:bucket_empty"},
	},
})

--"mcl_crafting_table:crafting_table"