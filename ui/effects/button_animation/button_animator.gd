class_name ButtonAnimator
extends Button

@export var ease_type: Tween.EaseType
@export var trans_type: Tween.TransitionType
@export var anim_duration: float
@export var scale_amount: float

var tween: Tween


func _ready() -> void:
	offset_transform_enabled = true
	mouse_entered.connect(_on_mouse_entered)
	mouse_exited.connect(_on_mouse_exited)


func reset_tween() -> void:
	if tween:
		tween.kill()
	tween = create_tween().set_ease(ease_type).set_trans(trans_type).set_parallel(true)


func _on_mouse_entered() -> void:
	reset_tween()
	tween.tween_property(self, "offset_transform_scale", Vector2(scale_amount, scale_amount), anim_duration)


func _on_mouse_exited() -> void:
	reset_tween()
	tween.tween_property(self, "offset_transform_scale", Vector2.ONE, anim_duration)
