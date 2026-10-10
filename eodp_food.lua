local modname = "eodp"
local if_modname = "eodp_it_f"
local PREFIX = mcl_eodp.prefix.de_papi
local S = minetest.get_translator(modname)
local IF_PREFIX = mcl_eodp.prefix.italian_food

-- REGISTRO DE ALIMENTOS PROPIOS (ESTÁNDAR MINECLONIA)
minetest.register_craftitem(PREFIX .. "lemon_fruit", {
  description = S("Lemon"),
  _doc_items_longdesc = S("A very acidic fruit, your eyes close, 90% chance of blindness"),
  inventory_image = modname .. "_lemon.png",
  groups = { food = 2, eatable = 10 , compostability = 30},
  _mcl_saturation = 9.5,
  _mcl_eat_effect = function(_, player)
		if math.random() <= 0.9 then
			mcl_potions.give_effect_by_level("blindness", player, 1, 10)
		end
	end
})

minetest.register_craftitem(PREFIX .. "lemonade", {
  description = S("Lemonade"),
  _doc_items_longdesc = S("a refreshing juice could help you resist fire, 40% chance of fire resistance"),
  inventory_image = modname .. "_lemonade.png",
  stack_max = 4, -- Limitado a 4 unidad por casilla (igual que los frascos de agua)
  groups = {brewitem=1, food=3, eatable=5, can_eat_when_full=1, bottle = 1},
  _mcl_eat_replace_with = "mcl_potions:glass_bottle",
  _mcl_saturation = 11.5,
  _mcl_eat_effect = function(_, player)
    if math.random() <= 0.4 then
      mcl_potions.give_effect("fire_resistance", player, 1, 80)
    end
  end
})

-- REGISTRO DE ALIMENTOS ESPECIALES DE DIAMANTE (ESTÁNDAR MINECLONIA)
minetest.register_craftitem(PREFIX .. "diamond_tomato", {
    description = S("Diamond Tomato"),
    _doc_items_longdesc = S("A legendary tomato infused with diamond power. Grants regeneration and resistance."),
    inventory_image = if_modname .. "_diamond_tomato.png",
    groups = { food = 2, eatable = 18, can_eat_when_full = 1, rarity = 2 },
    _mcl_saturation = 20.0,
    _mcl_eat_effect = function(_, placer)
        if placer and placer:is_player() and mcl_potions then
            mcl_potions.give_effect_by_level("regeneration", placer, 2, 30)
            mcl_potions.give_effect_by_level("resistance", placer, 1, 60)
        end
    end,
})

minetest.register_craftitem(PREFIX .. "diamond_basil", {
    description = S("Diamond Basil"),
    _doc_items_longdesc = S("A rare basil leaf infused with diamond power. Grants haste and speed."),
    inventory_image = if_modname .. "_diamond_basil.png",
    groups = { food = 2, eatable = 15, can_eat_when_full = 1, rarity = 2 },
    _mcl_saturation = 10.0,
    _mcl_eat_effect = function(_, placer)
        if placer and placer:is_player() and mcl_potions then
            mcl_potions.give_effect_by_level("haste", placer, 2, 45)
            mcl_potions.give_effect_by_level("swiftness", placer, 2, 45)
        end
    end,
})
minetest.register_craftitem(PREFIX .. "raw_pizza", {
    description = S("Raw Pizza"),
    _doc_items_longdesc = S("An unbaked pizza. It looks extremely filling and rich, but eating it raw causes severe food poisoning."),
    inventory_image = modname .. "_pizza_raw.png",
    groups = { food = 2, eatable = 20, can_eat_when_full = 1, rarity = 2 },
    _mcl_saturation = 30.0,
    _mcl_eat_effect = function(_, placer)
        if placer and placer:is_player() and mcl_potions then
            mcl_potions.give_effect_by_level("slowness", placer, 2, 180)
            mcl_potions.give_effect_by_level("fatigue", placer, 2, 120)
            mcl_potions.give_effect_by_level("poison", placer, 3, 45)
        end
    end,
})
minetest.register_craftitem(PREFIX .. "raw_olive_pizza", {
    description = S("Raw Olive Pizza"),
    _doc_items_longdesc = S("An unbaked pizza. It looks extremely filling and rich, but eating it raw causes severe food poisoning."),
    inventory_image = modname .. "_olive_pizza_raw.png",
    groups = { food = 2, eatable = 20, can_eat_when_full = 1, rarity = 2 },
    _mcl_saturation = 30.0,
    _mcl_eat_effect = function(_, placer)
        if placer and placer:is_player() and mcl_potions then
            mcl_potions.give_effect_by_level("slowness", placer, 3, 180)
            mcl_potions.give_effect_by_level("blindness", placer, 2, 120)
            mcl_potions.give_effect_by_level("poison", placer, 3, 45)
        end
    end,
})
minetest.register_craftitem(PREFIX .. "raw_mushroom_pizza", {
    description = S("Raw Mushroom Pizza"),
    _doc_items_longdesc = S("An unbaked pizza. It looks extremely filling and rich, but eating it raw causes severe food poisoning."),
    inventory_image = modname .. "_mushroom_pizza_raw.png",
    groups = { food = 2, eatable = 20, can_eat_when_full = 1, rarity = 2 },
    _mcl_saturation = 30.0,
    _mcl_eat_effect = function(_, placer)
        if placer and placer:is_player() and mcl_potions then
            mcl_potions.give_effect_by_level("slowness", placer, 2, 180)
            mcl_potions.give_effect_by_level("hunger", placer, 3, 120)
            mcl_potions.give_effect_by_level("poison", placer, 3, 45)
        end
    end,
})
minetest.register_craftitem(PREFIX .. "raw_margherita_pizza", {
    description = S("Raw Margherita Pizza"),
    _doc_items_longdesc = S("An unbaked pizza. It looks extremely filling and rich, but eating it raw causes severe food poisoning."),
    inventory_image = modname .. "_margherita_pizza_raw.png",
    groups = { food = 2, eatable = 20, can_eat_when_full = 1, rarity = 2 },
    _mcl_saturation = 30.0,
    _mcl_eat_effect = function(_, placer)
        if placer and placer:is_player() and mcl_potions then
            mcl_potions.give_effect_by_level("fatigue", placer, 3, 180)
            mcl_potions.give_effect_by_level("blindness", placer, 2, 120)
            mcl_potions.give_effect_by_level("poison", placer, 3, 45)
        end
    end,
})
minetest.register_craftitem(PREFIX .. "raw_capricious_egg_pizza", {
    description = S("Raw Capricious Egg Pizza"),
    _doc_items_longdesc = S("An unbaked pizza. It looks extremely filling and rich, but eating it raw causes severe food poisoning."),
    inventory_image = modname .. "_capricious_egg_pizza_raw.png",
    groups = { food = 2, eatable = 20, can_eat_when_full = 1, rarity = 2 },
    _mcl_saturation = 30.0,
    _mcl_eat_effect = function(_, placer)
        if placer and placer:is_player() and mcl_potions then
            mcl_potions.give_effect_by_level("fatigue", placer, 2, 180)
            mcl_potions.give_effect_by_level("hunger", placer, 3, 120)
            mcl_potions.give_effect_by_level("poison", placer, 3, 45)
        end
    end,
})

