extends Node

var WorldScene: PackedScene = preload("res://world/World.tscn")
var world_count: int = 0

onready var lobby = $Lobby
onready var players = $Players


func _ready() -> void:
	lobby.connect("start_game", self, "on_Lobby_start_game")


func on_Lobby_start_game() -> void:
	world_count += 1
	var world = WorldScene.instance()
	world.name = "World" + str(world_count)
	add_child(world, true)
	remove_child(players)
	for player in players.get_children():
		G.reparent(player, world.get_node("Players"))
	players.queue_free()
	G.world_node = world
	world.setup_game()
