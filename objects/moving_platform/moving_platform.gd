extends Path2D

@export var time: float = 1
@export var forward_direction: float = 1
@export var rotate_time: float = 0

var speed: float = 1
var rotate_speed: float = 0

@onready var path_follow_2d: PathFollow2D = $PathFollow2D
@onready var collision_shape: CollisionShape2D = $AnimatableBody2D/CollisionShape2D
@onready var rect: NinePatchRect = $AnimatableBody2D/NinePatchRect

func _ready() -> void:
	speed = 1 / time
	if rotate_time != 0:
		rotate_speed = 2 * PI / rotate_time
	

func _physics_process(delta: float) -> void:
	if rotate_time != 0:
		collision_shape.rotation += rotate_speed * delta * GameManager.time_scale
		rect.rotation += rotate_speed * delta * GameManager.time_scale
	
	path_follow_2d.progress_ratio += speed * delta * GameManager.time_scale * forward_direction
	
	if forward_direction == 1 and path_follow_2d.progress_ratio == 1:
		forward_direction = -1
	elif forward_direction == -1 and path_follow_2d.progress_ratio == 0:
		forward_direction = 1
