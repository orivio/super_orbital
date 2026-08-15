class_name LevelGrid
extends Control


signal level_grid_selected(name: String)


const LEVEL_MARKER: PackedScene = preload("res://ui/level_marker/level_marker.tscn")


var selected_number: int = 0
var last_save_file: SaveFile


@onready var grid_container: GridContainer = $HBoxContainer/Grid
@onready var left_button: Button = $HBoxContainer/LeftButton
@onready var right_button: Button = $HBoxContainer/RightButton


func update_visuals(save_file: SaveFile) -> void:
	for node in grid_container.get_children():
		node.queue_free()
	
	var max_level_to_display: int = save_file.room_idx
	
	for count in range(selected_number * 15, min(selected_number * 15 + 15, max_level_to_display)):
		var level_marker_instance: Control = LEVEL_MARKER.instantiate()
		grid_container.add_child(level_marker_instance)
		var level_name: String = GameManager.rooms.keys()[count]
		level_marker_instance.get_node("Label").text = level_name
		level_marker_instance.level_name = level_name
		level_marker_instance.level_selected.connect(_on_level_selected)
		level_grid_selected.connect(level_marker_instance._on_other_level_selected)
	last_save_file = save_file


func _on_left_button_button_down() -> void:
	selected_number -= 1
	if selected_number < 0:
		selected_number = 0
		return
	update_visuals(last_save_file)


func _on_right_button_button_down() -> void:
	selected_number += 1
	if selected_number * 15 - 1 > SaveManager.get_save_file().room_idx:
		selected_number -= 1
		return
	
	update_visuals(last_save_file)

func _on_level_selected(level_name: String) -> void:
	SaveManager.select_level(level_name)
	level_grid_selected.emit(level_name)
	
