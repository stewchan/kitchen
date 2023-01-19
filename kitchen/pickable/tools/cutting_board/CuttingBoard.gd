extends CookingTool
class_name CuttingBoard


func action() -> void:
	if current_ingred:
		if current_ingred.is_chopped:
			release()
		else:
			current_ingred.chop()
