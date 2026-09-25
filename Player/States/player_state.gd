@icon("res://Assets/state.svg")
class_name PlayerState extends Node

var player : Player
var next_state : PlayerState

#region /// state references
@onready var idle: PlayerStateIdle = %Idle
@onready var run: PlayerStateRun = %Run
#endregion

func init() -> void:
	"""
	What happens when the state is initialised
	"""
	pass

func enter() -> void:
	"""
	What happens when the state is entered
	- play animations
	"""
	pass	
	
func exit() -> void:
	"""
	What happens when the state is exited
	"""
	pass
	

func handle_input(event: InputEvent) -> PlayerState:
	"""
	What happens when an input is given
	- do we need to change state?
	"""
	return next_state


func process(_delta: float) -> PlayerState:
	"""
	What happens each process tick while in this state
	"""
	return next_state
	
	
func physics_process(_delta: float) -> PlayerState:
	"""
	What happens each physics tick while in this state
	"""
	return next_state
