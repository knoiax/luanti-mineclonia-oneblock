local modname = minetest.get_current_modname()
local OVERWORLD_POS = {x = 0, y = 10, z = 0}
local IF_PREFIX = mcl_eodp.prefix.italian_food
local PREFIX = mcl_eodp.prefix.de_papi

-- Función para forzar la carga del terreno y situar al jugador de forma totalmente segura
local function safe_teleport(player)
    if not player or not player:is_player() then return end

    local name = player:get_player_name()
    local min_p = {x = -10, y = 0, z = -10}
    local max_p = {x = 10, y = 20, z = 10}

    -- 1. Forzar al motor de Luanti a cargar/generar los chunks en memoria inmediatamente
    minetest.emerge_area(min_p, max_p, function(blockpos, action, calls_remaining)
        if calls_remaining == 0 then
            -- 2. Asegurar físicamente los nodos de la isla
            minetest.set_node(OVERWORLD_POS, {name = "mcl_core:dirt_with_grass"})
            minetest.set_node({x = 0, y = 9, z = 0}, {name = "mcl_core:bedrock"})

            -- 3. Teletransportar al jugador sobre el bloque firme
            if player and player:is_player() then
                player:set_pos({x = 0.5, y = 11.5, z = 0.5})
                player:set_velocity({x = 0, y = 0, z = 0})

                -- Reconfirmación síncrona a los 0.2s para evitar micro-desfases de física
                minetest.after(0.2, function()
                    if player and player:is_player() then
                        player:set_pos({x = 0.5, y = 11.5, z = 0.5})
                        player:set_velocity({x = 0, y = 0, z = 0})
                    end
                end)
            end
        end
    end)
end

minetest.register_on_newplayer(function(player) safe_teleport(player) end)
minetest.register_on_joinplayer(function(player) safe_teleport(player) end)
minetest.register_on_respawnplayer(function(player) safe_teleport(player) return true end)

-- 1. CONTROL DE PERSISTENCIA
local storage = minetest.get_mod_storage()
local blocks_mined_overworld = storage:get_int("blocks_mined_overworld") or 0
local blocks_mined_nether = storage:get_int("blocks_mined_nether") or 0
local blocks_mined_end = storage:get_int("blocks_mined_end") or 0
local chest_count = storage:get_int("chest_count") or 0
local nether_island_created = storage:get_string("nether_island_created") == "true"
local end_island_created = storage:get_string("end_island_created") == "true"

-- 2. LISTAS DE BOTÍN PARA COFRES (Validados con PT_todo_el_codigo_mobs_mc.txt)
local ow_standard_loot = {

    -- Italian_food
    IF_PREFIX ..  "basil",
    IF_PREFIX ..  "bruschetta",
    IF_PREFIX ..  "cannoli",
    IF_PREFIX ..  "cheese_rack",
    IF_PREFIX ..  "coffee", 
    IF_PREFIX ..  "coffee_roasted_bean",
    IF_PREFIX ..  "coffee_sack",
    IF_PREFIX ..  "cone",
    IF_PREFIX ..  "diamond_tomato",
    IF_PREFIX ..  "diamond_basil",
    IF_PREFIX ..  "dough",
    IF_PREFIX ..  "fazzoletto_raw",
    IF_PREFIX ..  "gnocco_raw",
    IF_PREFIX ..  "ice_cream",
    IF_PREFIX ..  "iron_rolling_pin",
    IF_PREFIX ..  "lasagna",
    IF_PREFIX ..  "mozzarella",
    IF_PREFIX ..  "mushroom_pizza",
    IF_PREFIX ..  "olive",
    IF_PREFIX ..  "olive_oil",
    IF_PREFIX ..  "olivewood",
    IF_PREFIX ..  "pandoro",
    IF_PREFIX ..  "panettone",
    IF_PREFIX ..  "pesto_bruschetta",
    IF_PREFIX ..  "pesto_sauce",
    IF_PREFIX ..  "pizza",
    IF_PREFIX ..  "pizza_cutter_wheel",
    IF_PREFIX ..  "pork_jowl",
    IF_PREFIX ..  "raviolo_raw",
    IF_PREFIX ..  "rolling_pin",
    IF_PREFIX ..  "sheep_cheese",
    IF_PREFIX ..  "sheep_milk_bucket",
    IF_PREFIX ..  "spaghetti",
    IF_PREFIX ..  "sugar_coffee",
    IF_PREFIX ..  "sunflowerolio",
    IF_PREFIX ..  "tiramisu",
    IF_PREFIX ..  "tomato",
    IF_PREFIX ..  "tomato_sauce",
    IF_PREFIX ..  "tomato_sauce_bruschetta",
    PREFIX .. "lemon",
    PREFIX .. "lemonsapling",
    PREFIX .. "lemonade 4",



    -- Huevos de Mobs Pacíficos/Pasivos
    --"mobs_mc:cow",
    --"mobs_mc:pig",
    --"mobs_mc:sheep",
    --"mobs_mc:chicken",
    --"mobs_mc:mooshroom",
    --"mobs_mc:villager",
    --"mobs_mc:axolotl",
    --"mobs_mc:dolphin",
    
    -- Huevos de Mobs Hostiles / Neutrales
    --"mobs_mc:zombie",
    --"mobs_mc:skeleton",
    --"mobs_mc:creeper",
    --"mobs_mc:spider",
    --"mobs_mc:enderman",

    -- Objetos varios
    --"mcl_core:stick", 
    --"mcl_farming:wheat_seeds", 
    --"mcl_farming:carrot", 
    --"mcl_farming:bread",
    --"mcl_farming:potato", 
    --"mcl_core:iron_ingot 2", 
    --"mcl_core:gold_ingot", 
    --"mcl_tridents:trident",
    --"mcl_buckets:bucket_water", 
    --"mcl_buckets:bucket_lava", 
    --"mcl_mobitems:saddle", 
    --"mcl_mobitems:gunpowder 2",
    --"mcl_trees:sapling_birch",
    --"mcl_trees:sapling_dark_oak",
    --"mcl_trees:sapling_dark_oak", 
    --"mcl_bamboo:bamboo",
    --"mcl_trees:sapling_oak", 
    --"mcl_trees:sapling_acacia", 
    --"mcl_farming:beetroot_seeds 5", 
    --"mcl_farming:sweet_berry"
    
}

