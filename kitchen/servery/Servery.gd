extends Node2D


signal served(dish)


func _on_Servery_body_entered(body: Node) -> void:
	if not body.has_method("get_dish"):
		return

	var dish = body.get_dish()
	if not dish.is_empty():
		body.queue_free()
		emit_signal("served", body.get_dish())

