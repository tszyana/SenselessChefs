# blind player
extends PlayerMovement

enum State { MOVE, HOLD, CHOP, STIR}
var state = State.MOVE

func _physics_process(delta: float) -> void:
	if state == State.MOVE:
		process_movement()
	else:
		velocity = Vector2.ZERO
		update_action_sprite()
	
	move_and_slide()
	update_vision()

func update_action_sprite() -> void:
	match state:
		State.HOLD:
			pass
		State.CHOP:
			pass
		State.STIR:
			pass

func update_vision() -> void:
	pass
