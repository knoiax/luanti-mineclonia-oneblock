local JsonLoader = {}

local modname = minetest.get_current_modname()
local modpath = minetest.get_modpath(modname)

-- Función centralizada para leer cualquier JSON exportado por tu app de Java
function JsonLoader.load_json_data(filename)
    local filepath = modpath .. "/data/" .. filename
    local file = io.open(filepath, "r")
    
    if not file then
        minetest.log("warning", "[JsonLoader] No se encontró el archivo de configuración: " + filepath)
        return nil
    end

    local content = file:read("*a")
    file:close()

    local parsed_data = minetest.parse_json(content)
    if not parsed_data then
        minetest.log("error", "[JsonLoader] Error de sintaxis JSON en el archivo: " + filename)
        return nil
    end

    return parsed_data
end

return JsonLoader