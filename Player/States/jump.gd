class_name PlayerStateJump extends PlayerState

var jump_velocity := 450.0

func init() -> void:
	pass

func enter() -> void:
	player.animation_player.play("jump")
	player.velocity.y = -jump_velocity
	player.add_debug_indicator(Color.GREEN)

	
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
	return next_state
	
	
func physics_process(_delta: float) -> PlayerState:
	if player.is_on_floor():
		return idle
	elif player.velocity.y >= 0:
		return fall
	player.velocity.x = player.direction.x * player.run_speed
	return next_state
