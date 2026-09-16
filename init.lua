-- Encapsulamiento seguro para evitar cierres periódicos y al iniciar el mundo
if mcl_levelgen then
    local original_can_place_snow = mcl_levelgen.can_place_snow
    
    if type(original_can_place_snow) == "function" then
        mcl_levelgen.can_place_snow = function(...)
            local status, result = pcall(original_can_place_snow, ...)
            if not status then
                -- Si ocurre un error interno en Mineclonia, se captura y se retorna false
                -- evitando que el juego colapse o cierre la sesión del usuario.
                return false
            end
            return result
        end
    else
        -- Si la función no existe en el momento de carga, provee un fallback seguro
        mcl_levelgen.can_place_snow = function(...)
            return false
        end
    end
end

local modname = minetest.get_current_modname()
local modpath = minetest.get_modpath(modname)

-- Cargar módulo Helper de funciones auxiliares para pruebas y depuración en vivo
dofile(minetest.get_modpath(minetest.get_current_modname()) .. "/helper.lua")

-- Cargar lógica principal de OneBlock
dofile(modpath .. "/oneblock.lua")