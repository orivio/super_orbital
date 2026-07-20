extends Control

@onready var back_button: Button = $BackButton

var save_settings_dirty: bool = false


func _ready() -> void:
	back_button.grab_focus()
	
	for button in find_children("*", "InputMapButton"):
		button.input_mapped.connect(_on_input_mapped)
		button.load_keycode_string()

func _on_back_button_pressed() -> void:
	if save_settings_dirty:
		back_button.text = "Back"
		SettingsManager.write_prefs_file()
		save_settings_dirty = false
	get_tree().change_scene_to_file("res://scenes/menu/menu.tscn")

func _on_input_mapped(action_name: StringName, event: InputEvent) -> void:
	InputMap.action_erase_events(action_name)
	InputMap.action_add_event(action_name, event)
	save_settings_dirty = true
	back_button.text = "Back (Save Preferences)"
