-- ====================================================================
-- MÓDULO: Fortaleza Calavera (Nodos Irrompibles y Trampas Inviolables)
-- ====================================================================
local modname = minetest.get_current_modname()
local S = minetest.get_translator(modname)
local PREFIX = mcl_eodp.prefix.de_papi

-- ====================================================================
-- CRISTAL TRANSLÚCIDO E IMPENETRABLE DE LA CALAVERA
-- ====================================================================
minetest.register_node(PREFIX .. "cristal_calavera", {
    description = S("Cristal Translúcido de la Calavera"),
    drawtype = "glasslike", -- Estilo cristal limpio sin marcos opacos
    tiles = {"cristal_calavera.png"},
    paramtype = "light",
    sunlight_propagates = true, -- Deja pasar la luz del sol al interior de la mandíbula
    use_texture_alpha = "blend", -- Habilita la transparencia suave (canal alfa del PNG de Piskel)
    is_ground_content = false,
    sounds = mcl_sounds.node_sound_glass_defaults(), -- Sonido característico al caminar/golpear cristal
    drop = "", -- No deja botín al romperse (por seguridad)
    
    -- Propiedades de seguridad y dureza comercial para la mazmorra
    _mcl_hardness = -1, -- Impenetrable a picos normales en supervivencia
    _mcl_blast_resistance = 3600000, -- Inmune a explosiones (TNT / Wither)
    
    -- Permite romper el bloque SOLO si estás en Modo Creativo (para diseñar el esquemático)
    can_dig = function(pos, player)
        if player and player:is_player() then
            local name = player:get_player_name()
            if minetest.is_creative_enabled(name) then
                return true -- Te deja minarlo y editar mientras construyes
            end
        end
        return false -- Bloqueo total en supervivencia
    end,
    
    groups = {
        handy = 1, 
        glass = 1, 
        building_block = 1, 
        material_glass = 1, 
        creative_breakable = 1,         -- Estándar de Mineclonia para romper bloques de dureza -1 en creativo
        not_in_creative_inventory = 0,  -- Colócalo en 0 para poder buscarlo y seleccionarlo fácilmente en tu inventario creativo
    },
})

-- --------------------------------------------------------------------
-- HUESO IRROMPIBLE (Reemplazo del hormigón con texturas oficiales)
-- --------------------------------------------------------------------
minetest.register_node(PREFIX .. "skull_bone_block", {
    description = S("Hueso Impenetrable del Templo"),
    tiles = {
        "immortal_bone_block_top.png", -- Parte superior
        "immortal_bone_block_top.png", -- Parte inferior
        "immortal_bone_block_side.png", -- Laterales
        "immortal_bone_block_side.png",
        "immortal_bone_block_side.png",
        "immortal_bone_block_side.png"
    },
    groups = {pickaxey = 1, material_stone = 1, building_block = 1, creative_breakable = 1},
    _mcl_hardness = -1, -- Indestructible en supervivencia
    _mcl_blast_resistance = 3600000, -- Inmune a Wither y TNT
    can_dig = function(pos, player)
        if player and player:is_player() then
            local name = player:get_player_name()
            if minetest.is_creative_enabled(name) then return true end
        end
        return false
    end,
    is_ground_content = false,
    sounds = mcl_sounds.node_sound_stone_defaults(),
})

-- --------------------------------------------------------------------
-- COLMILLOS RECTOS BASADOS EN DRIPSTONE (Apilables y con Polvo de Hueso)
-- --------------------------------------------------------------------
local dripstone_stages = {"tip", "frustum", "middle", "base"}

for i, stage in ipairs(dripstone_stages) do
    local node_name = PREFIX .. "pointed_dripstone_" .. stage
    minetest.register_node(node_name, {
        description = S("Colmillo Recto de la Calavera (@1)", stage),
        drawtype = "plantlike",
        tiles = {"immortal_tusk_" .. stage .. ".png"}, -- Mapeo automático de texturas exactas
        paramtype = "light",
        sunlight_propagates = true,
        walkable = false,
        drop = PREFIX .. "pointed_dripstone_tip",
        _mcl_hardness = -1,
        _mcl_blast_resistance = 3600000,
        can_dig = function(pos, player)
            if player and player:is_player() then
                local name = player:get_player_name()
                if minetest.is_creative_enabled(name) then return true end
            end
            return false
        end,
        groups = {pickaxey = 1, not_in_creative_inventory = (i > 1 and 1 or 0), creative_breakable = 1},
        sounds = mcl_sounds.node_sound_stone_defaults(),
        
        -- Crecimiento instantáneo con Polvo de Hueso
        on_rightclick = function(pos, node, clicker, itemstack)
            if itemstack and itemstack:get_name() == "mcl_farming:bone_meal" then
                local next_stage_idx = i + 1
                if next_stage_idx <= #dripstone_stages then
                    local next_name = PREFIX .. "pointed_dripstone_" .. dripstone_stages[next_stage_idx]
                    minetest.set_node(pos, {name = next_name})
                    if not (clicker and minetest.is_creative_enabled(clicker:get_player_name())) then
                        itemstack:take_item()
                    end
                    minetest.sound_play("default_place_node", {pos = pos, gain = 1.0}, true)
                end
            end
            return itemstack
        end,
    })
end

-- --------------------------------------------------------------------
-- COLMILLOS 3D CURVOS (tusk_upper, tusk_mid y tusk_tip)
-- --------------------------------------------------------------------
local tusk_3d_parts = {
    {name = "tusk_upper", mesh = "Tusk_upper.obj", desc = "Colmillo Superior (Parte Alta - 3D)"},
    {name = "tusk_mid",   mesh = "Tusk_mid.obj",   desc = "Colmillo Superior (Parte Media - 3D)"},
    {name = "tusk_tip",   mesh = "Tusk_tip.obj",   desc = "Colmillo Superior (Punta - 3D)"},
}

for _, part in ipairs(tusk_3d_parts) do
    minetest.register_node(PREFIX .. part.name, {
        description = S(part.desc),
        drawtype = "mesh",
        mesh = part.mesh,
        tiles = {"immortal_tusk_base.png"}, -- Textura unificada para el modelo 3D
        paramtype = "light",
        paramtype2 = "facedir",
        sunlight_propagates = true,
        walkable = true,
        selection_box = { type = "fixed", fixed = {-0.5, -0.5, -0.5, 0.5, 0.5, 0.5} },
        collision_box = { type = "fixed", fixed = {-0.5, -0.5, -0.5, 0.5, 0.5, 0.5} },
        _mcl_hardness = -1,
        _mcl_blast_resistance = 3600000,
        can_dig = function(pos, player)
            if player and player:is_player() then
                local name = player:get_player_name()
                if minetest.is_creative_enabled(name) then return true end
            end
            return false
        end,
        groups = {pickaxey = 1, building_block = 1, creative_breakable = 1},
        sounds = mcl_sounds.node_sound_stone_defaults(),
    })
end

return true