class_name Player extends CharacterBody2D

func _process(_delta: float) -> void:
	pass

func _physics_process(delta: float) -> void:
	velocity.x = 100.0 * Input.get_axis("left", "right")
	velocity.y += get_gravity().y * delta
	move_and_slide()
