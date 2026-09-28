class_name Player extends CharacterBody2D

const JUMP_INDICATOR = preload("uid://dkb3bgq33xpsd")

#region /// Exports
@export_range(1.0, 1000.0, 1.0) var run_speed := 150.0
#endregion

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
var gravity_multiplier := 1.0
#endregion


func _ready() -> void:
	initialise_states()
	pass

func _process(delta: float) -> void:
	update_direction()
	change_state(current_state.process(delta))

func _physics_process(delta: float) -> void:
	velocity.y += get_gravity().y * delta * gravity_multiplier
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
			child.player = self
	if states.size()==0:
		return
	
	# initialise
	for state in states:
		state.init()

	# set current
	change_state(current_state)
	current_state.enter()
	$Debugs/StateLabel.text = current_state.name
	pass

func change_state(new_state : PlayerState) -> void:
	if new_state==null:
		return
	if new_state==current_state:
		return
	if current_state:
		current_state.exit()
	
	states.push_front(new_state)
	current_state.enter()	
	$Debugs/StateLabel.text = current_state.name
	states.resize(3)


func update_direction() -> void:
	# var previous_direction : Vector2 = direction
	var x_axis := Input.get_axis("left", "right")
	var y_axis := Input.get_axis("up", "down")
	direction = Vector2(x_axis, y_axis)
	


func add_debug_indicator(color: Color = Color.RED) -> void:
	var d : Node2D = JUMP_INDICATOR.instantiate()
	get_tree().root.add_child(d)
	d.global_position = global_position
	d.modulate = color
	await get_tree().create_timer(3.0).timeout
	d.queue_free()
