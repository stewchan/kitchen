extends Node


var world_node: Node2D


func set_world(world: Node2D) -> void:
	world_node = world


func reparent_to_node(child: Pickable, new_parent, pos: Vector2 = Vector2.ZERO) -> void:
	child.get_parent().remove_child(child)
	new_parent.call_deferred("add_child", child)
	child.name = child.id
	child.position = pos
	child.set_deferred("owner", new_parent)


func reparent_to_world(ingred: Ingredient, global_pos: Vector2 = Vector2.ZERO) -> void:
	reparent_to_node(ingred, world_node.get_node("Items"), global_pos)

