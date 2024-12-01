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
		character_node.speed = randf_range(100, 150)
	
func update_flag_speed():
	var min_character_speed: float = 150
	for character_node in character_nodes:
		if character_node.speed < min_character_speed:
			min_character_speed = character_node.speed
	$Flag.speed = min_character_speed
	print(min_character_speed)

func _on_flag_move(position: Vector2) -> void:
	for index in character_nodes.size():
		var character_node = character_nodes[index]
		var new_position = position
		new_position.x += 30 * index
		if character_node.has_method("move"):
			character_node.move(new_position, $Flag.speed)
			
func _on_character_speed_change(new_speed: float):
	update_flag_speed()
