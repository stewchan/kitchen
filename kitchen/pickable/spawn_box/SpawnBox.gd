extends Pickable
class_name SpawnBox

signal spawn_ingredient(ingred_type, global_pos)

#var IngredientScene = preload("res://kitchen/pickable/ingredient/Ingredient.tscn")
var ingred_name: String = "Tomato"
var can_spawn: bool = true

func _ready() -> void:
	default_mode = RigidBody2D.MODE_CHARACTER
	can_pickup = false


func action() -> void:
	if can_spawn:
		can_spawn = false
		emit_signal("spawn_ingredient", ingred_name, global_position)
		yield(get_tree().create_timer(1),"timeout")
		can_spawn = true


