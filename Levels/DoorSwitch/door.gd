@tool
class_name Door extends Node2D

const DOOR_CRASH_AUDIO = preload("uid://oclxvp3idi4")

@onready var animation_player: AnimationPlayer = $AnimationPlayer

func _ready() -> void:
	if Engine.is_editor_hint():
		return
	for child in get_children():
		if child is Switch:
			child.activated.connect(_on_switch_activated)
			if child.is_open:
				_on_switch_is_open()
	return

func _on_switch_activated() -> void:
	animation_player.play("open")
	return

func _on_switch_is_open() -> void:
	animation_player.play("opened")
	return

func _get_configuration_warnings() -> PackedStringArray:
	if _check_for_switch():
		return []
	return ["Requires a switch node."]


func _check_for_switch() -> bool:
	for child in get_children():
		if child is Switch:
			return true
	return false
