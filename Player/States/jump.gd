class_name PlayerStateJump extends PlayerState

var jump_velocity := 450.0

func init() -> void:
	pass

func enter() -> void:
	player.animation_player.play("jump")
	player.animation_player.pause()
	player.velocity.y = -jump_velocity
	#player.add_debug_indicator(Color.GREEN)
	
	if player.previous_state == fall and not Input.is_action_pressed("jump"):
		await get_tree().physics_frame
		player.velocity.y *= 0.65
		player.change_state(fall)

func exit() -> void:
	pass
	

func handle_input(event: InputEvent) -> PlayerState:
	# Variable height jump; if jump released before peak, slow player and enter fall
	if event.is_action_released("jump"):
		player.velocity.y *= 0.65
		if player.velocity.y >= 0:
			return fall		
	return next_state


func process(_delta: float) -> PlayerState:
	_set_jump_frame()
	return next_state
	
	
func physics_process(_delta: float) -> PlayerState:
	if player.is_on_floor():
		return idle
	elif player.velocity.y >= 0:
		return fall
	player.velocity.x = player.direction.x * player.run_speed
	return next_state


func _set_jump_frame() -> void:
	var frame : float = remap(player.velocity.y, jump_velocity, 0.0, 0.0, 0.5)
	player.animation_player.seek(frame, true)
	return
