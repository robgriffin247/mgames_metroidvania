class_name PlayerStateCrouch extends PlayerState

var decel_rate := 10.0

func init() -> void:
	pass

func enter() -> void:
	player.collision_stand.disabled = true
	player.collision_crouch.disabled = false
	player.animation_player.play("crouch")

func exit() -> void:
	player.collision_stand.disabled = false
	player.collision_crouch.disabled = true
	

func handle_input(event: InputEvent) -> PlayerState:
	if event.is_action_pressed("jump"):
		player.one_way_platform_shape_cast.force_shapecast_update()
		if player.one_way_platform_shape_cast.is_colliding():
			player.position.y += 4
			return fall
		return jump
	return next_state


func process(_delta: float) -> PlayerState:
	if player.direction.y <= 0.5:
		return idle
	return next_state
	
	
func physics_process(delta: float) -> PlayerState:
	player.velocity.x -= player.velocity.x * decel_rate * delta
	if !player.is_on_floor():
		return fall
	return next_state
