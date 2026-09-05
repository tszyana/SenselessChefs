extends CharacterBody2D


const SPEED = 300.0

enum State { MOVE, HOLD, CHOP, STIR}
var state = State.MOVE

func _physics_process(delta: float) -> void:
	process_movement()
	move_and_slide()

func process_movement() -> void:
	# Get the input direction and handle the movement/deceleration.
	# As good practice, you should replace UI actions with custom gameplay actions.
	var direction := Input.get_vector("left", "right", "up", "down")
	
	velocity = direction * SPEED
	
	update_sprite(direction)

func update_sprite(dir: Vector2) -> void:
	match state:
		State.MOVE:
			if dir.x != 0:
				pass # sprite.flip_h = dir.x < 0 to flip sprite left/right
			elif dir.y < 0: 
				pass # change sprite to up
			elif dir.y > 0:
				pass # change sprite
		State.HOLD:
			pass
		State.CHOP:
			pass
		State.STIR:
			pass
		
