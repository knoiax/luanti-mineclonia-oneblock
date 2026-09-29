-- implementaciones/italian_food.lua
local modname = "eodp_it_f"
local PREFIX = mcl_eodp.prefix.italian_food
local S = minetest.get_translator(modname)
local modpath = minetest.get_modpath(minetest.get_current_modname())

-- Declaración anticipada del contenedor de lógica del árbol de olivo
local olive_tree = {}

mcl_trees.register_wood("olive", {
    readable_name = "Olive",
    tree_schems = {
        { file = modpath .. "/schematics/eodp_it_f_olive_tree_1.mts" },
        { file = modpath .. "/schematics/eodp_it_f_olive_tree_2.mts" },
        { file = modpath .. "/schematics/eodp_it_f_olive_tree_3.mts" },
        { file = modpath .. "/schematics/eodp_it_f_olive_tree_4.mts" },
    },
    tree_schems_2x2 = {
        { file = modpath .. "/schematics/olive_tree_giant_1.mts" },
        { file = modpath .. "/schematics/olive_tree_giant_2.mts" }
    },
    tree = {
        tiles = { modname .. "_olive_tree_top.png", modname .. "_olive_tree_top.png", modname .. "_olive_tree.png" }
    },
    leaves = {
        tiles = { modname .. "_olive_leaves.png" }
    },
    wood = {
        tiles = { modname .. "_planks.png" }
    },
    sapling = {
        tiles = { modname .. "_olive_sapling.png" },
        inventory_image = modname .. "_olive_sapling.png",
        wield_image = modname .. "_olive_sapling.png",
    }
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