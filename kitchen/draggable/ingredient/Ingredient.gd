extends Draggable
class_name Ingredient


func _on_Hitbox_body_entered(body: Node) -> void:
	if body == self:
		return
	if body as Ingredient:
		$Hitbox/CollisionShape2D.queue_free()
		$CollisionShape2D.queue_free()
		print(str(body))
