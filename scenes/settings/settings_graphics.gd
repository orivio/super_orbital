class_name SettingsGraphics
extends Control

signal graphics_changed

@onready var vsync_checker: CheckButton = $VBoxContainer/CheckButton
@onready var fullscreen_checker: CheckButton = $VBoxContainer/CheckButton2

var vsync_mode: DisplayServer.VSyncMode
var window_mode: Window.Mode

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	vsync_mode = DisplayServer.window_get_vsync_mode()
	window_mode = get_window().mode
	
	vsync_checker.button_pressed = vsync_mode == DisplayServer.VSYNC_ENABLED
	fullscreen_checker.button_pressed = window_mode == Window.Mode.MODE_FULLSCREEN


func _on_vsync_button_toggled(toggled_on: bool) -> void:
	match vsync_mode:
		DisplayServer.VSYNC_ENABLED:
			if toggled_on == false:
				vsync_mode = DisplayServer.VSYNC_DISABLED
				graphics_changed.emit()
		_:
			if toggled_on == true:
				vsync_mode = DisplayServer.VSYNC_ENABLED
				graphics_changed.emit()
	DisplayServer.window_set_vsync_mode(vsync_mode)

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
