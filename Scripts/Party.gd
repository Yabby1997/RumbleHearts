extends Node2D

@export var characters: Array[PackedScene]
var character_nodes: Array[Node2D] = []

func _ready() -> void:
	for character in characters:
		var character_node = character.instantiate()
		add_child(character_node)
		character_nodes.append(character_node)
		character_node.connect("speed_change", _on_character_speed_change)
	update_flag_speed()
	
	for character_node in character_nodes:
		var random_speed = randf_range(100, 150)
		character_node.speed = random_speed
	update_flag_speed()
	
func update_flag_speed():
	var min_speed = 150
	for character_node in character_nodes:
		if character_node.speed < min_speed:
			min_speed = character_node.speed
	for character_node in character_nodes:
		character_node.updateFlagSpeed(min_speed)
	$Flag.speed = min_speed

func _on_flag_move(position: Vector2) -> void:
	for index in character_nodes.size():
		var character_node = character_nodes[index]
		var new_position = position
		new_position.x += 15 * index
		if character_node.has_method("move"):
			character_node.move(new_position)
			
func _on_character_speed_change(new_speed: float):
	update_flag_speed()
