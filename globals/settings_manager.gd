extends Node

var prefs_file: PrefsFile

func load_prefs_file() -> void:
	var temp: PrefsFile = PrefsFile.load_prefs()
	if not temp:
		prefs_file = preload("res://prefs/prefs_file.gd").new()
	else:
		prefs_file = temp

func write_prefs_file() -> void:
	prefs_file.write_prefs()

func get_prefs_file() -> PrefsFile:
	return prefs_file
