-- oneblock.lua
local modname = minetest.get_current_modname()
local modpath = minetest.get_modpath(modname)
local S = minetest.get_translator(modname)
local EODP_CHEST = mcl_eodp.prefix.de_papi .. "chest"

-- 1. Carga de módulos externos limpios
local phases = dofile(modpath .. "/phases.lua")
local chests_manager = dofile(modpath .. "/chests.lua")
chests_manager.phases = phases
local storage = minetest.get_mod_storage()

local OVERWORLD_POS = {x = 0, y = 10, z = 0}
local dead_players = {}

-- Función auxiliar para selección ponderada (weighted random)
local function choose_weighted(items_table, pr)
    local total = 0
    for _, item in ipairs(items_table) do
        total = total + (item.weight or 1)
    end
    if total == 0 then return nil end
    
    local roll = pr:next(1, total)
    local acc = 0
    for _, item in ipairs(items_table) do
        acc = acc + (item.weight or 1)
        if roll <= acc then
            return item
        end
    end
    return items_table[1]
end

-- Función para obtener la fase actual según los bloques rotos y la dimensión
local function get_current_phase(blocks_mined, dimension)
    for _, phase in ipairs(phases) do
        if dimension == phase.dimension then
            local max_b = phase.max_blocks or math.huge
            if blocks_mined >= phase.min_blocks and blocks_mined <= max_b then
                return phase
            end
        end  
    end
    -- Fallback por seguridad
    return phases[1]
end

-- Función auxiliar para procesar tablas (global_ow_items y phase.items)
-- Filtrar elementos si es Fase 1 y aún no se alcanza el bloque 100
local available_items = {}
local blocks_mined = storage:get_int("blocks_mined_overworld") or 0
local last_animal_block = storage:get_int("last_animal_block") or 0
local last_hostile_block = storage:get_int("last_hostile_block") or 0
local last_lava_ow_block = storage:get_int("last_lava_ow_block") or 0
local last_water_block = storage:get_int("last_water_block") or 0
local function process_items(items_table)
    if not items_table then return end
    for _, item in ipairs(items_table) do
        local include = true
        if item.type == "mob" then
            -- Requiere >= 100 bloques Y que hayan pasado al menos 20 bloques desde el último animal
            if blocks_mined < 100 or (blocks_mined - last_animal_block < 20) then
                include = false
            end
        elseif item.type == "hostile_mob" then
            -- Requiere >= 200 bloques Y que hayan pasado al menos 50 bloques desde el último hostil
            if blocks_mined < 200 or (blocks_mined - last_hostile_block < 50) then
                include = false
            end
        elseif item.type == "lava" then
            -- Requiere >= 400 bloques y que hayan pasado al menos 50 bloques desde el último bloque
            if blocks_mined < 400 or (blocks_mined - last_lava_ow_block < 50) then
                include = false
            end            
        elseif item.type == "water" then
            -- Requiere >= 75 bloques y que hayan pasado al menos 30 bloques desde el último bloque
            if blocks_mined < 75 or (blocks_mined - last_water_block < 30) then
                include = false
            end            
        end
        -- No permitas que un identificador desactualizado de phases.lua
        -- llegue a set_node/add_entity y detenga el servidor.
        if (item.type == "node" or item.type == "water" or item.type == "lava")
                and (not item.name or not minetest.registered_nodes[item.name]) then
            include = false
        elseif (item.type == "mob" or item.type == "hostile_mob")
                and (not item.name or not minetest.registered_entities[item.name]) then
            include = false
        end
        if include then
            table.insert(available_items, item)
        end
    end
end

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

-- ====================================================================
-- SISTEMA DE SPAWN Y CAMAS
-- ====================================================================

