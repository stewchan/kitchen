extends Node2D

signal score_changed(score)
signal order_added(order)
signal order_removed(order)

var score: int = 0
var order_count: int = 0
var ingredient_count: int = 0
var level: int = 1
var dish_options = {}
var ingredient_options = []

var IngredientScene = preload("res://kitchen/draggable/ingredient/Ingredient.tscn")
var OrderScene = preload("res://kitchen/servery/order/Order.tscn")
var DishScene = preload("res://kitchen/servery/dish/Dish.tscn")
var PlateScene = preload("res://kitchen/draggable/plate/Plate.tscn")

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
	if Network.pid == 1:
		ingredient_timer.start()
		order_timer.start()


# TODO: Set up the game dish options and ingredients based on level
func prepare_kitchen() -> void:
	dish_options["Tomato Soup"] = ["Tomato"]
	dish_options["Eggplant Soup"] = ["Eggplant"]
	dish_options["Lettuce Soup"] = ["Lettuce"]
	dish_options["Supreme Soup"] = ["Tomato", "Lettuce", "Eggplant"]
	for dish_name in dish_options.keys():
		for ingredient in dish_options[dish_name]:
			if not ingredient_options.has(ingredient):
				ingredient_options.append(ingredient)


func spawn_plate() -> void:
	var plate = PlateScene.instance()
	plate.name = "Plate"
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


remotesync func complete_order(order: Order, completed: bool) -> void:
	if completed:
		score += 5
		order.queue_free()
		emit_signal("order_removed", order)
	else:
		score -= 1
	emit_signal("score_changed", score)


func spawn_ingredient(ingredient: Ingredient) -> void:
	ingredient_count += 1
	ingredient.position = Vector2(ingredient_count % 4 * 200 + 50, 450)
	items.call_deferred("add_child", ingredient, true)


func on_dish_served(dish: Dish) -> void:
	var completed = false
	var order: Order
	for o in orders.get_children():
		if o.has_dish(dish):
			order = o
			completed = true
			break
	rpc("complete_order", order, completed)	
	spawn_plate()


func random_dish() -> Dish:
	var dish = DishScene.instance()
	var r = int(randi() % dish_options.keys().size())
	var dish_name = dish_options.keys()[r]
	dish.dish_name = dish_name
	dish.set_ingredients(dish_options[dish_name])
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
