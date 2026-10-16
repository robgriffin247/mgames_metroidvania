@icon("uid://c34sqnulr0p34")
class_name SavePoint extends Node2D

@onready var area_2d: Area2D = $Area2D
@onready var animation_player: AnimationPlayer = $Node2D/AnimationPlayer

func _ready() -> void:
	area_2d.body_entered.connect(_on_player_entered)
	area_2d.body_exited.connect(_on_player_exited)
	pass

func _process(_delta) -> void:
	pass

func _on_player_entered(_node: Node2D) -> void:
	MessageBus.player_interacted.connect(_on_player_interacted)

func _on_player_exited(_node: Node2D) -> void:
	MessageBus.player_interacted.disconnect(_on_player_interacted)


func _on_player_interacted(_player: Player) -> void:
	print("Yayyy")
