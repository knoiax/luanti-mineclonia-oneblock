-- implementaciones/italian_food.lua
local modname = "eodp_it_f"
local PREFIX = mcl_eodp.prefix.italian_food
local S = minetest.get_translator(modname)


-- Café con efectos
minetest.register_craftitem(PREFIX .. "coffee", {
    description = S("Coffee"),
    inventory_image = modname .. "_coffee.png",
    groups = {food = 7, eatable = 8},
    _mcl_saturation = 2.4,
    on_place = function(itemstack, user, pointed_thing)
        if user and user:is_player() and mcl_potions then
            mcl_potions.give_effect_by_level("swiftness", user, 1, 16, false)
        end
        return minetest.do_item_eat(8, nil, itemstack, user, pointed_thing)
    end,
    on_secondary_use = function(itemstack, user, pointed_thing)
        if user and user:is_player() and mcl_potions then
            mcl_potions.give_effect_by_level("swiftness", user, 1, 16, false)
        end
        return minetest.do_item_eat(8, nil, itemstack, user, pointed_thing)
    end,
})

minetest.register_craftitem(PREFIX .. "sugar_coffee", {
	description = S("Sugar Coffee"),
	inventory_image = modname .. "_sugar_coffee.png",
	groups = {food = 7, eatable = 8},
	_mcl_saturation = 2.4,
	on_place = function(itemstack, user, pointed_thing)
		if user and user:is_player() then
			mcl_potions.give_effect_by_level("swiftness", user, 1, 16, false)
			mcl_potions.give_effect_by_level("haste", user, 1, 16, false)
		end
		return minetest.do_item_eat(8, nil, itemstack, user, pointed_thing)
	end,
	on_secondary_use = function(itemstack, user, pointed_thing)
		if user and user:is_player() then
			mcl_potions.give_effect_by_level("swiftness", user, 1, 16, false)
			mcl_potions.give_effect_by_level("haste", user, 1, 16, false)
		end
		return minetest.do_item_eat(8, nil, itemstack, user, pointed_thing)
	end,
})