-- 3. Olive Pizza Slice
mcl_eodp.register_food_item(
    PREFIX .. "olive_pizza_slice",
    S("Olive Pizza Slice"),
    modname .. "_olive_pizza.png",
    12.0, 10, 60,
    function(_, placer)
        if placer and placer:is_player() and mcl_potions then
            mcl_potions.give_effect_by_level("regeneration", placer, 2, 180)
            mcl_potions.give_effect_by_level("resistance", placer, 3, 120)
        end
    end
)

-- 4. Margherita Pizza Slice
mcl_eodp.register_food_item(
    PREFIX .. "margherita_pizza_slice",
    S("Margherita Pizza Slice"),
    modname .. "_margherita_pizza.png",
    12.0, 10, 60,
    function(_, placer)
        if placer and placer:is_player() and mcl_potions then
            mcl_potions.give_effect_by_level("regeneration", placer, 2, 180)
            mcl_potions.give_effect_by_level("strength", placer, 3, 120)
        end
    end
)

-- 5. Capricious Egg Pizza Slice
mcl_eodp.register_food_item(
    PREFIX .. "capricious_egg_pizza_slice",
    S("Capricious Egg Pizza Slice"),
    modname .. "_capricious_egg_pizza.png",
    12.0, 10, 60,
    function(_, placer)
        if placer and placer:is_player() and mcl_potions then
            mcl_potions.give_effect_by_level("regeneration", placer, 2, 180)
            mcl_potions.give_effect_by_level("leaping", placer, 3, 120)
        end
    end
)
-- 1. Pizza Clásica (Italian Food)
mcl_eodp.register_pizza_family("pizza", S("Pizza"), IF_PREFIX .. "pizza_slice", PREFIX)

-- 2. Mushroom Pizza (Italian Food)
mcl_eodp.register_pizza_family("mushroom_pizza", S("Mushroom Pizza"), IF_PREFIX .. "mushroom_pizza_slice", PREFIX)

-- 3. Olive Pizza (Mod principal)
mcl_eodp.register_pizza_family("olive_pizza", S("Olive Pizza"), PREFIX .. "olive_pizza_slice", PREFIX)

-- 4. Margherita Pizza (Mod principal)
mcl_eodp.register_pizza_family("margherita_pizza", S("Margherita Pizza"), PREFIX .. "margherita_pizza_slice", PREFIX)

-- 5. Capricious Egg Pizza (Mod principal)
mcl_eodp.register_pizza_family("capricious_egg_pizza", S("Capricious Egg Pizza"), PREFIX .. "capricious_egg_pizza_slice", PREFIX)


