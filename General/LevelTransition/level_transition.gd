@tool
@icon("res://General/LevelTransition/level_transition.svg")
class_name LevelTransition extends Node2D


enum SIDE { LEFT, RIGHT, TOP, BOTTOM }

@export_range(2, 16, 1, "or_greater") var size := 2 :
	set( value ) : 
		size = value
		apply_area_settings()

@export var location : SIDE = SIDE.LEFT :
	set( value ) :
		location = value
		apply_area_settings()

@export_file("*.tscn") var target_scene := ""
@export var target_area_name := "LevelTransition"

@onready var area_2d: Area2D = $Area2D


func _ready() -> void:
	if Engine.is_editor_hint():
		return
	SceneManager.new_scene_ready.connect(_on_new_scene_ready)
	SceneManager.load_scene_finished.connect(_on_load_scene_finished)


func on_player_entered(node: Node2D) -> void:
	SceneManager.transition_scene(target_scene, target_area_name, get_offset(node), get_transition_direction())
	return

func _on_new_scene_ready(target_name: String, offset: Vector2) -> void:
	if target_name == name:
		var player : Node = get_tree().get_first_node_in_group("Player")
		player.global_position = global_position + offset


func _on_load_scene_finished() -> void:
	area_2d.monitoring = false
	area_2d.body_entered.connect(on_player_entered)
	await get_tree().physics_frame
	await get_tree().physics_frame
	area_2d.monitoring = true

func apply_area_settings() -> void:
	area_2d = get_node_or_null("Area2D")
	if not area_2d:
		return
	if location == SIDE.LEFT or location == SIDE.RIGHT:
		area_2d.scale.y = size
		if location == SIDE.LEFT:
			area_2d.scale.x = -1
		else:
			area_2d.scale.x = 1
	else:
		area_2d.scale.x = size
		if location == SIDE.TOP:
			area_2d.scale.y = 1
		else:
			area_2d.scale.y = -1
	return


func get_offset(player: Node2D) -> Vector2:
	var offset := Vector2.ZERO
	var player_pos := player.global_position
	if location == SIDE.LEFT or location == SIDE.RIGHT:
		offset.x = -16 if location == SIDE.LEFT else 16
		offset.y = player_pos.y - global_position.y
	else:
		offset.y = -14 if location == SIDE.TOP else 62
		offset.x = player_pos.x - global_position.x
	return offset


func get_transition_direction() -> String:
	match location:
		SIDE.LEFT:
			return "left"
		SIDE.RIGHT:
			return "right"
		SIDE.TOP:
			return "up"
		SIDE.BOTTOM:
			return "down"
		_:
			return "left"
