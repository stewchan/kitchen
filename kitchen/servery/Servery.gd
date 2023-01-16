extends Node2D


signal served(dish)


func _on_Servery_body_entered(body: RigidBody2D) -> void:
	if not body is Plate:
		return
	var dish = body.get_dish()
	if not dish.is_empty():
		print(dish)
		body.queue_free()
		emit_signal("served", body.get_dish())
