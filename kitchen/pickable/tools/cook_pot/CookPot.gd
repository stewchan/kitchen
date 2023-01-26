extends KitchenTool
class_name CookPot


export var cook_speed: int = 4
var doneness: int = 0

onready var cook_timer = $CookTimer


func capture(ingredient: Ingredient):
	if ingredient.has_method("cook") and ingredient.is_cooked():
		return
	.capture(ingredient)
	cook_timer.start()


func cook():
	doneness += cook_speed
	
	if doneness < 100:
		if not progress_bar.visible:
			progress_bar.show()
		progress_bar.value = doneness
	elif doneness < 150:
		if progress_bar.visible:
			progress_bar.hide()
	elif doneness < 250:
		print("overcooked")
	elif doneness < 350:
		print("inedible")
	else:
		print("burnt")



# Override default mouse click to release cooked ingredient
func _input_event(_viewport, event, _shape_idx):
	if event is InputEventMouseButton and event.pressed:
		if captured_ingredient and captured_ingredient.is_cooked():
			cook_timer.stop()
			release()
		else:
			emit_signal("picked_up", self)


func _on_CookTimer_timeout() -> void:
	if weakref(captured_ingredient):
		cook()
	cook_timer.start()
