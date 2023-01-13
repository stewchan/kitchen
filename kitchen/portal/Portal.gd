extends Area2D

signal remove_item(item)

var next_peer: int


func _ready() -> void:
	pass


func _on_Portal_body_entered(item: Ingredient) -> void:
	# Remove item from current peer
	emit_signal("remove_item", item)
	# add item to next peer
	emit_signal("")
