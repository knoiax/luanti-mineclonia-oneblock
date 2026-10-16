local phases = {
    -- Ítems constantes que aparecen siempre en el Overworld (sin importar la fase)
    global_ow_items = {
        { type = "node", name = "mcl_core:dirt", weight = 30 },
        { type = "node", name = "mcl_core:dirt_with_grass", weight = 35 },
        { type = "node", name = "mcl_core:stone", weight = 25 },
        { type = "node", name = "mcl_core:gravel", weight = 10 },
        { type = "node", name = "mcl_core:sand", weight = 35 },
        { type = "mob",  name = "mobs_mc:cow", weight = 5, safe = true },
        { type = "mob",  name = "mobs_mc:sheep", weight = 5, safe = true },
        { type = "mob", name = "mobs_mc:pig", weight = 5, safe = true },
        { type = "mob", name = "mobs_mc:chicken", weight = 5, safe = true },
        { type = "hostile_mob", name = "mobs_mc:zombie", weight = 10, safe = true },
        { type = "hostile_mob", name = "mobs_mc:skeleton", weight = 8, safe = true },
        { type = "hostile_mob", name = "mobs_mc:spider", weight = 8, safe = true },
        { type = "hostile_mob", name = "mobs_mc:creeper", weight = 5, safe = true },
        { type = "chest", weight = 10 },
    },
    global_nth_items = {
        { type = "node", name = "mcl_blackstone:nether_gold", weight = 20 },
        { type = "node", name = "mcl_blackstone:soul_soil", weight = 30 },
        { type = "node", name = "mcl_nether:netherrack", weight = 40 },
        { type = "node", name = "mcl_nether:soul_sand", weight = 30 },
        { type = "node", name = "mcl_nether:magma", weight = 30 },
        { type = "hostile_mob", name = "mobs_mc:magma_cube_big", weight = 15 },
        { type = "hostile_mob", name = "mobs_mc:piglin_brute", weight = 15 },
        { type = "hostile_mob", name = "mobs_mc:piglin", weight = 15 },
        { type = "hostile_mob", name = "mobs_mc:zombified_piglin", weight = 15 },
        { type = "hostile_mob", name = "mobs_mc:hoglin", weight = 15 },
        { type = "hostile_mob", name = "mobs_mc:strider", weight = 15 },
        { type = "hostile_mob", name = "mobs_mc:enderman", weight = 15 },
        { type = "hostile_mob", name = "mobs_mc:blaze", weight = 15 },
        { type = "hostile_mob", name = "mobs_mc:wither", weight = 1 },
        { type = "hostile_mob", name = "mobs_mc:witherskeleton", weight = 5 },
        { type = "hostile_mob", name = "mobs_mc:piglin", weight = 15 },
        { type = "hostile_mob", name = "mobs_mc:zombified_piglin", weight = 15 },
    },
    {
        name = "Fase 1: Supervivencia Básica",
        min_blocks = 0,
        max_blocks = 199,
        dimension = "overworld",
        -- Lista de elementos con su respectiva probabilidad (peso)
        items = {
            { type = "node", name = "mcl_trees:leaves_acacia", weight = 5 },
            { type = "node", name = "mcl_trees:leaves_birch", weight = 5 },
            { type = "node", name = "mcl_trees:leaves_dark_oak", weight = 5 },
            { type = "node", name = "mcl_trees:leaves_oak", weight = 9},
            { type = "node", name = "mcl_trees:leaves_spruce", weight = 5 },
            { type = "node", name = "mcl_mangrove:mangrove_roots", weight = 7 },
            { type = "node", name = "mcl_trees:tree_acacia", weight = 8 },
            { type = "node", name = "mcl_trees:tree_birch", weight = 8 },
            { type = "node", name = "mcl_trees:tree_dark_oak", weight = 8 },
            { type = "node", name = "mcl_trees:tree_oak", weight = 10 },
            { type = "node", name = "mcl_trees:tree_olive", weight = 10 },
            { type = "node", name = "mcl_trees:tree_spruce", weight = 8 },
            { type = "node", name = "mcl_farming:hay_block", weight = 5},
            { type = "node", name = "mcl_farming:hay_block", weight = 5},

        },
    },
    {
        name = "Fase 2: Supervivencia intermedia",
        min_blocks = 200,
        max_blocks = 399,
        dimension = "overworld",
        -- Lista de elementos con su respectiva probabilidad (peso)
        items = {
            { type = "node", name = "mcl_trees:leaves_cherry_blossom", weight = 5 },
            { type = "node", name = "mcl_trees:leaves_dark_oak", weight = 1 },
            { type = "node", name = "mcl_trees:leaves_jungle", weight = 5 },
            { type = "node", name = "mcl_trees:leaves_mangrove", weight = 5 },
            { type = "node", name = "mcl_trees:leaves_oak", weight = 4},
            { type = "node", name = "mcl_trees:tree_cherry_blossom", weight = 8 },
            { type = "node", name = "mcl_trees:tree_jungle", weight = 8 },
            { type = "node", name = "mcl_trees:tree_mangrove", weight = 8 },
            { type = "node", name = "mcl_trees:tree_lemon", weight = 8 },
            { type = "mob", name = "mobs_mc:mooshroom", weight = 2, safe = true },
            { type = "node", name = "mcl_farming:pumpkin", weight = 5},
            { type = "node", name = "mcl_farming:melon", weight = 5},
        },
    },
    {
        name = "Fase 3: Profundidades y Minerales 1",
        min_blocks = 400,
        max_blocks = 599,
        dimension = "overworld",
        items = {
            { type = "node", name = "mcl_core:stone", weight = 20 },
            { type = "node", name = "mcl_core:granite", weight = 15 },
            { type = "node", name = "mcl_core:snowblock", weight = 20 },
            { type = "node", name = "mcl_powder_snow:powder_snow", weight = 8 },
            { type = "node", name = "mcl_core:stone_with_coal", weight = 20 },
            { type = "node", name = "mcl_core:stone_with_lapis", weight = 6 },
            { type = "node", name = "mcl_core:stone_with_iron", weight = 10 },
            { type = "node", name = "mcl_core:stone_with_gold", weight = 6 },
            { type = "node", name = "mcl_dripstone:dripstone_block", weight = 2 },
        },
    },  
    {
        name = "Fase 4: Profundidades y Minerales 2",
        min_blocks = 600,
        max_blocks = 799,
        dimension = "overworld",
        items = {
            { type = "node", name = "mcl_core:stone", weight = 15 },
            { type = "node", name = "mcl_core:granite", weight = 10 },
            { type = "node", name = "mcl_deepslate:deepslate", weight = 10 },
            { type = "node", name = "mcl_deepslate:deepslate_cobbled", weight = 7 },
            { type = "node", name = "mcl_deepslate:deepslate_with_redstone", weight = 5 },
            { type = "node", name = "mcl_core:stone_with_coal", weight = 10 },
            { type = "node", name = "mcl_core:stone_with_lapis", weight = 9 },
            { type = "node", name = "mcl_core:stone_with_iron", weight = 10 },
            { type = "node", name = "mcl_core:stone_with_gold", weight = 9 },
            { type = "node", name = "mcl_dripstone:dripstone_block", weight = 5 },
            { type = "hostile_mob", name = "mobs_mc:slime_big", weight = 5 },
            { type = "hostile_mob", name = "mobs_mc:cave_spider", weight = 8, safe = true },

        },
    },
    {
        name = "Fase 5: Profundidades y Minerales 3",
        min_blocks = 800,
        max_blocks = 999,
        dimension = "overworld",
        items = {
            { type = "node", name = "mcl_core:granite", weight = 5 },
            { type = "node", name = "mcl_deepslate:deepslate", weight = 20 },
            { type = "node", name = "mcl_deepslate:deepslate_cobbled", weight = 15 },
            { type = "node", name = "mcl_deepslate:deepslate_with_redstone", weight = 7 },
            { type = "node", name = "mcl_deepslate:deepslate_with_iron", weight = 7 },
            { type = "node", name = "mcl_deepslate:deepslate_with_coal", weight = 15 },
            { type = "node", name = "mcl_deepslate:deepslate_with_emerald", weight = 7 },
            { type = "node", name = "mcl_deepslate:deepslate_with_diamond", weight = 10 },
            { type = "node", name = "mcl_core:stone_with_coal", weight = 10 },
            { type = "node", name = "mcl_core:stone_with_redstone", weight = 10 },
            { type = "node", name = "mcl_core:stone_with_lapis", weight = 9 },
            { type = "node", name = "mcl_core:stone_with_emerald", weight = 5 },
            { type = "node", name = "mcl_core:stone_with_iron", weight = 15 },
            { type = "node", name = "mcl_core:stone_with_gold", weight = 12 },
            { type = "node", name = "mcl_core:stone_with_diamond", weight = 10 },
            { type = "hostile_mob", name = "mobs_mc:slime_big", weight = 5 },
            { type = "hostile_mob", name = "mobs_mc:cave_spider", weight = 8, safe = true },
            { type = "node", name = "mcl_dripstone:dripstone_block", weight = 5 },
        },
    },
    {
        name = "Fase 6: Continuidad en el Overworld",
        min_blocks = 1000,
        dimension = "overworld",
        items = {
            { type = "node", name = "mcl_farming:pumpkin", weight = 5},
            { type = "node", name = "mcl_farming:melon", weight = 5},
            { type = "node", name = "mcl_trees:leaves_dark_oak", weight = 1 },
            { type = "node", name = "mcl_core:stone", weight = 15 },
            { type = "node", name = "mcl_core:granite", weight = 10 },
            { type = "node", name = "mcl_deepslate:deepslate", weight = 20 },
            { type = "node", name = "mcl_deepslate:deepslate_cobbled", weight = 15 },
            { type = "node", name = "mcl_deepslate:deepslate_with_redstone", weight = 7 },
            { type = "node", name = "mcl_deepslate:deepslate_with_iron", weight = 7 },
            { type = "node", name = "mcl_deepslate:deepslate_with_coal", weight = 15 },
            { type = "node", name = "mcl_deepslate:deepslate_with_emerald", weight = 7 },
            { type = "node", name = "mcl_deepslate:deepslate_with_diamond", weight = 10 },
            { type = "node", name = "mcl_core:stone_with_coal", weight = 10 },
            { type = "node", name = "mcl_core:stone_with_redstone", weight = 10 },
            { type = "node", name = "mcl_core:stone_with_lapis", weight = 9 },
            { type = "node", name = "mcl_core:stone_with_emerald", weight = 5 },
            { type = "node", name = "mcl_core:stone_with_iron", weight = 15 },
            { type = "node", name = "mcl_core:stone_with_gold", weight = 12 },
            { type = "node", name = "mcl_core:stone_with_diamond", weight = 10 },
            { type = "node", name = "mcl_dripstone:dripstone_block", weight = 5 },
            { type = "hostile_mob", name = "mobs_mc:cave_spider", weight = 8, safe = true },
            { type = "hostile_mob", name = "mobs_mc:slime_big", weight = 5 },

        },
    },
    {
        name = "Fase 7 = Descubriendo el Nether",
        min_blocks = 0,
        max_blocks = 299,
        dimension = "nether",
        items = {
            { type = "node", name = "mcl_blackstone:basalt", weight = 15 },
            { type = "node", name = "mcl_blackstone:blackstone", weight = 20 },
            { type = "node", name = "mcl_core:gravel", weight = 10 },
            { type = "node", name = "mcl_core:bone_block", weight = 15 },
            { type = "node", name = "mcl_nether:glowstone", weight = 10 },
            { type = "node", name = "mcl_nether:quartz_ore", weight = 25 },

        }

    },
    {
        name = "Fase 8 = Vegetación del Nether",
        min_blocks = 300,
        max_blocks = 599,
        dimension = "nether",
        items = {
            { type = "node", name = "mcl_crimson:warped_wart_block", weight = 15 },
            { type = "node", name = "mcl_crimson:warped_nylium", weight = 15 },
            { type = "node", name = "mcl_crimson:crimson_nylium", weight = 15 },
            { type = "node", name = "mcl_crimson:shroomlight", weight = 15 },
            { type = "node", name = "mcl_trees:tree_crimson", weight = 5 },
            { type = "node", name = "mcl_trees:tree_warped", weight = 5 },

        }

    },
    {
        name = "Fase 9 = Fortalezas y Ruinas",
        min_blocks = 600,
        max_blocks = 899,
        dimension = "nether",
        items = {
            { type = "node", name = "mcl_nether:nether_brick", weight = 10 },
            { type = "node", name = "mcl_blackstone:basalt_polished", weight = 10 },
            { type = "node", name = "mcl_blackstone:blackstone_brick_polished_cracked", weight = 10 },
            { type = "node", name = "mcl_blackstone:blackstone_brick_polished", weight = 10 },
            { type = "node", name = "mcl_blackstone:blackstone_chiseled_polished", weight = 10 },
            { type = "node", name = "mcl_blackstone:blackstone_gilded", weight = 10 },
            { type = "node", name = "mcl_nether:ancient_debris", weight = 5 }, -- fuente de netherita
        }

    },
    {
        name = "Fase 10 = Continuidad en el Nether",
        min_blocks = 900,
        dimension = "nether",
        items = {
            { type = "node", name = "mcl_blackstone:basalt", weight = 15 },
            { type = "node", name = "mcl_blackstone:blackstone", weight = 20 },
            { type = "node", name = "mcl_core:gravel", weight = 10 },
            { type = "node", name = "mcl_core:bone_block", weight = 15 },
            { type = "node", name = "mcl_nether:glowstone", weight = 10 },
            { type = "node", name = "mcl_nether:quartz_ore", weight = 25 },
            { type = "node", name = "mcl_crimson:warped_wart_block", weight = 15 },
            { type = "node", name = "mcl_crimson:warped_nylium", weight = 15 },
            { type = "node", name = "mcl_crimson:crimson_nylium", weight = 15 },
            { type = "node", name = "mcl_crimson:shroomlight", weight = 15 },
            { type = "node", name = "mcl_trees:tree_crimson", weight = 5 },
            { type = "node", name = "mcl_trees:tree_warped", weight = 5 },
            { type = "node", name = "mcl_nether:nether_brick", weight = 10 },
            { type = "node", name = "mcl_blackstone:basalt_polished", weight = 10 },
            { type = "node", name = "mcl_blackstone:blackstone_brick_polished_cracked", weight = 10 },
            { type = "node", name = "mcl_blackstone:blackstone_brick_polished", weight = 10 },
            { type = "node", name = "mcl_blackstone:blackstone_chiseled_polished", weight = 10 },
            { type = "node", name = "mcl_blackstone:blackstone_gilded", weight = 10 },
            { type = "node", name = "mcl_nether:ancient_debris", weight = 5 }, -- fuente de netherita
        }

    },
    -- Aquí puedes seguir añadiendo fases posteriores con mayor dificultad de forma controlada
}


