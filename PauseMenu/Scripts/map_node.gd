@tool
@icon("res://PauseMenu/map_node.svg")
class_name MapNode extends Control

const SCALE_FACTOR := 40.0

const NODE_COLOURS := {
	"forest":Color.FOREST_GREEN,
	"dungeon":Color.DARK_SLATE_GRAY,
	"save":Color.DEEP_PINK,
}

@onready var label: Label = $Label
@onready var transition_blocks: Control = $TransitionBlocks

@export_file("*.tscn") var linked_scene : String : set = _on_scene_set
@export_tool_button("Update") var update_node_action : Callable = update_node

@export var entrances_top : Array[float] = []
@export var entrances_right : Array[float] = []
@export var entrances_bottom : Array[float] = []
@export var entrances_left : Array[float] = []

var indicator_offset := Vector2.ZERO


func _ready() -> void:
	if Engine.is_editor_hint():
		pass
	else:
		label.queue_free()
		create_transition_blocks()
		if not SaveManager.is_area_discovered(linked_scene):
			visible = false
		elif SceneManager.current_scene_uid == linked_scene:
			display_player_location()
			
		

func _on_scene_set(value : String) -> void:
	if linked_scene != value:
		linked_scene = value
		if Engine.is_editor_hint():
			update_node()
			

func update_node() -> void:
	"""
	This function will only want to be run in the editor by pressing the update node export var button
	"""
	var new_size := Vector2(480, 270)
	var transitions : Array[LevelTransition] = []
	var world := ""
	var new_color := Color.WHITE
	
	if ResourceLoader.exists(linked_scene):
		var packed_scene = ResourceLoader.load(linked_scene) as PackedScene
		if packed_scene:
			var instance = packed_scene.instantiate()
			if instance:
				for c in instance.get_children():
					if c is LevelBounds:

						update_node_label(instance)
						
						world = packed_scene.resource_path
						world = world.replace("res://Levels/Scenes/", "").split("/")[0].split("_")[1].replace(".tscn", "").to_lower()
						new_color = NODE_COLOURS[ world ]
						
						new_size = Vector2(c.width, c.height)
						
						indicator_offset = c.position
						
					elif c is LevelTransition:
						transitions.append(c)
						
				instance.queue_free()	

	size = (new_size / SCALE_FACTOR).round()
	modulate = new_color
	
	create_entrance_data(transitions)
	create_transition_blocks()
	
func update_node_label(scene: Node) -> void:
	if not label:
		label = $Label
	var t : String = scene.scene_file_path
	t = t.replace("res://Levels/Scenes/", "")
	t = t.replace(".tscn", "")
	label.text = t

func create_entrance_data(transitions: Array[LevelTransition]) -> void:
	entrances_left.clear()
	entrances_right.clear()
	entrances_top.clear()
	entrances_bottom.clear()

	for t in transitions:
		var pos : Vector2 = ( t.position - indicator_offset ) / SCALE_FACTOR
		if t.location == LevelTransition.SIDE.LEFT:
			var offset : float = clampf(pos.y-3, 2.0, self.size.y - 4.0)
			entrances_left.append(offset)
			
		elif t.location == LevelTransition.SIDE.RIGHT:
			var offset : float = clampf(pos.y-3, 2.0, self.size.y - 4.0)
			entrances_right.append(offset)
			
		elif t.location == LevelTransition.SIDE.TOP:
			var offset : float = clampf(pos.x-3, 2.0, self.size.x - 4.0)
			entrances_top.append(offset)
	
		elif t.location == LevelTransition.SIDE.BOTTOM:
			var offset : float = clampf(pos.x-3, 2.0, self.size.x - 4.0)
			entrances_bottom.append(offset)
	
func create_transition_blocks() -> void:
	if not transition_blocks:
		transition_blocks = %TransitionBlocks
	
	for c in transition_blocks.get_children():
		c.queue_free()
	
	for t in entrances_left:
		var block : ColorRect = add_block()
		block.size.y = 3
		block.position.x = 0
		block.position.y = t
	
	for t in entrances_right:
		var block : ColorRect = add_block()
		block.size.y = 3
		block.position.x = self.size.x - 1
		block.position.y = t	
		
	for t in entrances_top:
		var block : ColorRect = add_block()
		block.size.x = 3
		block.position.x = t
		block.position.y = 0		
		
	for t in entrances_bottom:
		var block : ColorRect = add_block()
		block.size.x = 3
		block.position.x = t
		block.position.y = self.size.y - 1
		

func add_block() -> ColorRect:
	var block : ColorRect = ColorRect.new()
	transition_blocks.add_child(block)
	block.custom_minimum_size.x = 1
	block.custom_minimum_size.y = 1
	return block
	
	
func display_player_location() -> void:
	var player : Player = get_tree().get_first_node_in_group("Player")
	var indicator : Control = %PlayerIndicator
	var _position : Vector2 = position
	_position += ((player.global_position - indicator_offset) / SCALE_FACTOR)
	var _clamp : Vector2 = Vector2(2,2)
	_position = _position.clamp(position + _clamp, position + size - _clamp)
	indicator.position = _position
	pass
	
	
