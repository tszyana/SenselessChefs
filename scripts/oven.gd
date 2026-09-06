extends Node2D

@onready var interactable: Area2D = $Interactable
@onready var drop_point: Marker2D = $DropPoint
@onready var progress_bar: ProgressBar = $ProgressBar

@export var bake_time := 3.0
var ingredients := []
const COMBOS = {
	"apple_pie": ["filled_bowl", "cut_apples", "pastry"]
}
var current_combo_index := 0
var current_ingredient_index := 0

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	interactable.interact = _on_interact
	progress_bar.hide()

func _on_interact():
	if current_combo_index >= COMBOS.size():
		print("All recipes are completed")
		return
		
	# if player is holding object??
	var player = get_tree().get_first_node_in_group("player_blind")
	
	if not player.carrying_item:
		print("Not holding anything u dummy")
		return
	
	var item = player.remove_item()	
	
	# get current recipe
	var combo = COMBOS.values()[current_combo_index]
	var expected_ingredient = combo[current_ingredient_index]
	
	# wrong ingredient
	if item.item_name != expected_ingredient:		
		make_trash(item)
		print("Wrong ingredient doofus")
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
		
		print("Baking ", item.item_name) # placeholder for sprite change??
		await get_tree().create_timer(bake_time).timeout
		
		var result_name = COMBOS.keys()[current_combo_index]
		make_result(result_name)
		
		if result_name == "apple_pie":
			end_game()
		
		print("Completed")
		
		current_combo_index += 1
		current_ingredient_index = 0
		progress_bar.hide()
		
		player.can_move = true
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

func end_game() -> void:
	print("GAME COMPLETE")
	# show end screen... end_screen.show() or smth
