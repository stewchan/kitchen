extends Node
class_name Recipe

var recipe_name: String
var ingredients: Array = []


static func random() -> Recipe:
	return load("res://kitchen/Recipe.gd").new("random")


func _init(name: String = "random", version: int = -1) -> void:
	if Data.recipes.keys().has(name):
		recipe_name = name
		if version >= 0:
			ingredients = Data.recipes[name][version]
		else:			
			ingredients = Data.recipes[name][int(randi() % Data.recipes[name].size())]
	else:
		print("Recipe name doesn't exist...choosing random recipe")
		recipe_name = Data.recipes.keys()[int(randi() % Data.recipes.size())]
		ingredients = Data.recipes[recipe_name][int(randi() % Data.recipes[recipe_name].size())]




