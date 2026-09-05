# blind player
extends PlayerMovement

@onready var hand_position: Marker2D = $HandPosition
@onready var kitchen: Node2D = $"../.."

enum State { MOVE, HOLD, CHOP, STIR}
var state = State.MOVE
var carrying_item: bool = false

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
	if Input.is_action_just_pressed("pickup"):
		if carrying_item:
			drop_item()
		elif is_in_range and target_object:
			target_object.reparent(hand_position)
			target_object.position = Vector2.ZERO
			carrying_item = true
			is_in_range = false
			

func drop_item() -> void:
	var dropped_position = global_position
	target_object.reparent(kitchen)
	target_object.global_position = dropped_position
	carrying_item = false
	

func _on_vision_area_area_entered(area: Area2D) -> void:
	if area is Pickable:
		is_in_range = true
		target_object = area


func _on_vision_area_area_exited(area: Area2D) -> void:
	if area is Pickable and not carrying_item:
		is_in_range = false
		target_object = null
