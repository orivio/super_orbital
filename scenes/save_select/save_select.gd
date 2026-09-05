extends Control

@export_group("Play Fade")
@export var play_fade_color: Color
@export var play_fade_duration: float
@export_group("Back Fade")
@export var back_fade_color: Color
@export var back_fade_duration: float
@export_group("Enter Fade")
@export var enter_fade_duration: float

@onready var new_button: Button = $PanelContainer/VBoxContainer/HBoxContainer/NewButton
@onready var play_button: Button = $PanelContainer/VBoxContainer/HBoxContainer/PlayButton
@onready var delete_button: Button = $PanelContainer/VBoxContainer/HBoxContainer/DeleteButton
@onready var load_button: Button = $PanelContainer/VBoxContainer/HBoxContainer/LoadButton
@onready var export_button: Button = $PanelContainer/VBoxContainer/HBoxContainer/ExportButton
@onready var back_button: Button = $BackButton
@onready var delete_confirmation: ConfirmationDialog = $PanelContainer/VBoxContainer/HBoxContainer/DeleteButton/ConfirmationDialog
@onready var export_file_dialog: FileDialog = $PanelContainer/VBoxContainer/HBoxContainer/ExportButton/FileDialog
@onready var import_file_dialog: FileDialog = $PanelContainer/VBoxContainer/HBoxContainer/LoadButton/FileDialog
@onready var fade_effect: FadeEffect = $FadeEffect
@onready var level_grid: LevelGrid = $PanelContainer/VBoxContainer/LevelGrid
@onready var left_button: LevelButton = $PanelContainer/VBoxContainer/LevelGrid/HBoxContainer/LeftButton
@onready var right_button: LevelButton = $PanelContainer/VBoxContainer/LevelGrid/HBoxContainer/RightButton

var save_exists: bool


func _ready() -> void:
	if not SaveManager.does_save_exist():
		new_button.disabled = false
		play_button.disabled = true
		delete_button.disabled = true
		load_button.disabled = false
		export_button.disabled = true
		
		save_exists = false
	else:
		SaveManager.load_save_file()
		new_button.disabled = true
		play_button.disabled = false
		delete_button.disabled = false
		load_button.disabled = true
		export_button.disabled = false
		
		level_grid.initialize(SaveManager.get_save_file())
		level_grid.spawn_level_grid(SaveManager.get_save_file(), level_grid.current_grid)
		save_exists = true
	
	delete_confirmation.get_cancel_button().pressed.connect(_on_delete_button_confirmation_cancelled)
	delete_confirmation.get_ok_button().pressed.connect(_on_delete_button_confirmation_accepted)
	
	export_file_dialog.file_selected.connect(_on_export_file_selected)
	import_file_dialog.file_selected.connect(_on_import_file_selected)
	
	export_file_dialog.root_subfolder = OS.get_system_dir(OS.SYSTEM_DIR_DOWNLOADS)
	export_file_dialog.current_file = "save.json"
	import_file_dialog.root_subfolder = OS.get_system_dir(OS.SYSTEM_DIR_DOWNLOADS)
	import_file_dialog.current_file = "save.json"
	
	fade_effect.color_rect.color = Color(0, 0, 0, 1)
	fade_effect.fade(Color(0, 0, 0, 0), enter_fade_duration)


func _on_back_button_pressed() -> void:
	new_button.mouse_filter = Control.MOUSE_FILTER_IGNORE
	play_button.mouse_filter = Control.MOUSE_FILTER_IGNORE
	delete_button.mouse_filter = Control.MOUSE_FILTER_IGNORE
	export_button.mouse_filter = Control.MOUSE_FILTER_IGNORE
	load_button.mouse_filter = Control.MOUSE_FILTER_IGNORE
	back_button.mouse_filter = Control.MOUSE_FILTER_IGNORE
	left_button.mouse_filter = Control.MOUSE_FILTER_IGNORE
	right_button.mouse_filter = Control.MOUSE_FILTER_IGNORE
	level_grid.disable_marker_input()
	await fade_effect.fade(back_fade_color, back_fade_duration).finished
	get_tree().change_scene_to_file("res://scenes/menu/menu.tscn")


func _on_new_button_pressed() -> void:
	SaveManager.create_new_save()
	
	new_button.disabled = true
	play_button.disabled = false
	delete_button.disabled = false
	load_button.disabled = true
	export_button.disabled = false
	
	level_grid.initialize(SaveManager.get_save_file())
	level_grid.spawn_level_grid(SaveManager.get_save_file(), level_grid.current_grid)
	save_exists = true
	SaveManager.write_save_file()


func _on_play_button_pressed() -> void:
	level_grid.disable_marker_input()
	await fade_effect.fade(play_fade_color, play_fade_duration).finished
	get_tree().change_scene_to_file("res://scenes/play/play.tscn")


func _on_delete_button_pressed() -> void:
	delete_confirmation.popup_centered_clamped(Vector2i(300, 100))

func _on_delete_button_confirmation_cancelled() -> void:
	pass

func _on_delete_button_confirmation_accepted() -> void:
	SaveManager.delete_save_file()
	
	new_button.disabled = false
	play_button.disabled = true
	delete_button.disabled = true
	load_button.disabled = false
	export_button.disabled = true
	
	level_grid.wipe_markers()
	save_exists = false

func _on_load_button_pressed() -> void:
	import_file_dialog.popup_file_dialog()

func _on_import_file_selected(file: String) -> void:
	SaveManager.import_from_file(file)
	level_grid.update_visuals(SaveManager.get_save_file())
	save_exists = true

func _on_export_button_pressed() -> void:
	export_file_dialog.popup_file_dialog()

func _on_export_file_selected(file: String) -> void:
	SaveManager.export_to_file(file)


func _on_level_grid_play() -> void:
	level_grid.disable_marker_input()
	await fade_effect.fade(play_fade_color, play_fade_duration).finished
	get_tree().change_scene_to_file("res://scenes/play/play.tscn")
