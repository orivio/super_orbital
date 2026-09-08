class_name SettingsGame
extends Control

signal game_changed

@onready var check_button: CheckButton = $VBoxContainer/HBoxContainer/CheckButton


func _ready() -> void:
	check_button.button_pressed = GameManager.checkpoints_enabled
	check_button.toggled.connect(_on_check_button_toggled)

func _on_check_button_toggled(toggled_on: bool) -> void:
	GameManager.checkpoints_enabled = toggled_on
	game_changed.emit()
