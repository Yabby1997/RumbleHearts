extends CharacterBody2D

func _physics_process(delta: float) -> void:
	var horizontal := Input.get_axis("ui_left", "ui_right")
	if horizontal:
		velocity.x = horizontal * 300
	else:
		velocity.x = move_toward(velocity.x, 0, 300)
		
	var vertical := Input.get_axis("ui_up", "ui_down")
	if vertical:
		velocity.y = vertical * 300
	else:
		velocity.y = move_toward(velocity.y, 0, 300)

	move_and_slide()
