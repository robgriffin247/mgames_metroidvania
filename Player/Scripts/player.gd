class_name Player extends CharacterBody2D

#region /// State machine variables
var states : Array[PlayerState]
var current_state : PlayerState :
	get: return states[0]
var previous_state : PlayerState :
	get: return states[1]		
#endregion

#region //// Standard variables
var direction := Vector2.ZERO
var gravity := get_gravity().y
#endregion


func _ready() -> void:
	initialise_states()
	pass

func _process(delta: float) -> void:
	update_direction()
	change_state(current_state.process(delta))

func _physics_process(delta: float) -> void:
	velocity.y += get_gravity().y * delta
	move_and_slide()
	change_state(current_state.physics_process(delta))

func _unhandled_input(event: InputEvent) -> void:
	change_state(current_state.handle_input(event))

func initialise_states() -> void:
	states = []

	# gather
	for child in $States.get_children():
		if child is PlayerState:
			states.append(child)
	if states.size()==0:
		return
	
	# initialise
	for state in states:
		state.init()

	# set current
	change_state(current_state)
	current_state.enter()
	pass

func change_state(new_state : PlayerState) -> void:
	if new_state==null or new_state==current_state:
		return
	if current_state:
		current_state.exit()
	
	states.push_front(new_state)
	current_state.enter()	
	states.resize(3)


func update_direction() -> void:
	# var previous_direction : Vector2 = direction
	var x_axis := Input.get_axis("left", "right")
	var y_axis := Input.get_axis("up", "down")
	direction = Vector2(x_axis, y_axis)
	
