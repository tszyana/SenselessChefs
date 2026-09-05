extends Node2D

@onready var interactable: Area2D = $Interactable

@export var bake_time := 2.0

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	interactable.interact = _on_interact

func _on_interact():
	var player = get_tree().get_first_node_in_group("player_blind")
	
	if not player.carrying_item:
		print("Not holding anything u dummy")
		return
	
	print("Baking...")
	player.can_move = false
	
	interactable.is_interactable = false
	
	await get_tree().create_timer(bake_time).timeout
	
	print("Done baking!")
	player.can_move = true
	interactable.is_interactable = true

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass
