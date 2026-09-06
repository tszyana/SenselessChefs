extends Node

enum Role {
	BLIND,
	DEAF,
	MUTE
}

var player_states := {}
var nickname : String
var playerNum := 0

func _ready() -> void:
	print("GameState initialized!")
	

func add_player(player_id: int) -> void:
	player_states[player_id] = {
		"role": playerNum,
		"ready": false,
		"nickname": ""
	}
	
	print("Added player ", player_id)
	playerNum += 1
	
func remove_player(player_id: int) -> void:
	player_states.erase(player_id)

	print("GameState: Removed player ", player_id)
	
	if playerNum > 0:
		playerNum -= 1
	
func set_nickname(name: String) -> void:
	nickname = name
	
func get_nickname() -> String:
	if nickname != null:
		return nickname
	else:
		return ""
		

	
