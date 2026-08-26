class_name PauseMenu
extends Control

signal close_pressed

var disable_input: bool

func _on_resume_button_pressed() -> void:
	if not disable_input:
		close_pressed.emit()
	
func _on_exit_button_pressed() -> void:
	if not disable_input:
		get_tree().change_scene_to_file("res://scenes/menu/menu.tscn")
		DialogueManager.end_dialogue_fast()
