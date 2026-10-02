class_name PlayerStateFall extends PlayerState

var coyote_time := 0.08
var coyote_timer := 0.0
var fall_gravity_multiplier := 1.165 # Make this small to make low-gravity

var jump_buffer_time := 0.08 # Allows jump to work if pressed just before leaving fall state
var jump_buffer_timer := 0.0

func init() -> void:
	pass

func enter() -> void:
	# play animation
	player.gravity_multiplier = fall_gravity_multiplier
	if player.previous_state==jump:
		coyote_timer = 0.0
	else:
		coyote_timer = coyote_time
	player.add_debug_indicator(Color.YELLOW)

	
func exit() -> void:
	player.gravity_multiplier = 1.0

	

	
func handle_input(event: InputEvent) -> PlayerState:
	if event.is_action_pressed("jump"):
		if coyote_timer >= 0:
			return jump
		else:
			jump_buffer_timer = jump_buffer_time 
	return next_state


func process(delta: float) -> PlayerState:
	coyote_timer -= delta
	jump_buffer_timer -= delta
	return next_state
	
	
func physics_process(_delta: float) -> PlayerState:
	if player.is_on_floor():
		player.add_debug_indicator(Color.RED)
		if jump_buffer_timer >= 0:
			return jump
		return idle
	player.velocity.x = player.direction.x * player.run_speed
	return next_state
