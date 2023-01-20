# warning-ignore-all:return_value_discarded
extends Node

const DEFAULT_PORT = 12345
const MAX_CLIENTS = 6

var server = null
var client = null
var ip_address = ""
var pid = 1


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
	
	get_tree().connect("connected_to_server", self, "_on_connected_to_server")
	get_tree().connect("server_disconnected", self, "_on_server_disconnected")


func create_server() -> void:
	server = NetworkedMultiplayerENet.new()
	server.create_server(DEFAULT_PORT, MAX_CLIENTS)
	pid = 1
	get_tree().set_network_peer(server)


func join_server() -> bool:
	client = NetworkedMultiplayerENet.new()
	var error = client.create_client(ip_address, DEFAULT_PORT)
	# TODO check to ensure a server exists
	if error:
		print("No Server Found. Try creating one.")
		return false
	get_tree().set_network_peer(client)
	pid = get_tree().get_network_unique_id()
	return true


func is_server() -> bool:
	return pid == 1


func _on_connected_to_server() -> void:
	print("Connected to server")


func _on_server_disconnected() -> void:
	print("Disconnected from server")
