extends Control

@onready var nicknameEdit : LineEdit = $NicknameEdit

func _on_host_button_pressed() -> void:
	print("HOST BUTTON PRESSED")
	GameState.set_nickname(nicknameEdit.text)
	NetworkManager.host_game()
	get_tree().change_scene_to_file("res://scenes/lobby.tscn")
	
func _on_join_button_pressed() -> void:
	print("JOIN GAME BUTTON PRESSED")
	GameState.set_nickname(nicknameEdit.text)
	NetworkManager.join_game(NetworkManager.DEFAULT_SERVER_IP)
	get_tree().change_scene_to_file("res://scenes/lobby.tscn")
