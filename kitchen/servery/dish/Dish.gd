extends Node
class_name Dish


var ingredients: Array = []
var dish_name: String = "Empty"

func set_dish(recipe: Recipe) -> void:
	dish_name = recipe.recipe_name
	ingredients = recipe.ingredients


func set_rand_dish() -> void:
	var recipe = Recipe.new("Random")
	dish_name = recipe.recipe_name
	ingredients = recipe.ingredients


func set_name(val: String) -> void:
	dish_name = val


func is_empty() -> bool:
	return ingredients == []


func equal_to(other: Dish) -> bool:
	var other_ingredients = other.ingredients
	if ingredients.size() != other_ingredients.size():
		return false
	ingredients.sort()
	other_ingredients.sort()
	for i in range(0, ingredients.size()):
		if ingredients[i] != other_ingredients[i]:
			return false
	return true

