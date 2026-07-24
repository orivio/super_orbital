class_name FadeEffect extends CanvasLayer

@onready var color_rect: ColorRect = $ColorRect

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	color_rect.color.a = 0.0

func fade(target_color: Color, duration: float) -> Tween:
	color_rect.color.r = target_color.r
	color_rect.color.g = target_color.g
	color_rect.color.b = target_color.b
	var tween = create_tween()
	tween.tween_property(color_rect, "color:a", target_color.a, duration)
	return tween

func _process(_delta: float) -> void:
	pass
