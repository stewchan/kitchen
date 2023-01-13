extends Control
class_name Order


var dish: Dish setget set_dish, get_dish

var DishScene = preload("res://kitchen/servery/dish/Dish.tscn")

onready var order_label = $V/OrderLabel
onready var ingredients_label = $V/IngredientsLabel


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



	
