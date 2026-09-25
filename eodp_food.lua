local modname = "eodp"
local if_modname = "eodp_it_f"
local PREFIX = mcl_eodp.prefix.de_papi
local S = minetest.get_translator(modname)

-- REGISTRO DE ALIMENTOS PROPIOS (ESTÁNDAR MINECLONIA)
minetest.register_craftitem(PREFIX .. "lemon", {
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
    groups = { food = 2, eatable = 20, can_eat_when_full = 1, rarity = 2 },
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
    groups = { food = 2, eatable = 10, can_eat_when_full = 1, rarity = 2 },
    _mcl_saturation = 10.0,
    _mcl_eat_effect = function(_, placer)
        if placer and placer:is_player() and mcl_potions then
            mcl_potions.give_effect_by_level("haste", placer, 2, 45)
            mcl_potions.give_effect_by_level("swiftness", placer, 2, 45)
        end
    end,
})