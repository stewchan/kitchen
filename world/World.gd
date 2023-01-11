extends Node2D


signal order_added(order)

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


func _ready() -> void:
	randomize()
	servery.connect("served", self, "on_dish_served")
	
	spawn_ingredient()
	spawn_ingredient()
	spawn_ingredient()
	
	spawn_order()
	spawn_order()
	spawn_order()
	
	spawn_plate()


func spawn_plate() -> void:
	var plate = PlateScene.instance()
	plate.name = "Plate"
	call_deferred("add_child", plate)
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
	emit_signal("order_added", order)


func spawn_ingredient() -> void:
	var r = randi() % 3
	var ingredient = IngredientScene.instance()
	ingredient_count += 1
	ingredient.name = "ingredient" + str(ingredient_count)
	if r == 1:
		ingredient.set_name("tomato")
	elif r == 2:
		ingredient.set_name("tomato")
	else:
		ingredient.set_name("eggplant")
	ingredient.position = Vector2(ingredient_count % 4 * 200 + 50, 450)
	call_deferred("add_child", ingredient)


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
	spawn_ingredient()


func start_game() -> void:
	pass
	


