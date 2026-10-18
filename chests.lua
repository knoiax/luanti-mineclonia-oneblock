-- chest.lua
local chests = {}
local PREFIX = mcl_eodp.prefix.de_papi
local IF_PREFIX = mcl_eodp.prefix.italian_food

local function cleanup_empty_chest(pos)
    local meta = minetest.get_meta(pos)
    local inv = meta:get_inventory()

    if meta:get_int("eodp_temporary_nether_compass") == 1 then
        -- Este cofre temporal existe únicamente para entregar la brújula.
        -- Retirarla lo elimina, aunque el jugador haya dejado otros objetos.
        if not inv:contains_item("main", "mcl_compass:compass_recovery") then
            minetest.remove_node(pos)
        end
        return
    end

    if not inv:is_empty("main") then return end
    -- Mantiene el comportamiento que ya usaban los cofres del OneBlock.
    minetest.set_node(pos, {name = "mcl_core:dirt_with_grass"})
end

local function chest_inventory_changed(pos)
    minetest.after(0, cleanup_empty_chest, pos)
end

minetest.override_item("mcl_chests:chest_small", {
    drop = "",
    on_metadata_inventory_take = chest_inventory_changed,
    on_metadata_inventory_move = chest_inventory_changed,
})

minetest.override_item("mcl_chests:chest", {
    drop = "",
    on_metadata_inventory_take = chest_inventory_changed,
    on_metadata_inventory_move = chest_inventory_changed,
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

local function gear_entry(name, chance, enchant_level)
    return {
        name = name,
        count = 1,
        chance = chance,
        enchant_level = enchant_level,
    }
end

local overworld_iron_gear = {
    "mcl_tools:sword_iron", "mcl_tools:axe_iron",
    "mcl_armor:helmet_iron", "mcl_armor:chestplate_iron",
    "mcl_armor:leggings_iron", "mcl_armor:boots_iron",
}
local overworld_diamond_gear = {
    "mcl_tools:sword_diamond", "mcl_tools:axe_diamond",
    "mcl_armor:helmet_diamond", "mcl_armor:chestplate_diamond",
    "mcl_armor:leggings_diamond", "mcl_armor:boots_diamond",
}
for _, phase_index in ipairs({5, 6}) do
    local standard, special = {}, {}
    for _, name in ipairs(overworld_iron_gear) do
        table.insert(standard, gear_entry(name, 0.45))
        table.insert(special, gear_entry(name, 0.55))
    end
    for _, name in ipairs(overworld_diamond_gear) do
        table.insert(standard, gear_entry(name, 0.12, 18))
        table.insert(special, gear_entry(name, 0.35, 22))
    end
    chests.loot_tables[phase_index] = {
        description = "Cofres Overworld de equipo y hallazgos raros",
        standard = standard,
        special = special,
    }
end

local nether_food_and_relics = {
    { name = "mcl_mobitems:porkchop", count = {min = 1, max = 3}, chance = 0.5 },
    { name = "mcl_mobitems:cooked_porkchop", count = {min = 1, max = 3}, chance = 0.45 },
    { name = "mcl_mobitems:rotten_flesh", count = {min = 1, max = 3}, chance = 0.25 },
    { name = "mcl_crimson:crimson_fungus", count = {min = 1, max = 3}, chance = 0.45 },
    { name = "mcl_crimson:warped_fungus", count = {min = 1, max = 3}, chance = 0.45 },
    { name = "mcl_nether:nether_wart_item", count = {min = 1, max = 3}, chance = 0.4 },
    { name = "mcl_mobitems:ghast_tear", count = {min = 1, max = 2}, chance = 0.18 },
    { name = "mcl_mobitems:blaze_rod", count = {min = 1, max = 3}, chance = 0.25 },
    { name = "mcl_mobitems:magma_cream", count = {min = 1, max = 3}, chance = 0.25 },
    { name = "mcl_nether:netherite_scrap", count = {min = 1, max = 2}, chance = 0.12 },
    { name = "mcl_nether:netherite_ingot", count = 1, chance = 0.04 },
    { name = "mcl_nether:netherite_upgrade_template", count = 1, chance = 0.08 },
    { name = "mcl_nether:quartz", count = {min = 2, max = 6}, chance = 0.35 },
    { name = "mcl_core:gold_nugget", count = {min = 2, max = 8}, chance = 0.35 },
}
for _, phase_index in ipairs({8, 9}) do
    local pool = {}
    for _, entry in ipairs(nether_food_and_relics) do
        table.insert(pool, entry)
    end
    chests.loot_tables[phase_index] = {
        description = "Cofre Nether: alimentos y hallazgos raros",
        standard = pool,
        special = pool,
    }
end

local nether_diamond_gear = {
    "mcl_tools:sword_diamond", "mcl_tools:axe_diamond",
    "mcl_armor:helmet_diamond", "mcl_armor:chestplate_diamond",
    "mcl_armor:leggings_diamond", "mcl_armor:boots_diamond",
}
local netherite_gear = {
    "mcl_tools:sword_netherite", "mcl_tools:axe_netherite",
    "mcl_armor:helmet_netherite", "mcl_armor:chestplate_netherite",
    "mcl_armor:leggings_netherite", "mcl_armor:boots_netherite",
}
for _, phase_index in ipairs({10, 11}) do
    local standard, special = {}, {}
    for _, name in ipairs(nether_diamond_gear) do
        table.insert(standard, gear_entry(name, 0.35, 20))
        table.insert(special, gear_entry(name, 0.5, 25))
    end
    for _, name in ipairs(netherite_gear) do
        table.insert(standard, gear_entry(name, 0.12, 28))
        table.insert(special, gear_entry(name, 0.3, 30))
    end
    chests.loot_tables[phase_index] = {
        description = "Cofre Nether: equipo encantado de alto nivel",
        standard = standard,
        special = special,
    }
end

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

                local stack = ItemStack(loot.name .. " " .. count)
                if loot.enchant_level and mcl_enchanting
                        and mcl_enchanting.enchant_randomly
                        and mcl_enchanting.can_enchant_freshly(stack:get_name())
                        and not mcl_enchanting.not_enchantable_on_enchanting_table(stack:get_name()) then
                    local ok, enchanted = pcall(
                        mcl_enchanting.enchant_randomly,
                        stack, loot.enchant_level, true, true, true
                    )
                    if ok and enchanted then stack = enchanted end
                end

                local slot = math.random(1, 27)
                inv:set_stack("main", slot, stack)
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

local function is_chest_only_node(name, def)
    local groups = def.groups or {}
    local is_amethyst_crystal = name:match("^mcl_amethyst:.*amethyst.*bud$")
        or name == "mcl_amethyst:amethyst_cluster"
    return (groups.attached_node or 0) > 0
        or (groups.climbable or 0) > 0
        or not not is_amethyst_crystal
end

local function is_nether_only_item(name)
    local namespace = name:match("^([^:]+):")
    return namespace == "mcl_nether" or namespace == "mcl_blackstone"
        or namespace == "mcl_crimson"
        or (namespace == "mcl_trees"
            and (name:find("crimson", 1, true) or name:find("warped", 1, true)))
end

local function is_end_only_item(name)
    local namespace = name:match("^([^:]+):")
    return namespace == "mcl_end" or namespace == "mcl_portals"
end

local function is_growable_item(name, def)
    local groups = def.groups or {}
    local basename = name:match(":([^:]+)$") or name
    return (groups.seed or 0) > 0 or (groups.seeds or 0) > 0
        or (groups.sapling or 0) > 0 or (groups.crop or 0) > 0
        or (groups.plant or 0) > 0
        or basename:match("_seeds?$") ~= nil
        or basename:match("_sapling$") ~= nil
        or basename:match("_plant$") ~= nil
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

    -- Plantas que necesitan apoyo (incluidas las enredaderas) y cristales
    -- quedan como botín de cofre, nunca como bloque del OneBlock.
    local chest_only_nodes = {}
    for name, def in pairs(minetest.registered_nodes) do
        local groups = def.groups or {}
        if is_chest_only_node(name, def)
                and (groups.not_in_creative_inventory or 0) == 0
                and def.liquidtype ~= "source" and def.liquidtype ~= "flowing" then
            table.insert(chest_only_nodes, name)
        end
    end
    table.sort(chest_only_nodes)

    -- Para los cofres avanzados del Overworld se guardan objetos sin receta
    -- que tampoco sean cultivos, semillas o plantines.
    local overworld_unobtainables = {}
    for name, def in pairs(minetest.registered_items) do
        local groups = def.groups or {}
        local recipes = minetest.get_all_craft_recipes
            and minetest.get_all_craft_recipes(name) or nil
        local has_recipe = recipes and #recipes > 0
        if not has_recipe and not excluded_random_items[name]
                and not is_growable_item(name, def)
                and not is_nether_only_item(name) and not is_end_only_item(name)
                and (groups.not_in_creative_inventory or 0) == 0 then
            table.insert(overworld_unobtainables, name)
        end
    end
    table.sort(overworld_unobtainables)

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
        local special_known_names = {}
        add_pool_names(loot_data.standard, known_names)
        add_pool_names(loot_data.special, special_known_names)

        local restricted_pool = phase_index == 5 or phase_index == 6
            or phase_index == 8 or phase_index == 9
            or phase_index == 10 or phase_index == 11
        -- Las fases restringidas usan solo los botines definidos para ellas;
        -- las demás pueden añadir los nodos de su propia fase.
        if not restricted_pool then
            for _, item in ipairs(phase.items or {}) do
                if item.type == "node" or item.type == "water" or item.type == "lava" then
                    add_loot_once(loot_data.standard, known_names, item.name, 1, 0.35)
                end
            end
        end

        if phase.dimension == "overworld" and phase_index ~= 5 and phase_index ~= 6 then
            for _, name in ipairs(chest_only_nodes) do
                add_loot_once(loot_data.standard, known_names, name, 1, 0.2)
            end
        end

        if phase_index == 5 or phase_index == 6 then
            for _, name in ipairs(overworld_unobtainables) do
                add_loot_once(loot_data.standard, known_names, name, 1, 0.3)
                add_loot_once(loot_data.special, special_known_names, name, 1, 0.35)
            end
        end

        -- Semillas y saplings se mantienen disponibles en los cofres del Overworld,
        -- salvo las cinco excepciones comerciales definidas arriba.
        if phase.dimension == "overworld" and phase_index ~= 5 and phase_index ~= 6 then
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
