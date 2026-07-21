class_name InputMapButton
extends Button

signal input_mapped(action: StringName, event: InputEvent)

@export var action_name: StringName

var listening: bool = false


func _ready() -> void:
	button_down.connect(_on_button_down)

func _on_button_down() -> void:
	if not listening:
		text = "Press a key..."
		listening = true
		get_viewport().set_input_as_handled()
		print("I just got pressed")

func _unhandled_input(event: InputEvent) -> void:
	if listening and event.is_pressed():
		input_mapped.emit(action_name, event)
		listening = false
		text = OS.get_keycode_string(event.keycode)
		get_viewport().set_input_as_handled()
		print("I just mapped a key")

func load_keycode_string() -> void:
	text = OS.get_keycode_string(InputMap.action_get_events(action_name)[0].physical_keycode)
