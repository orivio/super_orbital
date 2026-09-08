@tool
class_name MovingBlackhole
extends Path2D

@export var time: float = 1
@export var forward_direction: float = 1
@export_tool_button("Update Follow Visual") var update_line_button = update_follow_visual

var speed: float = 1
var rotate_speed: float = 0

@onready var path_follow_2d: PathFollow2D = $PathFollow2D
@onready var follow_visual: Line2D = $FollowVisual

func _ready() -> void:
	speed = 1 / time
	
	update_follow_visual()

func _physics_process(delta: float) -> void:
	if not Engine.is_editor_hint():
		if time == 0:
			return
		
		path_follow_2d.progress_ratio += speed * delta * GameManager.time_scale * forward_direction
		
		if forward_direction == 1 and path_follow_2d.progress_ratio >= 1:
			path_follow_2d.progress_ratio = 0

func update_follow_visual() -> void:
	follow_visual.points = curve.get_baked_points()
