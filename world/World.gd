extends Node2D

var held_object: Pickable = null
var ingredient_count: int = 0
var level: int = 1
var recipe_list = []

var OrderScene = preload("res://kitchen/servery/order/Order.tscn")
var DishScene = preload("res://kitchen/servery/dish/Dish.tscn")

onready var players = $Players
onready var servery = $Servery
onready var hud = $HUD
onready var orders = $Orders
onready var items = $Items
onready var ingredient_timer = $IngredientTimer
onready var order_timer = $OrderTimer
onready var portal = $Portal


func _ready() -> void:
	randomize()


func start_game() -> void:
	prepare_kitchen()
	items.spawn_plate(get_viewport_rect().size/2)
	items.spawn_cutting_board(Vector2(100,400))
	ingredient_timer.start()
	if Network.pid == 1:
		order_timer.start()


# TODO: Set up the game dish options and ingredients based on level
func prepare_kitchen() -> void:
	recipe_list = ["Soup", "Salad"]
	for recipe_name in recipe_list:
		for ingredient_list in Data.recipes[recipe_name]:
			for ingredient in ingredient_list:
				if not items.ingredient_options.has(ingredient):
					items.ingredient_options.append(ingredient)


func on_pickup(object: Pickable) -> void:
	if not held_object:
		held_object = object
		held_object.pickup()


func _unhandled_input(event: InputEvent) -> void:
	if event is InputEventMouseButton:
		if held_object and not event.pressed:
			held_object.drop(Input.get_last_mouse_speed())
			held_object = null


func _on_IngredientTimer_timeout() -> void:
	items.spawn_ingredient()


func _on_OrderTimer_timeout() -> void:
	if Network.is_server():
		orders.rpc("spawn_order", var2str(Dish.random()))


func _on_Servery_served(dish: Dish) -> void:
	var order_name = "none"
	for o in orders.get_children():
		if o.has_dish(dish):
			order_name = o.name
			break
	orders.rpc("complete_order", order_name)	
	items.spawn_plate(get_viewport_rect().size/2)


func _on_Portal_send_item_to(item: Ingredient, peer: int) -> void:
	items.rpc_id(peer, "spawn_ingredient", item.type)
	item.queue_free()
