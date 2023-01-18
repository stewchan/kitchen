extends Node2D


signal order_added(order)
signal order_removed(order)
signal score_changed(score)

var score: int = 0
var order_count: int = 0
var OrderScene = preload("res://kitchen/servery/order/Order.tscn")


remotesync func spawn_order(dish_json: String) -> void:
	order_count += 1
	var order = OrderScene.instance()
	order.name = "Order" + str(order_count)
	add_child(order)
	order.set_dish(str2var(dish_json))
	emit_signal("order_added", order)


remotesync func complete_order(order_name: String) -> void:
	if get_node_or_null(order_name):
		var order = get_node(order_name) as Order
		order.queue_free()
		score += order.value
		emit_signal("order_removed", order)
	else:
		score -= 1
	emit_signal("score_changed", score)
