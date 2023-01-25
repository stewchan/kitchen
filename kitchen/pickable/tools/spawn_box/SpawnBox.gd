extends KitchenTool
class_name SpawnBox

#signal spawn_ingredient(ingred_type, global_pos, impulse)

var ingred_name: String
var can_spawn: bool = false
var progress_speed: int = 100
var IngredientScene: PackedScene = preload("res://kitchen/pickable/ingredient/Ingredient.tscn")

onready var progress_bar = $ProgressBar
onready var planting_timer = $PlantingTimer


func _ready() -> void:
	plant_seed()


func plant_seed() -> void:
	if ingred_name and not current_ingred:
		var ingredient = IngredientScene.instance()
		ingredient.type = ingred_name
		add_child(ingredient)
		capture(ingredient)


func action(delta: float) -> void:
	if not current_ingred:
		return

	if can_spawn:
		can_spawn = false
		release()
		drop()
		planting_timer.start()
	else:
		progress_bar.value += progress_speed * delta
		if progress_bar.value >= progress_bar.max_value:
			if not progress_bar.visible:
				progress_bar.show()
			progress_bar.value = 0
			can_spawn = true


func _on_PlantingTimer_timeout() -> void:
	if not current_ingred:
		plant_seed()
