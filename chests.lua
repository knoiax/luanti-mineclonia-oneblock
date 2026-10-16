-- chest.lua
local chests = {}
local PREFIX = mcl_eodp.prefix.de_papi
local IF_PREFIX = mcl_eodp.prefix.italian_food

minetest.override_item("mcl_chests:chest_small", {
    drop = "",
    on_metadata_inventory_take = function(pos, listname, index, stack, player)
        local meta = minetest.get_meta(pos)
        local inv = meta:get_inventory()
        if inv:is_empty("main") then
            minetest.set_node(pos, {name = "mcl_core:dirt_with_grass"})
        end
    end,
})

minetest.override_item("mcl_chests:chest", {
    drop = "",
    on_metadata_inventory_take = function(pos, listname, index, stack, player)
        local meta = minetest.get_meta(pos)
        local inv = meta:get_inventory()
        if inv:is_empty("main") then
            minetest.set_node(pos, {name = "mcl_core:dirt_with_grass"})
        end
    end,
})

-- ====================================================================
-- TABLAS GLOBALES DE COFRES POR DIMENSIÓN
-- ====================================================================
chests.global_ow_chests_content = {
    standard = {
        { name = "mcl_core:apple", count = {min = 1, max = 3}, chance = 0.6 },
        { name = "mcl_core:cobweb", count = {min = 1, max = 5}, chance = 0.6 },
        { name = "mcl_core:ice", count = {min = 1, max = 5}, chance = 0.6 },
        { name = "mcl_tools:sword_gold_enchanted", count = 1, chance = 0.4 },
        { name = "mcl_tools:sword_stone", count = 1, chance = 0.4 },
        { name = "mcl_tools:axe_stone", count = 1, chance = 0.4 },
        { name = "mcl_bows:bow", count = 1, chance = 0.4 },
        { name = "mcl_bows:arrow", count = {min = 1, max = 9}, chance = 0.4 },
        { name = "mcl_mobitems:nametag", count = {min = 1, max = 4}, chance = 0.6 },
        { name = "mcl_mobitems:rotten_flesh", count = 1, chance = 0.4 },
        { name = "mcl_mobitems:saddle", count = 1, chance = 0.4 },

    },
    special = {
        { name = "mcl_bows:bow_enchanted", count = 1, chance = 0.4 },
        { name = "mcl_potions:weaving_arrow", count = {min = 1, max = 4}, chance = 0.4 },
        { name = "mcl_tools:axe_iron", count = 1, chance = 0.4 },
        { name = "mcl_farming:bread", count = 1, chance = 0.4 },
        { name = PREFIX .. "temp_water_bucket", count = 1, chance = 0.3 },
        { name = PREFIX .. "temp_lava_bucket", count = 1, chance = 0.15 },
    }
}

chests.global_nth_chests_content = {
    standard = {
        { name = "mcl_tools:sword_iron", count = 1, chance = 0.4 },
        { name = "mcl_mobitems:nametag", count = {min = 1, max = 4}, chance = 0.6 },
        { name = "mcl_tools:axe_iron", count = {min = 1, max = 3}, chance = 0.4 },

    },
    special = {
        { name = "mcl_tools:axe_iron_enchanted", count = 1, chance = 0.4 },
        { name = "mcl_tools:sword_iron_enchanted", count = 1, chance = 0.4 },
        { name = PREFIX .. "temp_lava_nth_bucket", count = 1, chance = 0.15 },
    }
}

chests.global_end_chests_content = {
    standard = {
        -- Ítems estándar globales del End
    },
    special = {}
}

