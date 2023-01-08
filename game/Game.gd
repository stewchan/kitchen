extends Node

var WorldScene: PackedScene = preload("res://world/World.tscn")

onready var lobby = $Lobby
onready var players = $Players


func _ready() -> void:
	lobby.connect("start_game", self, "on_start_game")


func on_start_game() -> void:
	var world = WorldScene.instance()
	world.name = "World" + str(int(randi() % 100))
	add_child(world, true)
	self.remove_child(players)
	world.add_child(players)
	world.start_game()
