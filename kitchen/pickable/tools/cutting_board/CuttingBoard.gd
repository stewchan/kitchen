extends KitchenTool
class_name CuttingBoard


export var chop_speed: int = 100


func action(delta: float) -> void:
	if not captured_ingredient:
		return
	if captured_ingredient.is_chopped():
		release()
	else:
		# Chop the ingredient
		if not progress_bar.visible:
			progress_bar.show()
		if progress_bar.value < progress_bar.max_value:
			progress_bar.value += chop_speed * delta
		elif progress_bar.value >= progress_bar.max_value:
			captured_ingredient.set_is_chopped()
			progress_bar.value = 0
			progress_bar.hide()
