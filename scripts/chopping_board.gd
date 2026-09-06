extends Node2D

@onready var interactable: Area2D = $Interactable

@export var chop_time := 1.5

var ingredients = []
const COMBOS = {
	"chopped_apple": ["apple"],
	"dough": ["flour", "egg", "salt"]
}

var current_combo_index := 0
var current_ingredient_index := 0

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	interactable.interact = _on_interact

func _on_interact():
	# if player is holding object??
	var player = get_tree().get_first_node_in_group("player_blind")
	
	if not player.carrying_item:
		print("Not holding anything u dummy")
		return
	
	var item = player.remove_item()	
	
	# get current recipe
	var combo = COMBOS.values()[current_combo_index]
	var expected_ingredient = combo[current_ingredient_index]
	
	if item.item_name != expected_ingredient:
		item.reparent(self)
		item.position = Vector2.ZERO
		make_result(item, "trash")
		return
	
	# if correct, then move item to chopping board
	item.reparent(self)
	item.position = Vector2.ZERO
	
	ingredients.append(item.item_name)
		
	player.can_move = false
	interactable.is_interactable = false
	
	print("Chopping", item.item_name) # placeholder for sprite change??
	
	await get_tree().create_timer(chop_time).timeout
		
	check_recipe(item)
	
	player.can_move = true
	interactable.is_interactable = true
	
func check_recipe(item: Pickable):
	var names = ingredients.duplicate()
	names.sort()
	
	for result in COMBOS:
		var recipe = COMBOS[result].duplicate()
		recipe.sort()
		
		if names == recipe:
			make_result(item, result)
			return
	if ingredients.size() >= 3:
		make_result(item, "trash")
		
func make_result(item: Pickable, result_name: String):
	item.item_name = result_name
	item.get_node("Sprite2D").texture = null
	
	for ingredient in get_children():
		if ingredient is Pickable and ingredient != item:
			ingredient.queue_free()
	
	ingredients.clear()
	ingredients.append(result_name)
