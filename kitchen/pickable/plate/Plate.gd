extends Pickable
class_name Plate

var IngredientScene: PackedScene = preload("res://kitchen/pickable/ingredient/Ingredient.tscn")

onready var ingredients = $Ingredients


func get_dish() -> Dish:
	var ingredients_list = []
	for ingredient in ingredients.get_children():
		ingredients_list.append(ingredient.name)
	var dish = Dish.new()		
	dish.ingredients = ingredients_list
	return dish


func capture(ingredient: Ingredient):
	# TODO: Loop through ingredients to combine them
	# Only allow 1 type of each ingredient on plate
	for ingred in ingredients.get_children():
		if ingred.same_as(ingredient):
			return
	var ingred = ingredient.process_and_clone()
	ingredient.queue_free()
	ingred.rotation = rotation
	ingredients.call_deferred("add_child", ingred)
	ingred.position = Vector2.ZERO


func _on_Hitbox_body_entered(ingredient: Ingredient) -> void:
	if ingredient.is_prepped:
		capture(ingredient)
