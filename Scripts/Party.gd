extends CharacterBody2D

@export var speed: float = 100:
	set(value):
		speed = value
		update_camera_smoothing(speed)
		
func _ready() -> void:
	update_camera_smoothing(speed)

func _physics_process(delta: float) -> void:
	var horizontal := Input.get_axis("ui_left", "ui_right")
	if horizontal:
		velocity.x = move_toward(velocity.x, horizontal * speed, speed)
	else:
		velocity.x = move_toward(velocity.x, 0, speed)
		
	var vertical := Input.get_axis("ui_up", "ui_down")
	if vertical:
		velocity.y = move_toward(velocity.y, vertical * speed, speed)
	else:
		velocity.y = move_toward(velocity.y, 0, speed)

	move_and_slide()

func _on_world_enter_new_world(width: Variant, height: Variant) -> void:
	$Camera2D.limit_top = 0
	$Camera2D.limit_left = 0
	$Camera2D.limit_bottom = height
	$Camera2D.limit_right = width

func update_camera_smoothing(newSpeed):
	if not has_node("Camera2D"):
		return
	$Camera2D.position_smoothing_speed = 3 + speed / 100
