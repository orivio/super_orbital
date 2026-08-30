class_name PauseGrid
extends HBoxContainer

signal back_pressed
signal level_selected(level_idx: int)

var current_selected_level_idx: int = -1

@onready var level_grid: LevelGrid = $VBoxContainer/LevelGrid


func _on_back_button_pressed() -> void:
	back_pressed.emit()


func _on_level_grid_level_grid_selected(level_idx: int) -> void:
	current_selected_level_idx = level_idx


func _on_level_grid_play() -> void:
	level_selected.emit(current_selected_level_idx)
