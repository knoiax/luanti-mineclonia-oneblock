local modname = "eodp_it_f"
local PREFIX = mcl_eodp.prefix.italian_food
local S = minetest.get_translator(modname)

minetest.register_tool(PREFIX .. "rolling_pin", {
    description = S("Rolling Pin"),
    inventory_image = modname .. "_rolling_pin.png",
    tool_capabilities = {
        full_punch_interval = 1.2,
        max_drop_level = 0,
        groupcaps = { crumbly = {times = {[1] = 2.0, [2] = 1.00, [3] = 0.50}, uses = 25, maxlevel = 1} },
        damage_groups = {fleshy = 1},
    },
    groups = {wooden_tool = 1},
})

minetest.register_tool(PREFIX .. "iron_rolling_pin", {
    description = S("Iron Rolling Pin"),
    inventory_image = modname .. "_iron_rolling_pin.png",
    tool_capabilities = {
        full_punch_interval = 1.0,
        max_drop_level = 1,
        groupcaps = {
            crumbly = {times = {[1] = 1.2, [2] = 0.7, [3] = 0.3}, uses = 60, maxlevel = 2},
        },
        damage_groups = {fleshy = 2},
    },
    groups = {metal_tool = 1},
})

minetest.register_tool(PREFIX .. "pizza_cutter_wheel", {
    description = S("Pizza Cutter"),
    inventory_image = modname .. "_cutter_wheel.png",
    tool_capabilities = {
        full_punch_interval = 1.0,
        max_drop_level = 1,
        groupcaps = { crumbly = {times = {[1] = 1.2, [2] = 0.7, [3] = 0.3}, uses = 90, maxlevel = 3} },
        damage_groups = {fleshy = 5},
    },
    groups = {metal_tool = 1},
})