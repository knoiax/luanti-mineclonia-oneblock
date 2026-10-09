-- oneblock.lua
local modname = minetest.get_current_modname()
local modpath = minetest.get_modpath(modname)
local S = minetest.get_translator(modname)

-- 1. Carga de módulos externos limpios
local phases = dofile(modpath .. "/phases.lua")
local chests_manager = dofile(modpath .. "/chests.lua")
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
            if blocks_mined >= phase.min_blocks and blocks_mined <= phase.max_blocks then
                return phase
            end
        end  
    end
    -- Si supera la última fase definida, retorna la última de esa dimensión
    for i = #phases, 1, -1 do
        if phases[i].dimension == dimension then
            return phases[i]
        end
    end
    return phases[1]
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

    local pr = mcl_oneblock and mcl_oneblock.pr or PcgRandom(os.time())

    -- A. ONEBLOCK OVERWORLD
    if pos.x == OVERWORLD_POS.x and pos.y == OVERWORLD_POS.y and pos.z == OVERWORLD_POS.z then
        local blocks_mined = storage:get_int("blocks_mined_overworld") or 0
        blocks_mined = blocks_mined + 1
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

        -- Seleccionar ítem según los pesos de phases.lua
        local selected = choose_weighted(current_phase.items, pr)
        local next_node = "mcl_core:dirt"

        if selected then
            if selected.type == "node" then
                next_node = selected.name
                minetest.set_node(OVERWORLD_POS, {name = next_node})
                
            elseif selected.type == "chest" then
                next_node = "mcl_chests:chest"
                minetest.set_node(OVERWORLD_POS, {name = next_node})
                
                -- Control de cofre especial (cada 4 cofres)
                local chest_count = storage:get_int("chest_count") or 0
                chest_count = chest_count + 1
                storage:set_int("chest_count", chest_count)
                local is_special = (chest_count % 4 == 0)

                -- Poblar el cofre usando chests.lua (pasando posición, índice y si es especial)
                if chests_manager and chests_manager.populate then
                    chests_manager.populate(OVERWORLD_POS, current_phase_index, is_special)
                end
                
            elseif selected.type == "mob" then
                next_node = "mcl_core:dirt"
                minetest.set_node(OVERWORLD_POS, {name = next_node})
                minetest.add_entity({x = pos.x, y = pos.y + 1, z = pos.z}, selected.name)
            end
        end

        if digger and digger.is_player and digger:is_player() then
            snap_player(digger, OVERWORLD_POS)
        end

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

        if selected then
            if selected.type == "node" then
                next_node = selected.name
            elseif selected.type == "chest" then
                next_node = "mcl_chests:chest"
                local chest_count = storage:get_int("chest_count") or 0
                chest_count = chest_count + 1
                storage:set_int("chest_count", chest_count)
                local is_special = (chest_count % 4 == 0)
                if chests_manager and chests_manager.populate then
                    chests_manager.populate(nether_pos, current_phase_index, is_special)
                end
            end
        end
        minetest.set_node(nether_pos, {name = next_node})
        if digger and digger.is_player and digger:is_player() then
            snap_player(digger, nether_pos)
        end

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

        if selected then
            if selected.type == "node" then
                next_node = selected.name
            elseif selected.type == "chest" then
                next_node = "mcl_chests:chest"
                local chest_count = storage:get_int("chest_count") or 0
                chest_count = chest_count + 1
                storage:set_int("chest_count", chest_count)
                local is_special = (chest_count % 4 == 0)
                if chests_manager and chests_manager.populate then
                    chests_manager.populate(end_pos, current_phase_index, is_special)
                end
            end
        end
        minetest.set_node(end_pos, {name = next_node})
        if digger and digger.is_player and digger:is_player() then
            snap_player(digger, end_pos)
        end
    end
end)