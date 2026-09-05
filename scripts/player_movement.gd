class_name PlayerMovement
extends CharacterBody2D


const SPEED = 300.0

# processes arrow keys for movement
func process_movement() -> void:
	# Get the input direction and handle the movement/deceleration.
	# As good practice, you should replace UI actions with custom gameplay actions.
	var direction := Input.get_vector("left", "right", "up", "down")
	
	velocity = direction * SPEED
	
	update_movement_sprite(direction)

# updates sprite to match movement
func update_movement_sprite(dir: Vector2) -> void:
	if dir.x != 0:
		pass # sprite.flip_h = dir.x < 0 to flip sprite left/right
	elif dir.y < 0: 
		pass # change sprite to up
	elif dir.y > 0:
		pass # change sprite
		
