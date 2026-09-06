extends Node2D

@onready var interactable: Area2D = $Interactable
@onready var progress_bar: ProgressBar = $ProgressBar
@onready var drop_point: Marker2D = $DropPoint

@export var stir_time := 2.0

var ingredients := []
const COMBOS = {
	"melted_butter": ["butter"],
	"filled_bowl": ["melted_butter", "flour", "water"]
}
var current_combo_index := 0
var current_ingredient_index := 0

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	interactable.interact = _on_interact
	progress_bar.hide()

func _on_interact():
	var player = get_tree().get_first_node_in_group("player_blind")
	
	if current_combo_index >= COMBOS.size():
		#print("All recipes are completed")
		player.message_bubble.show_message()
		return
		

	
	if not player.carrying_item:
		#print("Not holding anything u dummy")
		player.message_bubble.show_message()
		return
	
	var item = player.remove_item()	
	
	# get current recipe
	var combo = COMBOS.values()[current_combo_index]
	var expected_ingredient = combo[current_ingredient_index]
	
	# wrong ingredient
	if item.item_name != expected_ingredient:		
		make_trash(item)
		#print("Wrong ingredient doofus")
		return
	
	# if correct, then move item to chopping board
	item.reparent(self)
	item.position = Vector2.ZERO
	ingredients.append(item)
	
	current_ingredient_index += 1
	
	# update progress bar
	progress_bar.max_value = combo.size()
	progress_bar.value = current_ingredient_index
	progress_bar.show()
		
	# recipe is complete!
	if current_ingredient_index >= combo.size():
		player.can_move = false
		interactable.is_interactable = false
		
		#print("Stirring", item.item_name) # placeholder for sprite change??
		player.state = player.State.STIR
		await get_tree().create_timer(stir_time).timeout
		
		var result_name = COMBOS.keys()[current_combo_index]
		make_result(result_name)
		#print("Completed")
		
		current_combo_index += 1
		current_ingredient_index = 0
		progress_bar.hide()
		
		player.can_move = true
		if player.carrying_item:
			player.state = player.State.HOLD
		else:
			player.state = player.State.MOVE
		
		interactable.is_interactable = true
	
func make_trash(item: Pickable) -> void:
	item.item_name = "trash"
	item.update_sprite()
	
	item.reparent(get_parent())
	item.position = drop_point.global_position
	
func make_result(result_name: String):
	var result_item: Pickable = ingredients[0]	
	
	for i in range(1, ingredients.size()):
		ingredients[i].queue_free()
	
	result_item.item_name = result_name
	result_item.update_sprite()
	
	result_item.reparent(get_parent())
	result_item.global_position = drop_point.global_position
	
	ingredients.clear()
	ingredients.append(result_item)
