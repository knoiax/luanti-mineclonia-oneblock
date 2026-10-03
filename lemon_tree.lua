local modpath = minetest.get_modpath(minetest.get_current_modname())
local PREFIX = mcl_eodp.prefix.de_papi
local modname = "eodp"
local S = minetest.get_translator(modname)

-- Declaración anticipada del contenedor de lógica del árbol
local Lemon_tree = {}


mcl_trees.register_wood("lemon", {
    readable_name = "Lemon tree",
    tree_schems = {
        { file = modpath .. "/schematics/eodp_lemon_tree_1.mts" },
        { file = modpath .. "/schematics/eodp_lemon_tree_2.mts" },
        { file = modpath .. "/schematics/eodp_lemon_tree_3.mts" },
        { file = modpath .. "/schematics/eodp_lemon_tree_4.mts" },
    },
    tree = {
        description = S("Lemon Tree Log"),
        tiles = {modname .. "_lemon_tree_top.png", modname .. "_lemon_tree_top.png", modname .. "_lemon_tree.png" }
    },
    leaves = {
        description = S("Lemon Tree Leaves"),
        tiles = {modname .. "_lemon_leaves.png" }
    },
    stripped = {
        description = S("Stripped Lemon Tree Log"),
        tiles = {modname .. "_lemon_stripped_top.png", modname .. "_lemon_stripped_top.png", modname .. "_lemon_stripped.png",}
    },
    stripped_bark = {
        description = S("Stripped Lemon Tree Bark"),
        tiles = {modname .. "_lemon_stripped.png"},
    },
    wood = {
        description = S("Lemon Wood Planks"),
        tiles = {modname .. "_lemon_planks.png" }
    },
    sapling = {
        description = S("Lemon Sapling"),
        tiles = {modname .. "_lemon_sapling.png" },
        inventory_image = modname .. "_lemon_sapling.png",
        wield_image = modname .. "_lemon_sapling.png",
    },
    slab = {
        description = S("Lemon Wood Slabs"),
        bark = {
            description = S("Lemon Bark Slabs")
        }
    },
    bark = {
        description = S("Lemon Tree Bark")
    },
    stairs = {
        description = S("Lemon Wood Stairs"),
        bark= {
            description = S("Lemon Tree Bark Stairs")
        },
    },
    door = {
        description = S("Lemon Wood Door"),
		inventory_image = modname .. "_lemon_inventory_door.png",
		tiles_bottom = {modname .. "_lemon_door_lower.png", modname .. "_lemon_door_side_lower.png"},
		tiles_top = {modname .. "_lemon_door_upper.png", modname .. "_lemon_door_side_upper.png"}
	},
    trapdoor = {
        description = S("Lemon Wood Trapdoor"),
		tile_front = modname .. "_lemon_trapdoor.png",
		tile_side = modname .. "_lemon_trapdoor_side.png",
		wield_image = modname .. "_lemon_trapdoor.png",
	},
    fence = {
        description = S("Lemon Wood Fence"),
        tiles = {modname .. "_lemon_fence.png"},
    },
    fence_gate = {
        description = S("Lemon Wood Fence Gate"),
        tiles = {modname .. "_lemon_fence_gate.png"},
    },
    boat = {
        item = {
            description = S("Lemon Wood Boat"),
            inventory_image = modname .. "_lemon_wood_boat_inventory.png",
        },
        object = {
            textures = {
                modname .. "_lemon_wood_boat_texture.png",
                "blank.png",
            },
        },
    },
    chest_boat = {
        item = {
            description = S("Lemon Wood Boat With Chest"),
            inventory_image = modname .. "_lemon_wood_chest_boat_inventory.png",
        },
        object = {
            textures = {
                modname .. "_lemon_wood_boat_texture.png",
                "mcl_chests_normal.png",
            },
        },
    },
    button = {
        description = S("Lemon Wood Button"),
    },
    pressure_plate = {
        description = S("Lemon Wood Pressure Plate"),
    },
})

local lemon_item = PREFIX .. "lemon_fruit" 
local leaf_name = "mcl_trees:leaves_lemon"
local orphan_leaf_name = "mcl_trees:leaves_lemon_orphan"

-- Usamos las mismas probabilidades que las manzanas (a menor número, más probable)
local fruit_chances = {90, 80, 70, 50, 20}

local function inject_lemons_to_leaves(node_name)
	local def = minetest.registered_nodes[node_name]
	if not def then return end

	-- Hacemos una copia profunda de las tablas para no afectar otras hojas globales
	local new_drop = table.copy(def.drop)
	local new_fortune = table.copy(def._mcl_fortune_drop or {})

	-- Función auxiliar para insertar la aceituna en el nivel de fortuna correspondiente
	local function inject_drop(drop_table, fortune_level)
		if not drop_table or not drop_table.items then return end
		table.insert(drop_table.items, {
			items = { lemon_item },
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
inject_lemons_to_leaves(leaf_name)
inject_lemons_to_leaves(orphan_leaf_name)