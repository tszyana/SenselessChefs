extends Control

@onready var player_list: VBoxContainer = $PlayerList

func _ready() -> void:
	multiplayer.peer_connected.connect(_on_peer_connected)
	multiplayer.peer_disconnected.connect(_on_peer_disconnected)

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

	player_list.add_child(label)
