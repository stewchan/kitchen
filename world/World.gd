extends Node2D
class_name GameWorld

signal clock_ticked(time_remaining)
signal game_over()

var held_object: Pickable = null
var ingredient_count: int = 0
var level: int = 1
export var time_remaining: int = 5

var OrderScene = preload("res://kitchen/servery/order/Order.tscn")
var DishScene = preload("res://kitchen/servery/dish/Dish.tscn")
var BoxScene = preload("res://kitchen/pickable/tools/spawn_box/SpawnBox.tscn")

onready var players = $Players
onready var servery = $Servery
onready var hud = $HUD
onready var orders_manager = $OrdersManager
onready var orders = $OrdersManager/Orders
onready var items = $Items
onready var ingredient_timer = $IngredientTimer
onready var order_timer = $OrderTimer
onready var portal = $Portal
onready var clock_timer = $ClockTimer


func _ready() -> void:
	randomize()


func setup_game() -> void:
	emit_signal("clock_ticked", time_remaining)	
	if Network.pid == 1:
		players.rpc("add_recipes", ["pizza"])
		players.rpc("add_tools", ["Plate", "CuttingBoard"])
		players.prepare_tools()
		players.prepare_boxes()
		players.prepare_portals()
		rpc("_start_game")


remotesync func _start_game() -> void:
	get_tree	().paused = false
	order_timer.start()
	clock_timer.start()


# Called when picking up an object
func on_pickup(object: Pickable) -> void:
	if not held_object:
		held_object = object
		held_object.pickup()


# Callback for when item is chopped and then immediately picked up
func on_dropped(_object: Pickable) -> void:
	held_object = null


func _unhandled_input(event: InputEvent) -> void:
	if event is InputEventMouseButton:
		if held_object and not event.pressed:
			held_object.drop(Input.get_last_mouse_speed())
			held_object = null


func _on_IngredientTimer_timeout() -> void:
	items.spawn_ingredient()


func _on_OrderTimer_timeout() -> void:
	if Network.is_server():
		var recipe_name = G.recipe_list[int(randi()%G.recipe_list.size())]
		var recipe = Recipe.new(recipe_name, -1) # random version of this recipe
		orders_manager.rpc("spawn_order", var2str(recipe))


func _on_Servery_served(dish: Dish) -> void:
	var order_name = "none"
	for o in orders.get_children():
		if o.has_dish(dish):
			order_name = o.name
			break
	orders_manager.rpc("complete_order", order_name)	
	items.spawn_tool("Plate")


remotesync func stop_game() -> void:
	get_tree	().paused = true


func _on_ClockTimer_timeout() -> void:
	time_remaining -= 1
	emit_signal("clock_ticked", time_remaining)
	if time_remaining <= 0:
		clock_timer.stop()
		emit_signal("game_over")
		rpc("stop_game")
