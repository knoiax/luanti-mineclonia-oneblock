-- implementaciones/italian_food.lua
local modname = "eodp_it_f"
local PREFIX = mcl_eodp.prefix.italian_food
local S = minetest.get_translator(modname)

-- Registrar bebidas/alimentos embotellados (retornan botella de vidrio y stack_max = 4)
local function register_bottled_item(name, description, saturation, eat_value, effect_fn)
    minetest.register_craftitem(PREFIX .. name, {
        description = S(description),
        inventory_image = modname .. "_" .. name .. ".png",
        stack_max = 4,
        groups = {food = 3, eatable = eat_value, can_eat_when_full = 1, bottle = 1},
        _mcl_saturation = saturation,
        _mcl_eat_replace_with = "mcl_potions:glass_bottle",
        _mcl_eat_effect = effect_fn,
    })
end

-- Registrar líquidos en balde (retornan balde vacío y stack_max = 1)
local function register_bucket_item(name, description, saturation, eat_value, effect_fn)
    minetest.register_craftitem(PREFIX .. name, {
        description = S(description),
        inventory_image = modname .. "_" .. name .. ".png",
        stack_max = 1,
        groups = {food = 3, eatable = eat_value, can_eat_when_full = 1},
        _mcl_saturation = saturation,
        _mcl_eat_replace_with = "mcl_buckets:bucket_empty",
        _mcl_eat_effect = effect_fn,
    })
end


-- =================================================================
-- ALIMENTOS Y BEBIDAS EMBOTELLADAS (Retornan botella vacía)
-- =================================================================

-- Café
register_bottled_item("coffee", "Coffee", 2.4, 8, function(_, player)
    if player and player:is_player() and mcl_potions then
		-- Opcional: Otorgar un breve efecto de velocidad (speed)
        mcl_potions.give_effect_by_level("swiftness", player, 1, 16, false)
    end
end)

-- Café con azúcar
register_bottled_item("sugar_coffee", "Coffee with Sugar", 3.0, 10, function(_, player)
    if player and player:is_player() and mcl_potions then
		-- Opcional: Otorgar un breve efecto de velocidad (speed)
        mcl_potions.give_effect_by_level("swiftness", player, 1, 25, false)
    end
end)

-- Aceite de oliva
register_bottled_item("olive_oil", "Olive Oil", 1.0, 2)

-- Aceite de girasol
register_bottled_item("sunflowerolio", "Sunflower Oil", 1.0, 2)

-- Salsa de tomate
register_bottled_item("tomato_sauce", "Tomato Sauce", 2.0, 4)

-- Salsa pesto
register_bottled_item("pesto_sauce", "Pesto Sauce", 2.5, 5)

-- =================================================================
-- LÍQUIDOS EN BALDE (Retornan balde de hierro vacío)
-- =================================================================

-- Balde con leche de oveja
register_bucket_item("sheep_milk_bucket", "Sheep Milk Bucket", 8.5, 9, function(_, player)
    if player and player:is_player() and mcl_potions then
        mcl_potions.clear_effects(player)
    end
end)