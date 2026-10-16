@icon("res://Player/Sprites/player_spawn.svg")
class_name PlayerSpawn extends Node2D

func _ready() -> void:
	visible = false
	await get_tree().process_frame
	if get_tree().get_first_node_in_group("Player"):
		return
	var player : Player = load("uid://b0yr1gxchtey1").instantiate()
	get_tree().root.add_child(player)
	player.position = self.global_position
