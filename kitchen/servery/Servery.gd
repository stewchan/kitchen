extends Node2D


signal served


func _on_Servery_body_entered(body: Node) -> void:
	if body.has_method("get_dish") and body.get_dish():
		body.queue_free()
		emit_signal("served") #body.get_dish())

