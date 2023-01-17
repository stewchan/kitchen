extends Area2D

signal served(dish)


func _on_Servery_body_entered(body: RigidBody2D) -> void:
	if not body is Plate:
		return
	var dish = body.get_dish()
	if dish.is_empty():
		return
	body.queue_free()
	emit_signal("served", body.get_dish())
