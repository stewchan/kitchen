extends Node


func instance_node_at(node: Object, parent: Object, position: Vector2) -> Object:
	var node_instance = instance_node(node, parent)
	node_instance.global_position = position
	return node_instance


func instance_node(node: Object, parent: Object) -> Object:
	var node_instance = node.instance()
	parent.add_child(node_instance)
	return node_instance
