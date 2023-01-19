extends Pickable
class_name SpawnBox

signal spawn_ingredient(ingred_type, global_pos, impulse)

#var IngredientScene = preload("res://kitchen/pickable/ingredient/Ingredient.tscn")
var ingred_name: String = "Tomato"
var can_spawn: bool = true


func _ready() -> void:
	mode = RigidBody2D.MODE_STATIC
	immovable = true


func action() -> void:
	if can_spawn:
		can_spawn = false
		emit_signal("spawn_ingredient", ingred_name, global_position, Vector2.RIGHT * 300)
		drop()
		can_spawn = true


