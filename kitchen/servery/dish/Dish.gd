extends Node
class_name Dish


var ingredients = ["tomato"] setget set_ingredients, get_ingredients
var dish_name = "Soup"


func set_dish(ingredients: Array) -> void:
	self.ingredients = ingredients


func set_ingredients(value: Array) -> void:
	ingredients = value


func get_ingredients() -> Array:
	return ingredients


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