-- Botín especial / Tesoros (Libros encantados, equipamiento, mapas/marítimos)
local ow_special_loot = {
    "mcl_enchanting:book", -- Libro para encantar 
    "mcl_tools:sword_diamond", 
    "mcl_tools:pick_diamond", 
    "mcl_armor:chestplate_diamond",
    "mcl_cake:cake",
    "mobs_mc:ravager",
    "mcl_sponges:sponge", 
    "mcl_core:emerald 4", 
    "mcl_core:diamond 2",
    "mcl_core:diamond", 
    "mcl_core:emerald", 
    "mcl_core:gold_ingot 8", 
    "mcl_mobitems:nautilus_shell",
    "mcl_totems:totem", 
    "mcl_core:apple_gold", 
    "mcl_tridents:trident_enchanted",
    "mcl_trees:sapling_jungle",
    "mcl_trees:sapling_spruce", 
    "mcl_trees:sapling_cherry_blossom", 
    "mobs_mc:illusioner",
}
-- COFRES NETHER
local nether_standard_loot = {
    "mcl_nether:nether_wart", 
    "mcl_mobitems:blaze_rod", 
    "mcl_mobitems:ghast_tear",
    "mcl_core:gold_ingot 4", 
    "mcl_nether:quartz 8", 
    "mcl_farming:carrot_item_gold"
}
local nether_special_loot = {
    "mcl_nether:netherite_ingot", 
    "mcl_nether:netherite_scrap 2", 
    "mcl_enchanting:book_enchanted",
    "mcl_tools:sword_gold", 
    "mcl_armor:chestplate_gold", 
    "mcl_core:apple_gold", 
    "mcl_potions:fire_resistance", 
    "mcl_potions:invisibility",
    "mcl_potions:night_vision",
}

-- COFRES END
local end_standard_loot = {
    "mcl_throwing:ender_pearl 4", 
    "mcl_end:chorus_fruit 8", 
    "mcl_core:diamond 2",
    "mcl_core:obsidian 4", 
    "mcl_end:ender_eye 2"
}
local end_special_loot = {
    "mcl_armor:elytra", 
    "mcl_tools:pick_netherite", 
    "mcl_armor:chestplate_diamond_enchanted", 
    "mcl_enchanting:book_enchanted",
    "mcl_totems:totem", 
    "mcl_core:apple_gold_enchanted"
}

