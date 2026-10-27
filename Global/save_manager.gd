extends Node

const SLOTS : Array[String] = [
	"save_01", "save_02", "save_03"
]

var current_slot : int = 0
var save_data : Dictionary
var discovered_areas : Array = []
var persistent_data : Dictionary = {}

func _ready() -> void:
	SceneManager.scene_entered.connect(_on_scene_entered)


func _unhandled_key_input(event: InputEvent) -> void:
	if event is InputEventKey and event.pressed:
		if event.keycode == KEY_F7:
			load_game(current_slot) 
		elif event.keycode == KEY_1:
			current_slot = 0 
		elif event.keycode == KEY_2:
			current_slot = 1
		elif event.keycode == KEY_3:
			current_slot = 2


func create_new_game_save(slot: int) -> void:
	var new_game_scene : String = "uid://b36xnd7vbmdp7"
	current_slot = slot
	
	persistent_data.clear()
	discovered_areas.clear()
	discovered_areas.append(new_game_scene)

	save_data = {
		"discovered_areas" : discovered_areas,
		"player": {
			"hp" : 20,
			"max_hp" : 20,
			"position" : {
				"x": 112.0,
				"y": 230.0,
			},
			"abilities" : {
				"dash" : false,
				"double_jump" : false,
				"ground_slam" : false,
				"morph_roll" : false,
			},
			
		},
		"persistent_data" : persistent_data,
		"scene_path" : new_game_scene,
	}

	var save_file = FileAccess.open(get_file_name(current_slot), FileAccess.WRITE)
	save_file.store_line(JSON.stringify(save_data))
	save_file.close()
	load_game(current_slot)


func save_game() -> void:
	var player : Player = get_tree().get_first_node_in_group("Player")
	save_data = {
		"discovered_areas" : discovered_areas,
		"player": {
			"hp" : player.hp,
			"max_hp" : player.max_hp,
			"position" : {
				"x": player.global_position.x,
				"y": player.global_position.y,
			},
			"abilities" : player.abilities,
		},
		"persistent_data" : persistent_data,
		"scene_path" : SceneManager.current_scene_uid,
	}

	var save_file = FileAccess.open(get_file_name(current_slot), FileAccess.WRITE)
	save_file.store_line(JSON.stringify(save_data))

func load_game(slot: int) -> void:
	current_slot = slot
	if not FileAccess.file_exists(get_file_name(current_slot)):
		return
	var save_file = FileAccess.open(get_file_name(current_slot), FileAccess.READ)
	save_data = JSON.parse_string(save_file.get_line())
	
	persistent_data = save_data.get("persistent_data", {})
	discovered_areas = save_data.get("discovered_areas", [])
	var scene_path : String = save_data.get("scene_path", "uid://b36xnd7vbmdp7")
	SceneManager.transition_scene(scene_path, "", Vector2.ZERO, "up")
	await SceneManager.new_scene_ready
	setup_player()

func setup_player() -> void:
	var player : Player = null
	var player_save_data : Dictionary = save_data.get("player", {})

	while not player:
		player = get_tree().get_first_node_in_group("Player")
		await get_tree().process_frame
		
	player.max_hp = player_save_data.get("max_hp", 20.0)
	player.hp = player_save_data.get("hp", 20.0)
	player.global_position = Vector2(
		player_save_data.get("position", {}).get("x", 0.0),
		player_save_data.get("position", {}).get("y", 0.0)
	)
	player.abilities = player_save_data.get("abilities", {})

func get_file_name(slot: int) -> String:
	return "user://" + SLOTS[slot] + ".sav"



func save_file_exists(slot: int) -> bool:
	return FileAccess.file_exists(get_file_name(slot))


func is_area_discovered(scene_uid: String) -> bool:
	return discovered_areas.has(scene_uid)


func _on_scene_entered( scene_uid: String ) -> void:
	if discovered_areas.has(scene_uid):
		return
	else:
		discovered_areas.append(scene_uid)
