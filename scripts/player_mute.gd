# mute player
extends PlayerMovement

func _physics_process(delta: float) -> void:
	process_movement()
	move_and_slide()

func update_gesture_sprite() -> void:
	pass
