extends Pickable
class_name Plate

var IngredientScene: PackedScene = preload("res://kitchen/pickable/ingredient/Ingredient.tscn")

onready var ingredients = $Ingredients


func _ready() -> void:
	mode = RigidBody2D.MODE_CHARACTER


func get_dish() -> Dish:
	var ingredients_list = []
	for ingredient in ingredients.get_children():
		ingredients_list.append(ingredient.type)
	var dish = Dish.new()		
	dish.ingredients = ingredients_list
	return dish


func capture(ingredient: Ingredient):
	# If plate is empty
	if isEmpty():
		G.relocate_node(ingredient, ingredients)
		ingredient.disable()
		ingredient.set_plated()
		ingredient.rotation = rotation
	else:
		var plated_ingredient = ingredients.get_child(0) as Ingredient
		var all_ingredients = plated_ingredient.get_nested_ingredients()
		var ingred_types = plated_ingredient.get_nested_ingredient_types()
		if not ingred_types.has(ingredient.type):
			plated_ingredient = plated_ingredient.nest(ingredient)
			
#	for ingred in ingredients.get_children():
#		if ingred.same_as(ingredient):
#			return
#		G.relocate_node(ingredient, ingredients)
#		ingredient.disable()
#		ingredient.set_plated()
#		ingredient.rotation = rotation
	# move ingredients into correct draw order
#	for i in range(0, ingredients.get_children().size()):
#		if ingredient.plate_layer < ingredients.get_children()[i].plate_layer:
#			ingredients.call_deferred("move_child", ingredient, i)
#			break

func isEmpty() -> bool:
	return ingredients.get_child_count() == 0


func trash():
	if ingredients.get_children():
		for ingred in ingredients.get_children():
			ingredients.remove_child(ingred)
			ingred.queue_free()


func _on_Hitbox_body_entered(ingredient: Ingredient) -> void:
	if ingredient.is_plateable():
		capture(ingredient)
