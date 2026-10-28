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
        unmovable_by_piston = 1,
        unsticky = 1
    },
})

-- Variante irrompible que sí puede desplazarse y adherirse a slime.
minetest.register_node(PREFIX .. "cristal_calavera_movil", {
    description = S("Unbreakable Movable Translucent Skull Crystal"),
    drawtype = "glasslike",
    tiles = {"skull_glass.png"},
    paramtype = "light",
    sunlight_propagates = true,
    use_texture_alpha = "blend",
    is_ground_content = false,
    sounds = mcl_sounds.node_sound_glass_defaults(),
    _mcl_hardness = -1,
    _mcl_blast_resistance = 3600000,
    can_dig = function(pos, player)
        return player and player:is_player()
            and minetest.is_creative_enabled(player:get_player_name())
    end,
    groups = {
        handy = 1,
        glass = 1,
        building_block = 1,
        material_glass = 1,
        creative_breakable = 1,
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
    -- Mantenerlo decorativo como mcl_core:bone_block: los grupos `solid` y
    -- `opaque` pueden hacer que redstone lo trate como bloque conductor.
    groups = {pickaxey = 1, material_stone = 1, building_block = 1, creative_breakable = 1, unmovable_by_piston = 1, unsticky = 1},
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
    groups = {pickaxey = 1, material_stone = 1, building_block = 1, creative_breakable = 1, unmovable_by_piston = 1, unsticky = 1},
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
        groups = {pickaxey = 1, building_block = 1, creative_breakable = 1, unmovable_by_piston = 1, unsticky = 1},
        sounds = mcl_sounds.node_sound_stone_defaults(),
    })
end

-- ==================================================================== --
-- MÓDULO: Interior del Templo (Ladrillos de Piedra, Redstone y Dispensador) --
-- ==================================================================== --

-- 1. BLOQUE DE LADRILLO DE PIEDRA IRROMPIBLE DEL TEMPLO
minetest.register_node(PREFIX .. "skull_temple_stonebrick", {
    description = S("Unbreakable Temple Stone Brick"),
    --tiles = {"default_stone_brick.png"},
    tiles = {"test.png"},
    groups = {pickaxey = 1, material_stone = 1, building_block = 1, creative_breakable = 1, solid = 1, opaque = 1, unmovable_by_piston = 1, unsticky = 1},
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

-- Variante irrompible móvil para mecanismos y secciones del laberinto.
-- No incluye unmovable_by_piston ni unsticky: pistones y slime pueden moverla.
minetest.register_node(PREFIX .. "skull_temple_stonebrick_movable", {
    description = S("Unbreakable Movable Temple Stone Brick"),
    --tiles = {"default_stone_brick.png"},
    tiles = {"test2.png"},
    groups = {
        pickaxey = 1,
        material_stone = 1,
        building_block = 1,
        creative_breakable = 1,
        solid = 1,
        opaque = 1,
    },
    _mcl_hardness = -1,
    _mcl_blast_resistance = 3600000,
    can_dig = function(pos, player)
        return player and player:is_player()
            and minetest.is_creative_enabled(player:get_player_name())
    end,
    is_ground_content = false,
    sounds = mcl_sounds.node_sound_stone_defaults(),
})

-- Escaleras y Losas automáticas para el Ladrillo de Piedra del Templo
mcl_stairs.register_stair_and_slab("skull_temple_stonebrick", {
    baseitem = PREFIX .. "skull_temple_stonebrick",
    description_stair = S("Unbreakable Temple Stone Brick Stairs"),
    description_slab = S("Unbreakable Temple Stone Brick Slab"),
    groups = {pickaxey = 1, material_stone = 1, building_block = 1, creative_breakable = 1, unmovable_by_piston = 1, unsticky = 1},
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
    groups = {pickaxey = 1, material_stone = 1, creative_breakable = 1, unmovable_by_piston = 1, unsticky = 1},
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
    local vanilla_lever = minetest.registered_nodes["mcl_lever:lever_off"]
    minetest.register_node(node_name, {
        description = S("Unbreakable Lever of the Fortress"),
        drawtype = "mesh",
        mesh = mesh_file,
        tiles = {"default_stone_brick.png", "mesecons_walllever_lever.png"},
        paramtype = "light",
        -- Mineclonia usa facedir y su on_place para admitir las seis caras.
        paramtype2 = "facedir",
        sunlight_propagates = true,
        walkable = false,
        selection_box = {
            type = "fixed",
            fixed = {-3/16, -4/16, 2/16, 3/16, 4/16, 8/16},
        },
        groups = { pickaxey = 1, not_in_creative_inventory = (is_on and 1 or 0), creative_breakable = 1, attached_node_facedir = 1, unsticky = 1, unmovable_by_piston = 1},
        is_ground_content = false,
        sounds = mcl_sounds.node_sound_stone_defaults(),
        _mcl_hardness = -1,
        _mcl_blast_resistance = 3600000,
        on_place = vanilla_lever and vanilla_lever.on_place,
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
                return 15, vector.equals(minetest.facedir_to_dir(node.param2), dir)
            end or nil,
        },
    })
end

register_unbreakable_lever("off", "mesecons_walllever_lever_off.obj", false)
register_unbreakable_lever("on", "mesecons_walllever_lever_on.obj", true)

-- 4. DISPENSADOR IRROMPIBLE E INVIOLABLE (Inventario editable solo en creativo)
local function dispenser_formspec(pos)
    return table.concat({
        "formspec_version[4]",
        "size[11.75,10.425]",
        "label[4.125,0.375;" .. minetest.formspec_escape(S("Dispensador")) .. "]",
        mcl_formspec.get_itemslot_bg_v4(4.125, 0.75, 3, 3),
        "list[context;main;4.125,0.75;3,3;]",
        "label[0.375,4.7;" .. minetest.formspec_escape(S("Inventario")) .. "]",
        mcl_formspec.get_itemslot_bg_v4(0.375, 5.1, 9, 3),
        "list[current_player;main;0.375,5.1;9,3;9]",
        mcl_formspec.get_itemslot_bg_v4(0.375, 9.05, 9, 1),
        "list[current_player;main;0.375,9.05;9,1;]",
        "listring[context;main]",
        "listring[current_player;main]",
    })
end

local function creative_player(player)
    return player and player:is_player()
        and minetest.is_creative_enabled(player:get_player_name())
end

local function setup_skull_dispenser(pos)
    local meta = minetest.get_meta(pos)
    meta:set_string("formspec", dispenser_formspec(pos))
    meta:get_inventory():set_size("main", 9)
end

local function orient_skull_dispenser(pos, placer)
    if not placer or not placer:is_player() then return end
    local pitch = placer:get_look_vertical() * (180 / math.pi)
    local node = minetest.get_node(pos)
    local target
    if pitch > 55 then
        target = PREFIX .. "skull_dispenser_up"
    elseif pitch < -55 then
        target = PREFIX .. "skull_dispenser_down"
    end
    if target then
        minetest.swap_node(pos, {name = target, param2 = node.param2})
    end
end

local vanilla_dispenser = minetest.registered_nodes["mcl_dispensers:dispenser"]
local dispenser_def = {
    description = S("Unbreakable and Tamper-Proof Dispenser"),
    tiles = {
        "default_furnace_top.png", "default_furnace_bottom.png",
        "default_furnace_side.png", "default_furnace_side.png",
        "default_furnace_side.png", "mcl_dispensers_dispenser_front_horizontal.png"
    },
    paramtype = "light",
    paramtype2 = "facedir",
    is_ground_content = false,
    sounds = mcl_sounds.node_sound_stone_defaults(),
    groups = { pickaxey = 1, container = 2, material_stone = 1, dispenser = 1, creative_breakable = 1, unmovable_by_piston = 1, unsticky = 1 },
    _mcl_hardness = -1,
    _mcl_blast_resistance = 3600000,
    
    on_rightclick = function(pos, node, clicker, itemstack, pointed_thing)
        if creative_player(clicker) then
            if mcl_util.check_position_protection
                    and mcl_util.check_position_protection(pos, clicker) then
                return itemstack
            end
            local formspec_name = "mcl_eodp:skull_dispenser_" .. minetest.pos_to_string(pos)
            minetest.show_formspec(clicker:get_player_name(), formspec_name, dispenser_formspec(pos))
        end
        return itemstack
    end,

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
        setup_skull_dispenser(pos)
    end,
    after_dig_node = mcl_util.drop_items_from_meta_container({"main"}),
    on_metadata_inventory_put = vanilla_dispenser and vanilla_dispenser.on_metadata_inventory_put,
    on_metadata_inventory_take = vanilla_dispenser and vanilla_dispenser.on_metadata_inventory_take,
    on_metadata_inventory_move = vanilla_dispenser and vanilla_dispenser.on_metadata_inventory_move,
    -- Reutiliza el ciclo de activación y consumo de objetos de Mineclonia.
    _mcl_redstone = vanilla_dispenser and vanilla_dispenser._mcl_redstone
        or {connects_to = function() return true end},
}

-- El dispensador conserva la carga configurada en creativo: al activarse se
-- restaura su inventario después de que Mineclonia ejecute el dispensado.
if dispenser_def._mcl_redstone and dispenser_def._mcl_redstone.update then
    local vanilla_redstone_update = dispenser_def._mcl_redstone.update
    dispenser_def._mcl_redstone = table.copy(dispenser_def._mcl_redstone)
    dispenser_def._mcl_redstone.update = function(pos, node)
        local inv = minetest.get_meta(pos):get_inventory()
        local saved = {}
        for i = 1, inv:get_size("main") do
            saved[i] = inv:get_stack("main", i)
        end
        local result = vanilla_redstone_update(pos, node)
        for i, stack in ipairs(saved) do
            inv:set_stack("main", i, stack)
        end
        return result
    end
end

dispenser_def.after_place_node = function(pos, placer)
    setup_skull_dispenser(pos)
    orient_skull_dispenser(pos, placer)
end

minetest.register_node(PREFIX .. "skull_dispenser", dispenser_def)

local function register_skull_dispenser_variant(suffix, tiles)
    local def = table.merge({}, dispenser_def, {
        tiles = tiles,
        groups = table.merge(dispenser_def.groups, {not_in_creative_inventory = 1}),
        drop = PREFIX .. "skull_dispenser",
        after_place_node = setup_skull_dispenser,
    })
    minetest.register_node(PREFIX .. "skull_dispenser_" .. suffix, def)
end

register_skull_dispenser_variant("up", {
    "mcl_dispensers_dispenser_front_vertical.png", "default_furnace_bottom.png",
    "default_furnace_side.png", "default_furnace_side.png",
    "default_furnace_side.png", "default_furnace_side.png",
})
register_skull_dispenser_variant("down", {
    "default_furnace_top.png", "mcl_dispensers_dispenser_front_vertical.png",
    "default_furnace_side.png", "default_furnace_side.png",
    "default_furnace_side.png", "default_furnace_side.png",
})

-- ============================================================================
-- PISTONES PEGAJOSOS DEL TEMPLO (IRROMPIBLES)
-- ============================================================================

-- Heredar la mecánica real de Mineclonia: orientación, empuje, retracción y
-- pegado. Cada estado usa nombres propios para conservar la protección.
local vanilla_piston_off = minetest.registered_nodes["mcl_pistons:piston_sticky_off"]
local vanilla_piston_on = minetest.registered_nodes["mcl_pistons:piston_sticky_on"]
local vanilla_pusher = minetest.registered_nodes["mcl_pistons:piston_pusher_sticky"]
if vanilla_piston_off and vanilla_piston_on and vanilla_pusher then
    local skull_piston_off_name = PREFIX .. "piston_sticky"
    local skull_piston_on_name = PREFIX .. "piston_sticky_on"
    local skull_pusher_name = PREFIX .. "piston_sticky_pusher"
    local piston_spec = {
        offname = skull_piston_off_name,
        onname = skull_piston_on_name,
        pusher = skull_pusher_name,
        sticky = true,
    }
    local function protect_piston(def, hidden)
        def.description = "Unbreakable Sticky Piston of the Temple"
        def._mcl_hardness = -1
        def._mcl_blast_resistance = 3600000
        def._piston_spec = piston_spec
        def.groups = table.merge(def.groups or {}, {
            creative_breakable = 1,
            not_in_creative_inventory = hidden and 1 or 0,
        })
        def.can_dig = function(_, player) return creative_player(player) end
        return def
    end

    local off_def = protect_piston(table.merge({}, vanilla_piston_off, {}), false)
    off_def.drop = ""
    off_def.after_place_node = vanilla_piston_off.after_place_node
    minetest.register_node(skull_piston_off_name, off_def)

    local on_def = protect_piston(table.merge({}, vanilla_piston_on, {}), true)
    on_def.drop = skull_piston_off_name
    minetest.register_node(skull_piston_on_name, on_def)

    local pusher_def = table.merge({}, vanilla_pusher, {
        description = "Sticky Piston Head",
        corresponding_piston = skull_piston_on_name,
        drop = "",
        _mcl_hardness = -1,
        _mcl_blast_resistance = 3600000,
        groups = table.merge(vanilla_pusher.groups or {}, {creative_breakable = 1}),
        can_dig = function(_, player) return creative_player(player) end,
    })
    minetest.register_node(skull_pusher_name, pusher_def)
else
    minetest.log("error", "[mcl_eodp] No se pudieron registrar las variantes del pistón Calavera: falta mcl_pistons.")
end

-- PISTÓN NORMAL IRROMPIBLE
-- Usa la misma mecánica nativa que el pegajoso, pero sin retraer el bloque.
local vanilla_normal_off = minetest.registered_nodes["mcl_pistons:piston_off"]
local vanilla_normal_on = minetest.registered_nodes["mcl_pistons:piston_on"]
local vanilla_normal_pusher = minetest.registered_nodes["mcl_pistons:piston_pusher"]
if vanilla_normal_off and vanilla_normal_on and vanilla_normal_pusher then
    local skull_normal_off_name = PREFIX .. "piston"
    local skull_normal_on_name = PREFIX .. "piston_on"
    local skull_normal_pusher_name = PREFIX .. "piston_pusher"
    local piston_spec = {
        offname = skull_normal_off_name,
        onname = skull_normal_on_name,
        pusher = skull_normal_pusher_name,
        sticky = false,
    }

    local function protect_normal_piston(def, hidden)
        def.description = "Unbreakable Piston of the Temple"
        def._mcl_hardness = -1
        def._mcl_blast_resistance = 3600000
        def._piston_spec = piston_spec
        def.groups = table.merge(def.groups or {}, {
            creative_breakable = 1,
            not_in_creative_inventory = hidden and 1 or 0,
        })
        def.can_dig = function(_, player) return creative_player(player) end
        return def
    end

    local off_def = protect_normal_piston(table.merge({}, vanilla_normal_off, {}), false)
    off_def.drop = ""
    off_def.after_place_node = vanilla_normal_off.after_place_node
    minetest.register_node(skull_normal_off_name, off_def)

    local on_def = protect_normal_piston(table.merge({}, vanilla_normal_on, {}), true)
    on_def.drop = skull_normal_off_name
    minetest.register_node(skull_normal_on_name, on_def)

    local pusher_def = table.merge({}, vanilla_normal_pusher, {
        description = "Piston Head",
        corresponding_piston = skull_normal_on_name,
        drop = "",
        _mcl_hardness = -1,
        _mcl_blast_resistance = 3600000,
        groups = table.merge(vanilla_normal_pusher.groups or {}, {creative_breakable = 1}),
        can_dig = function(_, player) return creative_player(player) end,
    })
    minetest.register_node(skull_normal_pusher_name, pusher_def)
else
    minetest.log("error", "[mcl_eodp] No se pudieron registrar las variantes del pistón Calavera normal: falta mcl_pistons.")
end

return true
