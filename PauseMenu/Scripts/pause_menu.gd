class_name PauseMenu extends CanvasLayer

var player : Player

#region /// on ready variables
@onready var pause_screen: Control = %PauseScreen
@onready var system_screen: Control = %SystemScreen
@onready var system_menu_button: Button = %SystemMenuButton
@onready var back_to_map_button: Button = %BackToMapButton
@onready var back_to_title_button: Button = %BackToTitleButton
@onready var music_slider: HSlider = %MusicSlider
@onready var sfx_slider: HSlider = %SFXSlider
@onready var ui_slider: HSlider = %UISlider
#endregion

func _ready() -> void:
	player = get_tree().get_first_node_in_group("Player")
	show_pause_screen()
	system_menu_button.pressed.connect(show_system_screen)
	setup_system_screen()

func _unhandled_input(event: InputEvent) -> void:
	if pause_screen.visible and (event.is_action_pressed("right") or event.is_action_pressed("down")):
		system_menu_button.grab_focus()
	
	if event.is_action_pressed("pause"):
		get_viewport().set_input_as_handled()
		get_tree().paused = false
		queue_free()

func show_pause_screen() -> void:
	pause_screen.visible = true
	system_screen.visible = false

func show_system_screen() -> void:
	back_to_map_button.grab_focus()
	pause_screen.visible = false
	system_screen.visible = true

func setup_system_screen() -> void:
	back_to_map_button.pressed.connect(show_pause_screen)
	back_to_title_button.pressed.connect(_on_back_to_title_button_pressed)
	
func _on_back_to_title_button_pressed() -> void:
	get_tree().paused = false
	MessageBus.return_to_title_screen.emit()
	queue_free()
	SceneManager.transition_scene("uid://dah2f0n5ko78", "", Vector2.ZERO, "up")
		
