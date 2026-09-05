extends Node2D

@onready var interactable: Area2D = $Interactable
@export var stir_time := 2.0

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	interactable.interact = _on_interact

func _on_interact():
	# if player is holding ingredient??
	print("Stirring...")
	var player = get_tree().get_first_node_in_group("player_blind")
	player.can_move = false
	
	interactable.is_interactable = false
	
	await get_tree().create_timer(stir_time).timeout
	
	print("Finished chopping!")
	player.can_move = true
	interactable.is_interactable = true
