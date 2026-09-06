extends Node2D

@onready var game_timer = $Timer
@onready var time_label = $Control/TimerLabel
@onready var timer_popup = $Control/TimerPopup
@onready var pause_popup = $Control/PausePanel
@onready var recipe_popup = $Control/RecipePanel
@onready var deaf = $Players/DeafPlayer
@onready var mute = $Players/MutePlayer
@onready var blind = $Players/BlindPlayer
	
# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	GameState.setup_characters(
		blind,
		deaf,
		mute
	)

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta) -> void:
	# Tells time
	time_label.text = "Time left:\n" + str(int(game_timer.time_left))

# Shows popup telling users timer ran out
func _on_timer_timeout() -> void:
	timer_popup.visible = true

#  Scene changes
func _on_main_menu_button_pressed() -> void:
	get_tree().change_scene_to_file("res://scenes/main_menu.tscn")
func _on_restart_button_pressed() -> void:
	get_tree().change_scene_to_file("res://scenes/kitchen.tscn")

# Pause button
func _on_pause_button_pressed() -> void:
	get_tree().paused = true
	pause_popup.visible = true
# Resume button
func _on_resume_button_pressed() -> void:
	get_tree().paused = false
	pause_popup.visible = false

# Recipe stuff
func _on_recipe_button_pressed() -> void:
	recipe_popup.visible = true
func _on_close_button_pressed() -> void:
	recipe_popup.visible = false


func _on_to_menu_pressed() -> void:
	get_tree().change_scene_to_file("res://scenes/main_menu.tscn")
