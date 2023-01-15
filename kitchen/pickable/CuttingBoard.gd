extends Pickable
class_name CuttingBoard

var IngredientScene: PackedScene = preload("res://kitchen/pickable/ingredient/Ingredient.tscn")
var current_ingred: Ingredient = null

onready var hitbox_collision_shape: CollisionShape2D = $Hitbox/CollisionShape2D


func capture(ingredient: Ingredient):
	ingredient.disable()
	G.reparent_to_node(ingredient, self)
	ingredient.rotation = rotation
	current_ingred = ingredient
	can_pickup = false # The board


func release() -> void:
	current_ingred.enable()
	G.reparent_to_world(current_ingred)
	print(linear_velocity)
	current_ingred = null
	can_pickup = true # The board


func click_action() -> void:
	if current_ingred:
		if current_ingred.is_prepped:
			release()
		else:
			current_ingred.chop()


func _on_Hitbox_body_entered(ingredient: Ingredient) -> void:
	if not ingredient.is_prepped and not current_ingred:
		capture(ingredient)
