extends KitchenTool
class_name CuttingBoard

export var chop_speed: int = 100

var audio_streams: Array = [
	preload("res://assets/sounds/sfx/cleaver 1.wav"),
	preload("res://assets/sounds/sfx/cleaver 3.wav"),
	preload("res://assets/sounds/sfx/cleaver 4.wav"),
	preload("res://assets/sounds/sfx/cleaver 6.wav"),
]


func action(delta: float) -> void:
	if not captured_item:
		return
	if captured_item.is_chopped():
		release()
	else:
		# Chop the ingredient
		if not audio_player.playing:
			audio_player.stream = audio_streams[int(randi()%audio_streams.size())]
			audio_player.play()
		if not progress_bar.visible:
			progress_bar.show()
		if progress_bar.value < progress_bar.max_value:
			progress_bar.value += chop_speed * delta
		elif progress_bar.value >= progress_bar.max_value:
			captured_item.set_is_chopped(true)
			progress_bar.value = 0
			progress_bar.hide()


func _on_Hitbox_body_entered(ingredient: Ingredient) -> void:
	if not ingredient.is_chopped() and not captured_item:
		capture(ingredient)
