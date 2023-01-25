extends Pickable
class_name KitchenTool

var current_ingred: Ingredient = null

onready var hitbox_collision_shape: CollisionShape2D = $Hitbox/CollisionShape2D


func _ready() -> void:
	mode = RigidBody2D.MODE_CHARACTER
	._ready()


func capture(ingredient: Ingredient):
	ingredient.disable()
	G.reparent_to_node(ingredient, self)
	ingredient.rotation = rotation
	current_ingred = ingredient


func release() -> void:
	if current_ingred:
		current_ingred.enable()
		G.reparent_to_world(current_ingred, current_ingred.global_position)
		drop()
		yield(get_tree(), "idle_frame") # Required so pick up signal not called before drop
		emit_signal("picked_up", current_ingred)
		current_ingred = null


func _on_Hitbox_body_entered(ingredient: Ingredient) -> void:
	if not ingredient.is_chopped and not current_ingred:
		capture(ingredient)
