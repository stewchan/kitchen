extends Node


var world_node: GameWorld setget set_world


func set_world(world: GameWorld) -> void:
	world_node = world


func reparent(child, new_parent) -> void:
	child.get_parent().remove_child(child)
	new_parent.add_child( child)
	child.owner = world_node


func relocate_node(child: Pickable, new_parent, pos: Vector2 = Vector2.ZERO) -> void:
	child.get_parent().remove_child(child)
	new_parent.call_deferred("add_child", child)
	child.position = pos
	child.set_deferred("owner", new_parent)


func relocate_to_world(ingred: Ingredient, global_pos: Vector2 = Vector2.ZERO) -> void:
	relocate_node(ingred, world_node.get_node("Items"), global_pos)
