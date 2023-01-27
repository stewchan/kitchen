extends Node2D


signal order_added(order)
signal order_removed(order)
signal score_changed(score)

var score: int = 0
var order_count: int = 0
var order_expire_penalty: int = -2
var OrderScene = preload("res://kitchen/servery/order/Order.tscn")

var success_sounds: Array = [
	preload("res://assets/sounds/sfx/ding 1.wav"),
	preload("res://assets/sounds/sfx/ding 2.wav"),
	preload("res://assets/sounds/sfx/ding 3.wav"),
]

onready var audio_player = $AudioPlayer
onready var orders = $Orders


remotesync func spawn_order(recipe_json: String) -> void:
	order_count += 1
	var order = OrderScene.instance()
	order.name = "Order" + str(order_count)
	orders.add_child(order)
	order.set_dish_from_recipe(str2var(recipe_json))
	order.connect("order_expired", self, "on_order_expired")
	emit_signal("order_added", order)


func on_order_expired(_order: Order) -> void:
	print("Order expired")
	score += order_expire_penalty
	emit_signal("score_changed", score)


remotesync func complete_order(order_name: String) -> void:
	if orders.get_node_or_null(order_name):
		var order = orders.get_node(order_name) as Order
		order.queue_free()
		score += order.score_value
		# ding
		audio_player.stream = success_sounds[int(randi()%success_sounds.size())]
		audio_player.play()
		emit_signal("order_removed", order)
	else:
		# buzzer
		score -= 1
	emit_signal("score_changed", score)
