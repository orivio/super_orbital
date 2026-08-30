class_name PauseGrid
extends HBoxContainer

signal back_pressed

@onready var level_grid: LevelGrid = $VBoxContainer/LevelGrid


func _on_back_button_pressed() -> void:
	back_pressed.emit()
