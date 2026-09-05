extends Control


func _on_host_button_pressed() -> void:
	print("HOST BUTTON PRESSED")
	NetworkManager.host_game()
	
func _on_join_button_pressed() -> void:
	print("JOIN GAME BUTTON PRESSED")
	NetworkManager.join_game("192.168.1.88")
