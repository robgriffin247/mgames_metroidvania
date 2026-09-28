# Player State Machine

A player can only ever be in one state and state is determined by inputs and from user and the game.

```
---- <- on_ground() & input.get_axis("left", "right") == 0.0 ----
IDLE                                                         WALK
---- -> on_ground() & input.get_axis("left", "right") != 0.0 ----
```

``PlayerState`` is a blueprint class inherited by states; it is not attached to any nodes itself.
	- Contains references to all the states and the player
	- ``init()``: what happens when the state is initialised
	- ``enter()``: what happens when the state is entered, e.g. play animations, modify gravity
	- ``exit()``: what happens when the state is exited, e.g. modify gravity
	- ``handle_input()``: do we need to change state on input? what occurs while in the state? e.g. y velocity on jump
	- ``process()``:  do we need to change state at process tick? what occurs while in the state? e.g. set coyote/buffer timers in fall
	- ``physics_process()``: do we need to change state at physics tick? what occurs while in the state? e.g. left/right movement within jump
- ``player`` initialises, tracks and changes state
- Each state is then a node under ``Player`` (I orgnaise under a States node)
- Each state node has script and class extending ``PlayerState``
	- States set out rules for switching between, e.g.
	```
	func handle_input(event: InputEvent) -> PlayerState:
		if event.is_action_pressed("jump"):
			return jump
		return next_state
	```
	- States define player attributes during state:
		
func handle_input(event: InputEvent) -> PlayerState:
	```
	func handle_input(event: InputEvent) -> PlayerState:
		# Variable height jump; if jump released before peak, slow player and enter fall
		if event.is_action_released("jump"):
			player.velocity.y *= 0.65
			if player.velocity.y >= 0:
				return fall		
		return next_state
	```
