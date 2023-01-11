extends Node2D


var score: int = 0
var order_count: int = 0
var ingredient_count: int = 0

var IngredientScene = preload("res://kitchen/draggable/ingredient/Ingredient.tscn")
var OrderScene = preload("res://kitchen/servery/order/Order.tscn")
var DishScene = preload("res://kitchen/servery/dish/Dish.tscn")
var PlateScene = preload("res://kitchen/draggable/plate/Plate.tscn")

onready var players = $Players
onready var servery = $Servery
onready var hud = $HUD
onready var orders = $HUD/H/Orders
onready var items = $Items
onready var ingredient_timer = $IngredientTimer
onready var order_timer = $OrderTimer


func _ready() -> void:
	randomize()
	servery.connect("served", self, "on_dish_served")
	
	start_game()


func start_game() -> void:
	spawn_ingredient()
	spawn_ingredient()
	spawn_order()
	spawn_plate()
	ingredient_timer.start()
	order_timer.start()


func spawn_plate() -> void:
	var plate = PlateScene.instance()
	plate.name = "Plate"
	items.call_deferred("add_child", plate)
	items.call_deferred("move_child", plate, 0)
	plate.position = get_viewport_rect().size/2

	
func spawn_order() -> void:
	var order = OrderScene.instance()
	orders.add_child(order)
	var dish = DishScene.instance()
	var r = randi() % 3
	if r == 1:
		dish.ingredients = ["tomato"]
	elif r == 2:
		dish.ingredients = ["lettuce"]
	else:
		dish.ingredients = ["eggplant"]
	order.set_dish(dish)


func spawn_ingredient() -> void:
	var r = randi() % 3
	var ingredient = IngredientScene.instance()
	ingredient_count += 1
	ingredient.name = "ingredient" + str(ingredient_count)
	if r == 1:
		ingredient.set_name("tomato")
	elif r == 2:
		ingredient.set_name("lettuce")
	else:
		ingredient.set_name("eggplant")
	ingredient.position = Vector2(ingredient_count % 4 * 200 + 50, 450)
	items.call_deferred("add_child", ingredient)


func on_dish_served(dish: Dish) -> void:
	var order_valid = false
	for order in orders.get_children():
		if not order.is_valid(dish):
			continue
		else:
			order_valid = true
			order.queue_free()
			break
	if order_valid:
		score += 5
	else:
		score -= 1
	hud.update_score(score)
	spawn_plate()


func _on_IngredientTimer_timeout() -> void:
	spawn_ingredient()


func _on_OrderTimer_timeout() -> void:
	spawn_order()
