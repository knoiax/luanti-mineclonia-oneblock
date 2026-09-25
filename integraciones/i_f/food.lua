-- implementaciones/italian_food.lua
local modname = "eodp_it_f"
local PREFIX = mcl_eodp.prefix.italian_food
local S = minetest.get_translator(modname)

-- Variable para la descripción genérica de la ayuda (Mineclonia)
local mofood_longdesc = S("This is a food item which can be eaten.")

-- Función auxiliar para registrar comida
local function register_food_item(name, description, image, saturation, eat_value, comp_value )
	minetest.register_craftitem(name, {
		description = description,
		_doc_items_longdesc = mofood_longdesc,
		inventory_image = image,
		groups = {food = 2, eatable = eat_value, compostability = comp_value or 0},
		_mcl_saturation = saturation,
		on_place = minetest.item_eat(eat_value),
		on_secondary_use = minetest.item_eat(eat_value),
	})
end

-- REGISTRO ÚNICO Y CONSOLIDADO DE ALIMENTOS
register_food_item(PREFIX .. "basil", S("Basil"), modname .. "_basil.png", 3, 4, 60)
register_food_item(PREFIX .. "bruschetta", S("Bruschetta"), modname .. "_bruschetta.png", 20, 18, 90)
register_food_item(PREFIX .. "cannoli", S("Cannoli"), modname .. "_cannoli.png", 20, 18, 70)
register_food_item(PREFIX .. "coffee_roasted_bean", S("Roasted Coffee Bean"), modname .. "_roasted_coffee_bean.png", 3, 4)
register_food_item(PREFIX .. "cone", S("Ice Cream Cone"), modname .. "_cone.png", 4, 6)
register_food_item(PREFIX .. "dough", S("Dough"), modname .. "_dough.png", 10, 10, 55)
register_food_item(PREFIX .. "fazzoletto_raw", S("Raw Fazzoletto"), modname .. "_fazzoletti.png", 11, 11, 55)
register_food_item(PREFIX .. "gnocco_raw", S("Raw Gnocco"), modname .. "_gnocco.png", 11, 10, 55)
register_food_item(PREFIX .. "ice_cream", S("Chocolate Ice Cream"), modname .. "_ice_cream.png", 8, 12)
register_food_item(PREFIX .. "lasagna", S("Lasagna"), modname .. "_lasagna.png", 13, 10)
register_food_item(PREFIX .. "mozzarella", S("Mozzarella"), modname .. "_mozzarella.png", 8.5, 9)
register_food_item(PREFIX .. "mushroom_pizza", S("Mushroom Pizza"), modname .. "_mushroom_pizza.png", 16, 18)
register_food_item(PREFIX .. "olive", S("Olives"), modname .. "_olive.png", 3, 4, 30)
register_food_item(PREFIX .. "panettone", S("Panettone"), modname .. "_panettone.png", 7, 8, 40)
register_food_item(PREFIX .. "pandoro", S("Pandoro"), modname .. "_pandoro.png", 7, 8, 40)
register_food_item(PREFIX .. "pesto_bruschetta", S("Pesto Sauce Bruschetta"), modname .. "_pesauce_bruschetta.png", 24, 20, 90)
register_food_item(PREFIX .. "pork_jowl", S("Pork Jowl"), modname .. "_pork_jowl.png", 5, 3)
register_food_item(PREFIX .. "pizza", S("Pizza"), modname .. "_pizza.png", 16, 15)
register_food_item(PREFIX .. "raviolo_raw", S("Raw Raviolo"), modname .. "_raviolo.png", 12, 12)
register_food_item(PREFIX .. "sheep_cheese", S("Sheep Cheese"), modname .. "_sheep_cheese.png", 9, 8)
register_food_item(PREFIX .. "spaghetti", S("Tomato Spaghetti"), modname .. "_spaghetti.png", 12, 10, 50)
register_food_item(PREFIX .. "spaghetti_raw", S("Raw Spaghetti"), modname .. "_spaghetti_raw.png", 10, 10, 55)
register_food_item(PREFIX .. "tiramisu", S("Tiramisu"), modname .. "_tiramisu.png", 12, 8, 55)
register_food_item(PREFIX .. "tomato_sauce_bruschetta", S("Tomato Sauce Bruschetta"), modname .. "_tosauce_bruschetta.png", 24, 20, 90)
register_food_item(PREFIX .. "tomato", S("Tomato"), modname .. "_tomato.png", 8.5, 9, 60)