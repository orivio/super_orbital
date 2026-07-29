class_name SettingsControls
extends Node

signal controls_changed

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	for button in find_children("*", "InputMapButton"):
		button.input_mapped.connect(_on_input_mapped)
		button.load_keycode_string()


func _on_input_mapped(action_name: StringName, event: InputEvent) -> void:
	InputMap.action_erase_events(action_name)
	InputMap.action_add_event(action_name, event)
	controls_changed.emit()
