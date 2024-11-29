extends CharacterBody2D

@export var speed: float = 100
var move_to_flag: bool = false
var move_to_click_position: bool = false

var is_dragging: bool = false
var drop_position: Vector2 = Vector2.ZERO

func _ready() -> void:
	var flag = get_parent().get_node("Flag") as CharacterBody2D
	flag.connect("flag_move", on_flag_move)

func _unhandled_input(event: InputEvent) -> void:
	if event is InputEventMouseButton:
		if event.pressed and event.button_index == MOUSE_BUTTON_LEFT:
			if global_transform.origin.distance_to(get_global_mouse_position()) < 50:
				is_dragging = true
				move_to_flag = false
		elif not event.pressed and event.button_index == MOUSE_BUTTON_LEFT:
			if is_dragging:
				is_dragging = false
				move_to_flag = false
				drop_position = get_global_mouse_position()

func _physics_process(delta: float) -> void:
	if move_to_flag:
		var flag = get_parent().get_node("Flag") as CharacterBody2D
		var target_position = flag.global_position
		global_transform.origin = global_transform.origin.move_toward(target_position, speed * delta)
	elif drop_position != Vector2.ZERO:
		global_transform.origin = global_transform.origin.move_toward(drop_position, speed * delta)
		if global_transform.origin.distance_to(drop_position) < 1:
			drop_position = Vector2.ZERO

func on_flag_move():
	move_to_flag = true
	is_dragging = false
	drop_position = Vector2.ZERO
