extends Area2D
class_name Pickable

@export var item_name: String = ""

@onready var sprite_2d: Sprite2D = $Sprite2D

func _ready():
	update_sprite()

func update_sprite():
	match item_name:
		"apple": 
			sprite_2d.texture = null # preload("res://food/apple.png")
		"trash": 
			sprite_2d.texture = preload("res://icon.svg")
