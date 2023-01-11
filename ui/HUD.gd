extends CanvasLayer


var score: int = 0

onready var orders = $H/Orders
onready var score_label = $H/ScoreLabel


func update_score(val: int) -> void:
	score = val
	score_label.text = str(score)
