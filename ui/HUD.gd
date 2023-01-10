extends CanvasLayer


var score: int = 0

onready var orders = $H/Orders
onready var score_label = $H/ScoreLabel


func _on_World_order_added(order: Order) -> void:
	order.get_parent().remove_child(order)
	orders.add_child(order)


func on_dish_served(dish: Dish) -> void:
	for order in orders.get_children():
		if order.is_valid(dish):
			score += 5
		else:
			score -= 1
		score_label.text = str(score)
