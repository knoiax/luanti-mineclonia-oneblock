local modname = "eodp"
local PREFIX = mcl_eodp.prefix.de_papi
local IF_PREFIX = mcl_eodp.prefix.italian_food
local S = minetest.get_translator(modname)

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
    output = PREFIX ..  "raw_pizza",
    recipe = {
        {IF_PREFIX ..  "mozzarella" , IF_PREFIX ..  "mozzarella", IF_PREFIX ..  "mozzarella"}, 
        {IF_PREFIX ..  "tomato_sauce", IF_PREFIX ..  "tomato_sauce", IF_PREFIX ..  "tomato_sauce"}, 
        {IF_PREFIX ..  "dough", IF_PREFIX ..  "dough", IF_PREFIX ..  "dough"}, 
    },
})
core.register_craft({
    output = PREFIX ..  "raw_olive_pizza",
    recipe = {
        {IF_PREFIX ..  "olive", IF_PREFIX ..  "olive", IF_PREFIX ..  "olive"},   
        {"", PREFIX ..  "raw_pizza", ""}, 
        {"", "", ""}, 
    },
})
core.register_craft({
    output = PREFIX ..  "raw_mushroom_pizza",
    recipe = {
        {"mcl_mushrooms:mushroom_brown", "mcl_mushrooms:mushroom_brown", "mcl_mushrooms:mushroom_brown"},   
        {"", PREFIX ..  "raw_pizza", ""}, 
        {"", "", ""}, 
    },
})
core.register_craft({
    output = PREFIX ..  "raw_margherita_pizza",
    recipe = {
        {IF_PREFIX ..  "basil", IF_PREFIX ..  "basil", IF_PREFIX ..  "basil"},   
        {"", PREFIX ..  "raw_pizza", ""}, 
        {"", "", ""}, 
    },
})
core.register_craft({
    output = PREFIX ..  "raw_capricious_egg_pizza",
    recipe = {
        {"mcl_throwing:egg", "mcl_throwing:egg", "mcl_throwing:egg"},   
        {"", PREFIX ..  "raw_pizza", ""}, 
        {"", "", ""}, 
    },
})
core.register_craft({
	type = "cooking",
    output = PREFIX ..  "pizza",
    recipe = PREFIX ..  "raw_pizza",
})
core.register_craft({
	type = "cooking",
    output = PREFIX ..  "olive_pizza",
    recipe = PREFIX ..  "raw_olive_pizza",
})
core.register_craft({
	type = "cooking",
    output = PREFIX ..  "mushroom_pizza",
    recipe = PREFIX ..  "raw_mushroom_pizza",
})
core.register_craft({
	type = "cooking",
    output = PREFIX ..  "margherita_pizza",
    recipe = PREFIX ..  "raw_margherita_pizza",
})
core.register_craft({
	type = "cooking",
    output = PREFIX ..  "capricious_egg_pizza",
    recipe = PREFIX ..  "raw_capricious_egg_pizza",
})
-- Receta para el Cubo de Madera Temporal (para mover agua y de un solo uso)
core.register_craft({
    output = PREFIX .. "temp_wooden_bucket",
    recipe = {
        {"mcl_core:stick", "", "mcl_core:stick"},
        {"", "mcl_core:stick", ""},
    },
})

-- Receta para el Cubo de Piedra Temporal (para mover lava y de un solo uso)
core.register_craft({
    output = PREFIX .. "temp_stone_bucket",
    recipe = {
        {"mcl_core:cobble", "", "mcl_core:cobble"},
        {"", "mcl_core:cobble", ""},
    },
})

-- ====================================================================
-- 1. CUBO DE MADERA TEMPORAL (Especial para Agua / Se quema con Lava)
-- ====================================================================
minetest.register_craftitem(PREFIX .. "temp_wooden_bucket", {
    description = S("Cubo de Madera Temporal"),
    inventory_image = "eodp_wooden_bucket.png",
    wield_image = "eodp_wooden_bucket.png",
    stack_max = 1,
    groups = { not_in_creative_inventory = 1 },
    on_place = function(itemstack, placer, pointed_thing)
        if pointed_thing.type ~= "node" then
            return itemstack
        end

        local pos = pointed_thing.above
        local under_pos = pointed_thing.under
        local node_under = minetest.get_node(under_pos)
        local target_node = minetest.get_node(pos)

        -- Verificar si el espacio está libre para construir
        if not (minetest.registered_nodes[target_node.name] and minetest.registered_nodes[target_node.name].buildable_to) then
            return itemstack
        end

        -- CASO A: Si se usa sobre o cerca de LAVA -> Se calcina y quema al jugador
        if (node_under.name and node_under.name:find("lava")) or (target_node.name and target_node.name:find("lava")) then
            if placer and placer:is_player() then
                local current_hp = placer:get_hp()
                placer:set_hp(current_hp - 4)
                minetest.sound_play("mcl_player_damage", {pos = under_pos, gain = 1.0}, true)
                minetest.chat_send_player(
                    placer:get_player_name(), 
                    "🔥 ¡El cubo de madera se calcinó al contacto con la lava y sufriste quemaduras!"
                )
            end
            itemstack:take_item(1)
            return itemstack
        end

        -- CASO B: Recoger Agua -> Se llena y se convierte en temp_water_bucket
        if node_under.name and node_under.name:find("water") then
            minetest.sound_play("mcl_buckets_fill_water", {pos = under_pos, gain = 0.5}, true)
            minetest.set_node(under_pos, {name = "air"})
            minetest.check_for_falling(under_pos)
            if placer and placer:is_player() then
                minetest.chat_send_player(placer:get_player_name(), "💧 Recogiste agua con el cubo de madera.")
            end
            local filled = ItemStack(PREFIX .. "temp_water_bucket")
            if itemstack:get_count() > 1 then
                itemstack:take_item(1)
                if placer and placer:is_player() then
                    local inv = placer:get_inventory()
                    if inv:room_for_item("main", filled) then inv:add_item("main", filled) else minetest.add_item(placer:get_pos(), filled) end
                end
                return itemstack
            else
                return filled
            end
        end

        return itemstack
    end,
})

