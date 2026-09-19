extends Control


@export var intro_fade_duration: float
@export var scroll_speed: float


var credits_scroll_amount: float
var is_scrolling: bool


@onready var fade_effect: FadeEffect = $FadeEffect
@onready var credits: VBoxContainer = $Credits


func _ready() -> void:
	is_scrolling = false
	fade_effect.color_rect.color = Color(0, 0, 0, 1)
	fade_effect.fade(Color(0, 0, 0, 0), intro_fade_duration).finished.connect(_on_fade_in_finish)
	AudioManager.change_music("Quest of the Anomaly")

func _unhandled_input(event: InputEvent) -> void:
	if event.is_action_pressed("ui_cancel"):
		get_tree().change_scene_to_file("res://scenes/menu/menu.tscn")

func _process(delta: float) -> void:
	credits.offset_transform_position.y = get_window().size.y - credits_scroll_amount
	if is_scrolling:
		credits_scroll_amount += delta * scroll_speed
		if credits_scroll_amount > 2237 + 213 + 100 + get_window().size.y:
			get_tree().change_scene_to_file("res://scenes/menu/menu.tscn")

func _on_fade_in_finish() -> void:
	is_scrolling = true
