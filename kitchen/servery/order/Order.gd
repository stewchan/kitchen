extends Control
class_name Order


var dish: Dish setget set_dish, get_dish


onready var order_label = $V/OrderLabel
onready var ingredients_label = $V/IngredientsLabel


func is_valid(other: Dish) -> bool:
	return other.equal_to(dish)


func set_dish(value: Dish) -> void:
	dish = value
	order_label.text = dish.get_name()
	ingredients_label.text = PoolStringArray(dish.get_ingredients()).join(",")
	add_child(dish)


func get_dish() -> Dish:
	return dish



	
