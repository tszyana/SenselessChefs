extends Node2D

@onready var interactable: Area2D = $Interactable


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	interactable.interact = _on_interact

func _on_interact():
	var player = get_tree().get_first_node_in_group("player_blind")
	
	if not player.carrying_item:
		#print("Nothing to throw u dummy")
		player.message_bubble.show_message()
		return
	else:
		#print("Tossing into da trash")
		# get the pickable thing and delete it
		var item = player.remove_item()
		item.queue_free()
