extends Control

var WorldScene: PackedScene = preload("res://world/World.tscn")
var PlayerScene: PackedScene = preload("res://player/Player.tscn")

onready var multiplayer_config_ui = $MultiplayerConfig
onready var server_ip = $MultiplayerConfig/V/V/ServerIP
onready var device_ip_label = $MultiplayerConfig/V/V2/DeviceIPLabel
onready var world = get_parent().get_node("World")
onready var players = get_parent().get_node("Players")


func _ready():
	get_tree().connect("network_peer_connected", self, "_on_player_connected")
	get_tree().connect("network_peer_disconnected", self, "_on_player_disconnected")
	get_tree().connect("connected_to_server", self, "_on_connected_to_server")

	server_ip.text = Network.ip_address
	device_ip_label.text = Network.ip_address


func _on_player_connected(id: int) -> void:
	print("Player connected: " + str(id))
	if Network.pid == 1:
		print("updating")
		update_players()


func _on_player_disconnected(id: int) -> void:
	print("Player disconnected: " + str(id))
	despawn_player(id)


func _on_connected_to_server() -> void:
	print("Connected to server")


func _on_CreateButton_pressed() -> void:
	multiplayer_config_ui.hide()
	Network.create_server()
	spawn_player(1)


func _on_JoinButton_pressed() -> void:
	print("hello")
	if server_ip.text != "":
		Network.ip_address = server_ip.text
		Network.join_server()
		spawn_player(Network.pid)
		multiplayer_config_ui.hide()
		


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
