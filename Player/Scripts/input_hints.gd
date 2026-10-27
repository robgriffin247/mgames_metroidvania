@icon("uid://40h85avw7rp6")
class_name InputHints extends Node2D

enum ICONS {
	TRIANGLE,   # 0
	CROSS,      # 1
	SQUARE,     # 2
	CIRCLE,     # 3
	DPAD,       # 4
	A,          # 5
	B,          # 6
	X,          # 7
	Y,          # 8
	KEY_Z,      # 9
	KEY_X,      # 10
	KEY_C,      # 11
	KEY_S,      # 12
	KEY_ARROW,  # 13
	KEY_ESC,    # 14
	KEY_E,      # 15
}

const HINT_MAP : Dictionary = {
	"keyboard" : {
		"jump" : ICONS.KEY_Z,
		"attack" : ICONS.KEY_X,
		"dash" : ICONS.KEY_C,
		"interact" : ICONS.KEY_S,
		"up" : ICONS.KEY_ARROW,
	},
	"nintendo" : {
		"jump" : ICONS.X,
		"attack" : ICONS.Y,
		"dash" : ICONS.A,
		"interact" : ICONS.B,
		"up" : ICONS.DPAD,
	},
	"playstation" : {
		"jump" : ICONS.TRIANGLE,
		"attack" : ICONS.SQUARE,
		"dash" : ICONS.CIRCLE,
		"interact" : ICONS.CROSS,
		"up" : ICONS.DPAD,
	},
	"xbox" : {
		"jump" : ICONS.Y,
		"attack" : ICONS.X,
		"dash" : ICONS.B,
		"interact" : ICONS.A,
		"up" : ICONS.DPAD,
	},
	"unknown" : {
		"jump" : ICONS.KEY_Z,
		"attack" : ICONS.KEY_X,
		"dash" : ICONS.KEY_C,
		"interact" : ICONS.KEY_S,
		"up" : ICONS.KEY_ARROW,
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

	
func get_controller_type(device_id: int) -> void:
	var device_name : String = Input.get_joy_name(device_id).to_lower()
	
	if "xbox" in device_name:
		controller_type = "xbox"
	elif "switch" in device_name or "nintendo" in device_name:
		controller_type = "nintendo"
	elif "ps" in device_name or "playstation" in device_name or "dualsense" in device_name:
		controller_type = "playstation"
	else:
		controller_type = "unknown"

	set_process_input(false)