local function force_oneblock_spawn(player)
    if not player or not player:is_player() then return end
    local name = player:get_player_name()
    -- Mantener inmunidad solo por 1 segundo post-respawn para absorber daño residual
    dead_players[name] = true
    minetest.after(1.0, function()
        dead_players[name] = nil
    end)

    -- 1. Frenado síncrono inmediato para matar cualquier inercia de caída residual
    player:set_velocity({x = 0, y = 0, z = 0})
    player:set_acceleration({x = 0, y = 0, z = 0})
    player:set_pos({x = OVERWORLD_POS.x + 0.5, y = OVERWORLD_POS.y + 1.5, z = OVERWORLD_POS.z + 0.5})

    -- 2. Asegurar el área de forma instantánea
    minetest.emerge_area(
        {x = OVERWORLD_POS.x - 2, y = OVERWORLD_POS.y - 2, z = OVERWORLD_POS.z - 2},
        {x = OVERWORLD_POS.x + 2, y = OVERWORLD_POS.y + 2, z = OVERWORLD_POS.z + 2},
        function(blockpos, action, calls_remaining)
            if calls_remaining == 0 then
                if minetest.get_node(OVERWORLD_POS).name == "air" then
                    minetest.set_node(OVERWORLD_POS, {name = "mcl_core:dirt_with_grass"})
                end
                local below_pos = {x = OVERWORLD_POS.x, y = OVERWORLD_POS.y - 1, z = OVERWORLD_POS.z}
                if minetest.get_node(below_pos).name == "air" then
                    minetest.set_node(below_pos, {name = "mcl_core:bedrock"})
                end

                -- 2. Posicionar al jugador limpiamente anulando toda inercia de caída
                if player and player:is_player() then
                    player:set_velocity({x = 0, y = 0, z = 0})
                    player:set_pos({x = OVERWORLD_POS.x + 0.5, y = OVERWORLD_POS.y + 1.5, z = OVERWORLD_POS.z + 0.5})
                end
                
                -- Doble reconfirmación síncrona instantánea para evitar desfases de física
                minetest.after(0.1, function()
                    if player and player:is_player() then
                        player:set_velocity({x = 0, y = 0, z = 0})
                        player:set_pos({x = OVERWORLD_POS.x + 0.5, y = OVERWORLD_POS.y + 1.5, z = OVERWORLD_POS.z + 0.5})
                    end
                end)
            end
        end
    )
end

-- 1. Jugador Nuevo: Entra por primera vez al mundo comercial
minetest.register_on_newplayer(function(player)
    force_oneblock_spawn(player)
end)

-- 2. Jugador que se Reconecta: Mantiene su posición exacta (evita el exploit de salir/entrar para salvarse de la caída)
minetest.register_on_joinplayer(function(player)
    if not player or not player:is_player() then return end
    
    -- Solo aseguramos los chunks en memoria por seguridad, pero NO alteramos su posición de desconexión
    minetest.emerge_area(
        {x = OVERWORLD_POS.x - 2, y = OVERWORLD_POS.y - 2, z = OVERWORLD_POS.z - 2},
        {x = OVERWORLD_POS.x + 2, y = OVERWORLD_POS.y + 2, z = OVERWORLD_POS.z + 2},
        function(blockpos, action, calls_remaining)
            if calls_remaining == 0 then
                if minetest.get_node(OVERWORLD_POS).name == "air" then
                    minetest.set_node(OVERWORLD_POS, {name = "mcl_core:dirt_with_grass"})
                end
            end
        end
    )
end)

