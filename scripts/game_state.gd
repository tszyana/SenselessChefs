extends Node

signal nickname_changed

enum Role {
	BLIND,
	DEAF,
	MUTE
}

var player_states := {}
var nickname : String = ""
var player_order := []
var sprite : CharacterBody2D
var player_info := {"role" : -1,
					"ready" : false,
					"nickname" : ""}
var players_loaded = 0

func _ready() -> void:
	print("GameState initialized!")
	nickname_changed.connect(_on_nickname_changed)
	

func add_player(player_id: int) -> void:
	player_states[player_id] = player_info
	
	player_order.append(player_id)
	
	print("Added player ", player_id)
	
func remove_player(player_id: int) -> void:
	player_states.erase(player_id)

	print("GameState: Removed player ", player_id)
	
		
func set_player_role(id: int) -> void:
	player_states[id]["role"] = player_order.find(id)
	
func set_nickname(name: String) -> void:
	nickname = name
	nickname_changed.emit()
	
func get_nickname() -> String:
	return nickname
		
func setup_characters(blind : CharacterBody2D, deaf : CharacterBody2D, mute : CharacterBody2D) -> void:
	var myId := multiplayer.get_unique_id()
	var myRole : int = player_states[myId]["role"]
	
	if myRole == Role.BLIND:
		sprite = blind
		print("im blind")
		
	elif myRole == Role.DEAF:
		sprite = deaf
		VoiceChat.sound_enabled = false

		print("im deaf")
	
	elif myRole == Role.MUTE:
		sprite = mute
		VoiceChat.mic_enabled = false

		print("im mute")
		
func _on_nickname_changed():
	player_info["nickname"] = nickname
	if nickname == "":
		player_info["nickname"] = "Player"
	
	

	
	
