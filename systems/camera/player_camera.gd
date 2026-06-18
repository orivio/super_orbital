class_name PlayerCamera extends Camera2D

signal camera_shake

@export var shake_fade: float = 9
@export var random_strength: float = 10

var target: Vector2
var rng: RandomNumberGenerator = RandomNumberGenerator.new()
var shake_strength: float = 0.0
var thing: float = 0

func _ready() -> void:
	GameManager.camera = self
	camera_shake.connect(on_camera_shake)

func _process(delta: float) -> void:
	
	var shake_offset: Vector2 = Vector2.ZERO
	
	if shake_strength > 0:
		shake_strength = lerpf(shake_strength, 0, shake_fade * delta)
		shake_offset = random_offset()
	
	target = GameManager.player.global_position
	thing += delta
	position = target
	offset = shake_offset

func set_limits(rect: Rect2) -> void:
	limit_left = rect.position.x - rect.size.x / 2
	limit_right = rect.position.x + rect.size.x / 2
	limit_bottom = rect.position.y + rect.size.y / 2
	limit_top = rect.position.y - rect.size.y / 2
	
	# print("Setting limits: (left: ", limit_left, ", right: ", limit_right, ", top: ", limit_top, ", bottom: ", limit_bottom, ")")

func on_camera_shake() -> void:
	shake_strength = random_strength

func random_offset() -> Vector2:
	return Vector2(rng.randf_range(-shake_strength, shake_strength), rng.randf_range(-shake_strength,shake_strength))