-- 3. Respawn al Morir: La lógica comercial perfecta (Cama -> Si no hay cama o se destruyó -> OneBlock estricto)
if minetest.get_modpath("mcl_spawn") and mcl_spawn.spawn then
    local old_spawn = mcl_spawn.spawn
    
    mcl_spawn.spawn = function(player)
        if not player or not player:is_player() then return end

        -- 1. Anular toda inercia previa antes de procesar el destino
        player:set_velocity({x = 0, y = 0, z = 0})

        local meta = player:get_meta()
        local spawn_str = meta:get_string("mcl_beds:spawn")
        local has_valid_bed = false

        -- Verificar la cama asegurando no borrar el spawn si el chunk no está cargado ("ignore")
        if spawn_str and spawn_str ~= "" then
            local bed_pos = minetest.string_to_pos(spawn_str)
            if bed_pos then
                local node = minetest.get_node_or_nil(bed_pos)
                if not node then
                    node = minetest.get_node(bed_pos)
                end

                if node and node.name ~= "ignore" then
                    -- Chunk cargado: verificar físicamente el bloque
                    if string.find(node.name, "bed") or string.find(node.name, "respawn_anchor") then
                        has_valid_bed = true
                    else
                        -- Cama/Ancla fue destruida realmente, limpiar metadatos
                        meta:set_string("mcl_beds:spawn", "")
                    end
                else
                    -- Chunk no cargado ("ignore"): asumir que la cama sigue ahí para no borrarla
                    has_valid_bed = true
                end
            end
        end

        -- 2. Si tiene cama válida, delegar en Mineclonia asegurando velocidad cero
        if has_valid_bed then
            -- Intentar respawn nativo en cama
            local success = old_spawn(player)
            if success then
                minetest.after(0, function(p)
                    if p and p:is_player() then
                        p:set_velocity({x = 0, y = 0, z = 0})
                        p:set_acceleration({x = 0, y = 0, z = 0})
                    end
                end, player)
                return true
            end
        end

        -- 3. Si no tiene cama, forzar directamente al OneBlock de forma atómica
        force_oneblock_spawn(player)
        return true
    end
end

-- ====================================================================
-- LÓGICA DE ROMPER BLOQUES (CONEXIÓN MODULAR DE PHASES Y CHESTS)
-- ====================================================================

