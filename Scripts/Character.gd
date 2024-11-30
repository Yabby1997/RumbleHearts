extends CharacterBody2D

@export var speed: float = 100
var is_dragging: bool = false
var move_position: Vector2 = Vector2.ZERO

func _ready() -> void:
	var flag = get_parent().get_node("Flag") as CharacterBody2D
	flag.connect("flag_move", on_flag_move)

func _unhandled_input(event: InputEvent) -> void:
	if event is InputEventMouseButton and event.button_index == MOUSE_BUTTON_LEFT:
		if event.pressed and global_transform.origin.distance_to(get_global_mouse_position()) < 50:
			is_dragging = true
		elif not event.pressed and is_dragging:
			is_dragging = false
			move_position = get_global_mouse_position()

func _physics_process(delta: float) -> void:
	if move_position != Vector2.ZERO:
		$NavigationAgent2D.target_position = move_position
		var direction = global_position.direction_to($NavigationAgent2D.get_next_path_position())
		var new_velocity = direction.normalized() * speed
		if $NavigationAgent2D.is_navigation_finished():
			is_dragging = false
			move_position = Vector2.ZERO
			return
		$NavigationAgent2D.set_velocity(new_velocity)
		move_and_slide()

func on_flag_move(position: Vector2):
	is_dragging = false
	move_position = position

func _on_navigation_agent_2d_velocity_computed(safe_velocity: Vector2) -> void:
	velocity = safe_velocity
