extends Pickable
class_name Plate

var IngredientScene: PackedScene = preload("res://kitchen/pickable/ingredient/Ingredient.tscn")

onready var ingredients = $Ingredients


func get_dish() -> Dish:
	var ingredients_list = []
	for ingredient in ingredients.get_children():
		ingredients_list.append(ingredient.type)
	var dish = Dish.new()		
	dish.ingredients = ingredients_list
	return dish


func capture(ingredient: Ingredient):
	# TODO: Loop through ingredients to combine them
	# Only allow 1 type of each ingredient on plate
	for ingred in ingredients.get_children():
		if ingred.same_as(ingredient):
			return
	ingredient.disable()
	G.reparent_to_node(ingredient, ingredients)
	ingredient.rotation = rotation


func trash():
	if ingredients.get_children():
		for ingred in ingredients.get_children():
			ingredients.remove_child(ingred)
			ingred.queue_free()


func _on_Hitbox_body_entered(ingredient: Ingredient) -> void:
	if ingredient.is_prepped:
		capture(ingredient)
