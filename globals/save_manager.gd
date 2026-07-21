extends Node

var save_file: SaveFile

func load_save_file() -> void:
	var temp: SaveFile = SaveFile.load_save()
	if not temp:
		save_file = preload("res://save/save_file.gd").new()
	else:
		save_file = temp

func write_save_file() -> void:
	save_file.write_save()

func get_save_file() -> SaveFile:
	return save_file

func _on_room_changed(room_path: String) -> void:
	save_file.room_path = room_path
	write_save_file()

func _on_ability_unlocked(ability: String) -> void:
	save_file.player_abilities.unlock(ability)
	write_save_file()
	
func _on_ability_locked(ability: String) -> void:
	save_file.player_abilities.lock(ability)
	write_save_file()

func _on_dialogue_finished(tag: StringName) -> void:
	if save_file.dialogue_data.has(tag):
		save_file.dialogue_data.get(tag)["finished"] = true
	else:
		save_file.dialogue_data.set(tag, {"finished": true})
	write_save_file()
