extends Node
class_name Recipe

var recipe_name: String = "Empty"
var ingredients: Array = []


static func random() -> Recipe:
	var recipe = load("res://kitchen/Recipe.gd").new()
	var n = int(randi() % Data.recipes.size())
	recipe.recipe_name = Data.recipes.keys()[n]
	var i = int(randi() % Data.recipes[recipe.recipe_name].size())
	recipe.ingredients = Data.recipes[recipe.recipe_name][i]
	return recipe


func _init(name: String = "Random", version: int = -1) -> void:
	if Data.recipes.keys().has(name):
		recipe_name = name
		if version == -1:
			var i = int(randi() % Data.recipes[name].size())
			ingredients = Data.recipes[name][i]
		else:
			ingredients = Data.recipes[name][version]
	elif name == "Random":
		print("Setting random recipe")
	else:
		print("Recipe doesn't exist")


func get_ingredient_version(i: int) -> Array:
	assert(i >= 0 && i <= ingredients.size())
	return ingredients[i]


func get_rand_ingredient_version() -> Array:
	var i = int(randi() % Data.recipes.size())
	return ingredients[i]



