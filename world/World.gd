extends Node2D


var score: int = 0
var orders = []

onready var players = $Players
onready var servery = $Servery
onready var score_label = $HUD/ScoreLabel
onready var hud = $HUD




func _ready() -> void:
	servery.connect("served", self, "on_dish_served")


func start_game() -> void:
	pass
	

func on_dish_served() -> void:
	score += 1
	score_label.text = str(score)
	
