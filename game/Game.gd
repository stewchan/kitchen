extends Node

var WorldScene: PackedScene = preload("res://world/World.tscn")

onready var lobby = $Lobby
onready var players = $Players


func _ready() -> void:
#	randomize()
	lobby.connect("start_game", self, "on_start_game")


func on_start_game() -> void:
	var world = WorldScene.instance()
	world.name = "World" + str(int(randi() % 100))
	add_child(world, true)
	remove_child(players)
	world.get_node("Players").replace_by(players)
	world.start_game()