-- Completa automáticamente la fase de continuidad con materiales del Overworld
-- y mobs registrados por Mineclonia. Los bloques que componen estructuras
-- entran como nodos individuales; generar una estructura completa requiere un
-- sistema aparte de colocación de estructuras.
minetest.register_on_mods_loaded(function()
    local phase = phases[6]
    if not phase or phase.dimension ~= "overworld" then return end

    local excluded_nodes = {
        ["mcl_trees:sapling_lemon"] = true,
        ["mcl_trees:sapling_olive"] = true,
    }
    local function phase6_node_weight(name, default_weight)
        if name:find("with_gold", 1, true)
                or name:find("with_emerald", 1, true)
                or name:find("with_diamond", 1, true) then
            return 60
        elseif name:find("granite", 1, true)
                or name:find("calcite", 1, true)
                or name:find("limestone", 1, true) then
            return 30
        end
        return default_weight or 1
    end
    -- Estos namespaces contienen bloques exclusivos del Nether o del End.
    -- Se filtran por namespace para que actualizaciones del juego no incorporen
    -- accidentalmente esos materiales a la fase del Overworld.
    local excluded_node_mods = {
        mcl_blackstone = true,
        mcl_crimson = true,
        mcl_end = true,
        mcl_nether = true,
        mcl_portals = true,
    }
    -- Entidades excluidas por dimensión o hábitat. Enderman se conserva:
    -- también aparece naturalmente en el Overworld.
    local excluded_mobs = {
        ["mobs_mc:blaze"] = true,
        ["mobs_mc:ender_dragon"] = true,
        ["mobs_mc:endermite"] = true,
        ["mobs_mc:ghast"] = true,
        ["mobs_mc:hoglin"] = true,
        ["mobs_mc:baby_hoglin"] = true,
        ["mobs_mc:witherskeleton"] = true,
        ["mobs_mc:zoglin"] = true,
        ["mobs_mc:baby_zoglin"] = true,
        ["mobs_mc:magma_cube_big"] = true,
        ["mobs_mc:magma_cube_small"] = true,
        ["mobs_mc:magma_cube_tiny"] = true,
        ["mobs_mc:piglin"] = true,
        ["mobs_mc:piglin_brute"] = true,
        ["mobs_mc:zombified_piglin"] = true,
        ["mobs_mc:strider"] = true,
        ["mobs_mc:shulker"] = true,
        -- Alias legado de Mineclonia que convierte al lobo en perro domesticado
        -- con collar al aparecer mediante add_entity.
        ["mobs_mc:dog"] = true,
        ["mobs_mc:axolotl"] = true,
        ["mobs_mc:cod"] = true,
        ["mobs_mc:dolphin"] = true,
        ["mobs_mc:drowned"] = true,
        ["mobs_mc:baby_drowned"] = true,
        ["mobs_mc:guardian"] = true,
        ["mobs_mc:guardian_elder"] = true,
        ["mobs_mc:glow_squid"] = true,
        ["mobs_mc:pufferfish"] = true,
        ["mobs_mc:salmon"] = true,
        ["mobs_mc:squid"] = true,
        ["mobs_mc:tropical_fish"] = true,
        ["mobs_mc:turtle"] = true,
    }
    local already_added = {}
    for _, item in ipairs(phases.global_ow_items or {}) do
        if item.name then
            already_added[item.name] = true
        end
    end
    local eligible_items = {}
    for _, entry in ipairs(phase.items) do
        local node_def = entry.name and minetest.registered_nodes[entry.name]
        local is_water = entry.type == "water"
            or (node_def and (node_def.groups or {}).water and node_def.groups.water > 0)
        if not excluded_nodes[entry.name] and not is_water then
            table.insert(eligible_items, entry)
            if entry.name then
                already_added[entry.name] = true
            end
            if entry.type == "node" then
                entry.weight = phase6_node_weight(entry.name, entry.weight)
            end
        end
    end
    phase.items = eligible_items

    local registered_names = {}
    for name, def in pairs(minetest.registered_nodes) do
        local groups = def.groups or {}
        local is_visible = (groups.not_in_creative_inventory or 0) == 0
        local is_liquid = def.liquidtype == "flowing" or def.liquidtype == "source"
        local is_supported_source = def.liquidtype == "source"
            and (groups.lava or 0) > 0

        local mod_name = name:match("^([^:]+):")
        local is_nether_tree = mod_name == "mcl_trees"
            and (name:find("crimson", 1, true) or name:find("warped", 1, true))
        if name ~= "air" and name ~= "ignore" and name ~= "unknown"
                and not excluded_nodes[name] and is_visible
                and not excluded_node_mods[mod_name]
                and not is_nether_tree
                and (not is_liquid or is_supported_source)
                and not already_added[name] then
            table.insert(registered_names, name)
        end
    end
    table.sort(registered_names)

    for _, name in ipairs(registered_names) do
        local def = minetest.registered_nodes[name]
        local groups = def.groups or {}
        local entry_type = "node"
        if def.liquidtype == "source" and (groups.water or 0) > 0 then
            entry_type = "water"
        elseif def.liquidtype == "source" and (groups.lava or 0) > 0 then
            entry_type = "lava"
        end
        table.insert(phase.items, {
            type = entry_type,
            name = name,
            weight = phase6_node_weight(name, 1),
        })
        already_added[name] = true
    end

    -- mcl_mobs mantiene las definiciones originales de sus mobs registradas.
    -- type distingue animales/NPC pacíficos de monstruos hostiles.
    local registered_mobs = mcl_mobs and mcl_mobs.registered_mobs or {}
    local mob_names = {}
    for name, def in pairs(registered_mobs) do
        local spawn_category = def._spawn_category or ""
        local is_aquatic = spawn_category:find("water", 1, true) ~= nil
            or spawn_category == "axolotl"
        local is_already_tamed = def.tamed == true
        if not already_added[name] and not excluded_mobs[name]
                and not is_aquatic
                and not is_already_tamed
                and (def.type == "animal" or def.type == "npc" or def.type == "monster")
                and minetest.registered_entities[name] then
            table.insert(mob_names, name)
        end
    end
    table.sort(mob_names)

    for _, name in ipairs(mob_names) do
        local def = registered_mobs[name]
        local entry_type = def.type == "monster" and "hostile_mob" or "mob"
        table.insert(phase.items, {
            type = entry_type,
            name = name,
            -- El peso elevado compensa la gran cantidad de nodos automáticos:
            -- mantiene visibles las criaturas al sortear dentro de la fase.
            weight = 20,
            safe = true,
        })
    end
end)

return phases
