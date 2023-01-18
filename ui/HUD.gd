extends CanvasLayer


onready var orders = $H/Orders
onready var score_label = $H/ScoreLabel


func update_score_label(score: int) -> void:
	score_label.text = str(score)


func _on_Orders_order_removed(order) -> void:
	for o in orders.get_children():
		if o.name == order.name:
			orders.remove_child(o)
			break


func _on_Orders_score_changed(score) -> void:
	update_score_label(score)


func _on_Orders_order_added(order) -> void:
	var new_order = order.duplicate()
	new_order.name = order.name
	orders.add_child(new_order)
