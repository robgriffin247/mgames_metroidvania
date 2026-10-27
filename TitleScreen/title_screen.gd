class_name TitleScreen extends CanvasLayer

#region /// onready
@onready var main_menu: VBoxContainer = %MainMenu
@onready var new_game_menu: VBoxContainer = %NewGameMenu
@onready var load_game_menu: VBoxContainer = %LoadGameMenu
@onready var animation_player: AnimationPlayer = $Control/MainMenu/Logo/AnimationPlayer
#endregion

#region /// onready buttons
@onready var new_game_button: Button = %NewGameButton
@onready var load_game_button: Button = %LoadGameButton
@onready var new_slot_1_button: Button = %NewSlot1
@onready var new_slot_2_button: Button = %NewSlot2
@onready var new_slot_3_button: Button = %NewSlot3
@onready var load_slot_1_button: Button = %LoadSlot1
@onready var load_slot_2_button: Button = %LoadSlot2
@onready var load_slot_3_button: Button = %LoadSlot3
#endregion

func _ready() -> void:
	new_game_button.pressed.connect(show_new_game_menu)
	load_game_button.pressed.connect(show_load_game_menu)
	show_main_menu()
	animation_player.animation_finished.connect(on_animation_finished)
	new_slot_1_button.pressed.connect(on_new_game_pressed.bind(0))
	new_slot_2_button.pressed.connect(on_new_game_pressed.bind(1))
	new_slot_3_button.pressed.connect(on_new_game_pressed.bind(2))
	load_slot_1_button.pressed.connect(on_load_game_pressed.bind(0))
	load_slot_2_button.pressed.connect(on_load_game_pressed.bind(1))
	load_slot_3_button.pressed.connect(on_load_game_pressed.bind(2))


func show_main_menu() -> void:
	main_menu.visible = true
	new_game_menu.visible = false
	load_game_menu.visible = false
	new_game_button.grab_focus()


func on_animation_finished(anim_name: String) -> void:
	if anim_name == "start":
		animation_player.play("loop")


func show_new_game_menu() -> void:
	main_menu.visible = false
	new_game_menu.visible = true
	load_game_menu.visible = false
	new_slot_1_button.grab_focus()
	
	if SaveManager.save_file_exists(0):
		new_slot_1_button.text = "Replace Slot 1"
	if SaveManager.save_file_exists(1):
		new_slot_2_button.text = "Replace Slot 2"
	if SaveManager.save_file_exists(2):
		new_slot_3_button.text = "Replace Slot 3"


func show_load_game_menu() -> void:
	main_menu.visible = false
	new_game_menu.visible = false
	load_game_menu.visible = true
	load_slot_1_button.grab_focus()

	load_slot_1_button.disabled = false if SaveManager.save_file_exists(0) else true
	load_slot_2_button.disabled = false if SaveManager.save_file_exists(1) else true
	load_slot_3_button.disabled = false if SaveManager.save_file_exists(2) else true


func on_new_game_pressed(slot:int) -> void:
	SaveManager.create_new_game_save(slot)


func on_load_game_pressed(slot:int) -> void:
	SaveManager.load_game(slot)
