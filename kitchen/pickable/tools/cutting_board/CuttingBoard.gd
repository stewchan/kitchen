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
	if not captured_ingredient:
		return
	if captured_ingredient.is_chopped():
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
			captured_ingredient.set_is_chopped()
			progress_bar.value = 0
			progress_bar.hide()
