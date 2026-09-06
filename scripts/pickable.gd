extends Area2D
class_name Pickable

@export var item_name: String = "":
	set(value):
		item_name = value
		if is_inside_tree():
			update_sprite()

@onready var sprite_2d: Sprite2D = $Sprite2D

func update_sprite():
	match item_name:
		"apple": 
			sprite_2d.texture = preload("res://scenes/Images/Kitchen/Foodness/Apple.png")
		"banana": 
			sprite_2d.texture = preload("res://scenes/Images/Kitchen/Foodness/Banana.png")
		"water": 
			sprite_2d.texture = preload("res://scenes/Images/Kitchen/Foodness/Brita water.png")
		"butter": 
			sprite_2d.texture = preload("res://scenes/Images/Kitchen/Foodness/Butter.png")
		"cut_apples": 
			sprite_2d.texture = preload("res://scenes/Images/Kitchen/Foodness/Cut apples.png")
		"egg": 
			sprite_2d.texture = preload("res://scenes/Images/Kitchen/Foodness/Egg.png")
		"empty_bowl": 
			sprite_2d.texture = preload("res://scenes/Images/Kitchen/Foodness/Empty bowl_.png")
		"flour": 
			sprite_2d.texture = preload("res://scenes/Images/Kitchen/Foodness/Flour.png")
		"pastry": 
			sprite_2d.texture = preload("res://scenes/Images/Kitchen/Foodness/Pastry.png")
		"potato": 
			sprite_2d.texture = preload("res://scenes/Images/Kitchen/Foodness/Potato food.png")
		"salt": 
			sprite_2d.texture = preload("res://scenes/Images/Kitchen/Foodness/Salt.png")
		"sugar": 
			sprite_2d.texture = preload("res://scenes/Images/Kitchen/Foodness/Sugar.png")
		"melted_butter": 
			sprite_2d.texture = preload("res://scenes/Images/Kitchen/Foodness/Used pot.png")
		"filled_bowl": 
			sprite_2d.texture = preload("res://scenes/Images/Kitchen/Foodness/Filled bowl.png")
		"apple_pie": 
			sprite_2d.texture = preload("res://scenes/Images/Kitchen/Foodness/Low res apple pie….png")
		"trash": 
			sprite_2d.texture = preload("res://scenes/Images/Kitchen/Foodness/Censored food.png")
