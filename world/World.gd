extends Node2D


var score: int = 0


onready var players = $Players
onready var servery = $Servery
onready var score_label = $HUD/ScoreLabel
onready var hud = $HUD
onready var orders = $Orders

var IngredientScene = preload("res://kitchen/draggable/ingredient/Ingredient.tscn")


func _ready() -> void:
	servery.connect("served", self, "on_dish_served")
	var ingredient1 = IngredientScene.instance()
	ingredient1.set_name("tomato")
	ingredient1.position = Vector2(200, 300)
	add_child(ingredient1)
	
	var ingredient2 = IngredientScene.instance()
	ingredient2.set_name("lettuce")
	ingredient2.position = Vector2(800,400)
	add_child(ingredient2)


func start_game() -> void:
	pass
	

func on_dish_served(dish: Dish) -> void:
	for order in orders.get_children():
		if order.dish.compare_to(dish):
			score += 5
		else:
			score -= 1
	score_label.text = str(score)
	
