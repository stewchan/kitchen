extends Node

const DEFAULT_PORT = 12345
const MAX_CLIENTS = 6

var server = null
var client = null
var ip_address = ""
var pid = 0


func _ready() -> void:
	if OS.get_name() == "Windows":
		ip_address = IP.get_local_addresses()[3]
	elif OS.get_name() == "Android":
		ip_address = IP.get_local_addresses()[0]
	else:
		ip_address = IP.get_local_addresses()[3]

	for ip in IP.get_local_addresses():
		if ip.begins_with("192.168.") and not ip.ends_with(".1"):
			ip_address = ip
			break
	
	get_tree().connect("connected_to_server", self, "on_connected_to_server")
	get_tree().connect("server_disconnected", self, "on_server_disconnected")


func create_server() -> void:
	server = NetworkedMultiplayerENet.new()
	server.create_server(DEFAULT_PORT, MAX_CLIENTS)
	pid = 1
	get_tree().set_network_peer(server)


func join_server() -> void:
	client = NetworkedMultiplayerENet.new()
	client.create_client(ip_address, DEFAULT_PORT)
	get_tree().set_network_peer(client)
	pid = get_tree().get_network_unique_id()


func _on_connected_to_server() -> void:
	print("Connected to server")


func _on_server_disconnected() -> void:
	print("Disconnected from server")