extends Node

var WorldScene: PackedScene = preload("res://world/World.tscn")
var world_count: int = 0

onready var lobby = $Lobby
onready var players = $Players


func _ready() -> void:
	lobby.connect("start_game", self, "on_start_game")


func on_start_game() -> void:
	world_count += 1
	var world = WorldScene.instance()
	world.name = "World" + str(world_count)
	add_child(world, true)
	remove_child(players)
	world.get_node("Players").replace_by(players)
	world.start_game()
