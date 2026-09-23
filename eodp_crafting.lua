local PREFIX = mcl_eodp.prefix.de_papi

-- RECETA DE CRAFTEO DE LIMONADA
core.register_craft({
    output = PREFIX .. "lemonade 2",
    recipe = {
        {PREFIX .. "lemon", "mcl_potions:water", ""},
        {"", "mcl_potions:glass_bottle",  ""},
        {"", "", "mcl_core:sugar"},
    },
})