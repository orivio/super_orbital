class_name PauseMenu
extends Control

signal close_pressed
signal exit_pressed
signal level_selected(level_idx: int)

var pause_options: PauseOptions = null
var level_select: PauseGrid = null
var pause_settings: Control = null

@onready var panel_container: PanelContainer = $PanelContainer


func _ready() -> void:
	spawn_pause_options()


func spawn_pause_options() -> void:
	var pause_options_scene: PackedScene = load("res://scenes/pause_menu/pause_options.tscn")
	pause_options = pause_options_scene.instantiate()
	pause_options.close_pressed.connect(_on_resume_button_pressed)
	pause_options.level_select_pressed.connect(_on_level_select_button_pressed)
	pause_options.settings_pressed.connect(_on_settings_button_pressed)
	pause_options.exit_pressed.connect(_on_exit_button_pressed)
	panel_container.add_child(pause_options)
	panel_container.queue_sort()


func spawn_level_grid() -> void:
	var level_grid_scene: PackedScene = load("res://scenes/pause_menu/pause_grid.tscn")
	level_select = level_grid_scene.instantiate()
	level_select.back_pressed.connect(_on_level_select_back_pressed)
	level_select.level_selected.connect(_on_level_selected)
	panel_container.add_child(level_select)
	if not level_select.is_node_ready():
		await level_select.ready
	level_select.level_grid.update_visuals(SaveManager.get_save_file())
	panel_container.queue_sort()


func spawn_pause_settings() -> void:
	var pause_settings_scene: PackedScene = load("res://scenes/settings/settings_container.tscn")
	pause_settings = pause_settings_scene.instantiate()
	panel_container.add_child(pause_settings)
	panel_container.queue_sort()


func _on_resume_button_pressed() -> void:
	close_pressed.emit()


func _on_level_select_button_pressed() -> void:
	pause_options.queue_free()
	spawn_level_grid()


func _on_settings_button_pressed() -> void:
	pause_options.queue_free()
	spawn_pause_settings()


func _on_exit_button_pressed() -> void:
	exit_pressed.emit()


func _on_level_select_back_pressed() -> void:
	level_select.queue_free()
	spawn_pause_options()


func _on_level_selected(level_idx: int) -> void:
	level_selected.emit(level_idx)
