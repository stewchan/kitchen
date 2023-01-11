extends Control

signal start_game

var PlayerScene: PackedScene = preload("res://player/Player.tscn")

onready var config_ui = $C/V/Config
onready var server_ip = $C/V/Config/V/ServerIP
onready var message_label = $C/V/Waiting/MessageLabel
onready var players = get_parent().get_node("Players")
onready var start_game_button = $C/V/Waiting/StartGameButton


func _ready():
	get_tree().connect("network_peer_connected", self, "_on_player_connected")
	get_tree().connect("network_peer_disconnected", self, "_on_player_disconnected")
	get_tree().connect("connected_to_server", self, "_on_connected_to_server")
	server_ip.text = Network.ip_address
	message_label.text = "Your IP: " + Network.ip_address


func _on_player_connected(id: int) -> void:
	print("Player connected: " + str(id))
	if Network.pid == 1:
		spawn_player(id)
		update_players()


func _on_player_disconnected(id: int) -> void:
	print("Player disconnected: " + str(id))
	despawn_player(id)


func _on_connected_to_server() -> void:
	print("Connected to server")


func _on_CreateButton_pressed() -> void:
	Network.create_server()	
	config_ui.hide()
	message_label.text = "Waiting for players..."
	start_game_button.show()
	spawn_player(1)


func _on_JoinButton_pressed() -> void:
	if server_ip.text != "":
		Network.ip_address = server_ip.text
		if Network.join_server():
			spawn_player(Network.pid)
			config_ui.hide()
			message_label.text = "Joined"
		else:
			message_label.text = "No server found."


remotesync func update_players() -> void:
	for player in players.get_children():
		var pid = int(player.name)
		rpc("spawn_player", pid)


remotesync func spawn_player(pid: int) -> void:
	if not players.get_node_or_null(str(pid)):
		var player = PlayerScene.instance()
		player.name = str(pid)
		if pid == Network.pid:
			player.set_network_master(pid)
		players.add_child(player)


remote func despawn_player(pid: int) -> void:
	var player = players.get_node_or_null(str(pid))
	if player:
		player.queue_free()


func _on_StartGameButton_pressed() -> void:
	rpc("on_start_game")


remotesync func on_start_game() -> void:
	emit_signal("start_game")
	queue_free()
