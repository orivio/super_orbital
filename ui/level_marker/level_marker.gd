class_name LevelMarker
extends Control

signal level_selected(level_idx: int)
signal level_start(level_idx: int)

@export var highlighted_texture: Texture
@export var normal_texture: Texture
@export var selected_texture: Texture
@export var locked_texture: Texture
@export var rotate_speed: float
@export var scale_range: float
@export var ease_out_curve: Curve

var mouse_in: bool
var mouse_down: bool
var level_name: String
var is_selected: bool
var level_idx: int
var is_locked: bool
var is_rotating: bool
var is_scaling: bool
var rotate_tween: Tween
var scale_tween: Tween

@onready var texture_rect: TextureRect = $TextureRect
@onready var label: Label = $Label


func _ready() -> void:
	texture_rect.texture = normal_texture


func _input(event: InputEvent) -> void:
	if mouse_in and event is InputEventMouseButton and event.button_index == MOUSE_BUTTON_LEFT and event.pressed and not is_locked:
		mouse_down = true
	if mouse_in and event is InputEventMouseButton and event.button_index == MOUSE_BUTTON_LEFT and event.is_released() and not is_locked:
		mouse_down = false
		if is_selected:
			print("Level start: ", level_idx)
			level_start.emit(level_idx)
		else:
			level_selected.emit(level_idx)
			select()


func initialize(name_of_level: String, idx_of_level: int, locked: bool) -> void:
	level_name = name_of_level
	level_idx = idx_of_level
	if locked:
		texture_rect.texture = locked_texture
		is_locked = locked
	else:
		label.text = level_name


func select() -> void:
	is_selected = true
	start_rotation()
	start_scaling()
	texture_rect.texture = selected_texture


func disable() -> void:
	# TODO: Potentially spaghetti code
	is_locked = true
	stop_rotation()
	stop_scaling()


func start_rotation() -> void:
	if rotate_tween and rotate_tween.is_valid():
		return
	is_rotating = true
	do_rotation_cycle()


func do_rotation_cycle() -> void:
	if not is_rotating:
		rotate_tween.kill()
		return
	rotate_tween = create_tween()
	rotate_tween.tween_property(texture_rect, "rotation_degrees", 180, rotate_speed).as_relative()
	rotate_tween.finished.connect(do_rotation_cycle)

func stop_rotation() -> void:
	is_rotating = false
	if not rotate_tween:
		return
	rotate_tween.kill()
	rotate_tween = create_tween()
	var start: float = texture_rect.rotation_degrees
	var dest: float = ceil(start / 180) * 180
	var time_remaining: float = rotate_speed * (dest - texture_rect.rotation_degrees) / 180
	rotate_tween.tween_method(
		func(t: float) -> void:
			var curve_value: float = ease_out_curve.sample(t)
			texture_rect.rotation_degrees = lerp(start, dest, curve_value),
		0.0, 1.0, time_remaining
	)


func start_scaling() -> void:
	if scale_tween and scale_tween.is_valid():
		return
	is_scaling = true
	do_scaling_cycle()


func do_scaling_cycle() -> void:
	if not is_rotating:
		if scale_tween:
			scale_tween.kill()
		return
	scale_tween = create_tween().set_ease(Tween.EASE_IN_OUT).set_trans(Tween.TRANS_SINE)
	scale_tween.tween_property(texture_rect, "scale", Vector2(scale_range, scale_range), rotate_speed / 2)
	scale_tween.parallel().tween_property(label, "scale", Vector2(scale_range, scale_range), rotate_speed / 2)
	scale_tween.chain().tween_property(texture_rect, "scale", Vector2.ONE, rotate_speed / 2)
	scale_tween.parallel().tween_property(label, "scale", Vector2.ONE, rotate_speed / 2)
	scale_tween.finished.connect(do_scaling_cycle)

func stop_scaling() -> void:
	is_scaling = false
	if not scale_tween:
		return
	scale_tween.kill()
	scale_tween = create_tween()
	var start: float = texture_rect.scale.x
	var dest: float = 1
	var time_remaining: float = rotate_speed / 2 * (dest - texture_rect.rotation_degrees) / 180
	scale_tween.tween_method(
		func(t: float) -> void:
			var curve_value: float = ease_out_curve.sample(t)
			texture_rect.scale = Vector2(lerp(start, dest, curve_value), lerp(start, dest, curve_value)),
		0.0, 1.0, time_remaining
	)


func _on_mouse_exited() -> void:
	mouse_in = false
	if not is_selected and not is_locked:
		texture_rect.texture = normal_texture
		stop_rotation()


func _on_mouse_entered() -> void:
	mouse_in = true
	if not is_selected and not is_locked:
		texture_rect.texture = highlighted_texture
		start_rotation()


func _on_other_level_selected(other_idx: int) -> void:
	if other_idx != level_idx and not is_locked:
		is_selected = false
		if mouse_in:
			texture_rect.texture = highlighted_texture
		else:
			texture_rect.texture = normal_texture
			stop_rotation()
			stop_scaling()
