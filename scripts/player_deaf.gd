# deaf player
extends PlayerMovement

func _physics_process(delta: float) -> void:
	process_movement()
	move_and_slide()
	