minetest.register_on_dignode(function(pos, oldnode, digger)
    local nether_pos_str = storage:get_string("nether_ob_pos")
    local nether_pos = nether_pos_str ~= "" and minetest.string_to_pos(nether_pos_str) or nil
    local end_pos_str = storage:get_string("end_ob_pos")
    local end_pos = end_pos_str ~= "" and minetest.string_to_pos(end_pos_str) or nil

    local pr = mcl_eodp.pr

    -- A. ONEBLOCK OVERWORLD
    if pos.x == OVERWORLD_POS.x and pos.y == OVERWORLD_POS.y and pos.z == OVERWORLD_POS.z then
        -- Leer de mod_storage en cada rotura permite que /eodp_set_count
        -- actualice también el contador activo durante la sesión.
        blocks_mined = storage:get_int("blocks_mined_overworld") + 1
        storage:set_int("blocks_mined_overworld", blocks_mined)

        -- Buscar fase actual en phases.lua
        local current_phase = get_current_phase(blocks_mined, "overworld")
        
        -- Encontrar el índice numérico de la fase actual para los cofres
        local current_phase_index = 1
        for idx, p in ipairs(phases) do
            if p.name == current_phase.name then
                current_phase_index = idx
                break
            end
        end

        -- Cada sorteo debe partir solo de las opciones de esta fase.
        available_items = {}

        -- Procesar tanto los ítems globales como los de la fase actual
        process_items(phases.global_ow_items)
        process_items(current_phase.items)

        -- Seleccionar ítem según los pesos de phases.lua
        local selected = choose_weighted(available_items, pr)
        local next_node = "mcl_core:dirt"

        if selected then
            if selected.type == "node" then
                next_node = selected.name
                minetest.set_node(OVERWORLD_POS, {name = next_node})
                
            elseif selected.type == "chest" then
                next_node = EODP_CHEST
                minetest.set_node(OVERWORLD_POS, {name = next_node})
                
                -- Control de cofre especial (cada 4 cofres)
                local chest_count = storage:get_int("chest_count") or 0
                chest_count = chest_count + 1
                storage:set_int("chest_count", chest_count)
                local is_special = (chest_count % 4 == 0)

                local captured_pos = vector.new(OVERWORLD_POS)
                local captured_phase = current_phase_index
                local captured_special = is_special

                minetest.after(0, function()
                    if chests_manager and chests_manager.populate then
                        chests_manager.populate(captured_pos, captured_phase, captured_special)
                    end
                end)
                
            elseif selected.type == "mob" then
                next_node = "mcl_core:dirt"
                minetest.set_node(OVERWORLD_POS, {name = next_node})
                minetest.add_entity({x = pos.x, y = pos.y + 1, z = pos.z}, selected.name)

                -- Guardamos el bloque actual para activar el cooldown de 20 bloques en animales
                storage:set_int("last_animal_block", blocks_mined)

            elseif selected.type == "hostile_mob" then
                next_node = "mcl_core:dirt"
                minetest.set_node(OVERWORLD_POS, {name = next_node})
                minetest.add_entity({x = pos.x, y = pos.y + 1, z = pos.z}, selected.name)
                
                -- Guardamos el bloque actual para activar el cooldown de 50 bloques en hostiles
                storage:set_int("last_hostile_block", blocks_mined)
            elseif selected.type == "lava" then
                next_node = "mcl_core:lava_source"
                minetest.set_node(OVERWORLD_POS, {name = next_node})
                
                -- Guardamos el bloque actual para activar el cooldown de 50 bloques en hostiles
                storage:set_int("last_lava_ow_block", blocks_mined)
            elseif selected.type == "water" then
                next_node = "mcl_core:water_source"
                minetest.set_node(OVERWORLD_POS, {name = next_node})
                -- Guardamos el bloque actual para activar el cooldown de 30 bloques en hostiles
                storage:set_int("last_water_block", blocks_mined)
            end
        end

        if digger and digger.is_player and digger:is_player() then
            snap_player(digger, OVERWORLD_POS)
        end
        mcl_eodp.ensure_oneblock_node(OVERWORLD_POS, "mcl_core:dirt")

    -- B. ONEBLOCK NETHER
    elseif nether_pos and pos.x == nether_pos.x and pos.y == nether_pos.y and pos.z == nether_pos.z then
        local blocks_mined_nether = storage:get_int("blocks_mined_nether") or 0
        blocks_mined_nether = blocks_mined_nether + 1
        storage:set_int("blocks_mined_nether", blocks_mined_nether)

        local current_phase = get_current_phase(blocks_mined_nether, "nether")
        local current_phase_index = 1
        for idx, p in ipairs(phases) do
            if p.name == current_phase.name then current_phase_index = idx break end
        end

        local selected = choose_weighted(current_phase.items, pr)
        local next_node = "mcl_nether:netherrack"
        local spawned_mob
        local chest_special

        if selected then
            if selected.type == "node" then
                next_node = selected.name
            elseif selected.type == "chest" then
                next_node = EODP_CHEST
                local chest_count = storage:get_int("chest_count") or 0
                chest_count = chest_count + 1
                storage:set_int("chest_count", chest_count)
                chest_special = (chest_count % 4 == 0)
            elseif selected.type == "mob" or selected.type == "hostile_mob" then
                spawned_mob = selected.name
            end
        end
        minetest.set_node(nether_pos, {name = next_node})
        if next_node == EODP_CHEST and chests_manager and chests_manager.populate then
            local captured_pos = vector.new(nether_pos)
            local captured_phase = current_phase_index
            local captured_special = chest_special
            minetest.after(0, function()
                chests_manager.populate(captured_pos, captured_phase, captured_special)
            end)
        end
        if spawned_mob and minetest.registered_entities[spawned_mob] then
            minetest.add_entity({x = nether_pos.x, y = nether_pos.y + 1, z = nether_pos.z}, spawned_mob)
        end
        if digger and digger.is_player and digger:is_player() then
            snap_player(digger, nether_pos)
        end
        mcl_eodp.ensure_oneblock_node(nether_pos, "mcl_nether:netherrack")

    -- C. ONEBLOCK END
    elseif end_pos and pos.x == end_pos.x and pos.y == end_pos.y and pos.z == end_pos.z then
        local blocks_mined_end = storage:get_int("blocks_mined_end") or 0
        blocks_mined_end = blocks_mined_end + 1
        storage:set_int("blocks_mined_end", blocks_mined_end)

        local current_phase = get_current_phase(blocks_mined_end, "end")
        local current_phase_index = 1
        for idx, p in ipairs(phases) do
            if p.name == current_phase.name then current_phase_index = idx break end
        end

        local selected = choose_weighted(current_phase.items, pr)
        local next_node = "mcl_end:end_stone"
        local chest_special

        if selected then
            if selected.type == "node" then
                next_node = selected.name
            elseif selected.type == "chest" then
                next_node = EODP_CHEST
                local chest_count = storage:get_int("chest_count") or 0
                chest_count = chest_count + 1
                storage:set_int("chest_count", chest_count)
                chest_special = (chest_count % 4 == 0)
            end
        end
        minetest.set_node(end_pos, {name = next_node})
        if next_node == EODP_CHEST and chests_manager and chests_manager.populate then
            chests_manager.populate(end_pos, current_phase_index, chest_special)
        end
        if digger and digger.is_player and digger:is_player() then
            snap_player(digger, end_pos)
        end
        mcl_eodp.ensure_oneblock_node(end_pos, "mcl_end:end_stone")
    end
end)

