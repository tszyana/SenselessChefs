# deaf player
extends PlayerMovement

func _ready():
	# $RecipeButton.hide()
	VoiceChat.sound_enabled = false
	pass
	

func _physics_process(delta: float) -> void:
	process_movement()
	move_and_slide()
	
