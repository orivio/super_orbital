class_name PauseMenu
extends Control

signal close_pressed
signal exit_pressed


func _on_resume_button_pressed() -> void:
	close_pressed.emit()


func _on_exit_button_pressed() -> void:
	exit_pressed.emit()
