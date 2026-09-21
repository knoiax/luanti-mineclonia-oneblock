-- implementaciones/italian_food.lua
local modname = "eodp_it_f"
local S = minetest.get_translator(modname)
local PREFIX = mcl_eodp.prefix.italian_food

minetest.register_node(PREFIX .. "cheese_rack", {
    description = S("Cheese Rack"),
    tiles = {
        modname .. "_cheese_rack_top.png", modname .. "_cheese_rack_top.png",
        modname .. "_cheese_rack_side.png", modname .. "_cheese_rack_side.png",
        modname .. "_cheese_rack_side.png", modname .. "_cheese_rack_front.png"
    },
    groups = {choppy = 2, oddly_breakable_by_hand = 2},
    sounds = mcl_sounds.node_sound_wood_defaults(),
    paramtype2 = "facedir",

    on_construct = function(pos)
        local meta = minetest.get_meta(pos)
        local inv = meta:get_inventory()
        inv:set_size("input", 1)
        inv:set_size("output", 2)
        meta:set_int("cheese_time", 0)
        meta:set_int("last_percent", -1)
        meta:set_string("infotext", "Cheese Rack (empty)")
        meta:set_string("formspec", get_formspec(0))
    end,

    on_rightclick = function(pos, node, clicker)
        local meta = minetest.get_meta(pos)
        minetest.show_formspec(clicker:get_player_name(),
            PREFIX .. "cheese_rack", meta:get_string("formspec"))
    end,

    can_dig = function(pos, player)
        local inv = minetest.get_meta(pos):get_inventory()
        return inv:is_empty("input") and inv:is_empty("output")
    end,

    on_timer = function(pos, elapsed)
        local meta = minetest.get_meta(pos)
        local inv = meta:get_inventory()
        local input_stack = inv:get_stack("input", 1)
        local timer = meta:get_int("cheese_time")
        if input_stack:get_name() ~= PREFIX .. "sheep_milk_bucket" then
            meta:set_string("infotext", "Cheese Rack (empty)")
            meta:set_int("cheese_time", 0)
            meta:set_string("formspec", get_formspec(0))
            return false 
        end

        timer = timer + elapsed
        local progress = timer / CHEESE_TIME
        if progress > 1 then progress = 1 end

        if timer >= CHEESE_TIME then
            if inv:room_for_item("output", PREFIX .. "sheep_cheese") and
               inv:room_for_item("output", "mcl_buckets:bucket_empty") then

                inv:add_item("output", PREFIX .. "sheep_cheese")
                inv:add_item("output", "mcl_buckets:bucket_empty")
                input_stack:take_item()
                inv:set_stack("input", 1, input_stack)
                timer = 0
                progress = 0
            end
        end

        meta:set_int("cheese_time", timer)

        local percent = math.floor(progress * 100)
        local last = meta:get_int("last_percent")
        if math.abs(percent - last) >= 5 then
            meta:set_int("last_percent", percent)
            meta:set_string("formspec", get_formspec(progress))
        end

        meta:set_string("infotext", string.format("Cheese Rack (fermenting... %d%%)", percent))
        return true
    end,

    on_metadata_inventory_put = function(pos)
        local meta = minetest.get_meta(pos)
        local inv = meta:get_inventory()
        if not inv:get_stack("input", 1):is_empty() then
            minetest.get_node_timer(pos):start(1.0)
            meta:set_string("infotext", "Cheese Rack (fermenting...)")
        end
    end,

    on_metadata_inventory_take = function(pos)
        local meta = minetest.get_meta(pos)
        local inv = meta:get_inventory()
        if inv:get_stack("input", 1):is_empty() then
            minetest.get_node_timer(pos):stop()
            meta:set_string("infotext", "Cheese Rack (empty)")
            meta:set_string("formspec", get_formspec(0))
        end
    end,
})


minetest.register_node(PREFIX .. "coffee_sack", {
    description = "Coffee Sack",
    tiles = {
        modname .. "_coffee_sack_top.png",
        modname .. "_coffee_sack_bottom.png",
        modname .. "_coffee_sack_side.png"
    },
    groups = {
        choppy = 2,
        oddly_breakable_by_hand = 2,
        flammable = 3,
        falling_node = 1,
    },
    sounds = mcl_sounds.node_sound_wood_defaults(),
    paramtype2 = "facedir",
    is_ground_content = false,
})