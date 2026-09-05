extends Node2D

@onready var interactable: Area2D = $Interactable

@export var chop_time := 1.5

var ingredients = []

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	interactable.interact = _on_interact

func _on_interact():
	# if player is holding object??
	var player = get_tree().get_first_node_in_group("player_blind")
	var item = player.get_item()
	
	ingredients.append(item.item_name)
	
	if not player.carrying_item:
		print("Not holding anything u dummy")
		return
	
	print("Chopping...")
	player.can_move = false
	interactable.is_interactable = false
	
	if item and item.item_name == "apple":
		# chop apples
		pass
	else:
		pass
	
	await get_tree().create_timer(chop_time).timeout
	
	print("Finished chopping!")
	player.can_move = true
	interactable.is_interactable = true
	
