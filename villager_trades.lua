-- === ARCHIVO: ./villager_trades.lua ===
local PREFIX = mcl_eodp.prefix.de_papi
local IF_PREFIX = mcl_eodp.prefix.italian_food

minetest.register_on_mods_loaded(function()
    if not (minetest.get_modpath("mobs_mc") and mobs_mc and mobs_mc.villager_trades) then
        return
    end

    -- 1. Compra de limones por parte del Granjero (Nivel 1)
    if mobs_mc.villager_trades.farmer and mobs_mc.villager_trades.farmer[1] then
        table.insert(mobs_mc.villager_trades.farmer[1], {
            { PREFIX .. "lemon", 18, 18 },
            "mcl_core:emerald",
            16,
            2
        })
    end

    -- 2. Venta de Limonada por parte del Granjero (Nivel 2)
    if mobs_mc.villager_trades.farmer and mobs_mc.villager_trades.farmer[2] then
        table.insert(mobs_mc.villager_trades.farmer[2], {
            { "mcl_core:emerald", 2, 2 },
            { PREFIX .. "lemonade", 1, 1 },
            12,
            5
        })
    end

    -- 3. Venta de Queso de Oveja por el Granjero (Nivel 3)
    if mobs_mc.villager_trades.farmer and mobs_mc.villager_trades.farmer[3] then
        table.insert(mobs_mc.villager_trades.farmer[3], {
            { "mcl_core:emerald", 3, 3 },
            { IF_PREFIX .. "sheep_cheese", 1, 1 },
            8,
            10
        })
    end

    -- 4. Venta de Queso de Oveja por el Pastor (Nivel 1)
    if mobs_mc.villager_trades.shepherd and mobs_mc.villager_trades.shepherd[1] then
        table.insert(mobs_mc.villager_trades.shepherd[1], {
            { "mcl_core:emerald", 2, 2 },
            { IF_PREFIX .. "sheep_cheese", 1, 1 },
            12,
            2
        })
    end
end)