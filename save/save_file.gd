class_name SaveFile

const SAVE_GAME_PATH: String = "user://save_file.json"

var room_path: String = "res://rooms/1_walk/room_move.tscn"
var player_abilities: PlayerAbilities = preload("res://player/abilities/player_initial_abilities.tres")

func _init() -> void:
	if player_abilities:
		player_abilities = player_abilities.duplicate()

func write_save() -> void:
	var file: FileAccess = FileAccess.open(SAVE_GAME_PATH, FileAccess.WRITE)
	var data: Dictionary = {
		"room": room_path,
		"player_abilities": player_abilities.get_json()
	}
	file.store_string(JSON.stringify(data))
	file.close()

static func load_save() -> SaveFile:
	var file: FileAccess = FileAccess.open(SAVE_GAME_PATH, FileAccess.READ)
	if file == null:
		return null
	var data: Variant = JSON.parse_string(file.get_as_text())
	file.close()
	if data == null:
		push_error("Failed to read save file!")
		return null
	var save_file: SaveFile = SaveFile.new()
	save_file.room_path = data["room"]
	save_file.player_abilities = PlayerAbilities.from_json(data["player_abilities"])
	return save_file
