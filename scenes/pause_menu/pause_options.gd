class_name PauseOptions
extends Control

signal close_pressed
signal level_select_pressed
signal settings_pressed
signal exit_pressed


func _on_resume_button_pressed() -> void:
	close_pressed.emit()


func _on_level_select_button_pressed() -> void:
	level_select_pressed.emit()


func _on_settings_button_pressed() -> void:
	settings_pressed.emit()


func _on_exit_button_pressed() -> void:
	exit_pressed.emit()
