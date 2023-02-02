extends Area2D

var to_peer: int setget set_peer


remotesync func set_peer(pid: int) -> void:
	to_peer = pid


func _on_Portal_body_entered(item: Ingredient) -> void:
	G.world_node.items.rpc_id(to_peer, "on_Portal_spawn_ingredient", item.type)
	item.queue_free()
