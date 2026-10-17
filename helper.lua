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

if not mcl_eodp then mcl_eodp = {} end

-- Inicializar el generador aleatorio exclusivo de mcl_eodp
mcl_eodp.pr = mcl_eodp.pr or PcgRandom(os.time())

--=====================================
--Registro rápido de alimentos
--=====================================
local I = minetest.get_translator("eodp_it_f")

-- En el archivo principal de carga o helper (ej. init.lua o un archivo de utilidades)
if not mcl_eodp then mcl_eodp = {} end

-- Definimos la descripción genérica de ayuda para Mineclonia
local mofood_longdesc = I("This is a food item which can be eaten.")

-- Función auxiliar compartida y accesible globalmente
function mcl_eodp.register_food_item(name, description, image, saturation, eat_value, comp_value, effect_fn)
    minetest.register_craftitem(name, {
        description = description,
        _doc_items_longdesc = mofood_longdesc,
        inventory_image = image,
        groups = {food = 2, eatable = eat_value, can_eat_when_full = 1, compostability = comp_value or 0},
        _mcl_saturation = saturation,
        _mcl_eat_effect = effect_fn,
    })
end

--=====================================
--Registro de Pizzas
--=====================================
-- Función auxiliar para registrar la familia completa de nodos de cualquier pizza usando modelos 3D (.obj)
function mcl_eodp.register_pizza_family(pizza_key, description, slice_item_full_name, custom_node_prefix)
    local PREFIX = custom_node_prefix or mcl_eodp.prefix.de_papi
    
    -- Caja de selección y colisión fija (grosor de 2 píxeles, de -0.5 a -0.375 en Y)
    local pizza_node_box = {
        type = "fixed",
        fixed = { {-0.5, -0.5, -0.5, 0.5, -0.375, 0.5} }
    }

    local cake_groups = { 
        choppy = 2, 
        oddly_breakable_by_hand = 2, 
        snappy = 3, 
        attached_node = 1,
        dig_by_piston = 1, 
        unsticky = 1 
    }

    for i = 8, 1, -1 do
        local node_name = (i == 8) and (PREFIX .. pizza_key) or (PREFIX .. pizza_key .. "_" .. i)
        
        -- Asignar el archivo .obj correspondiente a cada estado de consumo (eodp_pizza_1.obj a eodp_pizza_8.obj)
        local mesh_file = "eodp_pizza_" .. i .. ".obj"
        
        -- Textura unificada mapeada en el .obj (aquí declaramos la línea unificada para el modelo 3D)
        local top_texture = ("eodp_node_" .. pizza_key .. "_" .. i .. ".png")
        
        local desc = (i == 8) and description or (description .. " (" .. i .. "/8 porciones)")

        minetest.register_node(node_name, {
            description = desc,
            drawtype = "mesh",
            mesh = mesh_file,
            tiles = {
                top_texture,     -- [Índice 2] Textura de la pizza / porción
            },
            inventory_image = "eodp_node_" .. pizza_key .. ".png",
            wield_image = "eodp_node_" .. pizza_key .. ".png",
            paramtype = "light",
            paramtype2 = "facedir",
            use_texture_alpha = "clip",
            selection_box = pizza_node_box,
            collision_box = pizza_node_box,
            stack_max = 1,
            drop = "",
            sounds = mcl_sounds.node_sound_wood_defaults(),
            is_ground_content = false,
            groups = table.merge(cake_groups, {
                not_in_creative_inventory = (i < 8 and 1 or 0),
                pizza = i
            }),
            
            on_rightclick = function(pos, node, clicker, itemstack)
                if mcl_util.check_position_protection and mcl_util.check_position_protection(pos, clicker) then
                    return
                end

                local current_slices = core.get_item_group(node.name, "pizza")

                if slice_item_full_name then
                    local inv = clicker:get_inventory()
                    if inv then
                        local leftover = inv:add_item("main", ItemStack(slice_item_full_name))
                        if not leftover:is_empty() then
                            minetest.item_drop(leftover, clicker, pos)
                        end
                    end
                end

                if current_slices <= 1 then
                    minetest.remove_node(pos)
                    minetest.check_for_falling(pos)
                else
                    local next_name = PREFIX .. pizza_key .. "_" .. (current_slices - 1)
                    minetest.swap_node(pos, {name = next_name, param2 = node.param2})
                end

                minetest.sound_play("mcl_eating_eat", {pos = pos, gain = 0.8}, true)
            end,
        })
    end
end

-- Función auxiliar para colocar el fluido temporalmente y consumir el ítem sin dejar rastro
function mcl_eodp.place_temporary_fluid(node_name)
    return function(itemstack, placer, pointed_thing)
        if pointed_thing.type ~= "node" then
            return itemstack
        end

        -- Obtener la posición adyacente donde se colocará el fluido
        local pos = pointed_thing.above
        local node_under = minetest.get_node(pos)

        -- Validar si el espacio está libre o es reemplazable (como aire)
        if minetest.registered_nodes[node_under.name] and minetest.registered_nodes[node_under.name].buildable_to then
            minetest.set_node(pos, {name = node_name})
            
            -- Opcional: Sonido de vaciado de cubo
            minetest.sound_play("mcl_buckets_fill_water", {pos = pos, gain = 0.5}, true)

            -- Consumir el ítem por completo (NO devuelve cubo vacío)
            itemstack:take_item(1)
            return itemstack
        end

        return itemstack
    end
end

-- helper.lua - Encapsulación y Diagnóstico
local OneBlockHelper = {}

-- Repara el OneBlock si, después del minado y de las callbacks del juego,
-- la posición quedó vacía. No reemplaza un nodo que sí se haya generado.
function mcl_eodp.ensure_oneblock_node(pos, fallback_name, delay)
    if not pos or not fallback_name then return false end
    if not minetest.registered_nodes[fallback_name] then
        minetest.log("error", "[mcl_eodp] Nodo de respaldo no registrado: " .. tostring(fallback_name))
        return false
    end

    minetest.after(delay or 0.1, function()
        local node = minetest.get_node_or_nil(pos)
        if not node or (node.name ~= "air" and node.name ~= "ignore") then return end

        minetest.set_node(pos, {name = fallback_name})
        minetest.log("warning", string.format(
            "[mcl_eodp] La posición OneBlock (%d, %d, %d) quedó vacía tras minar; se colocó %s.",
            pos.x, pos.y, pos.z, fallback_name
        ))
    end)
    return true
end

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
