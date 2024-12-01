extends CharacterBody2D

signal speed_change(float)

@export var speed: float = 100:
	set(new_speed):
		speed = new_speed
		speed_change.emit(new_speed)
	
var flag_speed: float = 100	
var is_dragging: bool = false
var move_position: Vector2 = Vector2.ZERO

func _unhandled_input(event: InputEvent) -> void:
	if event is InputEventMouseButton and event.button_index == MOUSE_BUTTON_LEFT:
		if event.pressed and global_transform.origin.distance_to(get_global_mouse_position()) < 20:
			is_dragging = true
		elif not event.pressed and is_dragging:
			is_dragging = false
			move_position = get_global_mouse_position()

func _physics_process(delta: float) -> void:
	if move_position != Vector2.ZERO:
		$NavigationAgent2D.target_position = move_position
		if $NavigationAgent2D.is_navigation_finished():
			is_dragging = false
			move_position = Vector2.ZERO
			return
		var direction = global_position.direction_to($NavigationAgent2D.get_next_path_position())
		if is_dragging:
			$NavigationAgent2D.set_velocity(direction.normalized() * speed)
		else:
			$NavigationAgent2D.set_velocity(direction.normalized() * flag_speed)
		move_and_slide()

func move(position: Vector2, flag_speed: float):
	is_dragging = false
	flag_speed = flag_speed
	move_position = position

func _on_navigation_agent_2d_velocity_computed(safe_velocity: Vector2) -> void:
	velocity = safe_velocity
