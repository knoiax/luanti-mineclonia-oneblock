local modpath = minetest.get_modpath(minetest.get_current_modname())
local PREFIX = mcl_eodp.prefix.de_papi
local modname = "eodp"
local S = minetest.get_translator(modname)

-- Declaración anticipada del contenedor de lógica del árbol
local Lemon_tree = {}

function Lemon_tree.generate(pos)
    local i = math.random(1, 4)
    local path = modpath .. "/schematics/eodp_lemon_tree_" .. i .. ".mts"
    minetest.set_node(pos, { name = "air" })
    
    -- Ajustamos el origen (pos1) restando la distancia hacia la esquina
    -- Si tu tronco estaba a 3 bloques en X y 3 bloques en Z desde pos1:
    local offset_pos = {
        x = pos.x - 3,
        y = pos.y,     -- Mantener la altura del suelo
        z = pos.z - 3
    }
    return minetest.place_schematic(offset_pos, path, "random", nil, true)
end

-- 1. Madera de limonero (Planks)
minetest.register_node(PREFIX .. "lemonwood", {
    description = S("Lemon Wood Planks"),
    tiles = { modname .. "_lemon_planks.png" },
    is_ground_content = false,
    groups = { handy = 1, axey = 1, building_block = 1, material_wood = 1, flammable = 3 },
    sounds = mcl_sounds.node_sound_wood_defaults(),
})

-- 2. Tronco Descortezado (Stripped Log)
minetest.register_node(PREFIX .. "stripped_lemontree", {
    description = S("Stripped Lemon Tree Log"),
    _doc_items_longdesc = S("The stripped trunk of an Lemon tree."),
    tiles = { modname .. "_lemon_stripped_top.png", modname .. "_lemon_stripped_top.png", modname .. "_lemon_stripped.png" },
    paramtype2 = "facedir",
    on_place = mcl_util.rotate_axis,
    stack_max = 64,
    groups = { handy = 1, axey = 1, tree = 1, flammable = 2, building_block = 1, material_wood = 1 },
    sounds = mcl_sounds.node_sound_wood_defaults(),
    _mcl_blast_resistance = 2,
    _mcl_hardness = 2,
})

-- 3. Tronco de Limonero (Log)
minetest.register_node(PREFIX .. "lemontree", {
    description = S("Lemon Tree Log"),
    _doc_items_longdesc = S("The trunk of an Lemon tree."),
    tiles = { modname .. "_lemon_tree_top.png", modname .. "_lemon_tree_top.png", modname .. "_lemon_tree.png" },
    paramtype2 = "facedir",
    on_place = mcl_util.rotate_axis,
    stack_max = 64,
    groups = { handy = 1, axey = 1, tree = 1, flammable = 2, building_block = 1, material_wood = 1 },
    sounds = mcl_sounds.node_sound_wood_defaults(),
    _mcl_blast_resistance = 2,
    _mcl_hardness = 2,
    _mcl_stripped_variant = PREFIX .. "stripped_lemontree",
})

-- 4. Hojas de Limonero (Leaves)
minetest.register_node(PREFIX .. "lemonleaves", {
    description = S("Lemon Tree Leaves"),
    _doc_items_longdesc = S("Lemon Tree leaves are grown from Lemon trees."),
    drawtype = "allfaces_optional",
    tiles = { modname .. "_lemon_leaves.png" },
    paramtype = "light",
    is_ground_content = false,
    groups = { snappy = 3, leaves = 1, flammable = 2, deco_block = 1 },
    sounds = mcl_sounds.node_sound_leaves_defaults(),
    drop = {
        max_items = 1,
        items = {
            { items = { PREFIX .. "lemonsapling" }, rarity = 20 },
            { items = { PREFIX .. "lemon" }, rarity = 10 },
            { items = { "mcl_core:stick" }, rarity = 5 },
        }
    },
})

-- 5. Brote / Sapling de Limonero
minetest.register_node(PREFIX .. "lemonsapling", {
    description = S("Lemon Sapling"),
    _doc_items_longdesc = S("Grows into an Lemon tree under the right conditions."),
    drawtype = "plantlike",
    tiles = { modname .. "_lemon_sapling.png" },
    inventory_image = modname .. "_lemon_sapling.png",
    wield_image = modname .. "_lemon_sapling.png",
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
            Lemon_tree.generate(pos or pointed_thing.under)
            return true
        end
    end,
})   

-- Crecimiento natural mediante ABM (Mineclonia / Luanti standard)
minetest.register_abm({
    label = "Lemon sapling growth",
    nodenames = { PREFIX .. "lemonsapling" },
    interval = 35,
    chance = 5,
    action = function(pos, node)
        local light = minetest.get_node_light(pos)
        if light and light >= 8 then
            Lemon_tree.generate(pos)
        end
    end,
})