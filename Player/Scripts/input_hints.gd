@icon("uid://40h85avw7rp6")
class_name InputHints extends Node2D

const HINT_MAP : Dictionary = {
	"keyboard" : {
		"jump" : 9,
		"attack" : 10,
		"dash" : 11,
		"interact" : 12,
		"up" : 13,
	},
	"switch" : {
		"jump" : 6,
		"attack" : 8,
		"dash" : 5,
		"interact" : 7,
		"up" : 4,
	},
	"playstation" : {
		"jump" : 1,
		"attack" : 2,
		"dash" : 3,
		"interact" : 0,
		"up" : 4,
	},
	"xbox" : {
		"jump" : 5,
		"attack" : 7,
		"dash" : 6,
		"interact" : 8,
		"up" : 4,
	},
}

var controller_type : String = "keyboard"

@onready var sprite_2d: Sprite2D = $Sprite2D
@onready var animation_player: AnimationPlayer = $AnimationPlayer

func _ready() -> void:
	visible = false
	MessageBus.input_hint_changed.connect(_on_hint_change)

func _on_hint_change(hint: String) -> void:
	# Signals can still fire while the scene tree is being torn down (e.g. on quit)
	if not is_inside_tree():
		return
	if hint=="":
		animation_player.play("out")
		await get_tree().create_timer(0.1).timeout
		if is_inside_tree():
			visible = false
	else:
		visible = true
		sprite_2d.frame = HINT_MAP[controller_type].get(hint, 1)
		animation_player.play("in")
	

func _input( event: InputEvent ) -> void:
	if event is InputEventMouseButton or event is InputEventKey:
		controller_type = "keyboard"
	elif event is InputEventJoypadButton:
		get_controller_type(event.device)
	set_process_input(false)

func get_controller_type(device_id: int) -> void:
	var device_name : String = Input.get_joy_name(device_id).to_lower()
	
	if "xbox" in device_name:
		controller_type = "xbox"
	elif "switch" in device_name or "nintendo" in device_name:
		controller_type = "switch"
	elif "ps" in device_name or "playstation" in device_name or "dualsense" in device_name:
		controller_type = "playstation"
	else:
		controller_type = "unknown"
