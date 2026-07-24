class_name SaveFile

const SAVE_GAME_PATH: String = "user://save_file.json"

var room: String = "move"
var player_abilities: PlayerAbilities = preload("res://player/abilities/player_initial_abilities.tres")
var dialogue_data: Dictionary
var progress_data: Array[String]

func _init() -> void:
	if player_abilities:
		player_abilities = player_abilities.duplicate()
	dialogue_data = {}

func write_to_file(file_path: String) -> void:
	var file: FileAccess = FileAccess.open(file_path, FileAccess.WRITE)
	var data: Dictionary = {
		"room": room,
		"player_abilities": player_abilities.get_json(),
		"dialogue": dialogue_data,
		"progress": progress_data
	}
	file.store_string(JSON.stringify(data, "\t"))
	file.close()

func write_save() -> void:
	write_to_file(SAVE_GAME_PATH)
	
static func does_save_exist() -> bool:
	return FileAccess.file_exists(SAVE_GAME_PATH)

static func delete_save_file() -> void:
	DirAccess.remove_absolute(SAVE_GAME_PATH)

static func load_from_file(file_path: String) -> SaveFile:
	var file: FileAccess = FileAccess.open(file_path, FileAccess.READ)
	if file == null:
		return null
	var data: Variant = JSON.parse_string(file.get_as_text())
	file.close()
	if data == null:
		push_error("Failed to read save file!")
		return null
	var save_file: SaveFile = SaveFile.new()
	save_file.room = data["room"]
	save_file.player_abilities = PlayerAbilities.from_json(data["player_abilities"])
	save_file.dialogue_data = data["dialogue"]
	save_file.progress_data.append_array(data["progress"])
	return save_file

static func load_save() -> SaveFile:
	return load_from_file(SAVE_GAME_PATH)
