local PREFIX = mcl_eodp.prefix.de_papi
local IF_PREFIX = mcl_eodp.prefix.italian_food

minetest.register_on_mods_loaded(function()
    if not minetest.get_modpath("mobs_mc") then
        return
    end

    -- Obtenemos la definición registrada de la entidad
    local entity_def = minetest.registered_entities["mobs_mc:wandering_trader"]
    if not entity_def then
        return
    end

    -- Guardamos la función original de on_spawn
    local original_on_spawn = entity_def.on_spawn

    -- Interceptamos on_spawn para inyectar nuestros intercambios
    entity_def.on_spawn = function(self, ...)
        -- 1. Ejecutamos la lógica original para que genere sus trueques base
        if original_on_spawn then
            original_on_spawn(self, ...)
        end

        -- 2. Definimos nuestras ofertas usando la API interna mobs_mc.trade_from_table
        local pr = PcgRandom(os.time() + 123)
        
        local custom_trades = {
            -- Tomate de Diamante
            { { "mcl_core:emerald", 5, 5 }, { PREFIX .. "diamond_tomato", 1, 1 }, 4, 5 },
            -- Albahaca de Diamante
            { { "mcl_core:emerald", 5, 5 }, { PREFIX .. "diamond_basil", 1, 1 }, 4, 5 },
            -- Semillas de Albahaca
            { { "mcl_core:emerald", 1, 1 }, { IF_PREFIX .. "basil_seeds", 1, 1 }, 12, 1 },
            -- Semillas de Tomate
            { { "mcl_core:emerald", 1, 1 }, { IF_PREFIX .. "tomato_plant_seeds", 1, 1 }, 12, 1 },
            -- Leche de Oveja
            { { "mcl_core:emerald", 3, 3 }, { IF_PREFIX .. "sheep_milk_bucket", 1, 1 }, 6, 3 },
            -- Brote de Limonero
            { { "mcl_core:emerald", 5, 5 }, { PREFIX .. "lemonsapling", 1, 1 }, 8, 5 },
            -- Brote de Olivo
            { { "mcl_core:emerald", 5, 5 }, { IF_PREFIX .. "olivesapling", 1, 1 }, 8, 5 },
        }

        -- Convertimos las tablas a objetos de trueque válidos de Mineclonia
        self._trades = self._trades or {}
        for _, trade_def in ipairs(custom_trades) do
            -- Solo agregamos con una probabilidad o elegimos algunos para no saturar
            if math.random(1, 2) == 1 then
                local trade_obj = mobs_mc.trade_from_table(pr, trade_def, false)
                table.insert(self._trades, trade_obj)
            end
        end

        -- Actualizamos la entidad con la nueva lista combinada
        self:update_trades(self._trades)
    end
end)