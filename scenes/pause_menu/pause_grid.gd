class_name PauseGrid
extends Control

signal back_pressed
signal level_selected(level_idx: int)

var current_selected_level_idx: int = 0

@onready var level_grid: LevelGrid = $PanelContainer/PauseGrid/VBoxContainer/LevelGrid


func _ready() -> void:
	level_grid.initialize(SaveManager.get_save_file())
	current_selected_level_idx = SaveManager.get_save_file().level_idx

func _on_back_button_pressed() -> void:
	back_pressed.emit()


func _on_level_grid_level_grid_selected(level_idx: int) -> void:
	current_selected_level_idx = level_idx


func _on_level_grid_play() -> void:
	level_grid.disable_marker_input()
	level_selected.emit(current_selected_level_idx)
