extends KitchenTool
class_name CuttingBoard


func action(delta: float) -> void:
	if captured_ingredient:
		if captured_ingredient.is_chopped:
			release()
		else:
			captured_ingredient.chop(delta)
