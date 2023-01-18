extends Pickable
class_name SpawnBox

signal spawn_ingredient(ingred_type, global_pos)

#var IngredientScene = preload("res://kitchen/pickable/ingredient/Ingredient.tscn")
var ingred_name: String = "Tomato"
var can_spawn: bool = true

onready var cooldown_timer = $CooldownTimer


func action() -> void:
	if can_spawn:
		print("spawn")
		spawn_ingredient()


func spawn_ingredient() -> void:
	can_spawn = false
	emit_signal("spawn_ingredient", ingred_name, global_position)
	cooldown_timer.start()


func _on_CooldownTimer_timeout() -> void:
	can_spawn = true
