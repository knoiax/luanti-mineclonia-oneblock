-- Forzar generador de mapa singlenode (mundo vacío)
minetest.set_mapgen_setting("mg_name", "singlenode", true)

local modname = minetest.get_current_modname()
local modpath = minetest.get_modpath(minetest.get_current_modname())

-- 1. Primero: Cargar las constantes y prefijos
dofile(modpath .. "/constants.lua")

-- 2. Segundo: Cargar las tablas del OneBlock
dofile(modpath .. "/mod_tables.lua")

-- Cargar módulo Helper de funciones auxiliares para pruebas y depuración en vivo
dofile(modpath ..  "/helper.lua")

-- Módulo de Integración Italian Food (i_f)
dofile(modpath .. "/integraciones/i_f/crafting.lua")
dofile(modpath .. "/integraciones/i_f/food.lua")
dofile(modpath .. "/integraciones/i_f/drinks.lua")
dofile(modpath .. "/integraciones/i_f/nodes.lua")
dofile(modpath .. "/integraciones/i_f/tools.lua")
dofile(modpath .. "/integraciones/i_f/olive_tree.lua")
dofile(modpath .. "/integraciones/i_f/crops.lua")


-- Cargar lógica principal de OneBlock
dofile(modpath .. "/oneblock.lua")
dofile(modpath .. "/lemon_tree.lua")
dofile(modpath .. "/eodp_food.lua")
dofile(modpath .. "/eodp_crafting.lua")
dofile(modpath .. "/villager_trades.lua")
dofile(modpath .. "/wandering_trader_trades.lua")
dofile(modpath .. "/eodp_nodes.lua")

-- Integracion de modulos de terceros
-- 3. Tercero: Cargar el registro de ítems de cada integración
-- dofile(modpath .. "/integraciones/morefood.lua")
-- dofile(modpath .. "/integraciones/bronze_stuff.lua")