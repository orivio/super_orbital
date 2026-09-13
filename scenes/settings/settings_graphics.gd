class_name SettingsGraphics
extends Control

signal graphics_changed

@onready var fullscreen_checker: CheckButton = $VBoxContainer/CheckButton2

var window_mode: Window.Mode

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	window_mode = get_window().mode
	
	fullscreen_checker.button_pressed = window_mode == Window.Mode.MODE_FULLSCREEN

func _on_windowed_button_toggled(toggled_on: bool) -> void:
	match window_mode:
		Window.Mode.MODE_FULLSCREEN:
			if toggled_on == false:
				window_mode = Window.Mode.MODE_WINDOWED
				graphics_changed.emit()
		_:
			if toggled_on == true:
				window_mode = Window.Mode.MODE_FULLSCREEN
				graphics_changed.emit()
	get_window().mode = window_mode