-- 3. POOLS DE BLOQUES (Sin cofres en la lista común para evitar spawn excesivo)
local overworld_phase_1 = {
    "mcl_core:dirt", 
    "mcl_core:dirt_with_grass", 
    "mcl_flowers:dandelion", 
    "mcl_flowers:poppy", 
    "mcl_trees:leaves_birch", 
    "mcl_trees:leaves_oak",
    "mcl_trees:leaves_spruce", 
    "mcl_core:gravel", 
    "mcl_core:sand", 
    "mcl_farming:pumpkin", 
    "mcl_farming:hay_block"
}
local overworld_phase_2 = {
    "mcl_core:dirt", 
    "mcl_core:dirt_with_grass", 
    "mcl_trees:wood_oak", 
    "mcl_trees:tree_birch", 
    "mcl_trees:tree_dark_oak", 
    "mcl_trees:tree_acacia", 
    "mcl_trees:tree_jungle", 
    "mcl_trees:wood_acacia", 
    "mcl_trees:wood_spruce", 
    "mcl_trees:wood_birch", 
    "mcl_trees:leaves_oak", 
    "mcl_core:gravel", 
    "mcl_trees:leaves_spruce",
    "mcl_trees:tree_spruce",
    "mcl_trees:tree_oak",
    "mcl_trees:tree_oak",
    "mcl_trees:tree_cherry_blossom", 
    "mcl_farming:melon"
}
local overworld_phase_3 = {
    "mcl_core:dirt_with_grass", 
    "mcl_trees:wood_mangrove", 
    "mcl_core:stone", 
    "mcl_core:cobble", 
    "mcl_core:stone_with_coal", 
    "mcl_core:stone_with_iron", 
    "mcl_dripstone:dripstone_block", 
    "mcl_trees:wood_jungle", 
    "mcl_trees:wood_dark_oak"
}
local overworld_phase_4 = {
    "mcl_core:dirt_with_grass",
    "mcl_core:stone", 
    "mcl_core:stone_with_iron", 
    "mcl_core:stone_with_gold", 
    "mcl_core:sand", 
    "mcl_trees:wood_cherry_blossom", 
    "mcl_trees:leaves_mangrove", 
    "mcl_core:stone_with_redstone", 
    "mcl_core:stone_with_lapis", 
    "mcl_core:stone_with_diamond", 
    "mcl_core:stone_with_emerald", 
    "mcl_core:obsidian", 
    "mcl_dripstone:dripstone_block",
    "mcl_trees:tree_mangrove",
    "mcl_trees:tree_bamboo"
}

local nether_pool = { 
    "mcl_nether:netherrack", 
    "mcl_nether:soul_sand", 
    "mcl_blackstone:soul_soil", 
    "mcl_blackstone:basalt", 
    "mcl_nether:glowstone", 
    "mcl_nether:quartz_ore", 
    "mcl_blackstone:nether_gold", 
    "mcl_nether:ancient_debris", 
    "mcl_nether:nether_brick", 
    "mcl_nether:magma",
    "mcl_trees:tree_crimson",
    "mcl_trees:tree_warped",
    "mcl_trees:wood_warped", 
    "mcl_trees:wood_crimson"
}

local end_pool = { 
    "mcl_end:end_stone", 
    "mcl_monster_eggs:monster_egg_stone", 
    "mcl_end:end_bricks", 
    "mcl_end:purpur_block", 
    "mcl_end:purpur_pillar", 
    "mcl_end:end_rod", 
    "mcl_end:chorus_plant", 
    "mcl_end:chorus_flower" 
}

