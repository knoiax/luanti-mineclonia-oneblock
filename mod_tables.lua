local T = mcl_eodp.prefix -- Alias corto para escribir menos código

-- Contenedor global de tablas del mod (evita sobreescrituras si se carga varias veces)
mcl_eodp.tables = mcl_eodp.tables or {}
el_oneblock_de_papi_tables = mcl_eodp.tables

-- 1. Categoría: Italian Food (Ítemes y alimentos externos adaptados)
el_oneblock_de_papi_tables.italian_food = {
    T.italian_food .. "pizza",
    T.italian_food .. "mushroom_pizza",
    T.italian_food .. "lasagna",
    T.italian_food .. "spaghetti",
    T.italian_food .. "dough",
    T.italian_food .. "bruschetta",
    T.italian_food .. "tomato_sauce_bruschetta",
    T.italian_food .. "pesto_bruschetta",
    T.italian_food .. "cannoli",
    T.italian_food .. "mozzarella",
    T.italian_food .. "sheep_cheese",
    T.italian_food .. "tomato",
    T.italian_food .. "basil",
    T.italian_food .. "olive",
    T.italian_food .. "tomato_sauce",
    T.italian_food .. "pesto_sauce",
    T.italian_food .. "tiramisu",
    T.italian_food .. "ice_cream",
    T.italian_food .. "panettone",
    T.italian_food .. "pandoro",
    T.italian_food .. "coffee",
    T.italian_food .. "sugar_coffee",
    -- Bloques, maderas y derivados de olivo incluidos en la integración
    T.italian_food .. "olivewood",
    T.italian_food .. "olivesapling",
}

-- 2. Categoría: Tus elementos propios (Limonero y producción principal)
el_oneblock_de_papi_tables.lemon_stuff = {
    T.de_papi .. "lemon",
    T.de_papi .. "lemonade",
    T.de_papi .. "lemonwood",
    T.de_papi .. "lemonsapling",
    T.de_papi .. "leave_lemon", -- O el nombre exacto de tus hojas de limonero registradas
}