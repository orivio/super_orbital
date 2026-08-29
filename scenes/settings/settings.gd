class_name Settings
extends Control

@onready var back_button: Button = $BackButton
@onready var controls: SettingsControls = $TabContainer/Controls
@onready var audio: SettingsAudio = $TabContainer/Audio
@onready var graphics: SettingsGraphics = $TabContainer/Graphics
@onready var tab_container: TabContainer = $TabContainer

var save_settings_dirty: bool = false


func _on_back_button_pressed() -> void:
	if save_settings_dirty:
		back_button.text = "Back"
		SettingsManager.write_prefs_file()
		save_settings_dirty = false
	
	tab_container.mouse_filter = Control.MOUSE_FILTER_IGNORE
	get_tree().change_scene_to_file("res://scenes/menu/menu.tscn")


func _on_controls_changed() -> void:
	save_settings_dirty = true
	back_button.text = "Back (Save Changes)"


func _on_audio_changed() -> void:
	save_settings_dirty = true
	back_button.text = "Back (Save Changes)"


func _on_graphics_changed() -> void:
	save_settings_dirty = true
	back_button.text = "Back (Save Changes)"
