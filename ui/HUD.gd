extends CanvasLayer

onready var orders = $H/Orders
onready var score_label = $H/ScoreLabel
onready var message_container = $MessageContainer
onready var message_label = $MessageContainer/MessageLabel
onready var clock_label = $H/ClockLabel


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


func _on_World_clock_ticked(time_remaining) -> void:
	clock_label.text = str(time_remaining)


func _on_World_game_over() -> void:
	message_label.text = "Game Over"
	message_container.show()
	message_label.show()
