extends Control

@onready var nicknameEdit : LineEdit = $NicknameEdit

func _on_host_button_pressed() -> void:
	print("HOST BUTTON PRESSED")
	GameState.set_nickname(nicknameEdit.text)
	NetworkManager.host_game()
	get_tree().change_scene_to_file("res://scenes/lobby.tscn")
	
func _on_join_button_pressed() -> void:
	print("JOIN GAME BUTTON PRESSED")
	NetworkManager.join_game("172.16.137.228")
	get_tree().change_scene_to_file("res://scenes/lobby.tscn")
