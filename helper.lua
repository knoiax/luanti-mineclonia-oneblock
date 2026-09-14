-- ====================================================================
-- HELPER DE PRUEBAS / DEBUG PARA ONEBLOCK
-- Uso en juego: /test_oneblock_items
-- Requisito: Tener privilegio 'give' o ser administrador
-- ====================================================================

minetest.register_chatcommand("test_oneblock_items", {
    params = "",
    description = "Entrega al jugador un stack de cada ítem configurado y registrado",
    privs = {give = true},
    func = function(name, param)
        local player = minetest.get_player_by_name(name)
        if not player then 
            return false, "Jugador no encontrado." 
        end
        
        local inv = player:get_inventory()
        local agregados = 0
        local omitidos = 0

        -- Si existen pools o tablas globales definidas en tu mod, las escanea de forma segura
        local pools_to_check = {}
        
        -- Escaneo condicional de pools si están definidos globalmente
        if overworld_phase_1 then table.insert(pools_to_check, overworld_phase_1) end
        if overworld_phase_2 then table.insert(pools_to_check, overworld_phase_2) end
        if overworld_phase_3 then table.insert(pools_to_check, overworld_phase_3) end
        if overworld_phase_4 then table.insert(pools_to_check, overworld_phase_4) end
        if nether_pool then table.insert(pools_to_check, nether_pool) end
        if end_pool then table.insert(pools_to_check, end_pool) end

        for _, pool in ipairs(pools_to_check) do
            for _, raw_item in ipairs(pool) do
                -- Limpiar cantidad si el string contiene formato "item_name count"
                local item_name = string.match(raw_item, "^(%S+)") or raw_item

                if minetest.registered_items[item_name] or minetest.registered_nodes[item_name] then
                    inv:add_item("main", item_name .. " 64")
                    agregados = agregados + 1
                else
                    omitidos = omitidos + 1
                    minetest.log("warning", "[OneBlock Helper] Ítem no registrado/desactivado: " .. tostring(item_name))
                end
            end
        end

        return true, string.format("Prueba completada: %d ítems entregados, %d no registrados/omitidos.", agregados, omitidos)
    end,
})