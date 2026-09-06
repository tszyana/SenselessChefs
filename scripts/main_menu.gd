extends Control

@onready var serverEdit : LineEdit = $NicknameEdit

func _on_host_button_pressed() -> void:
	print("HOST BUTTON PRESSED")
	$Join_HostAudio.play()
	NetworkManager.host_game()
	get_tree().change_scene_to_file("res://scenes/lobby.tscn")
	
func _on_join_button_pressed() -> void:
	print("JOIN GAME BUTTON PRESSED")
	$Join_HostAudio.play()
	NetworkManager.join_game(serverEdit.text)
	get_tree().change_scene_to_file("res://scenes/lobby.tscn")
