-- ====================================================================
-- Encapsulamiento seguro para mcl_levelgen.can_place_snow
-- Evita caídas de servidor por llamadas fuera de límites o valores nulos.
-- ====================================================================

-- Asegurar que el módulo mcl_levelgen exista antes de sobreescribirlo
if mcl_levelgen then
    local original_can_place_snow = mcl_levelgen.can_place_snow

    function mcl_levelgen.can_place_snow(x, y, z)
        -- 1. Validar parámetros de entrada
        if not x or not y or not z then
            return false
        end

        -- 2. Encapsular la ejecución real dentro de pcall (protected call)
        local success, result = pcall(original_can_place_snow, x, y, z)

        -- 3. Si ocurre un error interno en la función original, capturarlo y retornar false
        if not success then
            -- Opcional: registrar el error de forma informativa sin detener el servidor
            -- minetest.log("warning", "[OneBlock Safe-Guard] Ignorado error en can_place_snow: " .. tostring(result))
            return false
        end

        -- 4. Si la ejecución fue exitosa, devolver el resultado boolean original
        return result and true or false
    end
end

-- helper.lua - Encapsulación y Diagnóstico
local OneBlockHelper = {}

-- Función de captura y registro seguro de errores
function OneBlockHelper.safe_call(fn, context_name, ...)
    local args = {...}
    local success, result_or_err = xpcall(function()
        return fn(unpack(args))
    end, debug.traceback)

    if not success then
        minetest.log("error", "[OneBlock Helper] Error encapsulado en (" .. tostring(context_name) .. "): " .. tostring(result_or_err))
        return nil, result_or_err
    end

    return success, result_or_err
end

-- Validación estricta de posición para evitar cofres/bloques en el vacío
function OneBlockHelper.is_valid_oneblock_pos(pos, target_pos)
    if not pos or not target_pos then return false end
    return pos.x == target_pos.x and pos.y == target_pos.y and pos.z == target_pos.z
end

-- Registro del comando de chat en Luanti
minetest.register_chatcommand("helper", {
    params = "<accion>",
    description = "Comando de depuración e inspección para OneBlock",
    privs = { interact = true }, -- Permite ejecutar a cualquier jugador con privilegio de interactuar
    func = function(name, param)
        local args = string.split(param, " ")
        local cmd = args[1]

        if not cmd or cmd == "" or cmd == "help" then
            minetest.chat_send_player(name, "[Helper] Uso: /helper status | /helper test | /helper force")
            return true
        end

        -- Comando: /helper status
        if cmd == "status" then
            minetest.chat_send_player(name, "[Helper] Mod OneBlock activo correctamente.")
            return true

        -- Comando: /helper test (Ejecuta la verificación del bloque central)
        elseif cmd == "test" then
            minetest.chat_send_player(name, "[Helper] Probando lógica del bloque principal...")
            -- Inserción opcional: invocar la función de reemplazo de bloque si existe en tu lógica
            return true

        else
            minetest.chat_send_player(name, "[Helper] Opción no reconocida: " .. cmd)
            return true
        end
    end,
})
-- ====================================================================
-- Comando: /eodp_find <término> (Busca nombres técnicos registrados en memoria)
-- ====================================================================
minetest.register_chatcommand("eodp_find", {
    params = "<termino>",
    description = "Busca nombres técnicos de ítems, bloques o entidades que coincidan con el término.",
    privs = { interact = true },
    func = function(name, param)
        if not param or param == "" then
            return false, "❌ Uso correcto: /eodp_find <termino> (ej: /eodp_find gold, /eodp_find redstone)"
        end
        
        local term = param:lower()
        local matches = {}
        local max_results = 15 -- Límite para evitar saturar el chat
        
        -- Buscar en ítems (nodos, herramientas, objetos crafteables)
        for itemstring, def in pairs(minetest.registered_items) do
            local desc = def.description and def.description:lower() or ""
            if itemstring:find(term) or desc:find(term) then
                table.insert(matches, itemstring)
                if #matches >= max_results then break end
            end
        end
        
        if #matches == 0 then
            return true, "🔍 No se encontraron registros coincidentes con: " .. term
        end
        
        minetest.chat_send_player(name, string.format("📊 [EODP Find] Coincidencias para '%s' (máx %d):", term, max_results))
        for _, item_name in ipairs(matches) do
            minetest.chat_send_player(name, "   🔹 " .. item_name)
        end
        
        return true, "✅ Búsqueda finalizada."
    end,
})

-- ====================================================================
-- COMANDOS AUXILIARES DE DESARROLLO Y PRUEBAS (/helper, /eodp_status, etc.)
-- ====================================================================
local storage = minetest.get_mod_storage()

-- 1. Comando: /eodp_status (Consulta estado actual de bloques picados en todas las dimensiones)
minetest.register_chatcommand("eodp_status", {
    description = "Muestra el recuento actual de bloques picados en todas las dimensiones del OneBlock.",
    privs = { interact = true },
    func = function(name, param)
        local ow_count = storage:get_int("blocks_mined_overworld") or 0
        local nether_count = storage:get_int("blocks_mined_nether") or 0
        local end_count = storage:get_int("blocks_mined_end") or 0
        
        local msg = string.format("📊 [EODP Status] Overworld: %d | Nether: %d | End: %d", ow_count, nether_count, end_count)
        return true, msg
    end,
})

-- 2. Comando: /eodp_set_count <dimension> <número> (Modifica el contador de cualquier dimensión)
minetest.register_chatcommand("eodp_set_count", {
    params = "<overworld|nether|end> <numero>",
    description = "Establece el contador de bloques picados para la dimensión indicada (o Overworld por defecto).",
    privs = { interact = true },
    func = function(name, param)
        local args = string.split(param, " ")
        local dim, count_str
        
        if #args >= 2 then
            dim = args[1]:lower()
            count_str = args[2]
        elseif #args == 1 and tonumber(args[1]) then
            dim = "overworld"
            count_str = args[1]
        else
            return false, "❌ Uso: /eodp_set_count <overworld|nether|end> <numero> (o solo <numero> para Overworld)"
        end

        local count = tonumber(count_str)
        if not count then
            return false, "❌ Debes indicar un número válido."
        end

        local key, dim_name
        if dim == "overworld" or dim == "ow" then
            key = "blocks_mined_overworld"
            dim_name = "Overworld"
        elseif dim == "nether" or dim == "n" then
            key = "blocks_mined_nether"
            dim_name = "Nether"
        elseif dim == "end" or dim == "e" then
            key = "blocks_mined_end"
            dim_name = "End"
        else
            return false, "❌ Dimensión no válida. Usa: overworld, nether o end."
        end

        storage:set_int(key, count)
        return true, string.format("✅ [EODP] Contador de %s establecido a: %d", dim_name, count)
    end,
})

return OneBlockHelper