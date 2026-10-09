-- chest.lua
local chests = {}
local PREFIX = mcl_eodp.prefix.de_papi
local IF_PREFIX = mcl_eodp.prefix.italian_food

minetest.override_item("mcl_chests:chest_small", {
    drop = "",
    on_metadata_inventory_take = function(pos, listname, index, stack, player)
        local meta = minetest.get_meta(pos)
        local inv = meta:get_inventory()
        if inv:is_empty("main") then
            minetest.set_node(pos, {name = "mcl_core:dirt_with_grass"})
        end
    end,
})

minetest.override_item("mcl_chests:chest", {
    drop = "",
    on_metadata_inventory_take = function(pos, listname, index, stack, player)
        local meta = minetest.get_meta(pos)
        local inv = meta:get_inventory()
        if inv:is_empty("main") then
            minetest.set_node(pos, {name = "mcl_core:dirt_with_grass"})
        end
    end,
})

-- Definición de tablas de botín por fase o nivel de progresión
chests.loot_tables = {
    [1] = {
        description = "Cofre Fase 1: Básicos de Supervivencia",
        standard = {
            { name = "mcl_core:apple", count = {min = 1, max = 2}, chance = 0.6 },
            { name = "mcl_farming:wheat_seeds", count = {min = 1, max = 3}, chance = 0.5 },
            { name = "mcl_core:stone", count = {min = 1, max = 4}, chance = 0.4 },
            { name = "mcl_flowers:dandelion", count = 1, chance = 0.6 },
            { name = "mcl_flowers:poppy", count = 1, chance = 0.2 },
            { name = "mcl_tools:axe_wood", count = 1, chance = 0.2 },
            { name = "mcl_mobitems:gunpowder", count = {min = 1, max = 5}, chance = 0.6 },
            { name = "mcl_mobitems:string", count = {min = 1, max = 4}, chance = 0.6 },
            { name = "mcl_trees:sapling_oak", count = {min = 1, max = 4}, chance = 0.3 },
            { name = "mcl_trees:sapling_birch", count = {min = 1, max = 4}, chance = 0.3 },
            { name = "mcl_trees:sapling_dark_oak", count = {min = 1, max = 4}, chance = 0.3 },
        },
        special = {
            { name = "mcl_core:carrot", count = {min = 1, max = 2}, chance = 0.6 },
            { name = "mcl_tools:axe_gold", count = 1, chance = 0.5 },
            { name = "mcl_tools:sword_gold", count = 1, chance = 0.5 },
            { name = "mcl_tools:pick_gold", count = 1, chance = 0.4 },
            { name = "mcl_farming:hoe_gold_enchanted", count = 1, chance = 0.4 },
            { name = "mcl_farming:melon_seeds", count = {min = 1, max = 3}, chance = 0.3 },
            { name = "mcl_farming:pumpkin_seeds", count = {min = 1, max = 3}, chance = 0.3 },
            { name = PREFIX .. "lemon_fruit", count = {min = 1, max = 3}, chance = 0.2 },
            { name = IF_PREFIX ..  "basil", count = {min = 1, max = 3}, chance = 0.2 },
        },

    },
    [2] = {
        description = "Cofre Fase 2: Intermedios de supervivencia",
        standard = {
            { name = "mcl_core:iron_nugget", count = {min = 1, max = 2}, chance = 0.4 },
            { name = "mcl_farming:carrot", count = {min = 1, max = 3}, chance = 0.4 },
            { name = "mcl_core:coal_lump", count = {min = 2, max = 4}, chance = 0.5 },
            { name = "mcl_farming:melon_seeds", count = {min = 1, max = 3}, chance = 0.2 },
            { name = "mcl_farming:pumpkin_seeds", count = {min = 1, max = 3}, chance = 0.2 },
            { name = "mcl_core:stone", count = {min = 3, max = 7}, chance = 0.2 },
        },
        special = {
            { name = "mcl_tools:axe_iron", count = 1, chance = 0.3 },
            { name = "mcl_tools:axe_gold_enchanted", count = 1, chance = 0.4 },
            { name = "mcl_tools:sword_gold_enchanted", count = 1, chance = 0.4 },
            { name = "mcl_tools:pick_gold_enchanted", count = 1, chance = 0.4 },
            { name = IF_PREFIX ..  "lasagna", count = 1, chance = 0.2 },
        },
    },
    [3] = {
        description = "Cofre Fase 2: Minerales Iniciales",
        standard = {
            { name = "mcl_core:iron_nugget", count = {min = 1, max = 2}, chance = 0.4 },
            { name = "mcl_farming:carrot", count = {min = 1, max = 3}, chance = 0.4 },
            { name = "mcl_farming:potato", count = {min = 1, max = 3}, chance = 0.4 },
            { name = "mcl_core:coal_lump", count = {min = 2, max = 4}, chance = 0.6 },
            { name = "mcl_buckets:bucket_water", count = 1, chance = 0.2 },
        },
    },
    -- Nuevas fases o expansiones hechas por terceros se pueden añadir fácilmente aquí
}

-- Función modular para poblar el cofre generado en el mundo
function chests.populate(pos, phase_index, is_special)
    local meta = minetest.get_meta(pos)
    local inv = meta:get_inventory()
    inv:set_size("main", 27) -- Asegurar el tamaño estándar del cofre de Mineclonia
    
    local loot_data = chests.loot_tables[phase_index] or chests.loot_tables[1]
    if not loot_data then return end
    
    -- Seleccionar pool según si es cofre especial o estándar
    local pool = is_special and loot_data.special or loot_data.standard
    if not pool then 
        pool = loot_data.standard or {} 
    end
    
    -- Llenar el inventario aleatoriamente
    local items_to_add = is_special and math.random(6, 9) or math.random(4, 6)
    for i = 1, items_to_add do
        if #pool > 0 then
            local loot = pool[math.random(#pool)]
            if math.random() <= (loot.chance or 0.5) then
                local count = 1
                if type(loot.count) == "table" then
                    count = math.random(loot.count.min, loot.count.max)
                elseif type(loot.count) == "number" then
                    count = loot.count
                end
                
                local slot = math.random(1, 27)
                inv:set_stack("main", slot, ItemStack(loot.name .. " " .. count))
            end
        end
    end
end

return chests