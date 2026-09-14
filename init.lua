local modname = minetest.get_current_modname()
local modpath = minetest.get_modpath(modname)

-- Cargar funciones auxiliares y comandos de prueba
dofile(modpath .. "/helper.lua")

-- Cargar lógica principal de OneBlock
dofile(modpath .. "/oneblock.lua")