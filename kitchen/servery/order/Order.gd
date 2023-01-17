extends Control
class_name Order


signal order_expired(order)


var dish: Dish setget set_dish, get_dish
var DishScene = preload("res://kitchen/servery/dish/Dish.tscn")

onready var order_label = $V/OrderLabel
onready var ingredients_label = $V/IngredientsLabel
onready var expire_timer = $ExpireTimer
onready var expire_progress = $V/ExpireProgress


func _ready() -> void:
	expire_progress.max_value = expire_timer.wait_time
	expire_progress.value = expire_progress.max_value
	expire_timer.start()


func _process(delta: float) -> void:
	expire_progress.value = expire_timer.time_left


func is_empty() -> bool:
	return dish == null


func has_dish(other: Dish) -> bool:
	return other.equal_to(dish)


func set_dish(value: Dish) -> void:
	dish = value
	dish.name = "Dish"
	order_label.text = dish.dish_name
	ingredients_label.text = PoolStringArray(dish.ingredients).join("\n")
	add_child(dish)


func get_dish() -> Dish:
	return dish


func _on_LifetimeTimer_timeout() -> void:
	emit_signal("order_expired", self)
	queue_free()