local function find_nether_portal_nodes(pos)
    local center = vector.round(pos)
    return minetest.find_nodes_in_area(
        vector.subtract(center, 8), vector.add(center, 8), {"mcl_portals:portal"})
end

local function give_nether_recovery_compass(player, nether_pos, portal_pos)
    local meta = player:get_meta()
    local inv = player:get_inventory()
    local compass = ItemStack("mcl_compass:compass_recovery")
    if compass:is_empty() then
        minetest.log("error", "[mcl_eodp] No existe mcl_compass:compass_recovery")
        return
    end

    -- Mineclonia lee esta metadata del jugador para orientar la brújula.
    meta:set_string("mcl_compass:recovery_pos", minetest.pos_to_string(nether_pos))
    if meta:get_int("eodp_nether_compass_received") == 1 then
        for _, listname in ipairs({"main", "offhand"}) do
            for i = 1, inv:get_size(listname) do
                if inv:get_stack(listname, i):get_name() == compass:get_name() then return end
            end
        end
    end
    if inv:room_for_item("main", compass) then
        inv:add_item("main", compass)
        meta:set_int("eodp_nether_compass_received", 1)
        minetest.chat_send_player(player:get_player_name(), "🧭 [OneBlock] Recibiste una brújula que señala el OneBlock del Nether.")
        return
    end

    -- Buscar un espacio apoyado junto al portal, del lado del Nether.
    portal_pos = portal_pos or minetest.string_to_pos(storage:get_string("nether_portal_pos")) or player:get_pos()
    local portal_nodes = find_nether_portal_nodes(portal_pos)
    local portal_floor_y
    for _, portal_pos in ipairs(portal_nodes) do
        portal_floor_y = portal_floor_y and math.min(portal_floor_y, portal_pos.y) or portal_pos.y
    end

    local chest_pos
    if portal_floor_y then
        local offsets = {{x=1,z=0}, {x=-1,z=0}, {x=0,z=1}, {x=0,z=-1},
            {x=2,z=0}, {x=-2,z=0}, {x=0,z=2}, {x=0,z=-2}}
        for _, portal_pos in ipairs(portal_nodes) do
            if portal_pos.y == portal_floor_y then
                for _, offset in ipairs(offsets) do
                    local candidate = {x=portal_pos.x + offset.x, y=portal_floor_y, z=portal_pos.z + offset.z}
                    local node = minetest.get_node_or_nil(candidate)
                    local below = minetest.get_node_or_nil({x=candidate.x, y=candidate.y-1, z=candidate.z})
                    local def = node and minetest.registered_nodes[node.name]
                    local below_def = below and minetest.registered_nodes[below.name]
                    if def and def.buildable_to and below_def and below_def.walkable
                            and mcl_worlds.pos_to_dimension(candidate) == "nether" then
                        chest_pos = candidate
                        break
                    end
                end
            end
            if chest_pos then break end
        end
    end
    if not chest_pos then
        minetest.chat_send_player(player:get_player_name(), "[OneBlock] No encontré espacio para el cofre junto al portal del Nether; conserva un espacio libre junto a la salida.")
        return
    end

    minetest.set_node(chest_pos, {name = EODP_CHEST})
    local chest_meta = minetest.get_meta(chest_pos)
    chest_meta:set_int("eodp_temporary_nether_compass", 1)
    local chest_inv = chest_meta:get_inventory()
    chest_inv:set_size("main", 27)
    chest_inv:add_item("main", compass)
    meta:set_int("eodp_nether_compass_received", 1)
    minetest.chat_send_player(player:get_player_name(), "📦 [OneBlock] Inventario lleno: la brújula está en el cofre temporal junto al portal del Nether.")
