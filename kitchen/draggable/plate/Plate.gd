extends Draggable
class_name Plate


var IngredientScene: PackedScene = preload("res://kitchen/draggable/ingredient/Ingredient.tscn")

onready var ingredients = $Ingredients


func get_dish() -> Dish:
	var ingredients_list = []
	for ingredient in ingredients.get_children():
		ingredients_list.append(ingredient.name)
	var dish = Dish.new()		
	dish.ingredients = ingredients_list
	return dish


func combine(ingredient: Ingredient):
	# TODO: Loop through ingredients to combine them
	# Only allow 1 type of each ingredient on plate
	for ing in ingredients.get_children():
		if ing.same_as(ingredient):
			return
	var ing = ingredient.process_and_clone()
	ingredient.queue_free()
	ingredients.call_deferred("add_child", ing)
	ing.position = Vector2.ZERO


func _on_Hitbox_body_entered(ingredient: Ingredient) -> void:
	if ingredient.ready_to_plate():
		combine(ingredient)
