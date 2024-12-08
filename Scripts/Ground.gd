extends TileMapLayer

@onready var ground_object: TileMapLayer = $"../GroundObject"

func _use_tile_data_runtime_update(coords: Vector2i) -> bool:
	return coords in ground_object.get_used_cells_by_id(0)
	
func _tile_data_runtime_update(coords: Vector2i, tile_data: TileData) -> void:
	tile_data.set_navigation_polygon(0, null)
