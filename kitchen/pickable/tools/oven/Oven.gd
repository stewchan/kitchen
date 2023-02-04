extends KitchenTool
class_name Oven

export var cook_speed: int = 20

onready var cook_timer = $CookTimer


func cook():
	var doneness = captured_ingredient.doneness + cook_speed
	captured_ingredient.set_doneness(doneness)
	if doneness < 100:
		if not progress_bar.visible:
			progress_bar.show()
		progress_bar.value = doneness
	else:
		if progress_bar.visible:
			progress_bar.hide()
		
		if doneness < 150:
			captured_ingredient.set_is_cooked(true)
		elif doneness < 250:
			print("overcooked")
		elif doneness < 350:
			print("inedible")
		else:
			print("burnt")


# Override default mouse click to release cooked ingredient
func _input_event(_viewport, event, _shape_idx):
	if event is InputEventMouseButton and event.pressed:
		print("1")
		if captured_ingredient and captured_ingredient.is_cooked():
			print("2")
			cook_timer.stop()
			release()
		else:
			emit_signal("picked_up", self)


func _on_CookTimer_timeout() -> void:
	if weakref(captured_ingredient):
		cook()
	cook_timer.start()


func _on_Hitbox_body_entered(ingredient: Ingredient) -> void:
	if not captured_ingredient:
		if ingredient.is_chopped() and not ingredient.is_cooked():
			capture(ingredient)
			cook_timer.start()
			
