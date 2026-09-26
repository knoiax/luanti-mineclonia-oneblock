local modname = "eodp"
local PREFIX = mcl_eodp.prefix.de_papi
local IF_PREFIX = mcl_eodp.prefix.italian_food
local S = minetest.get_translator(modname)

-- 1. Verificación de API/Mod
if not minetest.get_modpath("mcl_stairs") then
    return
end

-- 2. Registro de Escaleras y Losas para Madera de Limonero
mcl_stairs.register_stair_and_slab("lemonwood", {
    baseitem = PREFIX .. "lemonwood",
    description_stair = S("Lemon Wood Stairs"),
    description_slab = S("Lemon Wood Slab"),
})

-- 3. Registro de Escaleras y Losas para Madera de Olivo
mcl_stairs.register_stair_and_slab("olivewood", {
    baseitem = IF_PREFIX .. "olivewood",
    description_stair = S("Olive Wood Stairs"),
    description_slab = S("Olive Wood Slab"),
})