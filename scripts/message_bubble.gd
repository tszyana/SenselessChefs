extends Node2D
class_name MessageBubble

@onready var sprite_2d: Sprite2D = $Sprite2D
@export var appear_time := 1.5


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	hide()


func show_message() -> void:
	show()
	await get_tree().create_timer(appear_time).timeout
	hide()
