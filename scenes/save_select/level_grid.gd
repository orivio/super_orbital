class_name LevelGrid
extends Control

signal level_grid_selected(level_idx: int)
signal play

const LEVEL_MARKER: PackedScene = preload("res://ui/level_marker/level_marker.tscn")
const LEVEL_DIR: LevelDirectory = preload("res://world/level_directory.tres")

var selected_number: int = 0
var last_save_file: SaveFile

@onready var current_grid: GridContainer = $HBoxContainer/Grid
@onready var left_button: Button = $HBoxContainer/LeftButton
@onready var right_button: Button = $HBoxContainer/RightButton


func initialize(save_file: SaveFile) -> void:
	selected_number = floor(save_file.max_level_idx / 15)


func wipe_markers() -> void:
	for node in current_grid.get_children():
		node.queue_free()


func spawn_level_grid(save_file: SaveFile, grid_container: GridContainer) -> void:
	wipe_markers()
	
	var max_level_to_display: int = save_file.max_level_idx
	var current_level: int = save_file.level_idx
	
	for count in range(selected_number * 15, min(selected_number * 15 + 15, LEVEL_DIR.levels.size())):
		var level_marker_instance: LevelMarker = LEVEL_MARKER.instantiate()
		grid_container.add_child(level_marker_instance)
		
		var level_meta: LevelMeta = LEVEL_DIR.get_level_meta(count)
		var level_name: String = level_meta.level_name
		
		level_marker_instance.level_selected.connect(_on_level_selected)
		level_marker_instance.level_start.connect(_on_level_start)
		level_grid_selected.connect(level_marker_instance._on_other_level_selected)
		
		if count == current_level:
			level_marker_instance.select()
		
		if count > max_level_to_display:
			level_marker_instance.initialize(level_name, count, true)
		else:
			level_marker_instance.initialize(level_name, count, false)
	last_save_file = save_file


func disable_marker_input() -> void:
	for child in current_grid.get_children():
		child.mouse_filter = Control.MOUSE_FILTER_IGNORE
		child.disable()


func _on_left_button_button_down() -> void:
	selected_number -= 1
	if selected_number < 0:
		selected_number = 0
		return
	spawn_level_grid(last_save_file, current_grid)


func _on_right_button_button_down() -> void:
	selected_number += 1
	if selected_number * 15 - 1 > SaveManager.get_save_file().level_idx:
		selected_number -= 1
		return
	spawn_level_grid(SaveManager.get_save_file(), current_grid)
	


func _on_level_selected(level_idx: int) -> void:
	SaveManager.select_level(level_idx)
	level_grid_selected.emit(level_idx)
	
func _on_level_start(level_idx: int) -> void:
	SaveManager.select_level(level_idx)
	play.emit()
