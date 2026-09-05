class_name PlayerAfterimage
extends Node2D

@export var opacity: float

var fade_tween: Tween
var frame: int
var fade_time: float
var sprite_flip_h: bool


@onready var sprite_2d: Sprite2D = $Sprite2D
@onready var timer: Timer = $Timer


func _ready() -> void:
	sprite_2d.frame = frame
	sprite_2d.flip_h = sprite_flip_h
	
	sprite_2d.modulate.a = opacity / 255
	
	timer.start(fade_time)
	
	fade_tween = create_tween()
	fade_tween.tween_property(sprite_2d, "modulate:a", 0.0, fade_time)


func _on_timer_timeout() -> void:
	queue_free()
