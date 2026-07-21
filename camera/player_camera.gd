class_name PlayerCamera extends Camera2D

signal camera_shake

@export var shake_fade: float = 9
@export var random_strength: float = 10
@export var default_zoom: float = 1

var target: Vector2
var rng: RandomNumberGenerator = RandomNumberGenerator.new()
var shake_strength: float = 0.0
var thing: float = 0
var directed_offset: Vector2 = Vector2.ZERO
var director_tween: Tween

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
	offset = shake_offset + directed_offset

func set_limits(rect: Rect2) -> void:
	limit_left = int(rect.position.x - rect.size.x / 2)
	limit_right = int(rect.position.x + rect.size.x / 2)
	limit_bottom = int(rect.position.y + rect.size.y / 2)
	limit_top = int(rect.position.y - rect.size.y / 2)
	# print("Setting limits: (left: ", limit_left, ", right: ", limit_right, ", top: ", limit_top, ", bottom: ", limit_bottom, ")")

func on_camera_shake() -> void:
	shake_strength = random_strength

func random_offset() -> Vector2:
	return Vector2(rng.randf_range(-shake_strength, shake_strength), rng.randf_range(-shake_strength,shake_strength))

func direct(zoo: float, in_time: float, stay_time: float, out_time: float, blocks_player: float) -> void:
	var tween: Tween = get_tree().create_tween()
	tween.tween_property(self, "zoom", Vector2(zoo, zoo), in_time)
	if blocks_player:
		tween.tween_callback(Callable(self, "_disable_player_input"))
	if stay_time != 0:
		tween.tween_interval(stay_time)
	if out_time != 0:
		tween.tween_property(self, "zoom", Vector2(default_zoom, default_zoom), out_time)
	if blocks_player:
		tween.tween_callback(Callable(self, "_enable_player_input"))

func undirect() -> void:
	var tween = get_tree().create_tween()
	tween.tween_property(self, "zoom", Vector2(default_zoom, default_zoom), 0.8)

func _disable_player_input() -> void:
	GameManager.player.input_locked = true
func _enable_player_input() -> void:
	GameManager.player.input_locked = false

func direct_offset(direction: Vector2, duration: float) -> Tween:
	if director_tween:
		director_tween.kill()
	
	director_tween = create_tween()
	director_tween.tween_property(self, "directed_offset", direction, duration).set_trans(Tween.TRANS_CUBIC).set_ease(Tween.EASE_OUT)
	
	return director_tween
