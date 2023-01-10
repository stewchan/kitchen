extends Control


var dish: Dish setget set_dish, get_dish


onready var order_label = $C/V/OrderLabel
onready var ingredients_label = $C/V/IngredientsLabel


func _ready() -> void:
	dish = $Dish


func set_dish(value: Dish) -> void:
	dish = value
	order_label.text = dish.get_name()
	ingredients_label.text = PoolStringArray(dish.get_ingredients()).join(",")


func get_dish() -> Dish:
	return dish
	

func order_fulfilled(other_dish: Dish) -> bool:
	queue_free()
	return dish.compare_to(other_dish)
