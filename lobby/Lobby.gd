extends Control


onready var multiplayer_config_ui = $MultiplayerConfig
onready var server_ip = $MultiplayerConfig/V/V/ServerIP
onready var device_ip_label = $MultiplayerConfig/V/V2/DeviceIPLabel


func _ready():
	get_tree().connect("network_peer_connected", self, "_on_player_connected")
	get_tree().connect("network_peer_disconnected", self, "_on_player_disconnected")
	get_tree().connect("connected_to_server", self, "_on_connected_to_server")

	server_ip.text = Network.ip_address
	device_ip_label.text = Network.ip_address


func _on_player_connected(id: int) -> void:
	print("Player connected: " + str(id))


func _on_player_disconnected(id: int) -> void:
	print("Player disconnected: " + str(id))


func _on_connected_to_server() -> void:
	print("Connected to server")


func _on_CreateButton_pressed() -> void:
	multiplayer_config_ui.hide()
	Network.create_server()


func _on_JoinButton_pressed() -> void:
	if server_ip.text != "":
		multiplayer_config_ui.hide()
		Network.ip_address = server_ip.text
		Network.join_server()
