class_name SaveFile
extends Resource

const SAVE_GAME_PATH: String = "user://save_file.tres"

@export var room_path: String = "res://rooms/walk/room_move.tscn"
@export var player_abilities: PlayerAbilities = preload("res://player/abilities/player_initial_abilities.tres")

func _init() -> void:
	if player_abilities:
		player_abilities = player_abilities.duplicate()

func write_save() -> void:
	ResourceSaver.save(self, SAVE_GAME_PATH)
	# print("Saving save file")

static func load_save() -> Resource:
	if ResourceLoader.exists(SAVE_GAME_PATH):
		return load(SAVE_GAME_PATH)
	return null
