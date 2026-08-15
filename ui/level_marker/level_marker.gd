class_name LevelMarker
extends Control


signal level_selected(level_name: String)
signal level_start(level_name: String)


@export var highlighted_texture: Texture
@export var normal_texture: Texture
@export var selected_texture: Texture


var mouse_in: bool
var mouse_down: bool
var level_name: String
var is_selected: bool


@onready var texture_rect: TextureRect = $TextureRect


func _ready() -> void:
	texture_rect.texture = normal_texture

func _on_mouse_entered() -> void:
	mouse_in = true
	if not is_selected:
		texture_rect.texture = highlighted_texture

func _on_mouse_exited() -> void:
	mouse_in = false
	if not is_selected:
		texture_rect.texture = normal_texture

func _input(event: InputEvent) -> void:
	if mouse_in and event is InputEventMouseButton and event.button_index == MOUSE_BUTTON_LEFT and event.pressed:
		mouse_down = true
	if mouse_in and event is InputEventMouseButton and event.button_index == MOUSE_BUTTON_LEFT and event.is_released():
		mouse_down = false
		if is_selected:
			level_start.emit(level_name)
		else:
			level_selected.emit(level_name)
			is_selected = true
			texture_rect.texture = selected_texture

func _on_other_level_selected(other_name: String) -> void:
	if other_name != level_name:
		is_selected = false
		if mouse_in:
			texture_rect.texture = highlighted_texture
		else:
			texture_rect.texture = normal_texture
