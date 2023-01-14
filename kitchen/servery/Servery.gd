extends Node2D


signal served(dish)


func _on_Servery_body_entered(plate: Plate) -> void:
	var dish = plate.get_dish()
	if not dish.is_empty():
		print(dish)
		plate.queue_free()
		emit_signal("served", plate.get_dish())