end

local function ensure_nether_oneblock(player)
    if not player or not player:is_player() then return end
    local pos = player:get_pos()
    if mcl_worlds.pos_to_dimension(pos) ~= "nether" then return end

    local layout_version = storage:get_int("nether_ob_layout_version")
    local nether_pos_str = storage:get_string("nether_ob_pos")
    local nether_pos = nether_pos_str ~= "" and minetest.string_to_pos(nether_pos_str) or nil
    local portal_nodes = find_nether_portal_nodes(pos)
    local portal_pos = vector.new(pos)
    if #portal_nodes > 0 then
        portal_pos = {x=0, y=pos.y, z=0}
        for _, node_pos in ipairs(portal_nodes) do
            portal_pos.x = portal_pos.x + node_pos.x / #portal_nodes
            portal_pos.z = portal_pos.z + node_pos.z / #portal_nodes
        end
        portal_pos = vector.round(portal_pos)
        storage:set_string("nether_portal_pos", minetest.pos_to_string(portal_pos))
    else
        local saved_portal_pos = minetest.string_to_pos(storage:get_string("nether_portal_pos"))
        if saved_portal_pos then portal_pos = saved_portal_pos end
    end
    if not nether_pos or layout_version < 2 then
        -- El ángulo es aleatorio y el radio horizontal siempre supera 100 nodos.
        local angle = math.rad(mcl_eodp.pr:next(0, 35999) / 100)
        local distance = mcl_eodp.pr:next(125, 250)
        local origin = portal_pos
        nether_pos = {
            x = math.floor(origin.x + math.cos(angle) * distance + 0.5),
            y = math.floor(pos.y),
            z = math.floor(origin.z + math.sin(angle) * distance + 0.5),
        }
        storage:set_string("nether_ob_pos", minetest.pos_to_string(nether_pos))
        storage:set_int("nether_ob_layout_version", 2)
        storage:set_int("nether_ob_initialized", 0)
        minetest.chat_send_player(player:get_player_name(), "🔥 [OneBlock] El desafío del Nether se generó en una ubicación aleatoria, a más de 100 bloques de la entrada.")
    end

    -- Inicializa también posiciones guardadas por la versión anterior, que
    -- podía dejar el punto sin bloque si el mapa no devolvía aire.
    if storage:get_int("nether_ob_initialized") ~= 1 then
        local target = vector.new(nether_pos)
        minetest.emerge_area(vector.subtract(target, 2), vector.add(target, 2), function(_, _, remaining)
            if remaining > 0 then return end
            minetest.set_node(target, {name = "mcl_nether:netherrack"})
            local below = {x=target.x, y=target.y-1, z=target.z}
            local below_node = minetest.get_node_or_nil(below)
            if below_node and (below_node.name == "air" or below_node.name == "mcl_core:void") then
                minetest.set_node(below, {name = "mcl_core:bedrock"})
            end
            storage:set_int("nether_ob_initialized", 1)
            if player and player:is_player() then
                give_nether_recovery_compass(player, target, portal_pos)
            end
        end)
        return
    end

    give_nether_recovery_compass(player, nether_pos, portal_pos)
end

-- Usar el cambio de dimensión de Mineclonia evita depender de rangos Y fijos.
mcl_worlds.register_on_dimension_change(function(player, dimension)
    if dimension == "nether" then ensure_nether_oneblock(player) end
end)

-- También cubre jugadores que ya estaban dentro del Nether al reiniciar el servidor.
minetest.register_on_joinplayer(function(player)
    minetest.after(1, function(p)
        if p and p:is_player() then ensure_nether_oneblock(p) end
    end, player)
end)
