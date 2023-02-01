extends Area2D

var to_peer: int


func _on_Portal_body_entered(item: Ingredient) -> void:
	G.world_node.items.rpc_id(to_peer, "on_portal_spawn_ingredient", item.type)
	item.queue_free()
