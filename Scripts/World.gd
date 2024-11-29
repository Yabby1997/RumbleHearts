extends Node2D

@export var world_width = 400
@export var world_height = 700

signal enter_new_world(width, height)

func _ready() -> void:
	enter_new_world.emit(world_width, world_height)
	var party_scene = load("res://Scenes/Party.tscn")
	var party_instance = party_scene.instantiate()
	add_child(party_instance)
