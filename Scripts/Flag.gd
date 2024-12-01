extends CharacterBody2D

signal flag_move(position: Vector2)

@export var speed: float = 100:
	set(value):
		speed = value
		#update_camera_smoothing(speed)
		
func _ready() -> void:
	update_camera_smoothing(speed)
	
func _physics_process(delta: float) -> void:
	var horizontal := Input.get_axis("ui_left", "ui_right")
	var vertical := Input.get_axis("ui_up", "ui_down")
	
	velocity = Vector2(horizontal, vertical) * speed
	
	if velocity.length() > speed:
		velocity = velocity.normalized() * speed
	
	if velocity != Vector2.ZERO:
		flag_move.emit(global_position)
	
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
