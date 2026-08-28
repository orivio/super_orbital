class_name LevelMarker
extends Control

signal level_selected(level_idx: int)
signal level_start(level_idx: int)

@export var highlighted_texture: Texture
@export var normal_texture: Texture
@export var selected_texture: Texture
@export var rotate_speed: float

var mouse_in: bool
var mouse_down: bool
var level_name: String
var is_selected: bool
var level_idx: int

@onready var texture_rect: TextureRect = $TextureRect
@onready var label: Label = $Label


func _ready() -> void:
	texture_rect.texture = normal_texture


func _process(_delta: float) -> void:
	pass
	# TODO: I think the effect looks good, but in order to really make it work,
	# I would need to do some more fancy stuff involving Tweens
	#if is_selected:
	#	texture_rect.rotation_degrees += delta * rotate_speed


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
			level_start.emit(level_idx)
		else:
			level_selected.emit(level_idx)
			is_selected = true
			texture_rect.texture = selected_texture


func initialize(name_of_level: String, idx_of_level: int) -> void:
	level_name = name_of_level
	level_idx = idx_of_level
	label.text = level_name


func _on_other_level_selected(other_idx: int) -> void:
	if other_idx != level_idx:
		is_selected = false
		if mouse_in:
			texture_rect.texture = highlighted_texture
		else:
			texture_rect.texture = normal_texture
