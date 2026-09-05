extends Control

@export_category("Scene Transition Fading")
@export var play_fade_color: Color
@export var settings_fade_color: Color
@export var play_fade_duration: float = 1.0
@export var settings_fade_duration: float = 0.5

var original_button_size: Vector2

@onready var play_button: Button = $VBoxContainer/VBoxContainer/PlayButton
@onready var settings_button: Button = $VBoxContainer/VBoxContainer/SettingsButton
@onready var quit_button: Button = $VBoxContainer/VBoxContainer/QuitButton
@onready var fade: FadeEffect = $FadeEffect


func _enter_tree() -> void:
	pass
	#Engine.time_scale = 0.1


func _ready() -> void:
	AudioManager.change_music(&"Lone Traveller")
	SettingsManager.load_prefs_file()
	original_button_size = play_button.size
	for button: Button in [play_button, settings_button]:
		button.pivot_offset = button.size / 2.0
	
	if OS.has_feature("web"):
		quit_button.visible = false
	
	if not Engine.is_editor_hint():
		RenderingServer.set_default_clear_color(Color.BLACK)


func _on_play_button_pressed() -> void:
	play_button.mouse_filter = Control.MOUSE_FILTER_IGNORE
	settings_button.mouse_filter = Control.MOUSE_FILTER_IGNORE
	quit_button.mouse_filter = Control.MOUSE_FILTER_IGNORE
	await fade.fade(play_fade_color, play_fade_duration).finished
	get_tree().change_scene_to_file("res://scenes/save_select/save_select.tscn")


func _on_settings_button_pressed() -> void:
	play_button.mouse_filter = Control.MOUSE_FILTER_IGNORE
	settings_button.mouse_filter = Control.MOUSE_FILTER_IGNORE
	quit_button.mouse_filter = Control.MOUSE_FILTER_IGNORE
	await fade.fade(settings_fade_color, settings_fade_duration).finished
	get_tree().change_scene_to_file("res://scenes/settings/settings.tscn")


func _on_quit_button_pressed() -> void:
	get_tree().quit(0)
