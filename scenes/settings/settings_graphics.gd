class_name SettingsGraphics
extends Control

signal graphics_changed

@onready var fullscreen_checker: CheckButton = $VBoxContainer/CheckButton2
@onready var camera_shake_checker: CheckButton = $VBoxContainer/CheckButton3
@onready var histop_checker: CheckButton = $VBoxContainer/CheckButton4

var window_mode: Window.Mode
var camera_shake: bool
var hitstop: bool

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	window_mode = get_window().mode
	camera_shake = GameManager.camera_shake_enabled
	hitstop = GameManager.hitstop_enabled
	
	fullscreen_checker.button_pressed = window_mode == Window.Mode.MODE_EXCLUSIVE_FULLSCREEN
	camera_shake_checker.button_pressed = camera_shake
	histop_checker.button_pressed = hitstop
	
	fullscreen_checker.toggled.connect(_on_windowed_button_toggled)
	camera_shake_checker.toggled.connect(_on_camera_shake_button_toggled)
	camera_shake_checker.toggled.connect(_on_hitstop_button_toggled)
	

func _on_windowed_button_toggled(toggled_on: bool) -> void:
	match window_mode:
		Window.Mode.MODE_EXCLUSIVE_FULLSCREEN:
			if toggled_on == false:
				window_mode = Window.Mode.MODE_WINDOWED
				graphics_changed.emit()
		_:
			if toggled_on == true:
				window_mode = Window.Mode.MODE_EXCLUSIVE_FULLSCREEN
				graphics_changed.emit()
	get_window().mode = window_mode


func _on_camera_shake_button_toggled(toggled_on: bool) -> void:
	if camera_shake != toggled_on:
		camera_shake = toggled_on
		GameManager.camera_shake_enabled = camera_shake
		graphics_changed.emit()


func _on_hitstop_button_toggled(toggled_on: bool) -> void:
	if hitstop != toggled_on:
		hitstop = toggled_on
		GameManager.hitstop_enabled = hitstop
		graphics_changed.emit()
