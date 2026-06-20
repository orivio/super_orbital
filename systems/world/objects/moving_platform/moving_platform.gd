extends Path2D

@export var time: float = 1
@export var forward_direction: float = 1

var speed: float = 1

@onready var path_follow_2d: PathFollow2D = $PathFollow2D

func _ready() -> void:
	speed = 1 / time

func _physics_process(delta: float) -> void:
	path_follow_2d.progress_ratio += speed * delta * GameManager.time_scale * forward_direction
	
	if forward_direction == 1 and path_follow_2d.progress_ratio == 1:
		forward_direction = -1
	elif forward_direction == -1 and path_follow_2d.progress_ratio == 0:
		forward_direction = 1
