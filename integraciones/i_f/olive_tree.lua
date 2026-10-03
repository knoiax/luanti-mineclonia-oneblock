-- implementaciones/italian_food.lua
local modname = "eodp_it_f"
local PREFIX = mcl_eodp.prefix.italian_food
local S = minetest.get_translator(modname)
local modpath = minetest.get_modpath(minetest.get_current_modname())

--Creaciones propias
local name = "eodp_"

-- Declaración anticipada del contenedor de lógica del árbol de olivo
local olive_tree = {}

mcl_trees.register_wood("olive", {
    readable_name = "Olive tree",
    tree_schems = {
        { file = modpath .. "/schematics/eodp_it_f_olive_tree_1.mts" },
        { file = modpath .. "/schematics/eodp_it_f_olive_tree_2.mts" },
        { file = modpath .. "/schematics/eodp_it_f_olive_tree_3.mts" },
        { file = modpath .. "/schematics/eodp_it_f_olive_tree_4.mts" },
    },
    tree_schems_2x2 = {
        { file = modpath .. "/schematics/eodp_it_f_olive_tree_giant_1.mts" },
        { file = modpath .. "/schematics/eodp_it_f_olive_tree_giant_2.mts" }
    },
    tree = {
        description = S("Olive Tree Log"),
        tiles = { modname .. "_olive_tree_top.png", modname .. "_olive_tree_top.png", modname .. "_olive_tree.png" }
    },
    leaves = {
        description = S("Olive Tree Leaves"),
        tiles = { modname .. "_olive_leaves.png" }
    },
    stripped = {
        description = S("Stripped Olive Tree Log"),
        tiles = { modname .. "_olive_stripped_top.png", modname .. "_olive_stripped_top.png", modname .. "_olive_stripped.png",}
    },
    stripped_bark = {
        description = S("Stripped Olive Tree Bark"),
        tiles = {modname .. "_olive_stripped.png"},
    },
    wood = {
        description = S("Olive Wood Planks"),
        tiles = { name .. "olive_planks.png" }
    },
    sapling = {
        description = S("Olive Sapling"),
        tiles = { modname .. "_olive_sapling.png" },
        inventory_image = modname .. "_olive_sapling.png",
        wield_image = modname .. "_olive_sapling.png",
    },
    slab = {
        description = S("Olive Wood Slabs"),
        bark = {
            description = S("Olive Bark Slabs")
        }
    },
    bark = {
        description = S("Olive Tree Bark")
    },
    stairs = {
        description = S("Olive Wood Stairs"),
        bark= {
            description = S("Olive Tree Bark Stairs")
        },
    },
    door = {
        description = S("Olive Wood Door"),
		inventory_image = name .. "olive_inventory_door.png",
		tiles_bottom = {name .. "olive_door_lower.png", name .. "olive_door_side_lower.png"},
		tiles_top = {name .. "olive_door_upper.png", name .. "olive_door_side_upper.png"}
	},
    trapdoor = {
        description = S("Olive Wood Trapdoor"),
		tile_front = name .. "olive_trapdoor.png",
		tile_side = name .. "olive_trapdoor_side.png",
		wield_image = name .. "olive_trapdoor.png",
	},
    fence = {
        description = S("Olive Wood Fence"),
        tiles = {name .. "olive_fence.png"},
    },
    fence_gate = {
        description = S("Olive Wood Fence Gate"),
        tiles = {name .. "olive_fence_gate.png"},
    },
    boat = {
        item = {
            description = S("Olive Wood Boat"),
            inventory_image = name .. "olive_wood_boat_inventory.png",
        },
        object = {
            textures = {
                name .. "olive_wood_boat_texture.png",
                "blank.png",
            },
        },
    },
    chest_boat = {
        item = {
            description = S("Olive Wood Boat With Chest"),
            inventory_image = name .. "olive_wood_chest_boat_inventory.png",
        },
        object = {
            textures = {
                name .. "olive_wood_boat_texture.png",
                "mcl_chests_normal.png",
            },
        },
    },
    button = {
        description = S("Olive Wood Button"),
    },
    pressure_plate = {
        description = S("Olive Wood Pressure Plate"),
    },
})

local olive_item = PREFIX .. "olive" 
local leaf_name = "mcl_trees:leaves_olive"
local orphan_leaf_name = "mcl_trees:leaves_olive_orphan"

-- Usamos las mismas probabilidades que las manzanas (a menor número, más probable)
local fruit_chances = {80, 70, 60, 40, 15}

local function inject_olives_to_leaves(node_name)
	local def = minetest.registered_nodes[node_name]
	if not def then return end

	-- Hacemos una copia profunda de las tablas para no afectar otras hojas globales
	local new_drop = table.copy(def.drop)
	local new_fortune = table.copy(def._mcl_fortune_drop or {})

	-- Función auxiliar para insertar la aceituna en el nivel de fortuna correspondiente
	local function inject_drop(drop_table, fortune_level)
		if not drop_table or not drop_table.items then return end
		table.insert(drop_table.items, {
			items = { olive_item },
			rarity = fruit_chances[fortune_level + 1]
		})
	end

	-- 1. Inyectamos en el drop normal (sin fortuna, nivel 0)
	inject_drop(new_drop, 0)

	-- 2. Inyectamos en los 4 niveles de encantamiento de fortuna
	for i = 1, 4 do
		if new_fortune[i] then
			inject_drop(new_fortune[i], i)
		end
	end

	-- 3. Sobrescribimos el nodo en el motor
	minetest.override_item(node_name, {
		drop = new_drop,
		_mcl_fortune_drop = new_fortune
	})
end

-- Ejecutamos la inyección tanto en hojas puestas por jugador como las huérfanas (decay)
inject_olives_to_leaves(leaf_name)
inject_olives_to_leaves(orphan_leaf_name)