-- Definición de tablas de botín por fase o nivel de progresión
chests.loot_tables = {
    [1] = {
        description = "Cofre Fase 1: Básicos de Supervivencia",
        standard = {
            { name = "mcl_farming:wheat_seeds", count = {min = 1, max = 3}, chance = 0.5 },
            { name = "mcl_core:stone", count = {min = 1, max = 4}, chance = 0.4 },
            { name = "mcl_flowers:dandelion", count = 1, chance = 0.6 },
            { name = "mcl_flowers:poppy", count = 1, chance = 0.2 },
            { name = "mcl_tools:axe_wood", count = 1, chance = 0.2 },
            { name = "mcl_tools:pick_wood", count = 1, chance = 0.2 },
            { name = "mcl_mangrove:propagule_clay", count = 1, chance = 0.3 },
            { name = "mcl_mobitems:gunpowder", count = {min = 1, max = 5}, chance = 0.6 },
            { name = "mcl_mobitems:string", count = {min = 1, max = 4}, chance = 0.6 },
            { name = "mcl_trees:sapling_oak", count = {min = 1, max = 4}, chance = 0.3 },
            { name = "mcl_trees:sapling_birch", count = {min = 1, max = 4}, chance = 0.3 },
            { name = "mcl_trees:sapling_dark_oak", count = {min = 1, max = 4}, chance = 0.3 },


        },
        special = {
            { name = "mcl_core:carrot", count = {min = 1, max = 2}, chance = 0.6 },
            { name = "mcl_tools:axe_gold", count = 1, chance = 0.5 },
            { name = "mcl_tools:sword_gold", count = 1, chance = 0.5 },
            { name = "mcl_tools:pick_gold", count = 1, chance = 0.4 },
            { name = "mcl_farming:hoe_gold_enchanted", count = 1, chance = 0.4 },
            { name = "mcl_farming:melon_seeds", count = {min = 1, max = 3}, chance = 0.3 },
            { name = "mcl_farming:pumpkin_seeds", count = {min = 1, max = 3}, chance = 0.3 },
            { name = PREFIX .. "lemon_fruit", count = {min = 1, max = 3}, chance = 0.2 },
            { name = IF_PREFIX ..  "basil", count = {min = 1, max = 3}, chance = 0.2 },
        },

    },
    [2] = {
        description = "Cofre Fase 2: Intermedios de supervivencia",
        standard = {
            { name = "mcl_core:iron_nugget", count = {min = 1, max = 2}, chance = 0.4 },
            { name = "mcl_farming:carrot", count = {min = 1, max = 3}, chance = 0.4 },
            { name = "mcl_core:coal_lump", count = {min = 2, max = 4}, chance = 0.5 },
            { name = "mcl_farming:melon_seeds", count = {min = 1, max = 3}, chance = 0.2 },
            { name = "mcl_farming:pumpkin_seeds", count = {min = 1, max = 3}, chance = 0.2 },
            { name = "mcl_core:stone", count = {min = 3, max = 7}, chance = 0.2 },
            { name = IF_PREFIX ..  "basil", count = {min = 1, max = 3}, chance = 0.2 },

        },
        special = {
            { name = "mcl_tools:axe_iron", count = 1, chance = 0.3 },
            { name = "mcl_tools:axe_gold_enchanted", count = 1, chance = 0.4 },
            { name = "mcl_tools:pick_gold_enchanted", count = 1, chance = 0.4 },
            { name = IF_PREFIX ..  "tomato", count = {min = 1, max = 3}, chance = 0.2 },
            { name = IF_PREFIX ..  "lasagna", count = 1, chance = 0.2 },
            { name = "mcl_potions:wind_charged_arrow", count = {min = 1, max = 3}, chance = 0.4 },
        },
    },
    [3] = {
        description = "Cofre Fase 3: Minerales Iniciales",
        standard = {
            { name = "mcl_core:iron_nugget", count = {min = 1, max = 2}, chance = 0.4 },
            { name = "mcl_farming:carrot", count = {min = 1, max = 3}, chance = 0.4 },
            { name = "mcl_core:coal_lump", count = {min = 2, max = 4}, chance = 0.6 },
        },
        special = {
            { name = "mcl_potions:wind_charged_arrow", count = {min = 1, max = 3}, chance = 0.4 },
            { name = IF_PREFIX ..  "sugar_coffee", count = {min = 1, max = 3}, chance = 0.4 },
            { name = "mcl_dripstone:pointed_dripstone", count = 1, chance = 0.6 },
        },
    },
    [4] = {
        description = "Cofre Fase 4: Minerales Intermedios",
        standard = {
            { name = "mcl_core:iron_ingot", count = {min = 1, max = 3}, chance = 0.4 },
            { name = "mcl_farming:betroot", count = {min = 1, max = 3}, chance = 0.4 },
            { name = "mcl_farming:potato", count = {min = 1, max = 3}, chance = 0.4 },
            { name = "mcl_core:coal_lump", count = {min = 2, max = 4}, chance = 0.6 },
            { name = "mcl_dripstone:pointed_dripstone", count = 1, chance = 0.6 },
        },
        special = {
            { name = "mcl_potions:regeneration_arrow", count = {min = 1, max = 3}, chance = 0.4 },
            { name = IF_PREFIX ..  "pizza_slice", count = {min = 1, max = 3}, chance = 0.4 },
        },
    },
    [7] = {
        description = "Cofre Fase 7: nether 1",
        standard = {
            { name = "mcl_crimson:crimson_fungus", count = {min = 1, max = 2}, chance = 0.4 },
            { name = "mcl_crimson:warped_fungus", count = {min = 1, max = 2}, chance = 0.4 },
            { name = "mcl_crimson:crimson_roots", count = {min = 1, max = 2}, chance = 0.4 },
            { name = "mcl_crimson:warped_roots", count = {min = 1, max = 2}, chance = 0.4 },
            { name = "mcl_nether:nether_wart", count = {min = 1, max = 2}, chance = 0.4 },

        },
        special = {
            { name = "mcl_tools:sword_iron", count = 1, chance = 0.5 },
        },
    },
    -- Nuevas fases o expansiones hechas por terceros se pueden añadir fácilmente aquí
}

