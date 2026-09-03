class_name ButtonAnimator
extends Node

@export var ease_type: Tween.EaseType = Tween.EASE_IN_OUT
@export var trans_type: Tween.TransitionType = Tween.TransitionType.TRANS_CUBIC
@export var anim_duration: float = 0.21
@export var scale_amount: float = 1.1
@export var target: Button

var tween: Tween


func _ready() -> void:
	target.offset_transform_enabled = true
	target.mouse_entered.connect(_on_mouse_entered)
	target.mouse_exited.connect(_on_mouse_exited)


func reset_tween() -> void:
	if tween:
		tween.kill()
	tween = create_tween().set_ease(ease_type).set_trans(trans_type).set_parallel(true)


func _on_mouse_entered() -> void:
	if target.disabled:
		return
	reset_tween()
	tween.tween_property(target, "offset_transform_scale", Vector2(scale_amount, scale_amount), anim_duration)


func _on_mouse_exited() -> void:
	reset_tween()
	tween.tween_property(target, "offset_transform_scale", Vector2.ONE, anim_duration)
