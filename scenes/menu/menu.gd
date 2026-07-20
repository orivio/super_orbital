extends Control

@export_category("Button Hovering Behavior")

@export var normal_button_scale: Vector2 = Vector2(1.0, 1.0);
@export var hover_button_scale: Vector2 = Vector2(1.1, 1.1);
@export var normal_button_opacity: float = 1.0
@export var hover_button_opacity: float = 1.25
@export var button_scale_duration: float = 0.0

@export_category("Scene Transition Fading")

@export var play_fade_color: Color
@export var settings_fade_color: Color
@export var play_fade_duration: float = 1.0
@export var settings_fade_duration: float = 0.5


var original_button_size: Vector2


@onready var play_button: Button = $VBoxContainer/VBoxContainer/PlayButton
@onready var settings_button: Button = $VBoxContainer/VBoxContainer/SettingsButton
@onready var fade: Fade = $Fade

func _enter_tree() -> void:
	pass
	#Engine.time_scale = 0.1

func _ready() -> void:
	SettingsManager.load_prefs_file()
	original_button_size = play_button.size
	for button: Button in [play_button, settings_button]:
		button.pivot_offset   = button.size / 2.0
	play_button.grab_focus()

func _on_play_button_pressed() -> void:
	await fade.fade(play_fade_color, play_fade_duration).finished
	get_tree().change_scene_to_file("res://scenes/play/play.tscn")

func _on_settings_button_pressed() -> void:
	await fade.fade(settings_fade_color, settings_fade_duration).finished
	get_tree().change_scene_to_file("res://scenes/settings/settings.tscn")


func _on_play_button_mouse_entered() -> void:
	animate_button(play_button, hover_button_scale, hover_button_opacity)

func _on_settings_button_mouse_entered() -> void:
	animate_button(settings_button, hover_button_scale, hover_button_opacity)


func _on_play_button_mouse_exited() -> void:
	animate_button(play_button, normal_button_scale, normal_button_opacity)

func _on_settings_button_mouse_exited() -> void:
	animate_button(settings_button, normal_button_scale, normal_button_opacity)


func animate_button(button: Button, scale_target: Vector2, opacity_target: float) -> void:
	var tween: Tween = create_tween()
	var _target_size: Vector2 = original_button_size * scale_target
	tween.tween_property(button, "scale", scale_target, button_scale_duration)
	tween.tween_property(button, "modulate:a", opacity_target, button_scale_duration)
