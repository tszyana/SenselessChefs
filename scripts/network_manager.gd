extends Node

const PORT := 9999
const MAX_PLAYERS := 3

var peer := ENetMultiplayerPeer.new()

func _ready() -> void:
	multiplayer.peer_connected.connect(_on_peer_connected)
	multiplayer.peer_disconnected.connect(_on_peer_disconnected)


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


func _on_peer_connected(id: int) -> void:
	print("Player connected: ", id)


func _on_peer_disconnected(id: int) -> void:
	print("Player disconnected: ", id)
	
@rpc("any_peer", "unreliable")
func send_voice_data(audio_data: PackedByteArray) -> void:
	var sender_id := multiplayer.get_remote_sender_id()

	print(
		"Received voice data from Player ",
		sender_id,
		": ",
		audio_data.size(),
	    " bytes"
	)
