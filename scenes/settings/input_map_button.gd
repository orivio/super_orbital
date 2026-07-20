class_name InputMapButton
extends Button

signal input_mapped(action: StringName, event: InputEvent)

@export var action_name: StringName

var listening: bool = false


func _ready() -> void:
	pressed.connect(_on_pressed)

func _on_pressed() -> void:
	text = "Press a key..."
	listening = true
	get_viewport().set_input_as_handled()

func _unhandled_input(event: InputEvent) -> void:
	if listening:
		input_mapped.emit(action_name, event)
		listening = false
		text = OS.get_keycode_string(event.keycode)

func load_keycode_string() -> void:
	text = OS.get_keycode_string(InputMap.action_get_events(action_name)[0].physical_keycode)
