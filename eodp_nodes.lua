-- ====================================================================
-- COFRE EXCLUSIVO E INDEPENDIENTE DEL ONEBLOCK
-- ====================================================================
local modname = minetest.get_current_modname() or "mcl_eodp"
local PREFIX = mcl_eodp.prefix.de_papi
local S = minetest.get_translator(modname)

-- Función pública para que otros módulos puedan reutilizar la limpieza del
-- cofre propio sin modificar los cofres nativos de Mineclonia.
function mcl_eodp.cleanup_empty_chest(pos)
    local meta = minetest.get_meta(pos)
    local inv = meta:get_inventory()

    -- Caso 1: Cofre temporal de la brújula del Nether
    if meta:get_int("eodp_temporary_nether_compass") == 1 then
        if not inv:contains_item("main", "mcl_compass:compass_recovery") then
            minetest.remove_node(pos)
        end
        return
    end

    -- Caso 2: Cofre de fases del OneBlock (Se convierte en tierra al vaciarse por completo)
    if meta:get_int("eodp_oneblock_chest") == 1 then
        if inv:is_empty("main") then
            minetest.set_node(pos, {name = "mcl_core:dirt_with_grass"})
        end
    end
end

local function chest_inventory_changed(pos)
    minetest.after(0, mcl_eodp.cleanup_empty_chest, pos)
end

local function chest_formspec(pos)
    local x, y, z = pos.x, pos.y, pos.z
    return table.concat({
        "formspec_version[4]",
        "size[11.75,10.425]",
        "label[0.375,0.375;" .. minetest.formspec_escape(S("Cofre de papi")) .. "]",
        mcl_formspec.get_itemslot_bg_v4(0.375, 0.75, 9, 3),
        string.format("list[nodemeta:%s,%s,%s;main;0.375,0.75;9,3;]", x, y, z),
        "label[0.375,4.7;" .. minetest.formspec_escape(S("Inventario")) .. "]",
        mcl_formspec.get_itemslot_bg_v4(0.375, 5.1, 9, 3),
        "list[current_player;main;0.375,5.1;9,3;9]",
        mcl_formspec.get_itemslot_bg_v4(0.375, 9.05, 9, 1),
        "list[current_player;main;0.375,9.05;9,1;]",
        string.format("listring[nodemeta:%s,%s,%s;main]", x, y, z),
        "listring[current_player;main]",
    })
end

minetest.register_node(PREFIX .. "chest", {
    description = S("Cofre de papi"),
    -- Textura basada en tu imagen eodp_chest.png (compatible con mapeo de cofres)
    tiles = {
        "eodp_chest.png^[sheet:2x2:0,0", -- Tapa superior
        "eodp_chest.png^[sheet:2x2:0,0", -- Base inferior
        "eodp_chest.png^[sheet:2x2:1,0", -- Lado derecho
        "eodp_chest.png^[sheet:2x2:1,0", -- Lado izquierdo
        "eodp_chest.png^[sheet:2x2:1,0", -- Parte trasera
        "eodp_chest.png^[sheet:2x2:0,1"  -- Frente con cerradura
    },
    drawtype = "nodebox",
    paramtype = "light",
    paramtype2 = "facedir",
    is_ground_content = false,
    sounds = mcl_sounds.node_sound_wood_defaults(),
    groups = {
        pickaxey = 1,
        container = 2,
        material_wood = 1,
        creative_breakable = 1,
        not_in_creative_inventory = 1 -- Oculto del creativo, se otorga por mod/comando
    },
    _mcl_hardness = -1, -- Irrompible en supervivencia
    _mcl_blast_resistance = 3600000, -- Inmune a explosiones

    can_dig = function(pos, player)
        if player and player:is_player() then
            local name = player:get_player_name()
            if minetest.is_creative_enabled(name) then return true end
        end
        local meta = minetest.get_meta(pos)
        local inv = meta:get_inventory()
        return inv:is_empty("main")
    end,

    on_construct = function(pos)
        local meta = minetest.get_meta(pos)
        local inv = meta:get_inventory()
        inv:set_size("main", 27)
        meta:set_string("infotext", S("Cofre de papi"))
    end,

    on_rightclick = function(pos, node, clicker)
        if not clicker or not clicker:is_player() then return end
        local player_name = clicker:get_player_name()
        local formname = string.format("mcl_eodp:chest_%s_%s_%s", pos.x, pos.y, pos.z)
        minetest.show_formspec(player_name, formname, chest_formspec(pos))
    end,

    on_metadata_inventory_take = chest_inventory_changed,
    on_metadata_inventory_put = chest_inventory_changed,
    on_metadata_inventory_move = chest_inventory_changed,

    after_dig_node = mcl_util.drop_items_from_meta_container({"main"}),

    _mcl_redstone = {
        connects_to = function(node, dir) return true end,
    },
})
