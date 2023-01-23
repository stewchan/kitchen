extends Control
class_name Order


signal order_expired(order)


var dish: Dish
var base_value: int = 2
var score_value: int = base_value
var DishScene: PackedScene = preload("res://kitchen/servery/dish/Dish.tscn")

onready var order_label = $V/OrderLabel
onready var ingredients_label = $V/IngredientsLabel
onready var expire_timer = $ExpireTimer
onready var expire_progress = $V/ExpireProgress
onready var dish_node = $V/DishNode


func _ready() -> void:
	expire_progress.max_value = expire_timer.wait_time
	expire_progress.value = expire_progress.max_value
	expire_timer.start()


func _process(_delta: float) -> void:
	expire_progress.value = expire_timer.time_left


func set_dish_from_recipe(recipe: Recipe) -> void:
	dish = DishScene.instance()
	dish_node.add_child(dish)
	dish.set_dish(recipe)
	order_label.text = dish.dish_name
	ingredients_label.text = PoolStringArray(dish.ingredients).join("\n")
	score_value = base_value * dish.ingredients.size()


func get_dish() -> Dish:
	return dish


func is_empty() -> bool:
	return dish == null


func has_dish(other: Dish) -> bool:
	return other.equal_to(dish)


func _on_LifetimeTimer_timeout() -> void:
	emit_signal("order_expired", self)
	queue_free()
