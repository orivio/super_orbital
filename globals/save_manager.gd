extends Node

var save_file: SaveFile

func does_save_exist() -> bool:
	return SaveFile.does_save_exist()

func create_new_save() -> SaveFile:
	save_file = preload("res://save/save_file.gd").new()
	return save_file

func delete_save_file() -> void:
	SaveFile.delete_save_file()

func export_to_file(file: String) -> void:
	if save_file:
		save_file.write_to_file(file)
	else:
		push_error("Save file not found!")

func import_from_file(file: String) -> void:
	save_file = SaveFile.load_from_file(file)

func load_save_file() -> bool:
	var temp: SaveFile = SaveFile.load_save()
	if not temp:
		save_file = preload("res://save/save_file.gd").new()
		return false
	else:
		save_file = temp
		return true

func write_save_file() -> void:
	save_file.write_save()

func get_save_file() -> SaveFile:
	return save_file

func _on_room_changed(room: String) -> void:
	save_file.room = room
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

func _on_progress_attained(progress_name: StringName) -> void:
	if save_file.progress_data.has(progress_name):
		return
	save_file.progress_data.append(progress_name)
	write_save_file()
