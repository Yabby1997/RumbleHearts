extends Node2D

@export var characters: Array[PackedScene]
		
func _ready() -> void:
	for character in characters:
		var character_node = character.instantiate()
		add_child(character_node)
