class_name PlayerStateCrouch extends PlayerState

var decel_rate := 10.0

func init() -> void:
	pass

func enter() -> void:
	player.collision_stand.disabled = true
	player.collision_crouch.disabled = false
	player.sprite.scale.y = 0.625
	player.sprite.position.y = -15.0
	
func exit() -> void:
	player.collision_stand.disabled = false
	player.collision_crouch.disabled = true
	player.sprite.scale.y = 1.0
	player.sprite.position.y = -24.0
	

func handle_input(event: InputEvent) -> PlayerState:
	if event.is_action_pressed("jump"):
		if player.one_way_platform_raycast.is_colliding():
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
