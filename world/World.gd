extends Node2D

signal score_changed(score)
signal order_added(order)
signal order_removed(order)

var held_object: Pickable = null
var score: int = 0
var order_count: int = 0
var ingredient_count: int = 0
var level: int = 1
var recipe_list = []
var ingredient_options = []

var IngredientScene = preload("res://kitchen/pickable/ingredient/Ingredient.tscn")
var OrderScene = preload("res://kitchen/servery/order/Order.tscn")
var DishScene = preload("res://kitchen/servery/dish/Dish.tscn")
var PlateScene = preload("res://kitchen/pickable/plate/Plate.tscn")

onready var players = $Players
onready var servery = $Servery
onready var hud = $HUD
onready var orders = $Orders
onready var items = $Items
onready var ingredient_timer = $IngredientTimer
onready var order_timer = $OrderTimer


func _ready() -> void:
	randomize()
	servery.connect("served", self, "on_dish_served")
	emit_signal("score_changed", score)
	print(Network.pid)


func start_game() -> void:
	prepare_kitchen()
	spawn_plate()
	ingredient_timer.start()
	if Network.pid == 1:
		order_timer.start()


# TODO: Set up the game dish options and ingredients based on level
func prepare_kitchen() -> void:
	recipe_list = ["Soup", "Salad"]
	for recipe_name in recipe_list:
		for ingredient_list in Data.recipes[recipe_name]:
			for ingredient in ingredient_list:
				if not ingredient_options.has(ingredient):
					ingredient_options.append(ingredient)


func spawn_plate() -> void:
	var plate = PlateScene.instance()
	plate.name = "Plate"
	plate.connect("clicked", self, "on_pickable_clicked")
	items.call_deferred("add_child", plate)
	items.call_deferred("move_child", plate, 0)
	plate.position = get_viewport_rect().size/2


remotesync func spawn_order(dish_json: String) -> void:
	order_count += 1
	var order = OrderScene.instance()
	order.name = "Order" + str(order_count)
	orders.add_child(order)
	order.set_dish(str2var(dish_json))
	emit_signal("order_added", order)


func spawn_ingredient(ingredient: Ingredient, pos: Vector2 = Vector2(100,100)) -> void:
	ingredient_count += 1
	ingredient.position = pos
	items.call_deferred("add_child", ingredient, true)


func on_dish_served(dish: Dish) -> void:
	var order_name = "none"
	for o in orders.get_children():
		if o.has_dish(dish):
			order_name = o.name
			break
	rpc("complete_order", order_name)	
	spawn_plate()


remotesync func complete_order(order_name: String) -> void:
	if order_name == "none":
		score -= 1
	elif orders.get_node_or_null(order_name):
		var order = orders.get_node(order_name)
		order.queue_free()
		score += 5
		emit_signal("order_removed", order)
	emit_signal("score_changed", score)


func random_dish() -> Dish:
	var dish = DishScene.instance()
	var name = recipe_list[int(randi() % recipe_list.size())]
	var recipe = Recipe.new(name, -1)
	dish.set_dish(recipe)
	return dish


func random_ingredient() -> Ingredient:
	var ingredient = IngredientScene.instance()
	var r = int(randi() % ingredient_options.size())
	ingredient.ingredient_name = ingredient_options[r]
	return ingredient


func _on_IngredientTimer_timeout() -> void:
	spawn_ingredient(random_ingredient())


func _on_OrderTimer_timeout() -> void:
	if Network.is_server():
		rpc("spawn_order", var2str(random_dish()))
