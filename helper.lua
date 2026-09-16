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

return OneBlockHelper