local passive_mobs = {
    "mobs_mc:cow",
    "mobs_mc:cow",
    "mobs_mc:mooshroom",
    "mobs_mc:sheep",
    "mobs_mc:sheep",
    "mobs_mc:chicken",
    "mobs_mc:chicken",
    "mobs_mc:pig",
    "mobs_mc:villager",
    "mobs_mc:wandering_trader"
}
local hostile_mobs_ow = {
    "mobs_mc:zombie",
    "mobs_mc:zombie", 
    "mobs_mc:zombie",
    "mobs_mc:zombie", 
    "mobs_mc:zombie", 
    "mobs_mc:zombie",
    "mobs_mc:zombie", 
    "mobs_mc:zombie",
    "mobs_mc:zombie", 
    "mobs_mc:zombie", 
    "mobs_mc:husk",
    "mobs_mc:husk",
    "mobs_mc:husk",
    "mobs_mc:husk", 
    "mobs_mc:husk",
    "mobs_mc:husk", 
    "mobs_mc:skeleton", 
    "mobs_mc:skeleton", 
    "mobs_mc:skeleton",
    "mobs_mc:skeleton",
    "mobs_mc:skeleton",
    "mobs_mc:stray",
    "mobs_mc:stray",
    "mobs_mc:stray",
    "mobs_mc:spider", 
    "mobs_mc:spider", 
    "mobs_mc:spider", 
    "mobs_mc:spider", 
    "mobs_mc:spider", 
    "mobs_mc:spider", 
    "mobs_mc:spider", 
    "mobs_mc:spider", 
    "mobs_mc:creeper", 
    "mobs_mc:creeper",  
    "mobs_mc:pillager",
    "mobs_mc:pillager", 
    "mobs_mc:witch",
    "mobs_mc:evoker", 
    "mobs_mc:vindicator", 
    "mobs_mc:phantom",
    "mobs_mc:slime",
    "mobs_mc:slime",
    "mobs_mc:slime",
    "mobs_mc:slime",
    "mobs_mc:slime",
    "mobs_mc:slime",
    "mobs_mc:villager_zombie",
    "mobs_mc:villager_zombie",
    "mobs_mc:villager_zombie"
}
local passive_mobs_nether = {
    "mobs_mc:piglin",
    "mobs_mc:piglin",
    "mobs_mc:piglin",
    "mobs_mc:piglin",
    "mobs_mc:piglin",
    "mobs_mc:zombified_piglin",
    "mobs_mc:zombified_piglin",
    "mobs_mc:zombified_piglin"
}
local hostile_mobs_nether = {
    "mobs_mc:piglin_brute",
    "mobs_mc:piglin_brute",
    "mobs_mc:piglin_brute",
    "mobs_mc:hoglin",
    "mobs_mc:hoglin",
    "mobs_mc:zoglin",
    "mobs_mc:zoglin",
    "mobs_mc:ghast",
    "mobs_mc:blaze",
    "mobs_mc:blaze",
    "mobs_mc:magma_cube",
    "mobs_mc:wither_skeleton"
}
local hostile_mobs_end = {"mobs_mc:enderman", "mobs_mc:shulker"}

-- 4. VACIAR MAPA, COLOCAR ONEBLOCK Y BEDROCK DE SEGURIDAD
minetest.register_on_generated(function(minp, maxp, seed)
    local vm, min, max = minetest.get_mapgen_object("voxelmanip")
    if not vm then return end

    local area = VoxelArea:new({MinEdge = min, MaxEdge = max})
    local data = vm:get_data()
    local c_air = minetest.get_content_id("air")
    local c_grass = minetest.get_content_id("mcl_core:dirt_with_grass")
    local c_bedrock = minetest.get_content_id("mcl_core:bedrock")

    -- Vaciar mapa
    for i in area:iterp(minp, maxp) do
        data[i] = c_air
    end

    -- Colocar OneBlock en y=10
    if minp.x <= OVERWORLD_POS.x and maxp.x >= OVERWORLD_POS.x and
       minp.y <= OVERWORLD_POS.y and maxp.y >= OVERWORLD_POS.y and
       minp.z <= OVERWORLD_POS.z and maxp.z >= OVERWORLD_POS.z then
        
        local vi_ob = area:index(OVERWORLD_POS.x, OVERWORLD_POS.y, OVERWORLD_POS.z)
        data[vi_ob] = c_grass
    end

    -- Colocar Bedrock en y=9
    if minp.x <= OVERWORLD_POS.x and maxp.x >= OVERWORLD_POS.x and
       minp.y <= (OVERWORLD_POS.y - 1) and maxp.y >= (OVERWORLD_POS.y - 1) and
       minp.z <= OVERWORLD_POS.z and maxp.z >= OVERWORLD_POS.z then

        local vi_bedrock = area:index(OVERWORLD_POS.x, OVERWORLD_POS.y - 1, OVERWORLD_POS.z)
        data[vi_bedrock] = c_bedrock
    end

    vm:set_data(data)

    -- EVITAR ERROR DE CONGELAMIENTO/NIVELGEN:
    -- Sobrescribir datos de bioma para que mcl_levelgen no procese capas de nieve sobre nulos
    local param2_data = vm:get_param2_data()
    for i in area:iterp(minp, maxp) do
        param2_data[i] = 0
    end
    vm:set_param2_data(param2_data)
    
    vm:calc_lighting()
    vm:write_to_map()
end)

