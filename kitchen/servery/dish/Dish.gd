extends TextureRect
class_name Dish


var ingredients: Array = []
var dish_name: String = "Empty"
var texture_base_path: String = "res://assets/images/dishes/"
var texture_path: String


static func random() -> Dish:
	var dish = load("res://kitchen/servery/dish/Dish.gd").new()
	var recipe = Recipe.random()
	dish.dish_name = recipe.recipe_name
	dish.ingredients = recipe.ingredients
	return dish


func set_dish(recipe: Recipe) -> void:
	dish_name = recipe.recipe_name
	ingredients = recipe.ingredients
	update_texture()


func update_texture() -> void:
	texture_path = texture_base_path + dish_name + "/" + dish_name
	for ingredient_name in ingredients:
		texture_path += "-" + ingredient_name
	texture_path += ".png"
	texture = load(texture_path)


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

