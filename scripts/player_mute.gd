# mute player
extends PlayerMovement

enum State { POINT, HAPPY, MAD, ONE, TWO, THREE, FOUR, NEUTRAL }
var state = State.NEUTRAL

func _ready():
	VoiceChat.mic_enabled = false
	# $RecipeButton.show()
	pass

func _physics_process(delta: float) -> void:
	process_movement()
	move_and_slide()
	update_gesture_sprite()
	
func _process(delta):
	if Input.is_action_just_pressed("num1"):
		state = State.ONE
	if Input.is_action_just_pressed("num2"):
		state = State.TWO
	if Input.is_action_just_pressed("num3"):
		state = State.THREE
	if Input.is_action_just_pressed("num4"):
		state = State.FOUR
	if Input.is_action_just_pressed("point"):
		state = State.POINT
	if Input.is_action_just_pressed("happy"):
		state = State.HAPPY
	if Input.is_action_just_pressed("mad"):
		state = State.MAD
	if Input.is_action_just_pressed("neutral"):
		state = State.NEUTRAL

func update_gesture_sprite() -> void:
	match state:
		State.POINT:
			#$Sprite2D.texture = preload("res://scenes/Images/pointing.jpeg")
			pass
		State.HAPPY:
			#$Sprite2D.texture = preload("res://scenes/Images/happy.jpeg")
			pass
		State.MAD:
			#$Sprite2D.texture = preload("res://scenes/Images/mad.jpeg")
			pass
		State.ONE:
			#$Sprite2D.texture = preload("res://scenes/Images/one.jpeg")
			pass
		State.TWO:
			#$Sprite2D.texture = preload("res://scenes/Images/two.png")
			pass
		State.THREE:
			#$Sprite2D.texture = preload("res://scenes/Images/spider3.jpg")
			pass
		State.FOUR:
			#$Sprite2D.texture = preload("res://scenes/Images/four.png")
			pass
		State.NEUTRAL:
			#$Sprite2D.texture = preload("res://scenes/Images/neutral.jpeg")
			pass
