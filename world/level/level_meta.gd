@tool
class_name LevelMeta
extends Resource

@export var level_name: String
@export_file("ogg") var music_for_this_room: String
@export_storage var scene_path: String
@export_tool_button("Goto scene") var goto_scene_button: Callable = _goto_scene_button

func _goto_scene_button() -> void:
	EditorInterface.open_scene_from_path(scene_path)
