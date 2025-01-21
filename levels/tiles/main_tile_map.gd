class_name LevelMainTileMap
extends TileMapLayer


## Returns the cell coordinates of the cell at a global position
func get_cell_at_global(global_pos: Vector2) -> Vector2i:
	return local_to_map(to_local(global_pos))
