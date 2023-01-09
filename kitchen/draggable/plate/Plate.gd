extends Draggable
class_name Plate


var IngredientScene: PackedScene = preload("res://kitchen/draggable/ingredient/Ingredient.tscn")

onready var ingredients = $Ingredients


func get_dish() -> Dish:
	var ingredients_list = []
	for ingredient in ingredients.get_children():
		ingredients_list.append(ingredient.name)
	var dish = Dish.new()		
	dish.set_ingredients(ingredients_list)
	return dish


func combine(ingredient: KinematicBody2D):
	# TODO: Loop through ingredients to combine them
	ingredient.queue_free()
	var new_ingredient = IngredientScene.instance()
	new_ingredient.get_node("CollisionShape2D").free()
	new_ingredient.get_node("Hitbox").free()
	ingredients.add_child(new_ingredient)
	
	new_ingredient.position = Vector2.ZERO


func _on_Hitbox_body_entered(body: KinematicBody2D) -> void:
	if body.has_method("ready_to_plate") and body.ready_to_plate():
		combine(body)
