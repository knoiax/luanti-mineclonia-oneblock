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

--pizzas
core.register_craft({
    output = PREFIX ..  "pizza_raw",
    recipe = {
        {IF_PREFIX ..  "mozzarella" , IF_PREFIX ..  "mozzarella", IF_PREFIX ..  "mozzarella"}, 
        {IF_PREFIX ..  "tomato_sauce", IF_PREFIX ..  "tomato_sauce", IF_PREFIX ..  "tomato_sauce"}, 
        {IF_PREFIX ..  "dough", IF_PREFIX ..  "dough", IF_PREFIX ..  "dough"}, 
    },
})
core.register_craft({
    output = PREFIX ..  "olive_pizza_raw",
    recipe = {
        {IF_PREFIX ..  "olive", IF_PREFIX ..  "olive", IF_PREFIX ..  "olive"},   
        {"", PREFIX ..  "pizza_raw", ""}, 
        {"", "", ""}, 
    },
})
core.register_craft({
    output = PREFIX ..  "mushroom_pizza_raw",
    recipe = {
        {"mcl_mushrooms:mushroom_brown", "mcl_mushrooms:mushroom_brown", "mcl_mushrooms:mushroom_brown"},   
        {"", PREFIX ..  "pizza_raw", ""}, 
        {"", "", ""}, 
    },
})
core.register_craft({
    output = PREFIX ..  "margherita_pizza_raw",
    recipe = {
        {IF_PREFIX ..  "basil", IF_PREFIX ..  "basil", IF_PREFIX ..  "basil"},   
        {"", PREFIX ..  "pizza_raw", ""}, 
        {"", "", ""}, 
    },
})
core.register_craft({
    output = PREFIX ..  "capricious_egg_pizza_raw",
    recipe = {
        {"mcl_throwing:egg", "mcl_throwing:egg", "mcl_throwing:egg"},   
        {"", PREFIX ..  "pizza_raw", ""}, 
        {"", "", ""}, 
    },
})
core.register_craft({
	type = "cooking",
    output = PREFIX ..  "pizza",
    recipe = PREFIX ..  "pizza_raw",
})
core.register_craft({
	type = "cooking",
    output = PREFIX ..  "olive_pizza",
    recipe = PREFIX ..  "olive_pizza_raw",
})
core.register_craft({
	type = "cooking",
    output = PREFIX ..  "mushroom_pizza",
    recipe = PREFIX ..  "mushroom_pizza_raw",
})
core.register_craft({
	type = "cooking",
    output = PREFIX ..  "margherita_pizza",
    recipe = PREFIX ..  "margherita_pizza_raw",
})
core.register_craft({
	type = "cooking",
    output = PREFIX ..  "capricious_egg_pizza",
    recipe = PREFIX ..  "capricious_egg_pizza_raw",
})

--"mcl_crafting_table:crafting_table"