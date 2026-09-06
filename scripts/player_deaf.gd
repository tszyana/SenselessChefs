# deaf player
extends PlayerMovement

func _ready():
	# $RecipeButton.hide()
	print("auth user id: ", get_multiplayer_authority())
	

func _physics_process(delta: float) -> void:
	if not is_multiplayer_authority():
		return
	process_movement()
	move_and_slide()
	
