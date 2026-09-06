# blind player
extends PlayerMovement

@onready var hand_position: Marker2D = $HandPosition
@onready var kitchen: Node2D = $"../.."
@onready var sprite_2d: Sprite2D = $Sprite2D
@onready var message_bubble: MessageBubble = $MessageBubble

@export var holding_sprite: Texture2D
@export var chopping_sprite: Texture2D
@export var stirring_sprite: Texture2D
@export var oven_sprite: Texture2D

@onready var darkness: ColorRect = $BlindnessOverlay/Darkness
@onready var blindness_overlay: CanvasLayer = $BlindnessOverlay
@onready var blind_world: Sprite2D = $BlindWorld

enum State { MOVE, HOLD, CHOP, STIR, BAKE }
var state = State.MOVE
var carrying_item: bool = false
var held_item: Pickable = null
var user_id : int

func _physics_process(delta: float) -> void:
	if not is_multiplayer_authority():
		return
	if is_multiplayer_authority():
		darkness.player = self
		blindness_overlay.visible = true
		kitchen.visible = false
		blind_world.visible = true
	else:
		blindness_overlay.visible = false
	process_movement()
	update_action_sprite()
	pickup_object()
	move_and_slide()
	update_vision()

func update_action_sprite() -> void:
	match state:
		State.MOVE:
			sprite.texture = movement_sprite
		State.HOLD:
			sprite.texture = holding_sprite
		State.CHOP:
			sprite.texture = chopping_sprite
		State.STIR:
			sprite.texture = stirring_sprite
		State.BAKE:
			sprite.texture = oven_sprite

func get_item() -> Pickable:
	return held_item

func remove_item() -> Pickable:
	var item = held_item
	held_item = null
	carrying_item = false
	state = State.MOVE
	return item

func update_vision() -> void:
	pass # for the blind thing

func pickup_object() -> void:
	if Input.is_action_just_pressed("pickup"):
		print(
			"Pickup pressed | carrying = ",
			carrying_item,
			" | in_range = ",
			is_in_range,
			" | target = ",
			target_object
		)
		if carrying_item:
			drop_item()
		elif is_in_range and target_object:
			state = State.HOLD
			held_item = target_object
			held_item.reparent(hand_position)
			held_item.position = Vector2.ZERO
			carrying_item = true
			is_in_range = false
			

func drop_item() -> void:
	held_item.reparent(kitchen)
	held_item.global_position = global_position
	state = State.MOVE
	carrying_item = false
	held_item = null

func _on_vision_area_area_entered(area: Area2D) -> void:
	if area is Pickable:
		print("ENTERED: ", area.item_name)
		is_in_range = true
		target_object = area


func _on_vision_area_area_exited(area: Area2D) -> void:
	if area is Pickable and not carrying_item:
		print("EXITED: ", area.item_name)
		is_in_range = false
		target_object = null
		
func _ready():
	#$RecipeButton.hide()
	blind_world.global_position = kitchen.global_position
	print("auth user id: ", get_multiplayer_authority())
	

	
