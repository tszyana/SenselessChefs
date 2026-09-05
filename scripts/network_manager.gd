extends Node

const PORT := 9999
const MAX_PLAYERS := 3

var peer := ENetMultiplayerPeer.new()


func host_game() -> void:
	var error := peer.create_server(PORT, MAX_PLAYERS)

	if error != OK:
		print("Failed to create server: ", error)
		return

	multiplayer.multiplayer_peer = peer

	print("Server started on port ", PORT)


func join_game(ip_address: String) -> void:
	var error := peer.create_client(ip_address, PORT)

	if error != OK:
		print("Failed to connect: ", error)
		return

	multiplayer.multiplayer_peer = peer

	print("Connecting to ", ip_address, ":", PORT)
