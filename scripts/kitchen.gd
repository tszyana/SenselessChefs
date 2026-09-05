extends Node2D

@onready var game_timer = $Timer
@onready var time_label = $Control/TimerLabel
	
# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta) -> void:
	#pass
	time_label.text = "Time left:\n" + str(int(game_timer.time_left))
