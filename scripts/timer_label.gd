extends Label

#@onready var game_timer = $GameTimer
#@onready var time_label = $CanvasLayer/TimeLabel

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	#time_label.text = "Time: " + str(ceil(game_timer.time_left))
	pass
	
	
