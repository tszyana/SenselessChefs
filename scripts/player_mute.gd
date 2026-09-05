# mute player
extends PlayerMovement

enum State { POINT, HAPPY, MAD, ONE, TWO, THREE, FOUR }
var state = null

func _physics_process(delta: float) -> void:
	process_movement()
	move_and_slide()
	update_gesture_sprite()

func update_gesture_sprite() -> void:
	match state:
		State.POINT:
			pass
		State.HAPPY:
			pass
		State.MAD:
			pass
		State.ONE:
			pass
		State.TWO:
			pass
		State.THREE:
			pass
		State.FOUR:
			pass
