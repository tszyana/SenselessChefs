extends Node2D

@onready var interactable: Area2D = $Interactable

var chopping = false
@export var chop_time := 2.0

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	interactable.interact = _on_interact

func _on_interact():
	# if player is holding object
	print("Object in oven!") # placeholder
	interactable.is_interactable = false

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass
