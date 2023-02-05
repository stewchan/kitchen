extends KitchenTool
class_name Oven

export var cook_speed: int = 20

onready var cook_timer = $CookTimer


func cook():
	var doneness = captured_item.doneness + cook_speed
	captured_item.set_doneness(doneness)
	if doneness < 100:
		if not progress_bar.visible:
			progress_bar.show()
		progress_bar.value = doneness
	else:
		if progress_bar.visible:
			progress_bar.hide()
		
		if doneness < 150:
			captured_item.set_is_cooked(true)
		elif doneness < 250:
			print("overcooked")
		elif doneness < 350:
			print("inedible")
		else:
			print("burnt")


# Override default mouse click to release cooked ingredient
func _input_event(_viewport, event, _shape_idx):
	if event is InputEventMouseButton and event.pressed:
		if captured_item and captured_item.is_cooked():
			cook_timer.stop()
			release()
		else:
			emit_signal("picked_up", self)


func _on_CookTimer_timeout() -> void:
	if weakref(captured_item):
		cook()
	cook_timer.start()


func _on_Hitbox_body_entered(item: Pickable) -> void:
	if captured_item:
		return
	print(item)		
	if item is Plate:
		var dish = item.get_dish()
		if dish.is_empty():
			print("No dish on plate")
			return
		else:
			print("capture from plate")
	#		capture(plate.get_dish())
	
			