extends CookingTool
class_name CookPot


onready var cook_timer = $CookTimer


func capture(ingredient: Ingredient):
	if ingredient.has_method("cook") and ingredient.is_cooked():
		return
	.capture(ingredient)
	cook_timer.start()


# Override default mouse click to release cooked ingredient
func _input_event(viewport, event, shape_idx):
	if event is InputEventMouseButton and event.pressed:
		if current_ingred and current_ingred.is_cooked():
			cook_timer.stop()
			release()
		else:
			emit_signal("picked_up", self)


func _on_CookTimer_timeout() -> void:
	if current_ingred:
		current_ingred.cook()
		cook_timer.start()
