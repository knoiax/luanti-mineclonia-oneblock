-- implementaciones/italian_food.lua
local modname = "eodp_it_f"
local PREFIX = mcl_eodp.prefix.italian_food
local S = minetest.get_translator(modname)
local modpath = minetest.get_modpath(minetest.get_current_modname())

-- 1. Madera de Olivo (Planks)
minetest.register_node(PREFIX .. "olivewood", {
    description = S("Olive Wood Planks"),
    tiles = { modname .. "_planks.png" },
    is_ground_content = false,
    groups = { handy = 1, axey = 1, building_block = 1, material_wood = 1, flammable = 3 },
    sounds = mcl_sounds.node_sound_wood_defaults(),
})

-- 2. Tronco de Olivo (Log)
minetest.register_node(PREFIX .. "olivetree", {
    description = S("Olive Tree Log"),
    _doc_items_longdesc = S("The trunk of an olive tree."),
    tiles = { modname .. "_olive_tree_top.png", modname .. "_olive_tree_top.png", modname .. "_olive_tree.png" },
    paramtype2 = "facedir",
    on_place = mcl_util.rotate_axis,
    stack_max = 64,
    groups = { handy = 1, axey = 1, tree = 1, flammable = 2, building_block = 1, material_wood = 1 },
    sounds = mcl_sounds.node_sound_wood_defaults(),
    _mcl_blast_resistance = 2,
    _mcl_hardness = 2,
    _mcl_stripped_variant = PREFIX .. "stripped_olivetree",
})

-- 3. Tronco Descortezado (Stripped Log)
minetest.register_node(PREFIX .. "stripped_olivetree", {
    description = S("Stripped Olive Tree Log"),
    _doc_items_longdesc = S("The stripped trunk of an olive tree."),
    tiles = { modname .. "_olive_stripped_top.png", modname .. "_olive_stripped_top.png", modname .. "_olive_stripped.png" },
    paramtype2 = "facedir",
    on_place = mcl_util.rotate_axis,
    stack_max = 64,
    groups = { handy = 1, axey = 1, tree = 1, flammable = 2, building_block = 1, material_wood = 1 },
    sounds = mcl_sounds.node_sound_wood_defaults(),
    _mcl_blast_resistance = 2,
    _mcl_hardness = 2,
})

-- 4. Hojas de Olivo (Leaves)
minetest.register_node(PREFIX .. "oliveleaves", {
    description = S("Olive Tree Leaves"),
    _doc_items_longdesc = S("Olive Tree leaves are grown from olive trees."),
    drawtype = "allfaces_optional",
    tiles = { modname .. "_olive_leaves.png" },
    paramtype = "light",
    is_ground_content = false,
    groups = { snappy = 3, leaves = 1, flammable = 2, deco_block = 1 },
    sounds = mcl_sounds.node_sound_leaves_defaults(),
    drop = {
        max_items = 1,
        items = {
            { items = { PREFIX .. "olivesapling" }, rarity = 20 },
            { items = { PREFIX .. "olive" }, rarity = 10 },
            { items = { "mcl_core:stick" }, rarity = 5 },
        }
    },
})

-- 5. Brote / Sapling de Olivo
minetest.register_node(PREFIX .. "olivesapling", {
    description = S("Olive Sapling"),
    _doc_items_longdesc = S("Grows into an olive tree under the right conditions."),
    drawtype = "plantlike",
    tiles = { modname .. "_olive_sapling.png" },
    inventory_image = modname .. "_olive_sapling.png",
    wield_image = modname .. "_olive_sapling.png",
    paramtype = "light",
    sunlight_propagates = true,
    walkable = false,
    selection_box = {
        type = "fixed",
        fixed = {-4/16, -0.5, -4/16, 4/16, 0.5, 4/16},
    },
    groups = { snappy = 3, sapling = 1, dig_immediate = 3, plant = 1, attached_node = 1, deco_block = 1 },
    sounds = mcl_sounds.node_sound_leaves_defaults(),
    
    -- Integración Nativa con Polvo de Hueso (Mineclonia)
    _on_bone_meal = function(itemstack, placer, pointed_thing, pos, node)
        if math.random() <= 0.45 then -- 45% de probabilidad de crecer al aplicar polvo de hueso
            olive_tree.generate(pos or pointed_thing.under)
            return true
        end
    end,
})   

-- 6. Lógica de crecimiento del Esquemático de Olivo
local olive_tree = {}   

function olive_tree.generate(pos)
    local i = math.random(1, 3)
    local path = modpath .. "/schematics/eodp_it_f_olive_tree_" .. i .. ".mts"
    minetest.set_node(pos, { name = "air" })
    return minetest.place_schematic(pos, path, "random", nil, true)
end   

-- Crecimiento natural mediante ABM (Mineclonia / Luanti standard)
minetest.register_abm({
    label = "Olive sapling growth",
    nodenames = { PREFIX .. "olivesapling" },
    interval = 35,
    chance = 5,
    action = function(pos, node)
        local light = minetest.get_node_light(pos)
        if light and light >= 8 then
            olive_tree.generate(pos)
        end
    end,
})