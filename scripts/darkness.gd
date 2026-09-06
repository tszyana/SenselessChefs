extends ColorRect

@export var radius_px: float = 120.0
@export var feather_px: float = 60.0

var player: Node2D

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	material.set_shader_parameter("radius_px", radius_px)
	material.set_shader_parameter("feather_px", feather_px)


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	if not player:
		return
	var cam := get_viewport().get_camera_2d()
	var screen_pos: Vector2
	if cam:
		screen_pos = cam.unproject_position(player.global_position)
	else:
		screen_pos = player.global_position
	material.set_shader_parameter("light_pos_px", screen_pos)
