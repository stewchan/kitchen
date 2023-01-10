extends Node
class_name Dish


var ingredients = [] setget set_ingredients, get_ingredients
var dish_name: String


func get_name() -> String:
	if not dish_name:
		if not ingredients:
			dish_name = "empty"
		else:
			dish_name = PoolStringArray(ingredients).join(",")
	return dish_name


# TODO: Set dish by name
func set_dish(name: String) -> void:
	pass


func set_ingredients(value: Array) -> void:
	ingredients = value


func get_ingredients() -> Array:
	return ingredients


func is_empty() -> bool:
	return ingredients == []


func compare_to(other: Dish) -> bool:
	var other_ingredients = other.get_ingredients()
	if ingredients.size() != other_ingredients.size():
		return false
	ingredients.sort()
	other_ingredients.sort()
	for i in range(0, ingredients.size()):
		if ingredients[i] != other_ingredients[i]:
			return false
	return true


func _ready() -> void:
	pass