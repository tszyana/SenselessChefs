extends Control


@onready var player_list: VBoxContainer = $VBoxContainer/PlayerList
@onready var start_button: Button = $StartButton

var is_ready := false

func _ready() -> void:
	multiplayer.peer_connected.connect(_on_peer_connected)
	multiplayer.peer_disconnected.connect(_on_peer_disconnected)
	
	if multiplayer.is_server():
		GameState.add_player(multiplayer.get_unique_id(), GameState.player_info)
		GameState.set_player_role(multiplayer.get_unique_id())

		update_player_list()
	
	# Only let the host press the start button
	start_button.disabled = not multiplayer.is_server()

func _on_peer_connected(id: int) -> void:
	print("Player connected: ", id)
	if multiplayer.is_server():
		GameState.add_player(id, GameState.player_info)
		GameState.set_player_role(id)
		sync_player_states.rpc(GameState.player_states)


func _on_peer_disconnected(id: int) -> void:
	print("Player disconnected: ", id)
	if multiplayer.is_server():
		GameState.remove_player(id)
		sync_player_states.rpc(GameState.player_states)


func update_player_list() -> void:
	for child in player_list.get_children():
		child.queue_free()

	var players := multiplayer.get_peers()

	# Add ourselves
	add_player_to_list(multiplayer.get_unique_id(), GameState.get_nickname())

	# Add everyone else
	for id in players:
		add_player_to_list(id, GameState.player_states[id]["nickname"])

func add_player_to_list(id: int, name: String) -> void:
	var label : Label
	
	print("Player states: ", GameState.player_states)
	print("Looking for ID: ", id)
	if GameState.player_states[id]["role"] == GameState.Role.BLIND:
		label = $BlindLabel
		
	elif GameState.player_states[id]["role"] == GameState.Role.DEAF:
		label = $DeafLabel
		
	elif GameState.player_states[id]["role"] == GameState.Role.MUTE:
		label = $MuteLabel
		
	label.text = name

	if id == multiplayer.get_unique_id():
		label.text += " (You)"
		
	if GameState.player_states[id]["ready"]:
		label.text += " - READY"
	else:
		label.text += " - NOT READY"



func _on_ready_button_pressed() -> void:

	is_ready = !is_ready
	#GameState.player_states[multiplayer.get_unique_id()] = is_ready

	if multiplayer.is_server():
		GameState.player_states[multiplayer.get_unique_id()]["ready"] = is_ready
		update_player_list()
		sync_ready_states.rpc(GameState.player_states)
	else:
		set_ready_on_server.rpc_id(1, is_ready)
		
# Returns true if all players are ready
func all_players_ready() -> bool:
	for id in multiplayer.get_peers():
		if not GameState.player_states[id]["ready"]:
			return false

	if not GameState.player_states[multiplayer.get_unique_id()]["ready"]:
		return false

	return true
	
func _on_start_button_pressed() -> void:
	if not multiplayer.is_server():
		return
	
	if not all_players_ready():
		print("Waiting for everyone to ready...")
		return
		
	#if GameState.player_order.size() != 3:
		#print("3 Players needed")
		#return
		
	NetworkManager.start_game.rpc()
	


@rpc("authority", "call_local", "reliable")
func sync_ready_states(states: Dictionary) -> void:
	GameState.player_states = states
	update_player_list()
	
@rpc("authority", "reliable", "call_local")
func sync_player_states(states: Dictionary, order: Array) -> void:
	GameState.player_states = states
	GameState.player_order = order
	update_player_list()
	
@rpc("any_peer", "reliable")
func set_ready_on_server(ready: bool) -> void:
	if not multiplayer.is_server():
		return

	var player_id := multiplayer.get_remote_sender_id()

	GameState.player_states[player_id]["ready"] = ready

	update_player_list()
	sync_ready_states.rpc(GameState.player_states)
	


func _on_back_button_pressed() -> void:
	get_tree().change_scene_to_file("res://scenes/main_menu.tscn")
