class_name Switch extends Node2D

signal activated

const DOOR_SWITCH_AUDIO = preload("uid://w4ap1r5nxbfx")
var is_open : bool = false

@onready var sprite_2d: Sprite2D = $Sprite2D
@onready var area_2d: Area2D = $Area2D

func _ready() -> void:
	if SaveManager.persistent_data.get_or_add(unique_name(), false) == true:
		is_open = true
		set_open()
	else:
		area_2d.body_entered.connect(_on_body_entered)
		area_2d.body_exited.connect(_on_body_exited)
		
	return


func _on_body_entered(_body: Node2D) -> void:
	MessageBus.input_hint_changed.emit("interact")
	MessageBus.player_interacted.connect(_on_player_interacted)

func _on_body_exited(_body: Node2D) -> void:
	MessageBus.input_hint_changed.emit("")
	MessageBus.player_interacted.disconnect(_on_player_interacted)

func _on_player_interacted(_player: Player) -> void:
	SaveManager.persistent_data[unique_name()] = true
	activated.emit()
	set_open()
	return

func set_open() -> void:
	sprite_2d.flip_h = true
	sprite_2d.modulate = Color.DARK_GRAY
	area_2d.queue_free()
	return

func unique_name() -> String:
	var u_name : String = ResourceUID.path_to_uid(owner.scene_file_path)
	u_name += "/" + get_parent().name + "/" + name
	return u_name
