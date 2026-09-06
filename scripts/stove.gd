extends Node2D

@onready var interactable: Area2D = $Interactable
@onready var progress_bar: ProgressBar = $ProgressBar
@onready var drop_point: Marker2D = $DropPoint

@export var stir_time := 2.0

var ingredients := []
const COMBOS = {
	"melted_butter": ["flour", "egg", "salt"],
	"cut_apples": ["apple"]
}

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	interactable.interact = _on_interact

func _on_interact():
	var player = get_tree().get_first_node_in_group("player_blind")
	var item = player.get_item()
	
	if not player.carrying_item:
		print("Not holding anything u dummy")
		return
	
	
	print("Stirring...")
	player.can_move = false
	
	interactable.is_interactable = false
	
	await get_tree().create_timer(stir_time).timeout
	
	print("Finished chopping!")
	player.can_move = true
	interactable.is_interactable = true
