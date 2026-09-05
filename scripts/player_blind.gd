# blind player
extends PlayerMovement

@onready var hand_position: Marker2D = $HandPosition

enum State { MOVE, HOLD, CHOP, STIR}
var state = State.MOVE

func _physics_process(delta: float) -> void:
	process_movement()
	update_action_sprite()
	pickup_object()
	move_and_slide()
	update_vision()

func update_action_sprite() -> void:
	match state:
		State.MOVE:
			pass
		State.HOLD:
			pass
		State.CHOP:
			pass
		State.STIR:
			pass

func update_vision() -> void:
	pass # for the blind thing

func pickup_object() -> void:
	if is_in_range:
		if Input.is_action_just_pressed("interact"):
			target_object.reparent(hand_position)
			target_object.position = hand_position.position
			

func _on_vision_area_area_entered(area: Area2D) -> void:
	if area is Pickable:
		is_in_range = true
		target_object = area


func _on_vision_area_area_exited(area: Area2D) -> void:
	if area is Pickable:
		is_in_range = false
		target_object = null
