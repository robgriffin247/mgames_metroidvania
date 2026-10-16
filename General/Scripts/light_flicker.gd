class_name FlickeringTorch extends AnimatedSprite2D

@export_range(0.0, 2.0) var speed := 1.0
@export_range(0.0, 2.0) var flicker_intensity := 0.3
@export_range(0.0, 1.0) var flicker_frequency := 0.1
var current_energy := 1.0

@onready var point_light_2d: PointLight2D = $PointLight2D

func _ready() -> void:
	frame = randi_range(0, sprite_frames.get_frame_count(animation)-1)
	speed_scale = speed * randf_range(0.9, 1.1)
	current_energy = point_light_2d.energy
	flicker()

func flicker() -> void:
	var new_value : float = randf_range(-1, 1) * flicker_intensity 
	point_light_2d.energy = new_value + current_energy
	await get_tree().create_timer(flicker_frequency + randf_range(flicker_frequency * -0.3, flicker_frequency * 0.3)).timeout
	flicker()	
