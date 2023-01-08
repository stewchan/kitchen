extends Draggable
class_name Plate


# Container
var ready_to_serve = false
# List of plated ingredients

var IngredientScene: PackedScene = preload("res://kitchen/draggable/ingredient/Ingredient.tscn")

onready var ingredients = $Ingredients


func combine(ingredient: KinematicBody2D):
	# Loop through ingredients to combine them
	print("Ingredient added")
	ingredient.queue_free()
	var new_ingredient = IngredientScene.instance()
	new_ingredient.get_node("CollisionShape2D").free()
	new_ingredient.get_node("Hitbox").free()
	ingredients.add_child(new_ingredient)
	
	new_ingredient.position = Vector2.ZERO


func _on_Hitbox_body_entered(body: Node) -> void:
	if body is Ingredient:
		print("combining")
		combine(body)
