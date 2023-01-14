extends Area2D


signal send_item_to(item, peer)

var destination_peer: int


func _ready() -> void:
	pass


func _on_Portal_body_entered(item: Ingredient) -> void:
	# Remove item from current peer
	emit_signal("send_item_to", item, destination_peer)
