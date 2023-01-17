extends Area2D


func _on_Trash_body_entered(body: Node) -> void:
	if body is Pickable and body.has_method("trash"):
		body.trash()
