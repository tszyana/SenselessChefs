extends Control

@onready var player_list: VBoxContainer = $PlayerList
var is_ready := false
var players_ready := {}

func _ready() -> void:
	multiplayer.peer_connected.connect(_on_peer_connected)
	multiplayer.peer_disconnected.connect(_on_peer_disconnected)
	
	players_ready[multiplayer.get_unique_id()] = false

	update_player_list()

func _on_peer_connected(id: int) -> void:
	print("Player connected: ", id)
	update_player_list()

func _on_peer_disconnected(id: int) -> void:
	print("Player disconnected: ", id)
	update_player_list()

func update_player_list() -> void:
	for child in player_list.get_children():
		child.queue_free()

	var players := multiplayer.get_peers()

	# Add ourselves
	add_player_to_list(multiplayer.get_unique_id())

	# Add everyone else
	for id in players:
		add_player_to_list(id)

func add_player_to_list(id: int) -> void:
	var label := Label.new()
	label.text = "Player " + str(id)

	if id == multiplayer.get_unique_id():
		label.text += " (You)"
		
		if players_ready.get(id, false):
			label.text += " - READY"
		else:
			label.text += " - NOT READY"

	player_list.add_child(label)


func _on_ready_button_pressed() -> void:
	is_ready = !is_ready
	players_ready[multiplayer.get_unique_id()] = is_ready

	if is_ready:
		$ReadyButton.text = "Unready"
	else:
		$ReadyButton.text = "Ready"

	update_player_list()
	set_ready.rpc(multiplayer.get_unique_id(), is_ready)
	
	
@rpc("any_peer", "call_local", "reliable", 0)
func set_ready(player_id: int, ready: bool):
	players_ready[player_id] = ready
	update_player_list()
	
