extends Node
class_name Recipe


var recipe_name: String = "Empty"
var ingredients: Array = []


func _init(name: String = "Random", version: int = -1) -> void:
	if name == "Random":
		set_random_recipe()	
	elif Data.recipes.keys().has(name):
		recipe_name = name
		if version == -1:
			var i = int(randi() % Data.recipes[name].size())
			ingredients = Data.recipes[name][i]
		else:
			ingredients = Data.recipes[name][version]
	else:
		print("Recipe doesn't exist")


func set_random_recipe() -> void:
	var n = int(randi() % Data.recipes.size())
	recipe_name = Data.recipes.keys()[n]
	var i = int(randi() % Data.recipes[recipe_name].size())
	ingredients = Data.recipes[recipe_name][i]


func get_ingredient_version(i: int) -> Array:
	assert(i >= 0 && i <= ingredients.size())
	return ingredients[i]


func get_rand_ingredient_version() -> Array:
	var i = int(randi() % Data.recipes.size())
	return ingredients[i]



