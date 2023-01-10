extends CanvasLayer


var score: int = 0

onready var orders = $H/Orders
onready var score_label = $H/ScoreLabel


func _on_World_order_added(order: Order) -> void:
	order.get_parent().remove_child(order)
	orders.add_child(order)


func update_score(val: int) -> void:
	score = val
	score_label.text = str(score)
