extends Control

func _on_resume_button_pressed() -> void:
	pass # Replace with function body.
	
func _on_exit_button_pressed() -> void:
	get_tree().change_scene_to_file("res://scenes/menu/menu.tscn")
