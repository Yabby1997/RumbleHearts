extends CharacterBody2D

## Signals
signal speed_change(float)

## Nodes
@onready var navigation_agent_2d: NavigationAgent2D = $NavigationAgent2D
@onready var animated_sprite_2d: AnimatedSprite2D = $AnimatedSprite2D

## Properties
@export var speed: float = 100:
	set(new_speed):
		speed = new_speed
		speed_change.emit(new_speed)
	
var flag_speed: float = 100	
var is_dragging: bool = false
var move_position: Vector2 = Vector2.ZERO

func _ready() -> void:
	animated_sprite_2d.play("idle")

## Inputs
func _unhandled_input(event: InputEvent) -> void:
	if event is InputEventMouseButton and event.button_index == MOUSE_BUTTON_LEFT:
		if event.pressed and global_transform.origin.distance_to(get_global_mouse_position()) < 5:
			is_dragging = true
			navigation_agent_2d.path_postprocessing = 1
		elif not event.pressed and is_dragging:
			is_dragging = false
			move_position = get_global_mouse_position()

## Callbacks
func _physics_process(delta: float) -> void:
	if move_position != Vector2.ZERO:
		navigation_agent_2d.target_position = move_position
		if navigation_agent_2d.is_navigation_finished():
			is_dragging = false
			move_position = Vector2.ZERO
			return
		var direction = global_position.direction_to(navigation_agent_2d.get_next_path_position())
		if is_dragging:
			navigation_agent_2d.set_velocity(direction * speed)
		else:
			navigation_agent_2d.set_velocity(direction * flag_speed)
		move_and_slide()

## Methods
func move(position: Vector2):
	is_dragging = false
	navigation_agent_2d.path_postprocessing = 1
	move_position = position
	animated_sprite_2d.play("move")

func _on_navigation_agent_2d_velocity_computed(safe_velocity: Vector2) -> void:
	velocity = safe_velocity