-- 5. FUNCIÓN PARA LLENAR COFRES CON DETECCIÓN DE DIMENSIÓN(CADA 4 UN TESORO)
local function populate_chest(pos, dimension)
    local meta = minetest.get_meta(pos)
    local inv = meta:get_inventory()
    inv:set_size("main", 27)

    chest_count = chest_count + 1
    storage:set_int("chest_count", chest_count)

    local is_special = (chest_count % 4 == 0)
    local loot_pool = {}

    -- Seleccionar tabla según el tipo de cofre y la dimensión
    if dimension == "nether" then
        loot_pool = is_special and nether_special_loot or nether_standard_loot
    elseif dimension == "end" then
        loot_pool = is_special and end_special_loot or end_standard_loot
    else
        loot_pool = is_special and ow_special_loot or ow_standard_loot
    end

    local items_to_add = is_special and math.random(5, 10) or math.random(3, 7)

    for i = 1, items_to_add do
        local random_item = loot_pool[math.random(#loot_pool)]
        local slot = math.random(1, 27)
        inv:set_stack("main", slot, ItemStack(random_item))
    end
end

-- Función auxiliar para obtener botín seguro
local function get_safe_loot_item(loot_table)
    local max_attempts = 10
    for i = 1, max_attempts do
        local candidate = loot_table[math.random(#loot_table)]
        -- Extrae únicamente el nombre técnico del ítem (ignorando cantidades)
        local item_name = candidate:match("(%S+)")
        
        -- Comprueba si el ítem / huevo realmente existe registrado en Luanti
        if minetest.registered_items[item_name] then
            return candidate
        end
    end
    -- Si tras varios intentos el huevo no existe, entrega un ítem de respaldo seguro
    return "mcl_core:apple"
end

-- 6. GENERADOR DE ISLA ONEBLOCK (ACTIVADO SOLO AL ATRAVESAR UN PORTAL)
-- En lugar de chequear 60 veces por segundo, revisamos la zona cuando el jugador cambia de posición
minetest.register_globalstep(function(dtime)
    for _, player in ipairs(minetest.get_connected_players()) do
        local pos = player:get_pos()
        if pos then
            -- Detección del Nether (Solo si cruzó el portal y llegó a la dimensión Nether: Y < -3000)
            if pos.y < -3000 and pos.y > -20000 and not nether_island_created then
                -- Posicionar el OneBlock justo frente al lugar de llegada del portal (o en las coordenadas de destino)
                local nether_ob_pos = {x = math.floor(pos.x + 50), y = math.floor(pos.y), z = math.floor(pos.z)}
                
                minetest.set_node(nether_ob_pos, {name = "mcl_nether:netherrack"})
                minetest.set_node({x = nether_ob_pos.x, y = nether_ob_pos.y - 1, z = nether_ob_pos.z}, {name = "mcl_core:bedrock"})
                
                storage:set_string("nether_ob_pos", minetest.pos_to_string(nether_ob_pos))
                storage:set_string("nether_island_created", "true")
                nether_island_created = true
                
                minetest.chat_send_player(player:get_player_name(), "¡Has cruzado al Nether! Tu OneBlock Nether ha sido creado a 50 bloques.")
            end

            -- Detección del End (Solo si cruzó el portal del End: Y > 20000)
            if pos.y > 20000 and pos.y < 30000 and not end_island_created then
                local end_ob_pos = {x = math.floor(pos.x + 100), y = math.floor(pos.y), z = math.floor(pos.z)}
                
                minetest.set_node(end_ob_pos, {name = "mcl_end:end_stone"})
                minetest.set_node({x = end_ob_pos.x, y = end_ob_pos.y - 1, z = end_ob_pos.z}, {name = "mcl_core:bedrock"})
                
                storage:set_string("end_ob_pos", minetest.pos_to_string(end_ob_pos))
                storage:set_string("end_island_created", "true")
                end_island_created = true
                
                minetest.chat_send_player(player:get_player_name(), "¡Has llegado al End! Tu OneBlock End ha sido creado a 100 bloques.")
            end
        end
    end
end)

-- Función para evitar caídas SOLO si el jugador está parado sobre el bloque picado
local function snap_player(digger, target_pos)
    if not digger or not digger:is_player() then return end

    local ppos = digger:get_pos()
    
    -- 1. Comprobar alineación horizontal (radio estrecho de 0.8 bloques)
    local standing_on_x = math.abs(ppos.x - target_pos.x) < 0.8
    local standing_on_z = math.abs(ppos.z - target_pos.z) < 0.8
    
    -- 2. Comprobar alineación vertical (pies entre la base del bloque y 1.5 bloques arriba)
    local standing_on_y = (ppos.y >= target_pos.y - 0.2) and (ppos.y <= target_pos.y + 1.5)

    -- SOLO si está parado justo encima del bloque que acaba de desaparecer:
    if standing_on_x and standing_on_z and standing_on_y then
        digger:set_pos({x = target_pos.x, y = target_pos.y + 1.2, z = target_pos.z})
        digger:set_velocity({x = 0, y = 0, z = 0})
    end
end

-- 7. LÓGICA AL ROMPER BLOQUES (CONTROL DE COFRES CADA 25 BLOQUES)
minetest.register_on_dignode(function(pos, oldnode, digger)
    local nether_pos_str = storage:get_string("nether_ob_pos")
    local nether_pos = nether_pos_str ~= "" and minetest.string_to_pos(nether_pos_str) or nil
    local end_pos_str = storage:get_string("end_ob_pos")
    local end_pos = end_pos_str ~= "" and minetest.string_to_pos(end_pos_str) or nil

    -- A. ONEBLOCK OVERWORLD
    if pos.x == OVERWORLD_POS.x and pos.y == OVERWORLD_POS.y and pos.z == OVERWORLD_POS.z then
        blocks_mined_overworld = blocks_mined_overworld + 1
        storage:set_int("blocks_mined_overworld", blocks_mined_overworld)

        -- Spawns
        local spawn_pos = {x = pos.x, y = pos.y + 1, z = pos.z}
        if blocks_mined_overworld % 80 == 0 then
            minetest.add_entity(spawn_pos, hostile_mobs_ow[math.random(#hostile_mobs_ow)])
        elseif blocks_mined_overworld % 45 == 0 then
            minetest.add_entity(spawn_pos, passive_mobs[math.random(#passive_mobs)])
        end

        -- Generar Cofre cada 30 bloques picados
        local next_block
        if blocks_mined_overworld % 5 == 0 then
            next_block = "mcl_chests:chest"
        else
            local pool = overworld_phase_1
            if blocks_mined_overworld > 800 then pool = overworld_phase_4
            elseif blocks_mined_overworld > 400 then pool = overworld_phase_3
            elseif blocks_mined_overworld > 200 then pool = overworld_phase_2 end
            next_block = pool[math.random(#pool)]
        end

        minetest.set_node(OVERWORLD_POS, {name = next_block})
        snap_player(digger, OVERWORLD_POS)
        if next_block == "mcl_chests:chest" then 
            populate_chest(OVERWORLD_POS, "overworld") 
        end

    -- B. ONEBLOCK NETHER
    elseif nether_pos and pos.x == nether_pos.x and pos.y == nether_pos.y and pos.z == nether_pos.z then
        blocks_mined_nether = blocks_mined_nether + 1
        storage:set_int("blocks_mined_nether", blocks_mined_nether)

        if blocks_mined_nether % 60 == 0 then
            local spawn_pos = {x = pos.x, y = pos.y + 1, z = pos.z}
            minetest.add_entity(spawn_pos, hostile_mobs_nether[math.random(#hostile_mobs_nether)])
        elseif blocks_mined_nether % 30 == 0 then
            local spawn_pos = {x = pos.x, y = pos.y + 1, z = pos.z}
            minetest.add_entity(spawn_pos, passive_mobs_nether[math.random(#passive_mobs_nether)])
        end

        local next_block
        if blocks_mined_nether % 30 == 0 then
            next_block = "mcl_chests:chest"
        else
            next_block = nether_pool[math.random(#nether_pool)]
        end

        minetest.set_node(nether_pos, {name = next_block})
        snap_player(digger, nether_pos)
        if next_block == "mcl_chests:chest" then 
            populate_chest(nether_pos, "nether") 
        end

    -- C. ONEBLOCK END
    elseif end_pos and pos.x == end_pos.x and pos.y == end_pos.y and pos.z == end_pos.z then
        blocks_mined_end = blocks_mined_end + 1
        storage:set_int("blocks_mined_end", blocks_mined_end)

        if blocks_mined_end % 40 == 0 then
            local spawn_pos = {x = pos.x, y = pos.y + 1, z = pos.z}
            minetest.add_entity(spawn_pos, hostile_mobs_end[math.random(#hostile_mobs_end)])
        end

        local next_block
        if blocks_mined_end % 25 == 0 then
            next_block = "mcl_chests:chest"
        else
            next_block = end_pool[math.random(#end_pool)]
        end

        minetest.set_node(end_pos, {name = next_block})
        snap_player(digger, end_pos)
        if next_block == "mcl_chests:chest" then 
            populate_chest(end_pos, "end") 
        end
    end
end)