class_name PlayerMovement
extends CharacterBody2D

@onready var sprite: Sprite2D = $Sprite2D
@export var movement_sprite: Texture2D

const SPEED = 500.0
var can_move := true
var is_in_range: bool = false
var target_object: Node2D

# processes arrow keys for movement
func process_movement() -> void:
	if not can_move:
		velocity = Vector2.ZERO
		return

	# Get the input direction and handle the movement/deceleration.
	# As good practice, you should replace UI actions with custom gameplay actions.
	var direction := Input.get_vector("left", "right", "up", "down")
	
	velocity = direction * SPEED
	
	update_movement_sprite(direction)

# updates sprite to match movement
func update_movement_sprite(dir: Vector2) -> void:
	if dir.x != 0:
		sprite.flip_h = dir.x < 0 
		
