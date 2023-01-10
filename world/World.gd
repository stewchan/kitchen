extends Node2D


signal order_added(order)

var score: int = 0
var order_count: int = 0
var ingredient_count: int = 0

var IngredientScene = preload("res://kitchen/draggable/ingredient/Ingredient.tscn")
var OrderScene = preload("res://kitchen/servery/order/Order.tscn")
var DishScene = preload("res://kitchen/servery/dish/Dish.tscn")

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
	ingredient.position = Vector2(ingredient_count * 200, 450)
	add_child(ingredient)


func on_dish_served(dish: Dish) -> void:
	for order in orders.get_children():
		if order.is_valid(dish):
			score += 5
			hud.update_score(score)
			order.queue_free()
			return
	score -= 1
	hud.update_score(score)


func start_game() -> void:
	pass
	


