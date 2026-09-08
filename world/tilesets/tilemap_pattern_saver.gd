@tool
class_name TileMapPatternSaver
extends TileMapLayer

@export var pattern_idx: int = 0
@export var export_name: String = "test"
@export_tool_button("Save Pattern") var save_pattern_button: Callable = save_pattern


func save_pattern() -> void:
	if pattern_idx >= tile_set.get_patterns_count():
		push_warning("Pattern IDX ", pattern_idx, " > ", tile_set.get_patterns_count())
		return
	
	var pattern: TileMapPattern = tile_set.get_pattern(pattern_idx)
	
	var error: Error = ResourceSaver.save(pattern, "res://world/tilesets/patterns/%s.tres" % export_name)
	if error:
		push_error("Failed to save tilemap pattern. Error code: ", error)
	else:
		print("Successfully saved tilemap pattern %s!" % export_name)
	
	EditorInterface.get_resource_filesystem().scan()
	
	pattern_idx = 0
	export_name = "test"