-- ====================================================================
-- 2. CUBO DE PIEDRA TEMPORAL (Especial para Lava / Se rompe con Agua)
-- ====================================================================
minetest.register_craftitem(PREFIX .. "temp_stone_bucket", {
    description = S("Cubo de Piedra Temporal"),
    inventory_image = "eodp_stone_bucket.png",
    wield_image = "eodp_stone_bucket.png",
    stack_max = 1,
    groups = { not_in_creative_inventory = 1 },
    on_place = function(itemstack, placer, pointed_thing)
        if pointed_thing.type ~= "node" then
            return itemstack
        end

        local pos = pointed_thing.above
        local under_pos = pointed_thing.under
        local node_under = minetest.get_node(under_pos)
        local target_node = minetest.get_node(pos)

        -- Verificar si el espacio está libre para construir
        if not (minetest.registered_nodes[target_node.name] and minetest.registered_nodes[target_node.name].buildable_to) then
            return itemstack
        end

        -- CASO A: Si se usa sobre o cerca de AGUA -> Las grietas ceden, se rompe y deja 2 adoquines
        if (node_under.name and node_under.name:find("water")) or (target_node.name and target_node.name:find("water")) then
            minetest.set_node(pos, {name = "mcl_core:water_flowing"})
            minetest.sound_play("default_water_footstep", {pos = pos, gain = 0.8}, true)
            
            if placer and placer:is_player() then
                minetest.chat_send_player(
                    placer:get_player_name(), 
                    "💧 ¡El cubo de piedra se hizo añicos! El agua se filtró y dejó trozos de adoquín en el suelo."
                )
            end
            
            minetest.add_item(pos, ItemStack("mcl_core:cobble 2"))
            itemstack:take_item(1)
            return itemstack
        end

        -- CASO B: Recoger Lava -> Se llena y se convierte en temp_lava_bucket o temp_lava_nth_bucket
        if node_under.name and node_under.name:find("lava") then
            local filled_item = (node_under.name:find("nether_lava") or node_under.name == "mcl_nether:nether_lava_source") 
                and (PREFIX .. "temp_lava_nth_bucket") 
                or (PREFIX .. "temp_lava_bucket")

            minetest.sound_play("mcl_buckets_fill_lava", {pos = under_pos, gain = 0.5}, true)
            minetest.set_node(under_pos, {name = "air"})
            minetest.check_for_falling(under_pos)
            if placer and placer:is_player() then
                minetest.chat_send_player(placer:get_player_name(), "🔥 La lava densa sella las grietas del cubo de piedra con éxito.")
            end
            local filled = ItemStack(filled_item)
            if itemstack:get_count() > 1 then
                itemstack:take_item(1)
                if placer and placer:is_player() then
                    local inv = placer:get_inventory()
                    if inv:room_for_item("main", filled) then inv:add_item("main", filled) else minetest.add_item(placer:get_pos(), filled) end
                end
                return itemstack
            else
                return filled
            end
        end

        return itemstack
    end,
})

-- 1. Cubo de Agua Temporal (Solo para cofres de OneBlock)
minetest.register_craftitem(PREFIX .. "temp_water_bucket", {
    description = S("Fragile wooden bucket with water"),
    inventory_image = "eodp_wooden_water_bucket.png",
    wield_image = "eodp_wooden_water_bucket.png",
    stack_max = 1,
    groups = { not_in_creative_inventory = 1 },
    on_place = mcl_eodp.place_temporary_fluid("mcl_core:water_source"),
})

-- 2. Cubo de Lava Temporal (Solo para cofres de OneBlock)
minetest.register_craftitem(PREFIX .. "temp_lava_bucket", {
    description = S("Fragile stone cube with lava"),
    inventory_image = "eodp_stone_lava_bucket.png",
    wield_image = "eodp_stone_lava_bucket.png",
    stack_max = 1,
    groups = { not_in_creative_inventory = 1 },
    on_place = mcl_eodp.place_temporary_fluid("mcl_core:lava_source"),
})

-- 2. Cubo de Lava del Nether Temporal (Solo para cofres de OneBlock)
minetest.register_craftitem(PREFIX .. "temp_lava_nth_bucket", {
    description = S("Fragile stone cube with Nether lava"),
    inventory_image = "eodp_stone_lava_bucket.png",
    wield_image = "eodp_stone_lava_bucket.png",
    stack_max = 1,
    groups = { not_in_creative_inventory = 1 },
    on_place = mcl_eodp.place_temporary_fluid("mcl_nether:nether_lava_source"),
})