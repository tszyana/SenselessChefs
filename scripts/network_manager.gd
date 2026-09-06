extends Node

signal player_connected(peer_id, player_info)
signal player_disconnected(peer_id)
signal server_disconnected

const PORT := 9999
const MAX_PLAYERS := 3
const DEFAULT_SERVER_IP = "172.16.137.228" # IPv4 localhost

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
	
	player_connected.emit(1, GameState.player_info)


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
	
func _on_server_disconnected() -> void:
	remove_multiplayer_peer()
	GameState.player_states.clear()
	server_disconnected.emit()
	
func remove_multiplayer_peer():
	multiplayer.multiplayer_peer = OfflineMultiplayerPeer.new()
	GameState.player_states.clear()
	
@rpc("any_peer", "call_local", "reliable")
func start_game() -> void:
	get_tree().change_scene_to_file("res://scenes/kitchen.tscn")

## Every peer will call this when they have loaded the game scene.
#@rpc("any_peer", "call_local", "reliable")
#func player_loaded():
	#if multiplayer.is_server():
		#GameState.players_loaded += 1
		#if GameState.players_loaded == GameState.player_order.size():
			#start_game()
			#GameState.players_loaded = 0
				
@rpc("any_peer", "unreliable")
func send_voice_data(audio_data: PackedByteArray) -> void:
	if not multiplayer.is_server():
		return
		
	var sender_id := multiplayer.get_remote_sender_id()
	
	print(
		"SERVER RECEIVED voice from Player ",
		sender_id,
		": ",
		audio_data.size(),
		" bytes"
	)
	
	# Host plays the client's voice locally.
	var samples := VoiceChat.pcm_to_audio_samples(audio_data)
	VoiceChat.play_voice_samples(samples)
	
	relay_voice_data(sender_id, audio_data)

			
			
@rpc("authority", "unreliable")
func receive_voice_data(sender_id: int, audio_data: PackedByteArray) -> void:
	print(
		"Received voice data from Player ",
		sender_id,
		": ",
		audio_data.size(),
		" bytes"
	)
	
	var samples :PackedFloat32Array = VoiceChat.pcm_to_audio_samples(audio_data)
	#print("Converted to ", samples.size(), " audio samples")
	VoiceChat.play_voice_samples(samples)
	
	
	
func relay_voice_data(sender_id: int, audio_data: PackedByteArray) -> void:
	print(
		"Relaying voice from Player ",
		sender_id,
		": ",
		audio_data.size(),
		" bytes"
	)

	for peer_id in multiplayer.get_peers():
		if peer_id != sender_id:
			print("Sending voice to Player ", peer_id)
			receive_voice_data.rpc_id(peer_id, sender_id, audio_data)
	
@rpc("any_peer", "call_local", "reliable")
func request_nickname() -> String:
	return GameState.get_nickname()		
			
