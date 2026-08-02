extends Node2D


@export var opacity: float


var fade_tween: Tween
var frame: int
var time: float
var flip: bool


@onready var sprite_2d: Sprite2D = $Sprite2D
@onready var timer: Timer = $Timer


func do_thing(fram: int, tim: float, fli: bool) -> void:
	frame = fram
	time = tim
	flip = fli

func _ready() -> void:
	sprite_2d.frame = frame
	sprite_2d.modulate.a = opacity / 255
	sprite_2d.flip_h = flip
	timer.start(time)
	fade_tween = create_tween()
	fade_tween.tween_property(sprite_2d, "modulate:a", 0.0, time)


func _on_timer_timeout() -> void:
	queue_free()
