-- ====================================================================
-- MÓDULO: Fortaleza Calavera (Nodos Irrompibles y Trampas Inviolables)
-- ====================================================================
local modname = "eodp"
local S = minetest.get_translator(modname)
local PREFIX = mcl_eodp.prefix.de_papi

-- ====================================================================
-- CRISTAL TRANSLÚCIDO E IMPENETRABLE DE LA CALAVERA
-- ====================================================================
minetest.register_node(PREFIX .. "cristal_calavera", {
    description = S("Unbreakable Translucent Crystal Skull"),
    drawtype = "glasslike", -- Estilo cristal limpio sin marcos opacos
    tiles = {"skull_glass.png"},
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
    description = S("Unbreakable Skull Bone block"),
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

mcl_stairs.register_stair_and_slab("skull_bone", {
    baseitem = PREFIX .. "skull_bone_block",
    description_stair = S("Unbreakable Skull Bone Stairs"),
    description_slab = S("Unbreakable Skull Bone Slab"),
    groups = {pickaxey = 1, material_stone = 1, building_block = 1, creative_breakable = 1},
    _mcl_hardness = -1,
    _mcl_blast_resistance = 3600000,
    sounds = mcl_sounds.node_sound_stone_defaults(),
})

-- --------------------------------------------------------------------
-- COLMILLOS 3D CURVOS (tusk_upper, tusk_mid y tusk_tip)
-- --------------------------------------------------------------------
local tusk_3d_parts = {
    {name = "tusk_upper", mesh = "Tusk_upper.obj", desc = "Colmillo Superior (Parte Alta - 3D)"},
    {name = "tusk_mid",   mesh = "Tusk_mid.obj",   desc = "Colmillo Superior (Parte Media - 3D)"},
    {name = "tusk_tip",   mesh = "Tusk_tip.obj",   desc = "Colmillo Superior (Punta - 3D)"},
    {name = "tusk_tip_left",   mesh = "Tusk_tip_left.obj",   desc = "Colmillo Superior Izquierdo (Punta - 3D)"},
    {name = "tusk_lower",   mesh = "Tusk_lower.obj",   desc = "Colmillo inferior (Parte Baja - 3D)"},
    {name = "tusk_down",   mesh = "Tusk_down.obj",   desc = "Colmillo inferior (Parte media Baja - 3D)"},
    {name = "tusk_mid_down",   mesh = "Tusk_mid_down.obj",   desc = "Colmillo inferior (Parte media Alta - 3D)"},
    {name = "tusk_tip_down_left",   mesh = "Tusk_tip_down_left.obj",   desc = "Colmillo inferior (Punta Izquierda - 3D)"},
    {name = "tusk_tip_down_right",   mesh = "Tusk_tip_down_right.obj",   desc = "Colmillo inferior (Punta Derecha - 3D)"},
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

-- ==================================================================== --
-- MÓDULO: Interior del Templo (Ladrillos de Piedra, Redstone y Dispensador) --
-- ==================================================================== --

-- 1. BLOQUE DE LADRILLO DE PIEDRA IRROMPIBLE DEL TEMPLO
minetest.register_node(PREFIX .. "skull_temple_stonebrick", {
    description = S("Unbreakable Temple Stone Brick"),
    tiles = {"default_stone_brick.png"},
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

-- Escaleras y Losas automáticas para el Ladrillo de Piedra del Templo
mcl_stairs.register_stair_and_slab("skull_temple_stonebrick", {
    baseitem = PREFIX .. "skull_temple_stonebrick",
    description_stair = S("Unbreakable Temple Stone Brick Stairs"),
    description_slab = S("Unbreakable Temple Stone Brick Slab"),
    groups = {pickaxey = 1, material_stone = 1, building_block = 1, creative_breakable = 1},
    _mcl_hardness = -1,
    _mcl_blast_resistance = 3600000,
    sounds = mcl_sounds.node_sound_stone_defaults(),
})

-- 2. PLACA DE PRESIÓN IRROMPIBLE (Basado en mcl_pressureplates)
mcl_pressureplates.register_pressure_plate("skull_stone", {
    description = S("Unbreakable Temple Stone Pressure Plate"),
    texture = "default_stone_brick.png",
    recipeitem = PREFIX .. "skull_stonebrick",
    sounds = mcl_sounds.node_sound_stone_defaults(),
    groups = {pickaxey = 1, material_stone = 1, creative_breakable = 1},
    activated_by = { player = true, mob = true },
    longdesc = S("Una placa de presión irrompible de la Fortaleza Calavera."),
})

-- Sobrescribir dureza y resistencia de la placa de presión generada para hacerla irrompible
for _, state in ipairs({"_off", "_on"}) do
    local plate_name = "mcl_pressureplates:pressure_plate_skull_stone" .. state
    if minetest.registered_nodes[plate_name] then
        minetest.override_item(plate_name, {
            _mcl_hardness = -1,
            _mcl_blast_resistance = 3600000,
            can_dig = function(pos, player)
                if player and player:is_player() then
                    if minetest.is_creative_enabled(player:get_player_name()) then return true end
                end
                return false
            end,
        })
    end
end

-- 3. PALANCA IRROMPIBLE DE LA FORTALEZA (Basado en mcl_lever)
local function register_unbreakable_lever(state_suffix, mesh_file, is_on)
    local node_name = PREFIX .. "skull_lever_" .. state_suffix
    minetest.register_node(node_name, {
        description = S("Unbreakable Lever of the Fortress"),
        drawtype = "mesh",
        mesh = mesh_file,
        tiles = {"default_stone_brick.png", "mesecons_walllever_lever.png"},
        paramtype = "light",
        paramtype2 = "facedir",
        sunlight_propagates = true,
        walkable = false,
        selection_box = { type = "fixed", fixed = { -3/16, -4/16, 2/16, 3/16, 4/16, 8/16 } },
        groups = { pickaxey = 1, not_in_creative_inventory = (is_on and 1 or 0), creative_breakable = 1, attached_node_facedir = 1, unsticky = 1 },
        is_ground_content = false,
        sounds = mcl_sounds.node_sound_stone_defaults(),
        _mcl_hardness = -1,
        _mcl_blast_resistance = 3600000,
        can_dig = function(pos, player)
            if player and player:is_player() then
                if minetest.is_creative_enabled(player:get_player_name()) then return true end
            end
            return false
        end,
        on_rightclick = function(pos, node)
            local target = is_on and (PREFIX .. "skull_lever_off") or (PREFIX .. "skull_lever_on")
            minetest.set_node(pos, {name = target, param2 = node.param2})
            minetest.sound_play("mesecons_button_push", {pos = pos, max_hear_distance = 16, pitch = (is_on and 0.9 or 1.0)}, true)
        end,
        _mcl_redstone = {
            connects_to = function(node, dir) return true end,
            get_power = is_on and function(node, dir)
                return 15, minetest.facedir_to_dir(node.param2) == dir
            end or nil,
        },
    })
end

register_unbreakable_lever("off", "mesecons_walllever_lever_off.obj", false)
register_unbreakable_lever("on", "mesecons_walllever_lever_on.obj", true)

-- 4. DISPENSADOR IRROMPIBLE E INVIOLABLE (Contenido fijo en supervivencia, editable solo en creativo)
local dispenser_def = {
    description = S("Unbreakable and Tamper-Proof Dispenser"),
    tiles = {
        "default_furnace_top.png", "default_furnace_bottom.png",
        "default_furnace_side.png", "default_furnace_side.png",
        "default_furnace_side.png", "mcl_dispensers_dispenser_front_horizontal.png"
    },
    drawtype = "nodebox",
    paramtype = "light",
    paramtype2 = "facedir",
    is_ground_content = false,
    sounds = mcl_sounds.node_sound_stone_defaults(),
    groups = { pickaxey = 1, container = 2, material_stone = 1, dispenser = 1, creative_breakable = 1 },
    _mcl_hardness = -1,
    _mcl_blast_resistance = 3600000,
    
    -- Restricción estricta: Solo se puede extraer, poner o mover ítems en modo creativo.
    allow_metadata_inventory_take = function(pos, listname, index, stack, player)
        if player and player:is_player() and minetest.is_creative_enabled(player:get_player_name()) then
            return stack:get_count()
        end
        return 0 -- Bloqueado en supervivencia (inviolable)
    end,
    allow_metadata_inventory_put = function(pos, listname, index, stack, player)
        if player and player:is_player() and minetest.is_creative_enabled(player:get_player_name()) then
            return stack:get_count()
        end
        return 0 -- No se puede alterar su contenido en supervivencia
    end,
    allow_metadata_inventory_move = function(pos, from_list, from_index, to_list, to_index, count, player)
        if player and player:is_player() and minetest.is_creative_enabled(player:get_player_name()) then
            return count
        end
        return 0
    end,
    can_dig = function(pos, player)
        if player and player:is_player() then
            if minetest.is_creative_enabled(player:get_player_name()) then return true end
        end
        return false -- Irrompible en supervivencia
    end,
    
    on_construct = function(pos)
        local meta = minetest.get_meta(pos)
        meta:get_inventory():set_size("main", 9)
    end,
    after_dig_node = mcl_util.drop_items_from_meta_container({"main"}),
    _mcl_redstone = {
        connects_to = function(node, dir) return true end,
    },
}

minetest.register_node(PREFIX .. "skull_dispenser", dispenser_def)

return true