class_name PauseMenu
extends Control

signal close_pressed
signal exit_pressed

var pause_options: PauseOptions = null
var level_select: Control = null

@onready var panel_container: PanelContainer = $PanelContainer


func _ready() -> void:
	spawn_pause_options()


func spawn_pause_options() -> void:
	var pause_options_scene: PackedScene = load("res://scenes/pause_menu/pause_options.tscn")
	pause_options = pause_options_scene.instantiate()
	pause_options.close_pressed.connect(_on_resume_button_pressed)
	pause_options.level_select_pressed.connect(_on_level_select_button_pressed)
	pause_options.exit_pressed.connect(_on_exit_button_pressed)
	panel_container.add_child(pause_options)


func spawn_level_grid() -> void:
	var level_grid_scene: PackedScene = load("res://scenes/pause_menu/pause_grid.tscn")
	level_select = level_grid_scene.instantiate()
	panel_container.add_child(level_select)
	if not level_select.is_node_ready():
		await level_select.ready
	level_select.get_node("LevelGrid").update_visuals(SaveManager.get_save_file())
	panel_container.queue_sort()


func _on_resume_button_pressed() -> void:
	close_pressed.emit()


func _on_level_select_button_pressed() -> void:
	pause_options.queue_free()
	spawn_level_grid()


func _on_exit_button_pressed() -> void:
	exit_pressed.emit()