-- Función modular para poblar el cofre generado en el mundo
function chests.populate(pos, phase_index, is_special)
    local meta = minetest.get_meta(pos)
    local inv = meta:get_inventory()
    inv:set_size("main", 27) -- Asegurar el tamaño estándar del cofre de Mineclonia

    local loot_data = chests.loot_tables[phase_index] or chests.loot_tables[1]
    if not loot_data then return end

    -- Seleccionar pool según si es cofre especial o estándar
    local pool = is_special and loot_data.special or loot_data.standard
    if not pool then
        pool = loot_data.standard or {}
    end

    -- Llenar el inventario aleatoriamente
    local items_to_add = is_special and math.random(6, 9) or math.random(4, 6)
    for i = 1, items_to_add do
        if #pool > 0 then
            local loot = pool[math.random(#pool)]
            if math.random() <= (loot.chance or 0.5) then
                local count = 1
                if type(loot.count) == "table" then
                    count = math.random(loot.count.min, loot.count.max)
                elseif type(loot.count) == "number" then
                    count = loot.count
                end

                local slot = math.random(1, 27)
                inv:set_stack("main", slot, ItemStack(loot.name .. " " .. count))
            end
        end
    end
end

-- ====================================================================
-- COMPLETADO AUTOMÁTICO DE COFRES A PARTIR DE FASES Y REGISTROS
-- ====================================================================
local excluded_random_items = {
    ["mcl_trees:sapling_lemon"] = true,
    ["mcl_trees:sapling_olive"] = true,
    [IF_PREFIX .. "coffee_bean"] = true,
    [IF_PREFIX .. "tomato_plant_seeds"] = true,
    [IF_PREFIX .. "basil_seeds"] = true,
}

local function item_is_seed(name, def)
    local groups = def.groups or {}
    if (groups.seed or groups.seeds or 0) > 0 then return true end
    local item_basename = name:match(":([^:]+)$") or name
    return item_basename:match("_seeds?$") ~= nil
end

local function make_loot_entry(name, count, chance)
    return {
        name = name,
        count = count,
        chance = chance,
    }
end

local function add_loot_once(pool, known_names, name, count, chance)
    if excluded_random_items[name] or known_names[name] then return end
    if not minetest.registered_items[name] then return end
    known_names[name] = true
    table.insert(pool, make_loot_entry(name, count, chance))
end

local function add_pool_names(pool, known_names)
    for index = #pool, 1, -1 do
        local entry = pool[index]
        if entry.name and excluded_random_items[entry.name] then
            table.remove(pool, index)
        elseif entry.name then
            known_names[entry.name] = true
        end
    end
end

-- oneblock.lua asigna la tabla de fases antes de que se ejecute este callback.
chests.phases = chests.phases or nil
minetest.register_on_mods_loaded(function()
    local phases = chests.phases
    if not phases then return end

    -- Asegura que las cinco exclusiones también se apliquen a entradas manuales.
    for _, loot_data in pairs(chests.loot_tables) do
        add_pool_names(loot_data.standard or {}, {})
        add_pool_names(loot_data.special or {}, {})
    end
    for _, global_data in ipairs({
        chests.global_ow_chests_content,
        chests.global_nth_chests_content,
        chests.global_end_chests_content,
    }) do
        add_pool_names(global_data.standard or {}, {})
        add_pool_names(global_data.special or {}, {})
    end

    local auto_saplings = {}
    local auto_seeds = {}
    for name, def in pairs(minetest.registered_items) do
        local groups = def.groups or {}
        if not excluded_random_items[name]
                and (groups.not_in_creative_inventory or 0) == 0 then
            if (groups.sapling or 0) > 0 then
                table.insert(auto_saplings, name)
            elseif item_is_seed(name, def) then
                table.insert(auto_seeds, name)
            end
        end
    end
    table.sort(auto_saplings)
    table.sort(auto_seeds)

    for phase_index, phase in ipairs(phases) do
        local loot_data = chests.loot_tables[phase_index]
        if not loot_data then
            local global_pool = phase.dimension == "nether"
                and chests.global_nth_chests_content
                or chests.global_ow_chests_content
            loot_data = {
                description = "Cofre " .. phase.name,
                standard = {},
                special = global_pool.special,
            }
            chests.loot_tables[phase_index] = loot_data
        end
        loot_data.standard = loot_data.standard or {}
        loot_data.special = loot_data.special or {}

        local known_names = {}
        add_pool_names(loot_data.standard, known_names)
        add_pool_names(loot_data.special, known_names)

        -- Añade al cofre estándar los nodos de su propia fase.
        for _, item in ipairs(phase.items or {}) do
            if item.type == "node" or item.type == "water" or item.type == "lava" then
                add_loot_once(loot_data.standard, known_names, item.name, 1, 0.35)
            end
        end

        -- Semillas y saplings se mantienen disponibles en los cofres del Overworld,
        -- salvo las cinco excepciones comerciales definidas arriba.
        if phase.dimension == "overworld" then
            for _, name in ipairs(auto_saplings) do
                add_loot_once(loot_data.standard, known_names, name, {min = 1, max = 2}, 0.3)
            end
            for _, name in ipairs(auto_seeds) do
                add_loot_once(loot_data.standard, known_names, name, {min = 1, max = 3}, 0.4)
            end
        end
    end
end)

return chests