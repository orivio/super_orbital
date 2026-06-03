class_name PlayerCamera extends Camera2D

var target: Vector2

func _ready() -> void:
	pass

func _process(_delta: float) -> void:
	
	target = GameManager.player.global_position
	
	position = target

func set_limits(rect: Rect2) -> void:
	limit_left = rect.position.x - rect.size.x / 2
	limit_right = rect.position.x + rect.size.x / 2
	limit_bottom = rect.position.y + rect.size.y / 2
	limit_top = rect.position.y - rect.size.y / 2
	
	# print("Setting limits: (left: ", limit_left, ", right: ", limit_right, ", top: ", limit_top, ", bottom: ", limit_bottom, ")")
